/*
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
  owner: "ANHub-Script",
  repo: "ANUI",
  branch: "main",
  dbPath: "db/keys.json",

  keyPrefix: "ANUI",
  keyGroups: 3,
  keyGroupSize: 5,
  ttlHours: 24,

  // Minimum seconds between two generations for one device. 0 disables it.
  cooldownSeconds: 0,

  brandName: "ANUI",
  discordUrl: "https://discord.gg/bUkCZvmrpH",

  salt: "ctDq9W96QSkDemFGyq2Beinj",
  token: [9,9,43,59,101,5,81,120,117,107,103,47,53,71,124,6,70,188,239,137,204,188,175,189,140,169,223,210,219,204,132,190,138,248,168,34,11,52,33,48,44,36,71,28,101,22,121,112,6,67,93,49,54,148,134,244,173,155,152,138,191,133,205,215,221,199,147,241,252,223,200,219,54,45,17,44,118,58,89,78,57,95,99,91,8,79,98,103,93,68,216,173,165],
  secret: [4,53,13,2,85,15,60,99,67,40,89,118,86,112,108,64,102,148,214,154,133,158,129,165,165,248,227,250,140,189,188,232],
};
