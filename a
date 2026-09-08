# Companion Pet System (PETSYS) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the full TRose.exe companion pet system — spawn/follow, care loop, emotion tree, exploration, equipment, naming, deposit, and 6 RmlUi dialogs.

**Architecture:** Server-authoritative pet state with dedicated PostgreSQL table. Pet spawns as a flagged `OBJ_NPC` in the game world. Client loads CSV data directly (not binary PET.DAT). Classic packet protocol (not FlatBuffers). RmlUi for all 6 dialogs.

**Tech Stack:** C++ (MSVC x86), PostgreSQL, RmlUi 6.2, Classic ROSE packet protocol

**Spec:** `doc/pet-system-design.md`  
**RE Reference:** `doc/re-trose-pet-system.md`

## Global Constraints

- Build: `MSBuild.exe rose-next.sln -p:Configuration=release;Platform=x86`
- Rust: `stable-i686-pc-windows-msvc` (build Rust before C++)
- All code is 32-bit x86 Windows
- Packets use `#pragma pack(push, 1)` and inherit `t_PACKETHEADER`
- Server achievement pattern: free functions in `gs_*.h`, NOT classes embedded in `classUSER`
- RmlUi panels: `Initialise/Shutdown/Toggle/Show/Hide/Refresh` interface
- DB migrations: folder `database/migrations/NNNN-name/up.sql` (next = 0012)
- Pet CSV files are in `Jrose/3Ddata/STB/` — copy to `data/3DDATA/STB/` for rose-next
- Max packet ID in use: `0x07f3` (achievements). Pet system starts at `0x07f4`.
- `settings.local.json` contains API key — **NEVER** use `git add -A`; stage explicit paths only.

---

## Phase 1: Foundation

### Task 1: Shared Types (`cpet.h`/`.cpp`)

**Files:**
- Create: `src/common/shared/cpet.h`
- Create: `src/common/shared/cpet.cpp`

**Interfaces:**
- Consumes: nothing (leaf dependency)
- Produces: `PetState`, `PetEquipSlot`, `PetAction`, `PetResult` enums; `PetInfo`, `PetCharDef`, `PetEmotionDef`, `PetSpecialDef`, `PetExploreItem`, `PetExploreTier`, `PetAcceDef` structs; all `PET_*` constants; `PetEmotionIsLearned(unsigned bits, int id) -> bool`, `PetEmotionSetLearned(unsigned& bits, int id)`, `PetGetAffectionLevel(int points) -> int`

- [ ] **Step 1: Create `cpet.h` with all enums, structs, and constants**

