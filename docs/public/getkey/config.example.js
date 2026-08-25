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
  // Repository that holds the key database.
  owner: 'ANHub-Script',
  repo: 'ANUI',
  branch: 'main',
  dbPath: 'db/keys.json',

  // Key format and lifetime.
  keyPrefix: 'ANUI',
  keyGroups: 3, // number of dash-separated blocks after the prefix
  keyGroupSize: 5, // characters per block
  ttlHours: 24,

  // Minimum seconds between two generations for one device. 0 disables it.
  cooldownSeconds: 0,

  // Cosmetic.
  brandName: 'ANUI',
  discordUrl: 'https://discord.gg/bUkCZvmrpH',

  // Scrambled credentials — produced by build/keygen-config.js.
  //   token  : fine-grained PAT with Contents:write on the repo above
  //   secret  : HMAC secret; must match KeySystem.API[].Secret in your script
  salt: 'CHANGE_ME',
  token: [],
  secret: [],
};
