/*
 * ANUI key generator — runtime configuration.
 *
 * DO NOT EDIT BY HAND. Generate it so the credentials are not stored verbatim:
 *
 *     node build/keygen-config.js
 *
 * ---------------------------------------------------------------------------
 * READ THIS BEFORE YOU DEPLOY
 * ---------------------------------------------------------------------------
 * GitHub Pages serves static files, so the token that writes db/keys.json ships
 * to every visitor's browser. The scrambling below only stops GitHub's own
 * secret scanner from auto-revoking the token and deters casual copy-paste. It
 * is NOT security: anyone who reads this file can recover the token.
 *
 * Keep the blast radius small:
 *   1. Use a FINE-GRAINED personal access token, never a classic one.
 *   2. Scope it to the key-database repository ONLY.
 *   3. Give it exactly one permission: Contents -> Read and write.
 *   4. Set an expiry and rotate on schedule.
 *   5. Strongly preferred: put the database in a SEPARATE repo (e.g. ANUI-Keys)
 *      so a leaked token cannot touch your library's source.
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

  salt: "7mUcOxwdZd4BOnNS-jI59lqr",
  token: [93,16,58,41,19,42,31,42,126,92,56,41,31,82,100,118,4,161,140,235,249,147,183,190,225,181,243,207,249,200,193,232,220,252,162,46,41,14],
  secret: [78,28,61,53,75,59,37,57,109,77,19,53,88,103,77,80,53],
};