```cpp
// src/common/shared/cpet.h
#pragma once
#include <string>
#include <vector>

// ── Constants ──────────────────────────────────────────────
constexpr int PET_MAX_PER_CHAR       = 3;
constexpr int PET_NAME_MAX           = 31;
constexpr int PET_EMOTION_MAX        = 27;
constexpr int PET_EXPLORE_TIERS      = 5;
constexpr int PET_FEED_COOLDOWN_SEC  = 300;
constexpr int PET_BATHE_COOLDOWN_SEC = 600;
constexpr int PET_EXPLORE_BASE_SEC   = 1800;
constexpr int PET_FOLLOW_DISTANCE    = 250;
constexpr int PET_TELEPORT_DISTANCE  = 1500;
constexpr int PET_BATHE_NPC_ID       = 1895;
constexpr int PET_NPC_RANGE_MIN      = 1885;
constexpr int PET_NPC_RANGE_MAX      = 4014;
constexpr int PET_MOOD_DECAY_INTERVAL= 600;
constexpr int PET_MOOD_DEPOSIT_MIN   = 30;
constexpr int PET_FEED_MOOD_GAIN     = 15;
constexpr int PET_BATHE_MOOD_GAIN    = 20;
constexpr int PET_BATHE_TENSION_GAIN = 10;
constexpr int PET_FEED_AFFECTION_PTS = 10;
constexpr int PET_BATHE_AFFECTION_PTS= 15;
constexpr int PET_EMOTE_AFFECTION_PTS= 5;
constexpr int PET_EXPLORE_AFFECTION_PTS = 20;
constexpr int PET_AFFECTION_THRESHOLDS[7] = {0, 0, 100, 300, 600, 1000, 1500};
// Index 0 unused, index 1-6 = threshold for affection levels 1-6

// ── Enums ──────────────────────────────────────────────────
enum PetState : unsigned char {
    PET_STATE_IDLE       = 0,
    PET_STATE_FEEDING    = 1,
    PET_STATE_BATHING    = 2,
    PET_STATE_EMOTING    = 3,
    PET_STATE_EXPLORING  = 4,
    PET_STATE_DEPOSITED  = 5,
};

enum PetEquipSlot : unsigned char {
    PET_SLOT_HEAD  = 1,
    PET_SLOT_BACK  = 2,
    PET_SLOT_ETC   = 3,
    PET_SLOT_CLOTH = 4,
};

enum PetAction : unsigned char {
    PET_ACT_SUMMON          = 0,
    PET_ACT_DISMISS         = 1,
    PET_ACT_FEED            = 2,
    PET_ACT_BATHE           = 3,
    PET_ACT_RENAME          = 4,
    PET_ACT_LEARN_EMOTION   = 5,
    PET_ACT_PERFORM_EMOTION = 6,
    PET_ACT_EQUIP           = 7,
    PET_ACT_UNEQUIP         = 8,
    PET_ACT_EXPLORE_START   = 9,
    PET_ACT_EXPLORE_COLLECT = 10,
    PET_ACT_DEPOSIT         = 11,
    PET_ACT_WITHDRAW        = 12,
    PET_ACT_NAME            = 13,
};

enum PetResult : unsigned char {
    PET_OK                  = 0,
    PET_ERR_NOT_FOUND       = 1,
    PET_ERR_TOO_FAR         = 2,
    PET_ERR_NO_PET          = 3,
    PET_ERR_NOT_SELECTED    = 4,
    PET_ERR_MAX_PETS        = 5,
    PET_ERR_COOLDOWN        = 6,
    PET_ERR_NO_FOOD         = 7,
    PET_ERR_LOW_MOOD        = 8,
    PET_ERR_LOW_AFFECTION   = 9,
    PET_ERR_ALREADY_LEARNED = 10,
    PET_ERR_PREREQ_MISSING  = 11,
    PET_ERR_EMOTION_FULL    = 12,
    PET_ERR_INCOMPATIBLE    = 13,
    PET_ERR_WRONG_PET       = 14,
    PET_ERR_INVALID_NAME    = 15,
    PET_ERR_EXPLORING       = 16,
    PET_ERR_CONDITIONS      = 17,
};

// ── Per-pet runtime state (shared client/server) ──────────
struct PetInfo {
    int         dbId          = 0;
    short       charId        = 0;    // PET_CHAR row -> NPC variant
    char        name[PET_NAME_MAX + 1] = {};
    short       affection     = 1;    // level 1-6
    int         affectionPts  = 0;    // accumulated points within level
    short       mood          = 100;  // 0-100
    short       tension       = 50;   // 0-100
    short       moveSpeed     = 0;
    short       legStrength   = 0;
    int         totalDistance = 0;
    int         exploreCount  = 0;
    int         messageCount  = 0;
    unsigned    learnedEmotions = 0;  // bitfield
    short       equipHead     = 0;    // PET_ACCE row, 0=empty
    short       equipBack     = 0;
    short       equipEtc      = 0;
    short       clothId       = 0;    // PET_CLOTH row, 0=default
    PetState    state         = PET_STATE_IDLE;
    short       exploreTier   = 0;
    int         exploreEndTime= 0;    // server tick when done
};

// ── CSV data definitions (loaded at startup) ──────────────
struct PetCharDef {
    short row;      // PET_CHAR row index
    short group;
    short npcId;
};

struct PetEmotionDef {
    short id;
    short group;
    short grade;
    short prereqs[6];
    short tab;          // 0=tricks, 1=dance
    short slotX, slotY;
    short iconId;
    std::string motionPath;
    std::string name;
    std::string description;
};

struct PetSpecialDef {
    short actionId;
    short targetNpcId;
    std::string motionPath;
    std::string effectPath;
};

struct PetExploreItem {
    short itemType;
    short itemId;
    short weight;
    short minQty;
    short maxQty;
};

struct PetExploreTier {
    short affinityLevel;
    std::vector<PetExploreItem> items;
    int totalWeight;    // precomputed sum of weights
};

struct PetAcceDef {
    std::string name;
    std::string modelPath;
    short slot;
    short boneId;
    short scale;
};

// ── Helpers ───────────────────────────────────────────────
inline bool PetEmotionIsLearned(unsigned bits, int id) {
    if (id < 0 || id >= PET_EMOTION_MAX) return false;
    return (bits & (1u << id)) != 0;
}

inline void PetEmotionSetLearned(unsigned& bits, int id) {
    if (id >= 0 && id < PET_EMOTION_MAX)
        bits |= (1u << id);
}

int PetGetAffectionLevel(int totalPoints);
bool PetIsValidName(const char* name);
```

- [ ] **Step 2: Create `cpet.cpp` with helper implementations**

```cpp
// src/common/shared/cpet.cpp
#include "cpet.h"
#include <cstring>

int PetGetAffectionLevel(int totalPoints) {
    for (int lv = 6; lv >= 1; --lv) {
        if (totalPoints >= PET_AFFECTION_THRESHOLDS[lv])
            return lv;
    }
    return 1;
}

bool PetIsValidName(const char* name) {
    if (!name || name[0] == '\0') return false;
    int len = (int)strlen(name);
    if (len > PET_NAME_MAX) return false;
    for (int i = 0; i < len; ++i) {
        char c = name[i];
        // Block control characters and common injection chars
        if (c < 0x20 && c != '\0') return false;
        if (c == '<' || c == '>' || c == '\\' || c == '/') return false;
    }
    return true;
}
```

- [ ] **Step 3: Add `cpet.cpp` to build**

Add `cpet.cpp` to the source list in `src/common/shared/` section of both `client.vcxproj` and all three server `.vcxproj` files. Follow the same pattern used for `cachievement.cpp`:
- Search for `cachievement.cpp` in each vcxproj
- Add `<ClCompile Include="..\common\shared\cpet.cpp" />` adjacent to it
- Also add `<ClInclude Include="..\common\shared\cpet.h" />` in the headers section

- [ ] **Step 4: Build to verify compilation**

```powershell
MSBuild.exe rose-next.sln -p:Configuration=release;Platform=x86 -t:sho_gameserver -v:m
```

Expected: compiles clean.

- [ ] **Step 5: Commit**

```
git add src/common/shared/cpet.h src/common/shared/cpet.cpp
# Also add the modified .vcxproj files
git commit -m "feat(pet): add shared pet types, enums, and constants"
```

---

### Task 2: Database Migration

**Files:**
- Create: `database/migrations/0012-pet-system/up.sql`
- Create: `database/migrations/0012-pet-system/down.sql`

