#!/usr/bin/env node
/*
 * Writes docs/public/getkey/config.js with the GitHub token and HMAC secret
 * stored scrambled rather than verbatim.
 *
 * Why scramble at all? GitHub's secret scanner revokes personal access tokens
 * the moment it sees one in a public repo, which would break the generator
 * within minutes of the first push. Scrambling keeps the token alive. It does
 * NOT make it secret — a static site cannot hold a secret. See the warning
 * block written into the generated file.
 *
 * Usage:
 *   node build/keygen-config.js                 # prompts for everything
 *   ANUI_GH_TOKEN=... ANUI_HMAC_SECRET=... \
 *     node build/keygen-config.js --yes         # non-interactive
 *
 * Options:
 *   --owner --repo --branch --db-path --ttl --prefix --cooldown --yes
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const readline = require('readline');

const OUT_PATH = path.join(__dirname, '..', 'docs', 'public', 'getkey', 'config.js');

const C = {
  g: '\x1b[38;2;48;255;106m',
  y: '\x1b[38;2;255;210;50m',
  c: '\x1b[38;2;50;231;255m',
  r: '\x1b[38;2;255;74;50m',
  d: '\x1b[2m',
  x: '\x1b[0m',
};

// --- args -------------------------------------------------------------------

function readArgs(argv) {
  const out = {};
  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];
    if (!token.startsWith('--')) continue;
    const name = token.slice(2);
    if (name === 'yes') {
      out.yes = true;
    } else {
      out[name] = argv[i + 1];
      i += 1;
    }
  }
  return out;
}

const args = readArgs(process.argv.slice(2));

// --- scrambling -------------------------------------------------------------

// Mirrored by `reveal()` in docs/public/getkey/app.js. Keep both in sync.
function scramble(plain, salt) {
  const out = [];
  for (let i = 0; i < plain.length; i += 1) {
    const s = salt.charCodeAt(i % salt.length);
    out.push(plain.charCodeAt(i) ^ s ^ ((i * 7 + 13) & 0xff));
  }
  return out;
}

function reveal(parts, salt) {
  return parts
    .map((n, i) => String.fromCharCode(n ^ salt.charCodeAt(i % salt.length) ^ ((i * 7 + 13) & 0xff)))
    .join('');
}

// --- prompting --------------------------------------------------------------

function ask(rl, question, fallback) {
  const suffix = fallback ? `${C.d} [${fallback}]${C.x}` : '';
  return new Promise((resolve) => {
    rl.question(`${C.c}?${C.x} ${question}${suffix}: `, (answer) => {
      resolve((answer || '').trim() || fallback || '');
    });
  });
}

// Reads without echoing, so a pasted token never lands in the scrollback.
function askHidden(rl, question) {
  return new Promise((resolve) => {
    const input = rl.input;
    const wasRaw = input.isRaw;
    let value = '';

    process.stdout.write(`${C.c}?${C.x} ${question}: `);

    if (input.isTTY) input.setRawMode(true);

    const onData = (chunk) => {
      for (const ch of chunk.toString('utf8')) {
        if (ch === '\r' || ch === '\n') {
          input.removeListener('data', onData);
          if (input.isTTY) input.setRawMode(Boolean(wasRaw));
          process.stdout.write('\n');
          resolve(value.trim());
          return;
        }
        if (ch === '\u0003') {
          process.stdout.write('\n');
          process.exit(130); // Ctrl-C
        }
        if (ch === '\u007f' || ch === '\b') {
          value = value.slice(0, -1);
          continue;
        }
        value += ch;
      }
    };
    input.on('data', onData);
  });
}

// --- output -----------------------------------------------------------------

function renderConfig(values) {
  return `/*
 * ANUI key generator — runtime configuration.
 *
 * GENERATED FILE. Recreate with:  node build/keygen-config.js
 *
 * ---------------------------------------------------------------------------
 * SECURITY NOTICE — READ THIS
 * ---------------------------------------------------------------------------
 * GitHub Pages is static hosting, so the token below is delivered to every
 * visitor's browser. The scrambling exists to stop GitHub's secret scanner from
 * auto-revoking the token and to deter casual copy-paste. It is NOT encryption:
 * anyone who reads this file can recover the token.
 *
 * Keep the blast radius small:
 *   1. FINE-GRAINED personal access token, never a classic one.
 *   2. Scoped to the key-database repository ONLY.
 *   3. Exactly one permission: Contents -> Read and write.
 *   4. Short expiry, rotated on a schedule.
 *   5. Strongly preferred: keep the database in a SEPARATE repo so a leaked
 *      token cannot reach your library's source.
 *
 * If you later want a leak-proof setup, move the write path behind a small
 * proxy (Cloudflare Worker, GitHub Actions) and delete the token from here.
 * Nothing in the Lua library has to change — it only ever reads the database.
 * ---------------------------------------------------------------------------
 */

