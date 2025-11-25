#!/usr/bin/env node
const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const MODE = process.argv[2] || 'build';

const P = "\x1b[38;2;48;255;106m";
const D = "\x1b[38;2;255;210;50m";
const B = "\x1b[38;2;50;231;255m";
const E = "\x1b[38;2;255;74;50m";
const R = "\x1b[0m";

// === Git helpers ===

// repoRoot = folder "WindUI"
const repoRoot = path.join(__dirname, '..');

// === Version helper ===
function bumpVersion() {
  const pkgPath = path.join(__dirname, '..', 'package.json');
  const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf-8'));

  const oldVer = pkg.version || null;

  // Kalau tidak ada version, mulai dari 1.0.0
  let [major, minor, patch] = (pkg.version || '1.0.0')
    .split('.')
    .map(n => parseInt(n, 10) || 0);

  // Jika sudah ada version, naikin patch
  if (oldVer) {
    patch += 1;
  }

  const newVer = `${major}.${minor}.${patch}`;
  pkg.version = newVer;

  fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 4) + '\n', 'utf-8');

  return { oldVer, newVer };
}

function runGit(args, options = {}) {
  const res = spawnSync('git', args, {
    cwd: repoRoot,
    stdio: options.stdio || ['ignore', 'pipe', 'pipe'],
    encoding: 'utf-8',
  });
  return res;
}

function autoCommit(version) {
  // cek apakah git bisa jalan & ada perubahan
  const status = runGit(['status', '--porcelain']);
  if (status.error) {
    console.error(`${E}[ × ]${R} Tidak bisa menjalankan git: ${status.error.message}`);
    return;
  }

  if (!status.stdout.trim()) {
    console.log(`${P}[ > ]${R} Tidak ada perubahan untuk di-commit`);
    return;
  }

  console.log(`${P}[ > ]${R} Auto commit & push ke Git...`);

  // commit SEMUA perubahan di repo
  let res = runGit(['add', '.'], { stdio: 'inherit' });
  if (res.status !== 0) {
    console.error(`${E}[ × ]${R} git add gagal`);
    return;
  }

  const msg = `build: ANUI v${version}`;
  res = runGit(['commit', '-S', '-m', msg], { stdio: 'inherit' });
  if (res.status !== 0) {
    console.error(`${E}[ × ]${R} git commit gagal (mungkin tidak ada perubahan baru?)`);
    return;
  }

  // --- LOGIKA PUSH DENGAN AUTO FORCE ---
  console.log(`${P}[ > ]${R} Mencoba push ke origin/main...`);
  res = runGit(['push', 'origin', 'main'], { stdio: 'inherit' });

  if (res.status !== 0) {
    console.error(`${E}[ ! ]${R} Git push biasa gagal (mungkin karena konflik remote).`);
    console.log(`${P}[ > ]${R} Melakukan Force Push...`);

    // Coba Force Push
    res = runGit(['push', 'origin', 'main', '--force'], { stdio: 'inherit' });

    if (res.status !== 0) {
      console.error(`${E}[ × ]${R} Git push --force juga gagal! Cek koneksi atau izin repo.`);
      return;
    } else {
      console.log(`${P}[ ✓ ]${R} Force push berhasil.`);
    }
  } else {
    console.log(`${P}[ ✓ ]${R} Auto commit & push selesai`);
  }
}

// === Folder Movement Logic ===

// PERBAIKAN PATH:
// Folder script ada di dalam repoRoot (WindUI/script), BUKAN di __dirname (WindUI/build/script)
const folderScriptDiRepo = path.join(repoRoot, 'script');

// Folder tujuan pemindahan (Di luar folder WindUI / Parent)
const folderScriptDiLuar = path.join(repoRoot, '..', 'script');

function moveScriptToParent() {
  if (fs.existsSync(folderScriptDiRepo)) {
    try {
      // Pindahkan DARI Repo KE Luar
      fs.renameSync(folderScriptDiRepo, folderScriptDiLuar);
      console.log(`${P}[ > ]${R} Folder 'script' dipindahkan sementara ke folder luar (parent).`);
      return true;
    } catch (err) {
      console.error(`${E}[ × ]${R} Gagal memindahkan folder script keluar: ${err.message}`);
      return false;
    }
  } else {
    console.log(`${D}[ ! ]${R} Folder script tidak ditemukan di ${folderScriptDiRepo}, melewati pemindahan.`);
  }
  return false;
}

function restoreScriptFromParent() {
  if (fs.existsSync(folderScriptDiLuar)) {
    try {
      // Pindahkan DARI Luar KE Repo
      fs.renameSync(folderScriptDiLuar, folderScriptDiRepo);
      console.log(`${P}[ > ]${R} Folder 'script' dikembalikan ke dalam repo.`);
    } catch (err) {
      console.error(`${E}[ × ]${R} Gagal mengembalikan folder script: ${err.message}`);
      console.error(`${E}[ ! ]${R} Cek manual di folder luar: ${folderScriptDiLuar}`);
    }
  }
}

// === Build logic ===