**Interfaces:**
- Consumes: `characters` table (existing)
- Produces: `character_pets` table

- [ ] **Step 1: Create migration directory**

```powershell
New-Item -ItemType Directory -Path database/migrations/0012-pet-system -Force
```

- [ ] **Step 2: Write `up.sql`**

```sql
-- database/migrations/0012-pet-system/up.sql
CREATE TABLE character_pets (
    id              SERIAL PRIMARY KEY,
    owner_id        INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    pet_char_id     SMALLINT NOT NULL,
    name            VARCHAR(31) NOT NULL,
    affection       SMALLINT NOT NULL DEFAULT 1,
    affection_pts   INTEGER NOT NULL DEFAULT 0,
    mood            SMALLINT NOT NULL DEFAULT 100,
    tension         SMALLINT NOT NULL DEFAULT 50,
    move_speed      SMALLINT NOT NULL DEFAULT 0,
    leg_strength    SMALLINT NOT NULL DEFAULT 0,
    total_distance  INTEGER NOT NULL DEFAULT 0,
    explore_count   INTEGER NOT NULL DEFAULT 0,
    message_count   INTEGER NOT NULL DEFAULT 0,
    learned_emotions INTEGER NOT NULL DEFAULT 0,
    equip_head      SMALLINT NOT NULL DEFAULT 0,
    equip_back      SMALLINT NOT NULL DEFAULT 0,
    equip_etc       SMALLINT NOT NULL DEFAULT 0,
    cloth_id        SMALLINT NOT NULL DEFAULT 0,
    is_summoned     BOOLEAN NOT NULL DEFAULT FALSE,
    is_deposited    BOOLEAN NOT NULL DEFAULT FALSE,
    explore_start   TIMESTAMP NULL,
    explore_tier    SMALLINT NULL,
    last_feed       TIMESTAMP NULL,
    last_bathe      TIMESTAMP NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_pet_owner ON character_pets(owner_id);
```

- [ ] **Step 3: Write `down.sql`**

```sql
-- database/migrations/0012-pet-system/down.sql
DROP TABLE IF EXISTS character_pets;
```

- [ ] **Step 4: Run migration to verify**

```powershell
& "D:\pgsql\bin\psql.exe" -U postgres -d roseonline -f database/migrations/0012-pet-system/up.sql
```

Expected: `CREATE TABLE` / `CREATE INDEX` output, no errors.

- [ ] **Step 5: Verify table exists**

```powershell
& "D:\pgsql\bin\psql.exe" -U postgres -d roseonline -c "\d character_pets"
```

- [ ] **Step 6: Commit**

```
git add database/migrations/0012-pet-system/up.sql database/migrations/0012-pet-system/down.sql
git commit -m "feat(pet): add character_pets database migration"
```

---

### Task 3: Packet Definitions

**Files:**
- Modify: `src/common/net_prototype.h`

**Interfaces:**
- Consumes: `t_PACKETHEADER`, `PetAction`, `PetResult`, `PetState`, `PetEquipSlot`, `PetInfo` from Task 1
- Produces: `CLI_PET_ACTION`/`GSV_PET_DATA` packet IDs; `cli_PET_ACTION`, `gsv_PET_DATA`, `gsv_PET_SPAWN`, `gsv_PET_DESPAWN`, `gsv_PET_EMOTION`, `gsv_PET_EXPLORE_DONE` structs; entries in `t_PACKET` union.

- [ ] **Step 1: Add packet ID defines after `CLI_ACHIEVEMENT_REQ`/`GSV_ACHIEVEMENT_DATA` (0x07f3)**

Find the line `#define CLI_ACHIEVEMENT_REQ  0x07f3` and add after it:

```cpp
// ── Pet system packets ────────────────────────────────────
#define CLI_PET_ACTION       0x07f4
#define GSV_PET_DATA         0x07f4   // reply + updates
#define GSV_PET_SPAWN        0x07f5
#define GSV_PET_DESPAWN      0x07f6
#define GSV_PET_EMOTION      0x07f7
#define GSV_PET_EXPLORE_DONE 0x07f8
```

- [ ] **Step 2: Add packet structs before the `t_PACKET` union**

Find the `cli_ACHIEVEMENT_REQ` struct and add after the achievement structs:

