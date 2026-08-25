/*
 * ANUI key generator — front end.
 *
 * Issues one key per device fingerprint and commits it to db/keys.json through
 * the GitHub Contents API. The read path lives in the Lua library
 * (src/utils/services/GitHubKey.lua). Both sides agree on:
 *
 *   keys[fingerprint] = { key, sig, issued_at, expires_at, regen, revoked }
 *   sig = HMAC_SHA256(secret, "key|fingerprint|issued_at|expires_at")[0..31]
 *
 * Timestamps come from GitHub's `Date` response header, never from the local
 * clock, so winding a machine's clock back cannot extend a key.
 */

'use strict';

const CFG = window.ANUI_KEYGEN_CONFIG || {};

/* Mirrors scramble() in build/keygen-config.js. Keep both in sync. */
function reveal(parts, salt) {
  if (!Array.isArray(parts) || !salt) return '';
  return parts
    .map((n, i) => String.fromCharCode(n ^ salt.charCodeAt(i % salt.length) ^ ((i * 7 + 13) & 0xff)))
    .join('');
}

const TOKEN = reveal(CFG.token, CFG.salt);
const SECRET = reveal(CFG.secret, CFG.salt);

const TTL_HOURS = Number(CFG.ttlHours) > 0 ? Number(CFG.ttlHours) : 24;
const TTL_SECONDS = Math.round(TTL_HOURS * 3600);
const COOLDOWN = Math.max(0, Number(CFG.cooldownSeconds) || 0);

/* Crockford-style: no I, L, O or U, so a key read aloud is unambiguous. 32
   symbols divide 256 evenly, so masking a random byte with 31 is unbiased. */
const KEY_ALPHABET = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

const API_ROOT = 'https://api.github.com';
const RING_CIRCUMFERENCE = 326.7; /* 2 * pi * 52, matches style.css */

/* DOM ---------------------------------------------------------------------- */

const pick = (hook) => document.querySelector('[' + hook + ']');

const el = {
  root: document.documentElement,
  brand: pick('data-brand'),
  ttlPill: pick('data-ttl-pill'),

  fpHint: pick('data-fp-hint'),
  fpWrap: pick('data-fp-wrap'),
  fp: pick('data-fp'),
  copyFp: pick('data-copy-fp'),
  manualForm: pick('data-manual-form'),
  fpInput: pick('data-fp-input'),
  fpError: pick('data-fp-error'),

  status: pick('data-status'),
  keybox: pick('data-keybox'),
  key: pick('data-key'),
  copyKey: pick('data-copy-key'),
  copyKeyLabel: pick('data-copy-key-label'),

  clock: pick('data-clock'),
  ring: pick('data-ring'),
  remaining: pick('data-remaining'),

  meta: pick('data-meta'),
  issued: pick('data-issued'),
  expires: pick('data-expires'),
  regen: pick('data-regen'),

  generate: pick('data-generate'),
  generateLabel: pick('data-generate-label'),
  refresh: pick('data-refresh'),
  notice: pick('data-notice'),
  discord: pick('data-discord'),
};

/* Mutable state ------------------------------------------------------------ */

let fingerprint = null;
let entry = null; // the live keys[fingerprint] record, or null
let dbSha = null; // blob sha required by the Contents API for updates
let clockSkew = 0; // serverEpoch - localEpoch
let ticker = null;
let busy = false;

/* Small helpers ------------------------------------------------------------ */

const encoder = new TextEncoder();

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

function nowSeconds() {
  return Math.floor(Date.now() / 1000) + clockSkew;
}

function show(node) {
  if (node) node.hidden = false;
}

function hide(node) {
  if (node) node.hidden = true;
}

function setStatus(message, kind) {
  if (!el.status) return;
  el.status.textContent = message;
  el.status.className = 'status' + (kind ? ' status--' + kind : '');
}