function writePackageLua() {
  const pkgJson = fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf-8');
  const out = [
    '-- Generated from package.json | build/build.js',
    '',
    'return [[',
    pkgJson,
    ']]',
  ].join('\n');
  fs.writeFileSync(path.join(__dirname, 'package.lua'), out, 'utf-8');
}

function getPkgInfo() {
  const p = require('../package.json');
  return {
    v: p.version || '',
    d: p.description || '',
    r: p.repository || '',
    s: p.discord || '',
    l: p.license || '',
  };
}

function renderHeader(pkgInfo) {
  let h = fs.readFileSync(path.join(__dirname, 'header.lua'), 'utf-8');
  const VER = pkgInfo.v;
  const DATE = new Date().toISOString().slice(0, 10);
  h = h
    .replace(/\{\{VERSION\}\}/g, VER)
    .replace(/\{\{BUILD_DATE\}\}/g, DATE)
    .replace(/\{\{DESCRIPTION\}\}/g, pkgInfo.d)
    .replace(/\{\{REPOSITORY\}\}/g, pkgInfo.r)
    .replace(/\{\{DISCORD\}\}/g, pkgInfo.s)
    .replace(/\{\{LICENSE\}\}/g, pkgInfo.l);
  return h;
}

function runDarklua(input, config) {
  const args = ['process', input, path.join('dist', 'temp.lua'), '--config', config];
  const start = Date.now();
  // Menggunakan shell: true bisa menyebabkan warning DEP0190, tapi diperlukan di beberapa env Windows
  const res = spawnSync('darklua', args, { stdio: ['ignore', 'pipe', 'pipe'], shell: true });
  const end = Date.now();
  const time = end - start;
  const code = (res.status !== null && res.status !== undefined) ? res.status : (res.error ? 1 : 0);
  return { code, stdout: res.stdout?.toString() || '', stderr: res.stderr?.toString() || '', time };
}

function main() {
  // NEW: bump version dulu kalau mode build
  let bumpInfo = null;
  if (MODE === 'build') {
    bumpInfo = bumpVersion();
  }

  writePackageLua();

  const prefix = MODE === 'dev' ? `${D}[ DEV ]${R}` : `${B}[ BUILD ]${R}`;

  const inputArg = process.argv[3];
  const input = MODE === 'dev' ? (process.env.INPUT_FILE || inputArg || './main.lua') : 'src/Init.lua';
  const output = 'dist/main.lua';
  const config = path.join('build', 'darklua.dev.config.json');

  const pkgInfo = getPkgInfo();
  const VER = pkgInfo.v;

  const header = renderHeader(pkgInfo);

  const darklua = runDarklua(input, config);
  const tempPath = path.join('dist', 'temp.lua');
  if (darklua.code !== 0 || !fs.existsSync(tempPath)) {
    console.error(`${E}[ × ]${R} DarkLua gagal`);
    if (darklua.stderr) console.error(darklua.stderr.trim());
    if (!fs.existsSync(tempPath)) {
      console.error(`${E}[ × ]${R} Missing output file: ${tempPath}`);
      console.error(`${E}[ > ]${R} Pastikan 'darklua' terinstall dan ada di PATH (lihat 'aftman.toml').`);
    }
    try { if (fs.existsSync(tempPath)) fs.unlinkSync(tempPath); } catch { }
    process.exit(1);
  }

  fs.mkdirSync('dist', { recursive: true });
  fs.writeFileSync(output, header + '\n\n', 'utf-8');
  const temp = fs.readFileSync(tempPath, 'utf-8');
  fs.appendFileSync(output, temp, 'utf-8');
  try { fs.unlinkSync(tempPath); } catch { }

  const sizeKB = Math.floor(fs.statSync(output).size / 1024);

  console.log('');
  const now = new Date();
  const hhmmss = now.toTimeString().split(' ')[0];
  console.log(`[ ${hhmmss} ]`);
  console.log(`${P}[ ✓ ]${R} ${prefix}`);

  // NEW: info versi yang di-bump
  if (bumpInfo) {
    console.log(`${P}[ > ]${R} Version bumped: ${bumpInfo.oldVer || 'none'} -> ${bumpInfo.newVer}`);
  }

  console.log(`${P}[ > ]${R} ANUI Build completed successfully`);
  console.log(`${P}[ > ]${R} Version: ${VER}`);
  console.log(`${P}[ > ]${R} Time taken: ${darklua.time}ms`);
  console.log(`${P}[ > ]${R} Size: ${sizeKB}KB`);
  console.log(`${P}[ > ]${R} Output file: ${output}`);
  console.log('');

  // Auto-commit hanya untuk mode build
  if (MODE === 'build') {
    // 1. Pindahkan folder script SEBELUM commit
    const scriptWasMoved = moveScriptToParent();

    try {
      // 2. Lakukan Auto Commit (dengan auto force push)
      autoCommit(VER);
    } finally {
      // 3. Kembalikan folder script SETELAH commit (gunakan finally agar tetap jalan meski commit error)
      if (scriptWasMoved) {
        restoreScriptFromParent();
      }
    }
  }
}

main();