```cpp
// ── Pet system packet structs ────────────────────────────

// Client -> Server: all pet actions through one packet
struct cli_PET_ACTION : public t_PACKETHEADER {
    BYTE  m_btAction;        // PetAction enum
    int   m_iPetDBID;        // pet database ID
    short m_nParam1;         // context-dependent (emotion_id, inv_slot, tier, equip_slot)
    short m_nParam2;         // context-dependent (item_id for equip)
    char  m_szName[32];      // for NAME/RENAME actions (null-terminated)
};

// Server -> Client: pet list or single-pet update
// Variable-length: header + m_nCount * sizeof(gsv_PET_ENTRY)
struct gsv_PET_ENTRY {
    int      m_iPetDBID;
    short    m_nCharId;       // PET_CHAR row
    char     m_szName[32];
    short    m_nAffection;
    int      m_iAffectionPts;
    short    m_nMood;
    short    m_nTension;
    short    m_nMoveSpeed;
    short    m_nLegStrength;
    int      m_iTotalDistance;
    int      m_iExploreCount;
    int      m_iMessageCount;
    unsigned m_dwLearnedEmotions;
    short    m_nEquipHead;
    short    m_nEquipBack;
    short    m_nEquipEtc;
    short    m_nClothId;
    BYTE     m_btState;       // PetState enum
    short    m_nExploreTier;
    int      m_iExploreEndTime;
};

struct gsv_PET_DATA : public t_PACKETHEADER {
    BYTE  m_btAction;         // PetAction that triggered this
    BYTE  m_btResult;         // PetResult enum
    short m_nCount;           // number of gsv_PET_ENTRY following
    // gsv_PET_ENTRY entries[m_nCount]; // variable-length
};

// Server -> Client: pet NPC spawned in world
struct gsv_PET_SPAWN : public t_PACKETHEADER {
    int   m_iPetDBID;
    WORD  m_wObjectIDX;       // NPC world object ID
    short m_nCharId;          // PET_CHAR row (NPC variant)
    char  m_szName[32];
    short m_nEquipHead;
    short m_nEquipBack;
    short m_nEquipEtc;
    short m_nClothId;
};

// Server -> Client: pet removed from world
struct gsv_PET_DESPAWN : public t_PACKETHEADER {
    WORD  m_wObjectIDX;
};

// Server -> Client: play emotion animation on pet
struct gsv_PET_EMOTION : public t_PACKETHEADER {
    WORD  m_wObjectIDX;       // pet NPC object
    short m_nEmotionId;
};

// Server -> Client: exploration finished with rewards
struct gsv_PET_EXPLORE_DONE : public t_PACKETHEADER {
    int   m_iPetDBID;
    BYTE  m_btItemCount;      // 0-3 items
    struct {
        short m_nItemType;
        short m_nItemId;
        short m_nQuantity;
    } m_Items[3];
};
```

- [ ] **Step 3: Add to `t_PACKET` union**

Find the `cli_ACHIEVEMENT_REQ` entry in the union and add after it:

```cpp
    cli_PET_ACTION         m_cli_PET_ACTION;
    gsv_PET_DATA           m_gsv_PET_DATA;
    gsv_PET_SPAWN          m_gsv_PET_SPAWN;
    gsv_PET_DESPAWN        m_gsv_PET_DESPAWN;
    gsv_PET_EMOTION        m_gsv_PET_EMOTION;
    gsv_PET_EXPLORE_DONE   m_gsv_PET_EXPLORE_DONE;
```

- [ ] **Step 4: Build all targets to verify**

```powershell
MSBuild.exe rose-next.sln -p:Configuration=release;Platform=x86 -v:m
```

Expected: all 4 binaries compile clean.

- [ ] **Step 5: Commit**

```
git add src/common/net_prototype.h
git commit -m "feat(pet): add pet packet definitions (0x07f4-0x07f8)"
```

---

### Task 4: Copy Pet CSV/STB Data Files

**Files:**
- Create: `data/3DDATA/STB/PET_CHAR.CSV` (copy from Jrose)
- Create: `data/3DDATA/STB/PET_EMOTION.CSV`
- Create: `data/3DDATA/STB/PET_IDLE.CSV`
- Create: `data/3DDATA/STB/PET_SPECIAL.CSV`
- Create: `data/3DDATA/STB/PET_EXPLOR.CSV`
- Create: `data/3DDATA/STB/PET_ACCE.STB` (copy from Jrose)
- Create: `data/3DDATA/STB/PET_CLOTH.STB`
- Create: `data/3DDATA/STB/PET_DUMMY.STB`

**Interfaces:**
- Consumes: Jrose source files
- Produces: data files in rose-next `data/` for runtime loading

- [ ] **Step 1: Copy CSV files from Jrose**

```powershell
Copy-Item 'Jrose\3Ddata\STB\PET_CHAR.CSV' 'data\3DDATA\STB\PET_CHAR.CSV'
Copy-Item 'Jrose\3Ddata\STB\PET_EMOTION.CSV' 'data\3DDATA\STB\PET_EMOTION.CSV' -Force
Copy-Item 'Jrose\3Ddata\STB\PET_IDLE.CSV' 'data\3DDATA\STB\PET_IDLE.CSV' -Force
Copy-Item 'Jrose\3Ddata\STB\PET_SPECIAL.CSV' 'data\3DDATA\STB\PET_SPECIAL.CSV' -Force
Copy-Item 'Jrose\3Ddata\STB\PET_EXPLOR.CSV' 'data\3DDATA\STB\PET_EXPLOR.CSV' -Force
```

- [ ] **Step 2: Copy STB files from Jrose**

```powershell
Copy-Item 'Jrose\3Ddata\STB\PET_ACCE.STB' 'data\3DDATA\STB\PET_ACCE.STB' -Force
Copy-Item 'Jrose\3Ddata\STB\PET_CLOTH.STB' 'data\3DDATA\STB\PET_CLOTH.STB' -Force
Copy-Item 'Jrose\3Ddata\STB\PET_DUMMY.STB' 'data\3DDATA\STB\PET_DUMMY.STB' -Force
```

- [ ] **Step 3: Verify files exist**

```powershell
Get-ChildItem data\3DDATA\STB\PET* | Select-Object Name, Length
```

Expected: 8 files listed.

> Note: `data/` is gitignored. These files are runtime data, not committed. Document in CLAUDE.md or README that pet CSV/STB must be copied from Jrose.

---

### Task 5: Server Pet Manager Skeleton + CSV Loader

**Files:**
- Create: `src/sho_gameserver/src/gs_pet.h`
- Create: `src/sho_gameserver/src/gs_pet.cpp`
- Modify: `src/sho_gameserver/src/gs_user.h` — add `Recv_cli_PET_ACTION` handler declaration
- Modify: server `.vcxproj` — add new files to build