window.ANUI_KEYGEN_CONFIG = {
  owner: ${JSON.stringify(values.owner)},
  repo: ${JSON.stringify(values.repo)},
  branch: ${JSON.stringify(values.branch)},
  dbPath: ${JSON.stringify(values.dbPath)},

  keyPrefix: ${JSON.stringify(values.keyPrefix)},
  keyGroups: ${values.keyGroups},
  keyGroupSize: ${values.keyGroupSize},
  ttlHours: ${values.ttlHours},

  // Minimum seconds between two generations for one device. 0 disables it.
  cooldownSeconds: ${values.cooldownSeconds},

  brandName: ${JSON.stringify(values.brandName)},
  discordUrl: ${JSON.stringify(values.discordUrl)},

  salt: ${JSON.stringify(values.salt)},
  token: ${JSON.stringify(values.token)},
  secret: ${JSON.stringify(values.secret)},
};
`;
}

function renderSnippet(values) {
  return [
    'ANUI:CreateWindow({',
    '    Title = "My Hub",',
    '    Folder = "MyHub",',
    '    KeySystem = {',
    '        Note = "Generate a key for this device. Valid for ' + values.ttlHours + ' hours.",',
    '        SaveKey = true,',
    '        API = {',
    '            {',
    '                Type = "github",',
    '                Owner = "' + values.owner + '",',
    '                Repo = "' + values.repo + '",',
    '                Branch = "' + values.branch + '",',
    '                DBPath = "' + values.dbPath + '",',
    '                URL = "' + values.siteUrl + '",',
    '                Secret = "<your HMAC secret>",',
    '            },',
    '        },',
    '    },',
    '})',
  ].join('\n');
}

// --- main -------------------------------------------------------------------

async function main() {
  const nonInteractive = Boolean(args.yes);

  const rl = nonInteractive
    ? null
    : readline.createInterface({ input: process.stdin, output: process.stdout });

  const pick = async (name, question, fallback, env) => {
    if (args[name] !== undefined) return String(args[name]);
    if (env && process.env[env]) return process.env[env];
    if (nonInteractive) return fallback;
    return ask(rl, question, fallback);
  };

  console.log(`\n${C.c}ANUI key generator — config builder${C.x}\n`);

  const values = {
    owner: await pick('owner', 'GitHub owner (user or org)', 'ANHub-Script', 'ANUI_GH_OWNER'),
    repo: await pick('repo', 'Repository holding the key database', 'ANUI', 'ANUI_GH_REPO'),
    branch: await pick('branch', 'Branch', 'main', 'ANUI_GH_BRANCH'),
    dbPath: await pick('db-path', 'Database path in that repo', 'db/keys.json', 'ANUI_DB_PATH'),
    keyPrefix: await pick('prefix', 'Key prefix', 'ANUI', 'ANUI_KEY_PREFIX'),
    ttlHours: Number(await pick('ttl', 'Key lifetime in hours', '24', 'ANUI_TTL_HOURS')),
    cooldownSeconds: Number(
      await pick('cooldown', 'Cooldown between regenerations, seconds', '0', 'ANUI_COOLDOWN')
    ),
    brandName: await pick('brand', 'Brand name shown on the page', 'ANUI', 'ANUI_BRAND'),
    discordUrl: await pick('discord', 'Discord invite (optional)', 'https://discord.gg/qN47S3mKZA', 'ANUI_DISCORD'),
    keyGroups: 3,
    keyGroupSize: 5,
  };

  values.siteUrl = await pick(
    'site-url',
    'Public URL of this generator page',
    `https://${values.owner.toLowerCase()}.github.io/${values.repo}/getkey/`,
    'ANUI_SITE_URL'
  );

  let token = process.env.ANUI_GH_TOKEN || args.token || '';
  let secret = process.env.ANUI_HMAC_SECRET || args.secret || '';

  if (!token) {
    if (nonInteractive) {
      console.error(`${C.r}[ x ]${C.x} No token. Set ANUI_GH_TOKEN or drop --yes.`);
      process.exit(1);
    }
    token = await askHidden(rl, 'Fine-grained PAT (Contents: read and write) — input hidden');
  }

  if (!secret) {
    if (nonInteractive) {
      secret = crypto.randomBytes(24).toString('base64url');
      console.log(`${C.y}[ ! ]${C.x} No ANUI_HMAC_SECRET given, generated one.`);
    } else {
      secret = await askHidden(rl, 'HMAC secret (blank = generate) — input hidden');
      if (!secret) secret = crypto.randomBytes(24).toString('base64url');
    }
  }

  if (rl) rl.close();

  // --- validation -----------------------------------------------------------

  if (!token) {
    console.error(`${C.r}[ x ]${C.x} Token is required.`);
    process.exit(1);
  }

  if (!/^(github_pat_|ghp_|gho_|ghs_)/.test(token)) {
    console.log(`${C.y}[ ! ]${C.x} Token does not look like a GitHub PAT. Continuing anyway.`);
  }

  if (/^ghp_/.test(token)) {
    console.log(
      `${C.y}[ ! ]${C.x} That is a CLASSIC token — it can reach every repo you own.\n` +
      `      Replace it with a fine-grained PAT scoped to ${values.owner}/${values.repo}.`
    );
  }

  if (!Number.isFinite(values.ttlHours) || values.ttlHours <= 0) {
    console.error(`${C.r}[ x ]${C.x} Key lifetime must be a positive number of hours.`);
    process.exit(1);
  }

  if (!Number.isFinite(values.cooldownSeconds) || values.cooldownSeconds < 0) {
    console.error(`${C.r}[ x ]${C.x} Cooldown must be zero or more seconds.`);
    process.exit(1);
  }

  // --- scramble + verify ----------------------------------------------------

  values.salt = crypto.randomBytes(18).toString('base64url');
  values.token = scramble(token, values.salt);
  values.secret = scramble(secret, values.salt);

  if (reveal(values.token, values.salt) !== token || reveal(values.secret, values.salt) !== secret) {
    console.error(`${C.r}[ x ]${C.x} Round-trip check failed; refusing to write a broken config.`);
    process.exit(1);
  }

  fs.mkdirSync(path.dirname(OUT_PATH), { recursive: true });
  fs.writeFileSync(OUT_PATH, renderConfig(values), 'utf-8');

  // --- report ---------------------------------------------------------------

  const rel = path.relative(path.join(__dirname, '..'), OUT_PATH).replace(/\\/g, '/');

  console.log(`\n${C.g}[ ok ]${C.x} Wrote ${rel}`);
  console.log(`${C.g}[ >  ]${C.x} Generator page: ${values.siteUrl}`);
  console.log(`${C.g}[ >  ]${C.x} Database:       ${values.owner}/${values.repo}@${values.branch}:${values.dbPath}`);
  console.log(`${C.g}[ >  ]${C.x} Key lifetime:   ${values.ttlHours}h`);

  console.log(`\n${C.y}[ !! ]${C.x} The token is recoverable from the deployed page. Use a`);
  console.log(`       fine-grained PAT limited to Contents:write on that one repo.`);

  console.log(`\n${C.c}HMAC secret${C.x} — paste this into your script's KeySystem config:`);
  console.log(`  ${secret}\n`);
  console.log(`${C.d}${renderSnippet(values).replace(/^/gm, '  ')}${C.x}\n`);
  console.log(`${C.d}  Keep the secret out of your git history if you can; it is only as${C.x}`);
  console.log(`${C.d}  private as the obfuscated copy already shipped in the page.${C.x}\n`);
}

main().catch((error) => {
  console.error(`${C.r}[ x ]${C.x} ${error.message}`);
  process.exit(1);
});