function setNotice(message, kind) {
  if (!el.notice) return;
  if (!message) {
    el.notice.textContent = '';
    hide(el.notice);
    return;
  }
  el.notice.textContent = message;
  el.notice.className = 'notice' + (kind === 'warn' ? ' notice--warn' : '');
  show(el.notice);
}

function fmtDuration(totalSeconds) {
  const seconds = Math.max(0, Math.floor(totalSeconds));
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  if (h > 0) return m > 0 ? h + 'h ' + m + 'm' : h + 'h';
  if (m > 0) return m + 'm';
  return seconds + 's';
}

function clockText(totalSeconds) {
  const seconds = Math.max(0, Math.floor(totalSeconds));
  const pad = (n) => String(n).padStart(2, '0');
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = seconds % 60;
  return h > 0 ? h + ':' + pad(m) + ':' + pad(s) : pad(m) + ':' + pad(s);
}

function fmtTime(epoch) {
  const value = Number(epoch);
  if (!Number.isFinite(value) || value <= 0) return '—';
  const date = new Date(value * 1000);
  return date.toLocaleString(undefined, {
    year: 'numeric', month: 'short', day: '2-digit',
    hour: '2-digit', minute: '2-digit',
  });
}

/* Crypto and encoding ------------------------------------------------------ */

function toHex(bytes) {
  let out = '';
  for (let i = 0; i < bytes.length; i += 1) out += bytes[i].toString(16).padStart(2, '0');
  return out;
}

async function hmacHex(secret, message) {
  if (!secret) return '';
  const cryptoKey = await crypto.subtle.importKey(
    'raw', encoder.encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
  );
  const signature = await crypto.subtle.sign('HMAC', cryptoKey, encoder.encode(message));
  return toHex(new Uint8Array(signature));
}

function signaturePayload(record) {
  return [
    String(record.key),
    fingerprint,
    String(Math.floor(Number(record.issued_at) || 0)),
    String(Math.floor(Number(record.expires_at) || 0)),
  ].join('|');
}

async function expectedSignature(record) {
  const full = await hmacHex(SECRET, signaturePayload(record));
  return full.slice(0, 32);
}

function base64ToText(base64) {
  const binary = atob(String(base64 || '').replace(/\s+/g, ''));
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i += 1) bytes[i] = binary.charCodeAt(i);
  return new TextDecoder().decode(bytes);
}

function textToBase64(text) {
  const bytes = encoder.encode(text);
  let binary = '';
  // chunked so a large database cannot blow the argument limit
  for (let i = 0; i < bytes.length; i += 0x8000) {
    binary += String.fromCharCode.apply(null, bytes.subarray(i, i + 0x8000));
  }
  return btoa(binary);
}

/* GitHub Contents API ------------------------------------------------------ */

function encodePath(path) {
  return String(path || 'db/keys.json')
    .split('/')
    .filter((segment) => segment.length > 0)
    .map(encodeURIComponent)
    .join('/');
}

function contentsUrl(query) {
  const base = API_ROOT + '/repos/' + encodeURIComponent(CFG.owner) + '/' +
    encodeURIComponent(CFG.repo) + '/contents/' + encodePath(CFG.dbPath);
  return query ? base + '?' + query : base;
}

function cacheBuster() {
  return String(Date.now()) + '-' + Math.floor(Math.random() * 1e7);
}

/* Keeps our clock pinned to GitHub's. Every response carries a Date header. */
function syncClock(response) {
  const header = response.headers.get('date');
  if (!header) return;
  const parsed = Date.parse(header);
  if (!Number.isFinite(parsed)) return;
  clockSkew = Math.floor(parsed / 1000) - Math.floor(Date.now() / 1000);
}