**Interfaces:**
- Consumes: `cpet.h` (Task 1), `classUSER` (existing), `STBDATA` (existing STB loader)
- Produces: `InitPetSystem()`, `PetLoadCSVData()`, `PetOnLogin(classUSER*)`, `PetOnLogout(classUSER*)`, `PetOnZoneChange(classUSER*)`, global `g_PetCharDefs`, `g_PetEmotionDefs`, `g_PetSpecialDefs`, `g_PetExploreTiers`, `g_PetIdleMotions`

- [ ] **Step 1: Create `gs_pet.h`**

Follow the `gs_achievement.h` pattern — free functions, not a class:

```cpp
// src/sho_gameserver/src/gs_pet.h
#pragma once
#include "shared/cpet.h"
#include <vector>
#include <string>

class classUSER;

// ── Global pet data (loaded once at startup) ─────────────
extern std::vector<PetCharDef>     g_PetCharDefs;
extern std::vector<PetEmotionDef>  g_PetEmotionDefs;
extern std::vector<PetSpecialDef>  g_PetSpecialDefs;
extern std::vector<PetExploreTier> g_PetExploreTiers;
extern std::vector<std::string>    g_PetIdleMotions;

// ── System lifecycle ─────────────────────────────────────
void InitPetSystem();           // Load CSVs + STBs
void PetLoadCSVData();          // Parse all pet CSV files

// ── Per-user lifecycle (called from classUSER) ───────────
void PetOnLogin(classUSER* pUSER);       // Load from DB, send list
void PetOnLogout(classUSER* pUSER);      // Save to DB, despawn
void PetOnZoneChange(classUSER* pUSER);  // Despawn/respawn

// ── Packet handler (called from classUSER::Recv_cli_PET_ACTION) ─
void PetHandleAction(classUSER* pUSER, BYTE action, int petDbId,
                     short param1, short param2, const char* szName);

// ── Helpers ──────────────────────────────────────────────
void PetSendList(classUSER* pUSER);
void PetSendResult(classUSER* pUSER, PetAction action, PetResult result);
const PetCharDef* PetFindCharDef(short charRow);
const PetEmotionDef* PetFindEmotionDef(short emotionId);
```

- [ ] **Step 2: Create `gs_pet.cpp` with CSV loader stub**

