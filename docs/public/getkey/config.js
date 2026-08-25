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
  repo: "ANUI-Keys",
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

  salt: "GAmIKJhRboRD9gojvpBiPfT_",
  token: [45,60,2,3,23,24,0,28,70,87,94,47,105,77,85,43,73,189,159,162,249,158,199,136,196,181,234,247,172,253,246,210,233,196,220,51,91,38,0,69,97,31,53,39,101,84,72,121,67,68,73,72,124,189,223,154,150,198,148,172,242,134,147,254,232,157,222,207,218,242,242,146,12,7,4,96,3,51,115,51,14,29,74,68,41,55,70,60,49,64,131,179,153],
  secret: [16,17,50,1,38,73,59,37,104,89,109,83,12,76,87,87,94,198,186,149,134,141,193,128,149,169,228,224,183,223,241,225],
};