async function ghRequest(method, url, body) {
  const response = await fetch(url, {
    method: method,
    cache: 'no-store',
    headers: {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ' + TOKEN,
      'X-GitHub-Api-Version': '2022-11-28',
      'Content-Type': 'application/json',
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  syncClock(response);

  let payload = null;
  try {
    payload = await response.json();
  } catch (_) {
    payload = null;
  }

  return { ok: response.ok, status: response.status, payload: payload };
}

function describe(response, prefix) {
  const detail = response.payload && response.payload.message ? response.payload.message : '';
  let reason;
  switch (response.status) {
    case 401:
      reason = 'the token is invalid or expired';
      break;
    case 403:
      reason = 'the token lacks Contents: read and write on ' + CFG.owner + '/' + CFG.repo +
        ', or the rate limit is exhausted';
      break;
    case 404:
      reason = 'the repository, branch or path does not exist, or the token cannot see it';
      break;
    case 409:
      reason = 'the database changed mid-write';
      break;
    case 422:
      reason = 'GitHub rejected the commit (stale sha or protected branch)';
      break;
    default:
      reason = 'HTTP ' + response.status;
  }
  return prefix + ': ' + reason + (detail ? ' — ' + detail : '') + '.';
}

function emptyDb() {
  return { version: 1, updated_at: 0, ttl_hours: TTL_HOURS, keys: {} };
}

function normalizeDb(raw) {
  const db = raw && typeof raw === 'object' ? raw : {};
  if (!db.keys || typeof db.keys !== 'object' || Array.isArray(db.keys)) db.keys = {};
  if (!Number.isFinite(Number(db.version))) db.version = 1;
  return db;
}

async function loadDb() {
  const response = await ghRequest('GET', contentsUrl('ref=' + encodeURIComponent(CFG.branch || 'main') +
    '&cb=' + cacheBuster()));

  if (response.status === 404) {
    dbSha = null; // first write creates the file
    return emptyDb();
  }
  if (!response.ok) throw new Error(describe(response, 'Could not read the key database'));

  dbSha = response.payload && response.payload.sha ? response.payload.sha : null;

  // The Contents API stops inlining content past ~1 MB. A key database that big
  // needs pruning, so say that instead of failing on an empty JSON.parse.
  if (response.payload && response.payload.encoding !== 'base64') {
    throw new Error('The key database is too large for the Contents API. Prune expired entries in ' +
      CFG.dbPath + '.');
  }

  try {
    return normalizeDb(JSON.parse(base64ToText(response.payload.content)));
  } catch (_) {
    throw new Error('The key database is not valid JSON. Fix ' + CFG.dbPath + ' in the repo by hand.');
  }
}

function saveDb(db, message) {
  const body = {
    message: message,
    content: textToBase64(JSON.stringify(db, null, 2) + '\n'),
    branch: CFG.branch || 'main',
  };
  if (dbSha) body.sha = dbSha; // omitted only when the file does not exist yet
  return ghRequest('PUT', contentsUrl(''), body);
}

/* Key issuing -------------------------------------------------------------- */

function randomKey() {
  const groups = Math.max(1, Math.floor(Number(CFG.keyGroups) || 3));
  const size = Math.max(1, Math.floor(Number(CFG.keyGroupSize) || 5));
  const bytes = new Uint8Array(groups * size);
  crypto.getRandomValues(bytes);

  const blocks = [];
  let cursor = 0;
  for (let g = 0; g < groups; g += 1) {
    let block = '';
    for (let c = 0; c < size; c += 1) {
      block += KEY_ALPHABET[bytes[cursor] & 31];
      cursor += 1;
    }
    blocks.push(block);
  }

  const prefix = String(CFG.keyPrefix || '').trim();
  return (prefix ? [prefix].concat(blocks) : blocks).join('-');
}

async function buildRecord(previous, issued) {
  const key = randomKey();
  const record = {
    key: key,
    sig: '',
    issued_at: issued,
    expires_at: issued + TTL_SECONDS,
    regen: (Math.floor(Number(previous && previous.regen)) || 0) + 1,
    revoked: false,
  };
  record.sig = await expectedSignature(record);
  return record;
}

/* Overwrites keys[fingerprint], which is what kills the previous key: the Lua
   side compares the entered key against this single record. */
async function issueKey() {
  for (let attempt = 0; attempt < 3; attempt += 1) {
    const db = await loadDb();
    const previous = db.keys[fingerprint];
    const issued = nowSeconds();

    if (previous && COOLDOWN > 0) {
      const wait = (Math.floor(Number(previous.issued_at)) || 0) + COOLDOWN - issued;
      if (wait > 0) {
        throw new Error('Cooldown active. Wait ' + fmtDuration(wait) + ' before generating again.');
      }
    }

    const record = await buildRecord(previous, issued);
    db.keys[fingerprint] = record;
    db.updated_at = issued;
    db.ttl_hours = TTL_HOURS;

    const response = await saveDb(
      db,
      'keys: issue ' + fingerprint.slice(0, 8) + ' (#' + record.regen + ')'
    );

    if (response.ok) {
      dbSha = response.payload && response.payload.content && response.payload.content.sha
        ? response.payload.content.sha
        : null;
      return record;
    }

    // Someone else committed between our GET and PUT. Re-read and redo.
    if (response.status === 409 || response.status === 422) {
      await sleep(400 + attempt * 600);
      continue;
    }

    throw new Error(describe(response, 'Could not write the key database'));
  }

  throw new Error('The database kept changing while writing. Try again in a moment.');
}

/* Rendering ---------------------------------------------------------------- */

function stopTicker() {
  if (ticker !== null) {
    clearInterval(ticker);
    ticker = null;
  }
}

function tick() {
  if (!entry) return;

  const expires = Math.floor(Number(entry.expires_at)) || 0;
  const issued = Math.floor(Number(entry.issued_at)) || 0;
  const remaining = expires - nowSeconds();
  const total = Math.max(1, expires - issued);
  const fraction = Math.min(1, Math.max(0, remaining / total));

  if (el.ring) el.ring.style.strokeDashoffset = String(RING_CIRCUMFERENCE * (1 - fraction));

  if (remaining <= 0) {
    if (el.remaining) el.remaining.textContent = '00:00';
    // Only announce the expiry we watched happen; a record that was already
    // expired on load carries a more precise message from reportEntryState().
    if (el.root.dataset.state !== 'expired') {
      setStatus('This key has expired. Generate a new one.', 'err');
      el.root.dataset.state = 'expired';
    }
    stopTicker();
    return;
  }

  if (el.remaining) el.remaining.textContent = clockText(remaining);
}

function renderEntry(statusMessage) {
  stopTicker();

  if (!entry) {
    hide(el.keybox);
    hide(el.clock);
    hide(el.meta);
    if (el.generateLabel) el.generateLabel.textContent = 'Generate key';
    return;
  }

  if (el.key) el.key.textContent = entry.key;
  if (el.issued) el.issued.textContent = fmtTime(entry.issued_at);
  if (el.expires) el.expires.textContent = fmtTime(entry.expires_at);
  if (el.regen) el.regen.textContent = '#' + (Math.floor(Number(entry.regen)) || 1);
  if (el.generateLabel) el.generateLabel.textContent = 'Regenerate key';

  show(el.keybox);
  show(el.clock);
  show(el.meta);

  if (statusMessage) setStatus(statusMessage.text, statusMessage.kind);
  tick();
  ticker = setInterval(tick, 1000);
}

/* Device fingerprint ------------------------------------------------------- */

/* The Lua side sends a 32-hex fingerprint (SHA-256 of the HWID, truncated) so a
   raw HWID never lands in a public repo. Accept a wider range in case someone
   pastes a full digest. */
function normalizeFingerprint(value) {
  const clean = String(value || '').trim().toLowerCase().replace(/[^0-9a-f]/g, '');
  return /^[0-9a-f]{16,64}$/.test(clean) ? clean : null;
}

function readFingerprintFromUrl() {
  const fromHash = new URLSearchParams(location.hash.replace(/^#/, '')).get('fp');
  if (fromHash) return normalizeFingerprint(fromHash);
  return normalizeFingerprint(new URLSearchParams(location.search).get('fp'));
}

function askForFingerprint(message) {
  fingerprint = null;
  hide(el.fpWrap);
  show(el.manualForm);
  if (el.fpHint) el.fpHint.textContent = message;
  setStatus('Waiting for a device fingerprint…');
  if (el.generate) el.generate.disabled = true;
  if (el.refresh) el.refresh.disabled = true;
  el.root.dataset.state = 'manual';
  if (el.fpInput) el.fpInput.focus();
}

function adoptFingerprint(value) {
  fingerprint = value;
  if (el.fp) el.fp.textContent = value;
  if (el.fpHint) el.fpHint.textContent = 'This key is bound to the device below.';
  show(el.fpWrap);
  hide(el.manualForm);
  el.root.dataset.state = 'ready';
}

/* Reads the current record for this device and reflects it in the UI. */
async function refreshEntry() {
  setStatus('Reading the database…');
  const db = await loadDb();
  const found = db.keys[fingerprint];

  if (!found || found.revoked || !found.key) {
    entry = null;
    renderEntry();
    setStatus('No key issued for this device yet. Press Generate key.', 'warn');
    el.root.dataset.state = 'empty';
    return;
  }

  entry = found;
  await reportEntryState();
}

/* Signature check is the same one the Lua side runs, so a mismatch here means
   the database was edited by hand and the key would be rejected in game. */
async function reportEntryState() {
  const remaining = (Math.floor(Number(entry.expires_at)) || 0) - nowSeconds();

  if (SECRET && (await expectedSignature(entry)) !== String(entry.sig || '')) {
    renderEntry({ text: 'Signature mismatch — this key will be rejected in game.', kind: 'err' });
    setNotice('The stored signature does not match the record. The database was edited outside this ' +
      'page, or the HMAC secret changed. Regenerate to fix it.', 'warn');
    el.root.dataset.state = 'invalid';
    return;
  }

  if (remaining <= 0) {
    el.root.dataset.state = 'expired';
    renderEntry({ text: 'Key expired ' + fmtDuration(-remaining) + ' ago. Generate a new one.', kind: 'err' });
    return;
  }

  const kind = remaining < 3600 ? 'warn' : 'ok';
  renderEntry({ text: 'Key active. Expires in ' + fmtDuration(remaining) + '.', kind: kind });
  el.root.dataset.state = 'active';
}

/* Actions ------------------------------------------------------------------ */

function setBusy(button, label, state) {
  busy = state;
  if (el.generate) el.generate.disabled = state || !fingerprint;
  if (el.refresh) el.refresh.disabled = state || !fingerprint;
  if (!button) return;
  if (state) {
    button.dataset.busy = '1';
    if (label) label.textContent = 'Working…';
  } else {
    delete button.dataset.busy;
  }
}

async function onGenerate() {
  if (busy || !fingerprint) return;
  setNotice('');
  setBusy(el.generate, el.generateLabel, true);
  setStatus(entry ? 'Replacing the previous key…' : 'Issuing a key…');

  try {
    entry = await issueKey();
    await reportEntryState();
  } catch (error) {
    setStatus('Generation failed.', 'err');
    setNotice(error.message || String(error));
  } finally {
    setBusy(el.generate, el.generateLabel, false);
    if (el.generateLabel) el.generateLabel.textContent = entry ? 'Regenerate key' : 'Generate key';
  }
}

async function onRefresh() {
  if (busy || !fingerprint) return;
  setNotice('');
  setBusy(el.refresh, null, true);
  try {
    await refreshEntry();
  } catch (error) {
    setStatus('Could not reach the database.', 'err');
    setNotice(error.message || String(error));
  } finally {
    setBusy(el.refresh, null, false);
  }
}

async function copyText(text) {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch (_) {
    // Clipboard API needs a secure context; fall back to a hidden textarea.
    const scratch = document.createElement('textarea');
    scratch.value = text;
    scratch.setAttribute('readonly', '');
    scratch.style.position = 'fixed';
    scratch.style.opacity = '0';
    document.body.appendChild(scratch);
    scratch.select();
    let ok = false;
    try {
      ok = document.execCommand('copy');
    } catch (_) {
      ok = false;
    }
    document.body.removeChild(scratch);
    return ok;
  }
}

function flash(node, text, revert) {
  if (!node) return;
  node.textContent = text;
  setTimeout(() => { node.textContent = revert; }, 1400);
}

/* Wiring ------------------------------------------------------------------- */

function applyBranding() {
  const brand = String(CFG.brandName || 'ANUI');
  if (el.brand) el.brand.textContent = brand;
  document.title = 'Get Key — ' + brand;
  if (el.ttlPill) el.ttlPill.textContent = TTL_HOURS + 'h per device';
  if (el.discord && CFG.discordUrl) {
    el.discord.href = CFG.discordUrl;
    el.discord.rel = 'noopener';
    el.discord.target = '_blank';
    show(el.discord);
  }
}

function bindEvents() {
  if (el.generate) el.generate.addEventListener('click', onGenerate);
  if (el.refresh) el.refresh.addEventListener('click', onRefresh);

  if (el.copyKey) {
    el.copyKey.addEventListener('click', async () => {
      if (!entry) return;
      const ok = await copyText(entry.key);
      flash(el.copyKeyLabel, ok ? 'Copied' : 'Press Ctrl+C', 'Copy');
    });
  }

  if (el.copyFp) {
    el.copyFp.addEventListener('click', async () => {
      if (!fingerprint) return;
      const ok = await copyText(fingerprint);
      el.copyFp.title = ok ? 'Copied' : 'Copy failed';
      setTimeout(() => { el.copyFp.title = 'Copy fingerprint'; }, 1400);
    });
  }

  if (el.manualForm) {
    el.manualForm.addEventListener('submit', (event) => {
      event.preventDefault();
      const value = normalizeFingerprint(el.fpInput ? el.fpInput.value : '');
      if (!value) {
        if (el.fpError) {
          el.fpError.textContent = 'That does not look like a fingerprint. Expected 32 hex characters.';
          show(el.fpError);
        }
        return;
      }
      hide(el.fpError);
      start(value);
    });
  }
}

function configProblem() {
  if (!CFG.owner || !CFG.repo) return 'config.js has no repository set.';
  if (!TOKEN) return 'config.js has no GitHub token.';
  if (CFG.salt === 'CHANGE_ME') return 'config.js is still the example file.';
  return null;
}

async function start(value) {
  adoptFingerprint(value);
  if (el.generate) el.generate.disabled = false;
  if (el.refresh) el.refresh.disabled = false;

  try {
    await refreshEntry();
  } catch (error) {
    setStatus('Could not reach the database.', 'err');
    setNotice(error.message || String(error));
  }
}

function boot() {
  applyBranding();
  bindEvents();

  const problem = configProblem();
  if (problem) {
    if (el.fpHint) el.fpHint.textContent = 'Generator not configured.';
    setStatus('Unavailable.', 'err');
    setNotice(problem + ' Run: node build/keygen-config.js');
    el.root.dataset.state = 'unconfigured';
    return;
  }

  if (!window.isSecureContext || !crypto.subtle) {
    setStatus('Unavailable.', 'err');
    setNotice('This page needs HTTPS to sign keys. Open it over https:// or on localhost.');
    el.root.dataset.state = 'insecure';
    return;
  }

  const fromUrl = readFingerprintFromUrl();
  if (!fromUrl) {
    askForFingerprint('No device in the link. Paste the fingerprint from your script.');
    return;
  }

  start(fromUrl);
}

boot();