```cpp
// src/sho_gameserver/src/gs_pet.cpp
#include "gs_pet.h"
#include "gs_user.h"
#include "LIB_Util.h"
#include <cstdio>
#include <cstring>

// ── Globals ──────────────────────────────────────────────
std::vector<PetCharDef>     g_PetCharDefs;
std::vector<PetEmotionDef>  g_PetEmotionDefs;
std::vector<PetSpecialDef>  g_PetSpecialDefs;
std::vector<PetExploreTier> g_PetExploreTiers;
std::vector<std::string>    g_PetIdleMotions;

// ── CSV parsing helpers ──────────────────────────────────
static std::vector<std::string> SplitCSVLine(const char* line) {
    std::vector<std::string> fields;
    std::string current;
    bool inQuotes = false;
    for (const char* p = line; *p; ++p) {
        if (*p == '"') { inQuotes = !inQuotes; continue; }
        if (*p == ',' && !inQuotes) {
            fields.push_back(current);
            current.clear();
            continue;
        }
        current += *p;
    }
    fields.push_back(current);
    return fields;
}

static short SafeShort(const std::string& s) {
    if (s.empty()) return 0;
    return (short)atoi(s.c_str());
}

// ── PET_CHAR.CSV loader ──────────────────────────────────
static void LoadPetCharCSV(const char* path) {
    FILE* fp = fopen(path, "rb");
    if (!fp) {
        g_LOG(LOG_NORMAL, "[PET] Cannot open %s\n", path);
        return;
    }
    char buf[1024];
    int lineNum = 0;
    while (fgets(buf, sizeof(buf), fp)) {
        lineNum++;
        if (lineNum == 1) continue; // skip header
        auto f = SplitCSVLine(buf);
        if (f.size() < 3) continue;
        if (f[1].empty() || f[2].empty()) continue;
        PetCharDef def;
        def.row   = (short)lineNum;
        def.group = SafeShort(f[1]);
        def.npcId = SafeShort(f[2]);
        g_PetCharDefs.push_back(def);
    }
    fclose(fp);
    g_LOG(LOG_NORMAL, "[PET] Loaded %d pet characters\n", (int)g_PetCharDefs.size());
}

// ── PET_IDLE.CSV loader ──────────────────────────────────
static void LoadPetIdleCSV(const char* path) {
    FILE* fp = fopen(path, "rb");
    if (!fp) return;
    char buf[512];
    int lineNum = 0;
    while (fgets(buf, sizeof(buf), fp)) {
        lineNum++;
        if (lineNum == 1) continue;
        auto f = SplitCSVLine(buf);
        if (f.size() < 3) continue;
        if (f[2].empty()) continue;
        g_PetIdleMotions.push_back(f[2]);
    }
    fclose(fp);
    g_LOG(LOG_NORMAL, "[PET] Loaded %d idle motions\n", (int)g_PetIdleMotions.size());
}

// ── PET_SPECIAL.CSV loader ───────────────────────────────
static void LoadPetSpecialCSV(const char* path) {
    FILE* fp = fopen(path, "rb");
    if (!fp) return;
    char buf[1024];
    int lineNum = 0;
    while (fgets(buf, sizeof(buf), fp)) {
        lineNum++;
        if (lineNum == 1) continue;
        auto f = SplitCSVLine(buf);
        if (f.size() < 7) continue;
        PetSpecialDef def;
        def.actionId    = SafeShort(f[2]);
        def.targetNpcId = SafeShort(f[3]);
        if (f.size() > 4) def.motionPath = f[4];
        if (f.size() > 5) def.effectPath = f[5];
        g_PetSpecialDefs.push_back(def);
    }
    fclose(fp);
    g_LOG(LOG_NORMAL, "[PET] Loaded %d special actions\n", (int)g_PetSpecialDefs.size());
}

// ── PET_EMOTION.CSV loader ───────────────────────────────
static void LoadPetEmotionCSV(const char* path) {
    FILE* fp = fopen(path, "rb");
    if (!fp) return;
    char buf[4096];
    int lineNum = 0;
    while (fgets(buf, sizeof(buf), fp)) {
        lineNum++;
        if (lineNum == 1) continue; // skip header
        auto f = SplitCSVLine(buf);
        if (f.size() < 25) continue;
        if (f[0].empty()) continue; // skip blank rows
        PetEmotionDef def;
        def.id    = (short)lineNum;   // row number = emotion ID
        def.group = SafeShort(f[0]);  // group number
        // f[1] = emotion name (JP)
        def.grade = SafeShort(f[2]);
        // prereqs from grade emotion columns
        def.prereqs[0] = SafeShort(f[3]);
        def.prereqs[1] = SafeShort(f[4]);
        def.prereqs[2] = SafeShort(f[5]);
        def.prereqs[3] = SafeShort(f[6]); // vision emotions
        def.prereqs[4] = SafeShort(f[7]);
        def.prereqs[5] = SafeShort(f[8]);
        def.tab   = SafeShort(f[9]);
        def.slotX = SafeShort(f[10]);
        def.slotY = SafeShort(f[11]);
        def.iconId = SafeShort(f[22]);
        if (f.size() > 23) def.motionPath  = f[23];
        if (f.size() > 24) def.description = f[24];
        def.name = f[1];
        g_PetEmotionDefs.push_back(def);
    }
    fclose(fp);
    g_LOG(LOG_NORMAL, "[PET] Loaded %d emotions\n", (int)g_PetEmotionDefs.size());
}

// ── PET_EXPLOR.CSV loader ────────────────────────────────
static void LoadPetExploreCSV(const char* path) {
    FILE* fp = fopen(path, "rb");
    if (!fp) return;
    char buf[8192];
    int lineNum = 0;
    while (fgets(buf, sizeof(buf), fp)) {
        lineNum++;
        if (lineNum == 1) continue;
        auto f = SplitCSVLine(buf);
        if (f.size() < 4) continue;
        PetExploreTier tier;
        tier.affinityLevel = SafeShort(f[2]);
        tier.totalWeight = 0;
        // Items are in quoted fields from column 3 onward
        // Each is "type id weight min max"
        for (int i = 3; i < (int)f.size(); ++i) {
            if (f[i].empty()) continue;
            int t, id, w, mn, mx;
            if (sscanf(f[i].c_str(), "%d %d %d %d %d", &t, &id, &w, &mn, &mx) == 5) {
                PetExploreItem item;
                item.itemType = (short)t;
                item.itemId   = (short)id;
                item.weight   = (short)w;
                item.minQty   = (short)mn;
                item.maxQty   = (short)mx;
                tier.items.push_back(item);
                tier.totalWeight += w;
            }
        }
        g_PetExploreTiers.push_back(tier);
    }
    fclose(fp);
    g_LOG(LOG_NORMAL, "[PET] Loaded %d explore tiers\n", (int)g_PetExploreTiers.size());
}

// ── Init ─────────────────────────────────────────────────
void PetLoadCSVData() {
    g_PetCharDefs.clear();
    g_PetEmotionDefs.clear();
    g_PetSpecialDefs.clear();
    g_PetExploreTiers.clear();
    g_PetIdleMotions.clear();

    LoadPetCharCSV("3DDATA\\STB\\PET_CHAR.CSV");
    LoadPetIdleCSV("3DDATA\\STB\\PET_IDLE.CSV");
    LoadPetSpecialCSV("3DDATA\\STB\\PET_SPECIAL.CSV");
    LoadPetEmotionCSV("3DDATA\\STB\\PET_EMOTION.CSV");
    LoadPetExploreCSV("3DDATA\\STB\\PET_EXPLOR.CSV");
}

void InitPetSystem() {
    PetLoadCSVData();
    g_LOG(LOG_NORMAL, "[PET] Pet system initialized\n");
}

// ── Helpers (stubs — implemented in Phase 2+) ────────────
const PetCharDef* PetFindCharDef(short charRow) {
    for (auto& d : g_PetCharDefs)
        if (d.row == charRow) return &d;
    return nullptr;
}

const PetEmotionDef* PetFindEmotionDef(short emotionId) {
    for (auto& d : g_PetEmotionDefs)
        if (d.id == emotionId) return &d;
    return nullptr;
}

void PetSendList(classUSER* pUSER) {
    // TODO Phase 2: send GSV_PET_DATA with full pet list
}

void PetSendResult(classUSER* pUSER, PetAction action, PetResult result) {
    // TODO Phase 2: send GSV_PET_DATA with result code
}

void PetOnLogin(classUSER* pUSER) {
    // TODO Phase 2: load pets from DB, send list
}

void PetOnLogout(classUSER* pUSER) {
    // TODO Phase 2: save pets to DB, despawn
}

void PetOnZoneChange(classUSER* pUSER) {
    // TODO Phase 2: despawn/respawn pet NPC
}

void PetHandleAction(classUSER* pUSER, BYTE action, int petDbId,
                     short param1, short param2, const char* szName) {
    // TODO Phase 2+: dispatch to specific handlers
    PetSendResult(pUSER, (PetAction)action, PET_ERR_CONDITIONS);
}
```

- [ ] **Step 3: Add packet handler declaration to `gs_user.h`**

Find `bool Recv_cli_ACHIEVEMENT_REQ(t_PACKET* pPacket);` and add after it:

```cpp
    bool Recv_cli_PET_ACTION(t_PACKET* pPacket);
```

- [ ] **Step 4: Add packet handler implementation**

Find `classUSER::Recv_cli_ACHIEVEMENT_REQ` in the server codebase and add a similar handler nearby (likely in `gs_user.cpp` or `gs_user_main.cpp`):

```cpp
bool classUSER::Recv_cli_PET_ACTION(t_PACKET* pPacket) {
    cli_PET_ACTION& pkt = pPacket->m_cli_PET_ACTION;
    pkt.m_szName[31] = '\0'; // ensure null-termination
    PetHandleAction(this, pkt.m_btAction, pkt.m_iPetDBID,
                    pkt.m_nParam1, pkt.m_nParam2, pkt.m_szName);
    return true;
}
```

- [ ] **Step 5: Register packet handler in dispatch table**

Find where `CLI_ACHIEVEMENT_REQ` is registered in the packet dispatch (search for `CLI_ACHIEVEMENT_REQ` in the server packet routing code) and add:

```cpp
case CLI_PET_ACTION:
    return Recv_cli_PET_ACTION(pPacket);
```

- [ ] **Step 6: Call `InitPetSystem()` at server startup**

Find where `InitAchievementSystem()` is called in the gameserver startup sequence and add after it:

```cpp
#include "gs_pet.h"
// ...
InitPetSystem();
```

- [ ] **Step 7: Add new files to server `.vcxproj`**

Add `gs_pet.cpp` and `gs_pet.h` to the gameserver project, adjacent to `gs_achievement.*`.

- [ ] **Step 8: Build gameserver**

```powershell
taskkill /f /im mspdbsrv.exe 2>$null; MSBuild.exe rose-next.sln -p:Configuration=release;Platform=x86 -t:sho_gameserver -v:m
```

Expected: compiles clean, server starts and prints `[PET] Pet system initialized` + CSV load counts.

- [ ] **Step 9: Commit**

```
git add src/sho_gameserver/src/gs_pet.h src/sho_gameserver/src/gs_pet.cpp
# Also stage modified gs_user.h, dispatch file, startup file, .vcxproj
git commit -m "feat(pet): server pet manager skeleton with CSV loaders"
```

---

## Phase 2-8: Remaining Phases

Phases 2-8 follow the same task structure. Due to plan size, they are outlined below with key implementation details. Each phase should be expanded to full step-by-step detail at execution time, using the patterns established in Phase 1.

### Task 6 (Phase 2): Server Summon/Dismiss + DB Load/Save

**Files:** Modify `gs_pet.cpp`, `gs_user.cpp`

**Key implementation:**
- `PetOnLogin`: `SELECT * FROM character_pets WHERE owner_id = ?` via SQL thread
- `PetOnLogout`: `UPDATE character_pets SET ... WHERE id = ?`
- Summon: spawn NPC via `pZONE->AddPetNPC(npcId, ownerPos)` — need to add this method to `CZoneTHREAD` that creates an `CObjNPC` with `m_bCompanionPet = true`
- Dismiss: remove NPC from zone, set `is_summoned = false`
- `PetSendList`: build `gsv_PET_DATA` packet with all pet entries
- `PetSendResult`: build `gsv_PET_DATA` with `m_nCount = 0` and result code

### Task 7 (Phase 2): Server Pet Follow Tick

**Files:** Modify `gs_pet.cpp`, add to zone tick

**Key implementation:**
- In the pet NPC's `Proc()` tick (or via the zone thread's per-NPC tick):
  - Get owner position, compute target offset behind owner facing direction
  - If distance > PET_TELEPORT_DISTANCE → warp to owner
  - If distance > PET_FOLLOW_DISTANCE → `SetCMD_MOVE2D` toward target
  - Else → idle
- Zone change: hook `PetOnZoneChange` into the existing zone-transition handler for `classUSER`

### Task 8 (Phase 2): Client CPetManager + Recv Handlers

**Files:** Create `src/client/gamedata/cpetmanager.h/.cpp`, modify `recvpacket.cpp`, `sendpacket.h/.cpp`

**Key implementation:**
- `CPetManager::Instance()` singleton
- `LoadCSVData()`: same CSV parsing as server (shared logic or duplicate)
- `OnPetList()`: populate `m_Pets[]` from `gsv_PET_DATA` entries
- `OnPetSpawn()`: store `m_nActiveObjID`, mark NPC object as companion pet
- `OnPetDespawn()`: clear active object
- Send functions: fill `cli_PET_ACTION` struct and call `Send_PACKET`
- Add `Recv_gsv_PET_DATA`, `Recv_gsv_PET_SPAWN`, `Recv_gsv_PET_DESPAWN`, `Recv_gsv_PET_EMOTION`, `Recv_gsv_PET_EXPLORE_DONE` to `CRecvPACKET`

### Task 9 (Phase 2): Client Pet NPC Companion Flag

**Files:** Modify client `CObjNPC` (search for the actual file path), modify name rendering

**Key implementation:**
- Add `bool m_bCompanionPet = false` to the client NPC object
- Add `char m_szPetName[32] = {}` for custom name
- In `DrawName()`: if companion pet, draw `m_szPetName` with special color (e.g. green)
- In click handler: if companion pet, call `RoseRmlPet::Show()` instead of NPC dialog
- Suppress HP bar drawing for companion pets

### Task 10 (Phase 3): Server Care Handlers (Feed/Bathe/Mood)

**Files:** Modify `gs_pet.cpp`

**Key implementation:**
- `PetHandleFeed`: check cooldown (`last_feed + PET_FEED_COOLDOWN_SEC < now`), find food item in inventory, consume it, mood += 15, affection_pts += 10, check level up, send update
- `PetHandleBathe`: check NPC 1895 proximity, cooldown, mood += 20, tension += 10, affection_pts += 15, broadcast emotion anim
- Mood decay: in zone tick, every PET_MOOD_DECAY_INTERVAL seconds, decrement mood for all online users with summoned pets

### Task 11 (Phase 4): Server Name/Deposit Handlers

**Files:** Modify `gs_pet.cpp`

**Key implementation:**
- `PetHandleName`/`PetHandleRename`: call `PetIsValidName()`, update DB, send update
- `PetHandleDeposit`: check mood > 30, despawn NPC, set `is_deposited = true`
- `PetHandleWithdraw`: check deposit NPC proximity, unmark deposited
- Register `GF_PetDepositOpen` as Lua game function

### Task 12 (Phase 5): Server Emotion Learning + Exploration

**Files:** Modify `gs_pet.cpp`

**Key implementation:**
- `PetHandleLearnEmotion`: validate group, grade, prereqs (bitfield checks), mutual exclusion (vision emotion links), set bit, send update
- `PetHandlePerformEmotion`: check learned, broadcast `GSV_PET_EMOTION`
- `PetHandleExploreStart`: validate tier <= affection, despawn pet, set state + timer
- `PetHandleExploreCollect`: check timer elapsed, weighted random loot roll, create items in inventory, send `GSV_PET_EXPLORE_DONE`

### Task 13 (Phase 6): Server Equipment + Client Accessory Rendering

**Files:** Modify `gs_pet.cpp`, client model attachment code

**Key implementation:**
- Server: validate accessory exists, set slot, send `GSV_PET_EQUIP_UPDATE`
- Client: on equip update, load ZSC object from `PET_ACCE.ZSC`, get bone ID from `PET_DUMMY.STB`, attach model part to pet NPC skeleton bone
- Cloth: swap body texture DDS using the path from `PET_CLOTH.STB`

### Tasks 14-19 (Phase 7): RmlUi Dialogs

Each dialog follows the `RoseRmlAchievement` pattern:
- Class with `Initialise(ctx, assetDir)`, `Shutdown()`, `Toggle()`, `Show()`, `Hide()`, `Refresh()`
- `BuildDataModel()` registers data bindings and event callbacks
- Inner row structs for list data
- `.RML` + `.RCSS` asset files in `data/3DDATA/rmlui/`

**Task 14:** `RoseRmlPetName` — simplest dialog, editbox + 2 buttons
**Task 15:** `RoseRmlPetRename` — old name display + editbox + 2 buttons
**Task 16:** `RoseRmlPetFood` — inventory scan for food items, icon grid
**Task 17:** `RoseRmlPetDeposit` — scrollable pet list, modal
**Task 18:** `RoseRmlCompetence` — stat display from PetInfo
**Task 19:** `RoseRmlPet` — main window, most complex:
- Top tab bar (5 tabs) switching between info pane and list pane
- Info pane: portrait, name, bars, 4 action buttons, sub-tab bar (5 sub-tabs)
- Sub-tab content: trick grid, dance tree, stats, explore tier selector
- List pane: full-info rows with 64x64 portrait icons, state badges

### Task 20 (Phase 8): Polish

**Files:** Various

**Key implementation:**
- Pet idle animation cycling: random selection from 4 warning ZMOs on timer
- Error message strings mapped from `PetResult` enum
- Explore countdown timer display in UI
- GM commands: `/pet give <variant>`, `/pet setaffection <level>` (chat command handler)
- Edge case: owner dies → pet enters idle near death position (does not despawn)
- Edge case: pet in different sector than owner → teleport on next tick

---

## Verification Checklist

- [ ] Server compiles and starts with `[PET] Pet system initialized`
- [ ] Client compiles and loads pet CSV data
- [ ] GM `/pet give 2` gives a White Ronya pet
- [ ] Pet spawns and follows player
- [ ] Pet survives zone change
- [ ] Feed pet → mood increases, food consumed
- [ ] Bathe near NPC 1895 → animation plays, mood increases
- [ ] Name pet on first obtain (31 char max)
- [ ] Rename pet
- [ ] Deposit/withdraw at NPC
- [ ] Learn trick → icon lights up in UI
- [ ] Perform trick → pet plays animation, visible to nearby players
- [ ] Send pet on exploration → pet despawns → returns with items
- [ ] Equip accessory → visible on pet model
- [ ] Change cloth → pet body texture changes
- [ ] All 6 dialogs open and function
- [ ] Pet list shows portrait icons per variant
- [ ] Mood decays over time while summoned
- [ ] Affection levels up after enough interactions
- [ ] Multiple pets (up to 3) tracked per character
- [ ] Pet state persists across login/logout
