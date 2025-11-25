repeat
	task.wait();
until game:IsLoaded();

-- [LOADING SCREEN DARI FILE 2]
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

-- [MODIFIKASI 1: UPDATE FOLDER PATH]
-- Path dasar sekarang diarahkan langsung ke ANUI/AnimeWeapons
local FolderPath = "ANUI/AnimeWeapons"; 
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"; -- File timer ditaruh di dalam folder agar rapi
local ZoneDBFile = "Zone_Database.json";

local function SecureWipe()
	if not isfile or (not delfile) or (not readfile) or (not listfiles) then
		return;
	end;
	local currentTime = os.time();
	local isExpired = false;
	
    -- Cek path baru
	if isfile(ExpiryFile) then
		local savedTime = tonumber(readfile(ExpiryFile)) or 0;
		if currentTime > savedTime then
			isExpired = true;
		end;
	-- Cek folder lama untuk pembersihan (Opsional, menjaga kebersihan file lama)
	elseif isfolder(FolderPath) then
		isExpired = true;
	end;

	if isExpired then
		if isfile(ExpiryFile) then
			delfile(ExpiryFile);
		end;
		
        -- List folder yang mungkin berisi data lama/baru untuk dibersihkan jika expired
		local PossiblePaths = {
			"ANUI/AnimeWeapons",
		};
		local UserId = tostring(game.Players.LocalPlayer.UserId);
		for _, path in pairs(PossiblePaths) do
			if isfolder(path) then
				for _, file in pairs(listfiles(path)) do
					if string.find(file, ".key") or string.find(file, ".json") or string.find(file, UserId) then
						pcall(function()
							delfile(file);
						end);
					end;
				end;
			end;
		end;
		task.wait(0.5);
	end;
end;
SecureWipe();

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local Reliable = (ReplicatedStorage:WaitForChild("Reply")):WaitForChild("Reliable");
local Unreliable = (ReplicatedStorage:WaitForChild("Reply")):WaitForChild("Unreliable");

-- Pastikan folder utama ada
if not isfolder("ANUI") then makefolder("ANUI") end
if not isfolder(FolderPath) then makefolder(FolderPath) end

local Config = {
	AutoFarm = false,
	AutoDungeon = false,
	AutoFuse = false,
	AutoRankUp = false,
	AutoYen_Luck = false,
	AutoYen_Damage = false,
	AutoYen_Yen = false,
	AutoYen_Mastery = false,
	AutoYen_Critical = false,
	AutoRollBiju = false,
	AutoRollRace = false,
	AutoRollSayajin = false,
	AutoRollFruits = false,
	AutoRollHaki = false,
	AutoRollBreathing = false,
	AutoRollOrganization = false,
	AutoRollTitan = false,
    AutoRollMagicEyes = false,
    AutoRollDemonArt = false,
    AutoUpgradeMagicEyes = false,
	AutoChance_Breath = false,
	AutoChance_Pirate = false,
	AutoChance_Wise = false,
	AutoChance_Leve = false,
	SelectedEnemy = nil,
	ZoneConfigurations = {},
	TargetDungeon = {},
	TargetRaid = {},
	TargetDefense = {} 
};
local hrp, humanoid;
local LastZone = nil;
local CurrentZoneName = "";
local CurrentZoneEnemiesCache = {};
local IsLoadingConfig = false;
local IsTeleporting = false;
local GlobalEnemyMap = {};
local RollConfigs = {};
local AllRollTypes = {
	"Biju",
	"Race",
	"Sayajin",
	"Fruits",
	"Haki",
	"Breathing",
	"Organization",
	"Titan",
    "MagicEyes",
    "DemonArt"
};
local ChanceUpgradeTypes = {
	"Breath",
	"Pirate",
	"Wise",
	"Leve"
};
local EnemyDropdown = nil;
local RankProgressUI = nil;
local RollToggleUI = {};
local YenUpgradeToggleUI = {};
local TokenUpgradeToggleUI = {};
local ChanceUpgradeToggleUI = {};
(getgenv()).PlayerData = nil;

local function JSONPretty(val, indent)
	indent = indent or 0;
	local valType = type(val);
	if valType == "table" then
		local s = "{\n";
		for k, v in pairs(val) do
			local formattedKey = type(k) == "number" and tostring(k) or "\"" .. tostring(k) .. "\"";
			s = s .. string.rep("    ", indent + 1) .. formattedKey .. ": " .. JSONPretty(v, indent + 1) .. ",\n";
		end;
		return s .. string.rep("    ", indent) .. "}";
	elseif valType == "string" then
		return "\"" .. val .. "\"";
	else
		return tostring(val);
	end;
end;
local function ScanPlayerData()
	if (getgenv()).PlayerData then
		return;
	end;
	for _, v in pairs(getgc(true)) do
		if type(v) == "table" then
			if rawget(v, "Attributes") and rawget(v, "YenUpgrades") then
				(getgenv()).PlayerData = v;
				break;
			end;
			if rawget(v, "Data") and type(rawget(v, "Data")) == "table" then
				local inner = rawget(v, "Data");
				if rawget(inner, "Attributes") and rawget(inner, "YenUpgrades") then
					(getgenv()).PlayerData = inner;
					break;
				end;
			end;
		end;
	end;
end;
task.spawn(ScanPlayerData);
local function InitAutoReconnectBypass()
	local targetFound = false;
	local function activateBypass(func, uiObject, numIndex)
		task.spawn(function()
			while true do
				debug.setupvalue(func, numIndex, 0);
				if uiObject then
					uiObject.Visible = true;
					uiObject.Text = "ANHub Bypass Reconnect V2";
					uiObject.TextColor3 = Color3.fromRGB(0, 255, 100);
				end;
				task.wait(0.1);
			end;
		end);
	end;
	local function deepScan(func, path)
		if not islclosure(func) then
			return;
		end;
		local upvalues = debug.getupvalues(func);
		local foundUI = nil;
		local foundNumIndex = nil;
		for i, v in pairs(upvalues) do
			if typeof(v) == "Instance" and v.Name == "autoReconnect" then
				foundUI = v;
			end;
			if type(v) == "number" then
				foundNumIndex = i;
			end;
		end;
		if foundUI and foundNumIndex then
			if not targetFound then
				targetFound = true;
				activateBypass(func, foundUI, foundNumIndex);
			end;
		end;
		local protos = debug.getprotos(func);
		for i, proto in pairs(protos) do
			deepScan(proto, path .. " > Proto" .. i);
		end;
	end;
	for _, func in pairs(getgc()) do
		if type(func) == "function" and islclosure(func) and (not isexecutorclosure(func)) then
			local info = debug.getinfo(func);
			if info.source and string.find(info.source, "AutoReconnect.c") then
				deepScan(func, "Main");
			end;
		end;
	end;
	local VirtualUser = game:GetService("VirtualUser");
	(game:GetService("Players")).LocalPlayer.Idled:Connect(function()
		VirtualUser:CaptureController();
		VirtualUser:ClickButton2(Vector2.new());
	end);
end;
task.spawn(InitAutoReconnectBypass);
local ConfigsPath = ReplicatedStorage.Scripts.Configs;
local YenModule = require(ConfigsPath.Machines.YenUpgrades);
local TokenModule = require(ConfigsPath.Machines.TokenUpgrades);
local RankModule = require(ConfigsPath.Machines.RankUp);
local UtilsModule = require(ConfigsPath.Utility.Utils);
local MaterialsModule = require(ConfigsPath.General.Materials);
local ChanceModules = {};
local ChancePath = ReplicatedStorage.Scripts.Configs:FindFirstChild("ChanceUpgrades");
if ChancePath then
	for _, name in ipairs(ChanceUpgradeTypes) do
		local s, m = pcall(require, ChancePath:FindFirstChild(name));
		if s and type(m) == "table" then
			ChanceModules[name] = m;
		else
			warn("Failed to load Chance Module: " .. name);
		end;
	end;
end;
local MagicEyesModule = nil;
pcall(function()
    MagicEyesModule = require(ReplicatedStorage.Scripts.Configs.RollGachaUpgrades.MagicEyes);
end);
local DemonArtModule = nil;
pcall(function()
    DemonArtModule = require(ReplicatedStorage.Scripts.Configs.RollGachaUpgrades.DemonArt);
end);
local YenUpgradeConfig = YenModule.Config;
local TokenUpgradeConfig = TokenModule.Config;
local MaxRankCap = RankModule.MAX or 33;
local function GetYenCost(lvl)
	return YenModule.GetUpgradeCost(lvl);
end;
local function GetYenBuff(name, lvl)
	return YenModule.GetUpgradeBuff(name, lvl);
end;
local function GetTokenCost(lvl)
	return TokenModule.GetUpgradeCost(lvl);
end;
local function GetTokenBuff(name, lvl)
	return TokenModule.GetUpgradeBuff(name, lvl);
end;
local function GetRankRequirement(rank)
	return RankModule.GetRequirement(rank);
end;
local function GetRankBuff(rank)
	return RankModule.GetBuff(rank);
end;
local function FormatNumber(n)
	return UtilsModule.ToText(n);
end;
local RollMaterialMap = {
	Biju = "BijuToken",
	Race = "RaceToken",
	Sayajin = "SayajinToken",
	Fruits = "FruitsToken",
	Haki = "HakiToken",
	Breathing = "BreathingToken",
	Organization = "OrganizationToken",
	Titan = "TitanToken",
    MagicEyes = "EyeToken",
    DemonArt = "DemonToken"
};
local RollDisplayNames = {
	Biju = "Biju Shard",
	Race = "Race Shard",
	Sayajin = "Sayajin Shard",
	Fruits = "Fruits Shard",
	Haki = "Haki Shard",
	Breathing = "Breathing Stone",
	Organization = "Organization Shard",
	Titan = "Titan Shard",
    MagicEyes = "Magic Eyes",
    DemonArt = "Demon Art"
};
local RollTypeToConfig = {
	Biju = "AutoRollBiju",
	Race = "AutoRollRace",
	Sayajin = "AutoRollSayajin",
	Fruits = "AutoRollFruits",
	Haki = "AutoRollHaki",
	Breathing = "AutoRollBreathing",
	Organization = "AutoRollOrganization",
	Titan = "AutoRollTitan",
    MagicEyes = "AutoRollMagicEyes",
    DemonArt = "AutoRollDemonArt"
};

local function LoadZoneDB()
    -- Path manual diupdate ke FolderPath
	if isfile(FolderPath .. "/" .. ZoneDBFile) then
		local success, result = pcall(function()
			return HttpService:JSONDecode(readfile(FolderPath .. "/" .. ZoneDBFile));
		end);
		if success and type(result) == "table" then
			Config.ZoneConfigurations = result;
		end;
	end;
end;

local function SaveZoneConfig(zone, selectedItem)
	if not zone or zone == "" or zone == "Unknown" then
		return;
	end;
	if not selectedItem then
		return;
	end;
	local val = type(selectedItem) == "table" and selectedItem.Value or selectedItem;
	local title = type(selectedItem) == "table" and selectedItem.Title or selectedItem;
	if not val or val == "" then
		return;
	end;
	local savedEntry = {};
	local foundObj = nil;
	for _, cached in ipairs(CurrentZoneEnemiesCache) do
		if cached.Value == val then
			foundObj = cached;
			break;
		end;
	end;
	if foundObj then
		savedEntry = foundObj;
	else
		savedEntry = {
			Title = title,
			Value = val,
			Desc = "Saved"
		};
	end;
	Config.SelectedEnemy = val;
	Config.ZoneConfigurations[zone] = savedEntry;
	
    -- Path manual diupdate ke FolderPath
	if not isfolder(FolderPath) then
		makefolder(FolderPath);
	end;
	if writefile and HttpService then
		pcall(function()
			writefile(FolderPath .. "/" .. ZoneDBFile, HttpService:JSONEncode(Config.ZoneConfigurations));
		end);
	end;
end;
LoadZoneDB();

local function GetOnlineKeys()
	local keys = {
		"Keynya",
		"FreeKey"
	};
	local url = "https://raw.githubusercontent.com/AdityaNugrahaInside/ANHub/refs/heads/main/Key";
	local success, response = pcall(function()
		return game:HttpGet(url);
	end);
	if success then
		keys = {};
		for line in response:gmatch("[^\r\n]+") do
			local cleanKey = string.gsub(line, "^%s*(.-)%s*$", "%1");
			if cleanKey ~= "" then
				table.insert(keys, cleanKey);
			end;
		end;
	end;
	return keys;
end;
local function GetDynamicRankIcon()
	local iconId = "rbxassetid://84366761557806";
	pcall(function()
		local part = Workspace.Billboards.Machines.RankUp.icon;
		if part and part.Image then
			iconId = part.Image;
		end;
	end);
	return iconId;
end;
local function GetRollIconAsset(rollType)
	local fallback = "rbxassetid://84366761557806";
	local assetId = "";
	pcall(function()
		local machine = Workspace.Billboards.CrateRoll:FindFirstChild(rollType);
		if machine and machine:FindFirstChild("icon") then
			assetId = machine.icon.Image;
		end;
	end);
	if assetId == "" or assetId == nil then
		if RollConfigs[rollType] and RollConfigs[rollType].ImageId then
			assetId = RollConfigs[rollType].ImageId;
		end;
	end;
	if assetId and assetId ~= "" then
		local cleanId = ((tostring(assetId)):gsub("rbxassetid://", "")):gsub("http://www.roblox.com/asset/%?id=", "");
		if tonumber(cleanId) then
			return "rbxassetid://" .. cleanId;
		else
			return assetId;
		end;
	end;
	return fallback;
end;
local dungeonList, dungeonDB, raidList, raidDB = {}, {}, {}, {};
local defenseList, defenseDB = {}, {}; 
local function LoadDungeonData()
	local success, module = pcall(function()
		return require(ReplicatedStorage.Scripts.Configs.Gamemodes.Dungeon);
	end);
	if success and module and module.PHASES then
		dungeonList, dungeonDB = {}, {};
		for id, phase in ipairs(module.PHASES) do
			local dName = phase.Name;
			local hpCalc = math.floor((phase.HealthBase or 0) / 50);
			local desc = "Hp Base: " .. FormatNumber(hpCalc);
			table.insert(dungeonList, {
				Title = dName,
				Desc = desc,
				Value = dName
			});
			dungeonDB[dName] = {
				ID = id,
				Time = phase.START_MINUTE,
				BaseDesc = desc
			};
		end;
	end;
end;
local function LoadRaidData()
	local success, module = pcall(function()
		return require(ReplicatedStorage.Scripts.Configs.Gamemodes.Raid);
	end);
	if success and module and module.PHASES then
		raidList, raidDB = {}, {};
		for id, phase in ipairs(module.PHASES) do
			local rName = phase.Name;
			local hpCalc = math.floor((phase.HealthBase or 0) / 50);
			local desc = "Hp Base: " .. FormatNumber(hpCalc);
			table.insert(raidList, {
				Title = rName,
				Desc = desc,
				Value = rName
			});
			raidDB[rName] = {
				ID = id,
				Times = phase.START_TIMES,
				BaseDesc = desc
			};
		end;
	end;
end;
local function LoadDefenseData()
	local success, module = pcall(function()
		return require(ReplicatedStorage.Scripts.Configs.Gamemodes.Defense);
	end);
	if success and module and module.PHASES then
		defenseList, defenseDB = {}, {};
		for id, phase in ipairs(module.PHASES) do
			local rName = phase.Name;
			local hpCalc = math.floor((phase.HealthBase or 0) / 50);
			local desc = "Hp Base: " .. FormatNumber(hpCalc);
			table.insert(defenseList, {
				Title = rName,
				Desc = desc,
				Value = rName
			});
			defenseDB[rName] = {
				ID = id,
				Times = phase.START_TIMES,
				BaseDesc = desc 
			};
		end;
	end;
end;
local function LoadRollData(rollType)
	local success, module = pcall(function()
		return require(ReplicatedStorage.Scripts.Configs.RollGachas[rollType]);
	end);
	if success and module then
		RollConfigs[rollType] = {
			Cost = module.Cost or 1,
			MaterialKey = module.Material or rollType .. "Token",
			ImageId = module.ImageId
		};
	else
		RollConfigs[rollType] = {
			Cost = 1,
			MaterialKey = rollType .. "Token",
			ImageId = "84366761557806"
		};
	end;
end;
LoadDungeonData();
LoadRaidData();
LoadDefenseData(); 
for _, rollType in ipairs(AllRollTypes) do
	LoadRollData(rollType);
end;
local function RefreshEnemyData()
	local uiList = {};
	local seenForUI = {};
	GlobalEnemyMap = {};
	local EnemiesFolder = Workspace:FindFirstChild("Enemies");
	if not EnemiesFolder then
		return uiList;
	end;
	for _, v in pairs(getgc(true)) do
		if type(v) == "table" then
			local config = rawget(v, "Config");
			local alive = rawget(v, "Alive");
			local uid = rawget(v, "Uid");
			local dataSection = rawget(v, "Data");
			if config and alive == true and uid and dataSection and dataSection.CFrame then
				local display = config.Display or "Unknown";
				local realName = rawget(v, "Character") and v.Character.Name or display;
				if not GlobalEnemyMap[realName] then
					GlobalEnemyMap[realName] = {};
				end;
				table.insert(GlobalEnemyMap[realName], v);
				if not seenForUI[realName] then
					seenForUI[realName] = true;
					table.insert(uiList, {
						Title = display .. " (" .. (config.Difficult or "Normal") .. ")",
						Value = realName,
						Desc = "HP: " .. FormatNumber((config.MaxHealth or 0)),
						HP = config.MaxHealth or 0
					});
				end;
			end;
		end;
	end;
	table.sort(uiList, function(a, b)
		return a.HP < b.HP;
	end);
	CurrentZoneEnemiesCache = uiList;
	return uiList;
end;
local function GetAvatarsWithStats()
	local list, zoneOrders, machineStats = {}, {}, {};
	local Data = (getgenv()).PlayerData;
	local zonesConfigPath = ReplicatedStorage:FindFirstChild("Scripts") and ReplicatedStorage.Scripts.Configs:FindFirstChild("Zones");
	if zonesConfigPath then
		local s, r = pcall(require, zonesConfigPath);
		if s and type(r) == "table" then
			for k, d in pairs(r) do
				zoneOrders[k] = d.Order or 999;
			end;
		end;
	end;
	local machinePath = ReplicatedStorage.Scripts.Configs.Machines:FindFirstChild("Avatar");
	if machinePath then
		local s, r = pcall(require, machinePath);
		if s and type(r) == "table" then
			machineStats = r;
		end;
	end;
	local zonesPath = ReplicatedStorage.Scripts.Configs["Multiple Zones"].Enemies;
	if zonesPath then
		for _, module in pairs(zonesPath:GetChildren()) do
			if module:IsA("ModuleScript") then
				local zoneName = module.Name;
				local zoneOrder = zoneOrders[zoneName] or 999;
				local success, data = pcall(require, module);
				if success and type(data) == "table" then
					for internalKey, stats in pairs(data) do
						local isOwned = false;
						if Data and Data.Morphs and Data.Morphs[internalKey] then
							isOwned = true;
						end;
						local isEquipped = false;
						if Data and Data.Attributes and Data.Attributes.Avatar == internalKey then
							isEquipped = true;
						end;
						local statusPrefix = "[LOCKED]";
						if isOwned then
							statusPrefix = "";
						end;
						if isEquipped then
							statusPrefix = "[EQUIPPED]";
						end;
						local mStat = machineStats[internalKey];
						local descParts = {};
						if mStat then
							if mStat.Mastery then
								table.insert(descParts, "Mas: " .. mStat.Mastery .. "%");
							end;
							if mStat.Damage then
								table.insert(descParts, "Dmg: " .. mStat.Damage .. "%");
							end;
						end;
						local finalDesc = #descParts > 0 and table.concat(descParts, " | ") or "No Stats";
						if not isOwned then
							finalDesc = "LOCKED - Defeat to unlock";
						end;
						table.insert(list, {
							Title = (statusPrefix ~= "" and statusPrefix .. " " or "") .. (stats.Display or internalKey),
							Value = internalKey,
							Desc = finalDesc,
							_ZoneOrder = zoneOrder,
							_HP = stats.MaxHealth or 0,
							_Owned = isOwned,
							_Equipped = isEquipped
						});
					end;
				end;
			end;
		end;
		table.sort(list, function(a, b)
			if a._ZoneOrder ~= b._ZoneOrder then
				return a._ZoneOrder < b._ZoneOrder;
			else
				return a._HP < b._HP;
			end;
		end);
	end;
	return list;
end;
local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- [MODIFIKASI 2: KEYBIND DAN FOLDER]
local Window = l:CreateWindow({
	Title = "AN Hub - Anime Weapons",
	Icon = "rbxassetid://84366761557806",
	Author = "Aditya Nugraha",
	Folder = "AnimeWeapons", -- Folder untuk Library (Otomatis menjadi ANUI/AnimeWeapons/config)
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	Resizable = true,
	SideBarWidth = 170,
	HideSearchBar = true,
	ToggleKey = Enum.KeyCode.RightControl, -- Menambahkan Keybind (Right Ctrl)
	KeySystem = {
		Enabled = true,
		Title = "ANHub Access",
		Description = "Key expires every 24 Hours!",
		Key = GetOnlineKeys(),
		URL = "https://discord.gg/cy6uMRmeZ",
		Note = "Join Discord for Key",
		SaveKey = true
	}
});

do
	Window:Tag({
		Title = "v" .. ANUI.Version,
		Icon = "github",
		Color = Color3.fromHex("#ff0000")
	});
end;

if not isfile(ExpiryFile) then
	writefile(ExpiryFile, tostring(os.time() + 86400));
end;

Window:OnDestroy(function()
	Config.AutoFarm = false;
	Config.AutoDungeon = false;
	Config.AutoFuse = false;
	Config.AutoRankUp = false;
	Config.AutoRollBiju = false;
	Config.AutoRollRace = false;
	Config.AutoRollSayajin = false;
	Config.AutoYen_Luck = false;
	Config.AutoYen_Damage = false;
	Config.AutoYen_Yen = false;
	Config.AutoYen_Mastery = false;
	Config.AutoYen_Critical = false;
	if CurrentZoneName ~= "" and Config.SelectedEnemy then
		SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy);
	end;
end);

local function CreateTabButtons(section, tabNames)
    local TabSystem = {
        CurrentTab = tabNames[1],
        Elements = {},
        ButtonObjects = {}
    }
    for _, name in pairs(tabNames) do TabSystem.Elements[name] = {} end

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "TabButtonsContainer"
    ButtonContainer.Size = UDim2.new(1, 0, 0, 35)
    ButtonContainer.BackgroundTransparency = 1
    
    local ContainerPadding = Instance.new("UIPadding")
    ContainerPadding.Parent = ButtonContainer
    ContainerPadding.PaddingLeft = UDim.new(0, 5)
    ContainerPadding.PaddingRight = UDim.new(0, 5)
    
    local Dummy = section:Paragraph({Title="Temp", Desc=""})
    local ContentParent = Dummy.ParagraphFrame.UIElements.Main.Parent.Parent.Content
    ButtonContainer.Parent = ContentParent
    Dummy.ParagraphFrame:Destroy()

    ButtonContainer.LayoutOrder = -9999

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = ButtonContainer
    UIList.FillDirection = Enum.FillDirection.Horizontal
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)
    
    local function UpdateVisibility(selectedTab)
        TabSystem.CurrentTab = selectedTab
        for name, objects in pairs(TabSystem.Elements) do
            local isVisible = (name == selectedTab)
            for _, obj in ipairs(objects) do
                if obj.ElementFrame then 
                    obj.ElementFrame.Visible = isVisible 
                elseif obj.UIElements and obj.UIElements.Main then
                    obj.UIElements.Main.Visible = isVisible
                elseif obj.GroupFrame then
                    obj.GroupFrame.Visible = isVisible
                end
            end
        end
        for name, btn in pairs(TabSystem.ButtonObjects) do
            local isSelected = (name == selectedTab)
            local targetColor = isSelected and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 45, 45)
            local targetText = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            game:GetService("TweenService"):Create(btn.TextLabel, TweenInfo.new(0.2), {TextColor3 = targetText}):Play()
        end
        task.spawn(function()
            task.wait(0.05)
            if section.Opened then
                section:Open()
            end
        end)
    end

    local btnWidth = 1 / #tabNames 

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Name = name .. "_Btn"
        btn.Parent = ButtonContainer
        btn.Size = UDim2.new(btnWidth, -5, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.AutoButtonColor = true
        btn.Text = ""
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local lbl = Instance.new("TextLabel")
        lbl.Parent = btn
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)

        btn.MouseButton1Click:Connect(function() UpdateVisibility(name) end)
        TabSystem.ButtonObjects[name] = btn
    end

    function TabSystem:Add(tabName, elementObject)
        if not TabSystem.Elements[tabName] then return end
        table.insert(TabSystem.Elements[tabName], elementObject)
        if tabName ~= TabSystem.CurrentTab then
            if elementObject.ElementFrame then 
                elementObject.ElementFrame.Visible = false 
            elseif elementObject.UIElements and elementObject.UIElements.Main then
                elementObject.UIElements.Main.Visible = false
            elseif elementObject.GroupFrame then
                elementObject.GroupFrame.Visible = false
            end
        end
    end

    UpdateVisibility(tabNames[1])
    section:Divider()
    return TabSystem
end
local function GetHRP()
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
end;
LocalPlayer.CharacterAdded:Connect(function(char)
	hrp = char:WaitForChild("HumanoidRootPart");
	humanoid = char:WaitForChild("Humanoid");
end);
pcall(function()
	if LocalPlayer.Character then
		hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
		humanoid = LocalPlayer.Character:FindFirstChild("Humanoid");
	end;
end);
local function LogicAutoFarm()
	local currentTargetObj = nil;
	while Config.AutoFarm do
		if Window.Destroyed then
			break;
		end;
		if currentTargetObj then
			if currentTargetObj.Alive == false or (not currentTargetObj.Data) or (not currentTargetObj.Uid) then
				currentTargetObj = nil;
			end;
		end;
		if not currentTargetObj then
			local targetName = Config.SelectedEnemy;
			if targetName and hrp and GlobalEnemyMap[targetName] then
				local enemyList = GlobalEnemyMap[targetName] or {};
				local closest, minDst = nil, math.huge;
				local myPos = hrp.Position;
				for _, enemyObj in ipairs(enemyList) do
					if enemyObj.Alive == true and enemyObj.Data and enemyObj.Data.CFrame then
						local dst = (myPos - enemyObj.Data.CFrame.Position).Magnitude;
						if dst < minDst then
							minDst = dst;
							closest = enemyObj;
						end;
					end;
				end;
				if closest then
					currentTargetObj = closest;
					if hrp and currentTargetObj.Data and currentTargetObj.Data.CFrame then
						hrp.CFrame = currentTargetObj.Data.CFrame * CFrame.new(0, 5, 2);
					end;
				end;
			end;
		elseif currentTargetObj.Uid and Unreliable then
			pcall(function()
				Unreliable:FireServer("Hit", {
					currentTargetObj.Uid
				});
			end);
		end;
		task.wait(0.1);
	end;
end;
local function MaintainAutoStatus()
	while not Window.Destroyed do
		if Config.AutoFarm or Config.AutoDungeon then
			local Data = (getgenv()).PlayerData;
			if Data and Data.Settings and Reliable then
				if Data.Settings.AutoClick == false then
					pcall(function()
						Reliable:FireServer("Settings", {
							"AutoClick",
							true
						});
					end);
				end;
				if Data.Settings.AutoAttack == false then
					pcall(function()
						Reliable:FireServer("Settings", {
							"AutoAttack",
							true
						});
					end);
				end;
			end;
		end;
		task.wait(1);
	end;
end;
local function isPlayerInZone(zone)
	local chars = zone:FindFirstChild("Characters");
	if chars and chars:FindFirstChild(LocalPlayer.Name) then
		return true;
	end;
	return false;
end;
local function GetCurrentMapStatus()
	local zones = Workspace:FindFirstChild("Zones");
	if zones then
		for _, zone in pairs(zones:GetChildren()) do
			if isPlayerInZone(zone) then
				return zone.Name;
			end;
		end;
	end;
	if Workspace:FindFirstChild("Dungeon") then
		return "Dungeon";
	end;
	if Workspace:FindFirstChild("Raid") then
		return "Raid";
	end;
	if Workspace:FindFirstChild("Defense") then
		return "Defense";
	end;
	if Workspace:FindFirstChild("Enemies") and (not zones) then
		return "Dungeon:Active";
	end;
	return "Unknown";
end;
local function LogicGamemodes()
	local wasInGamemode = false;
	local currentTargetObj = nil;
	local refreshTimer = 0;
	while Config.AutoDungeon do
		if Window.Destroyed then
			break;
		end;
		local currentMap = GetCurrentMapStatus();
		local inLobbyZone = false;
		if Workspace:FindFirstChild("Zones") and Workspace.Zones:FindFirstChild("Dungeon") then
			if isPlayerInZone(Workspace.Zones.Dungeon) then
				inLobbyZone = true;
			end;
		end;
		local isFightingZone = string.find(currentMap, ":") and (string.find(currentMap, "Dungeon") or string.find(currentMap, "Raid") or string.find(currentMap, "Defense"));
		if currentMap == "Raid" or currentMap == "Defense" then
			isFightingZone = true 
		end
		
		if currentMap ~= "Unknown" then
			if isFightingZone then
				wasInGamemode = true;
				if os.time() - refreshTimer > 1 then
					RefreshEnemyData();
					refreshTimer = os.time();
				end;
				if currentTargetObj then
					if currentTargetObj.Alive == false or (not currentTargetObj.Data) then
						currentTargetObj = nil;
					end;
				end;
				if not currentTargetObj and hrp then
					local closest, minDst = nil, math.huge;
					local myPos = hrp.Position;
					for _, enemyList in pairs(GlobalEnemyMap) do
						for _, enemyObj in ipairs(enemyList) do
							if enemyObj.Alive == true and enemyObj.Data and enemyObj.Data.CFrame then
								local dst = (myPos - enemyObj.Data.CFrame.Position).Magnitude;
								if dst < minDst then
									minDst = dst;
									closest = enemyObj;
								end;
							end;
						end;
					end;
					if closest then
						currentTargetObj = closest;
						if currentTargetObj.Data and currentTargetObj.Data.CFrame then
							hrp.CFrame = currentTargetObj.Data.CFrame * CFrame.new(0, 5, 2);
						end;
					end;
				end;
				if currentTargetObj and currentTargetObj.Uid and Unreliable then
					pcall(function()
						Unreliable:FireServer("Hit", {
							currentTargetObj.Uid
						});
					end);
				end;
				task.wait(0.1);
			elseif inLobbyZone or wasInGamemode and (not isFightingZone) then
				currentTargetObj = nil;
				if LastZone and LastZone ~= "" and not string.find(LastZone, "Dungeon:") and not string.find(LastZone, "Raid:") and not string.find(LastZone, "Defense:") and LastZone ~= "Unknown" then
					l:Notify({
						Title = "Mode Finished",
						Content = "In Lobby -> Returning to " .. LastZone,
						Icon = "map-pin",
						Duration = 3
					});
					if Reliable then
						pcall(function()
							Reliable:FireServer("Zone Teleport", {
								LastZone
							});
						end);
					end;
					wasInGamemode = false;
					task.wait(4);
				else
					wasInGamemode = false;
				end;
			else
				local t = os.date("*t");
				local currentMinute = t.min;
				local targetString, targetName = nil, "";
				for _, dName in pairs(Config.TargetDungeon) do
					local data = dungeonDB[dName];
					if data and currentMinute == data.Time then
						targetString = "Dungeon:" .. tostring(data.ID);
						targetName = dName;
						break;
					end;
				end;
				if not targetString then
					for _, rName in pairs(Config.TargetRaid) do
						local data = raidDB[rName];
						if data and data.Times then
							for _, timeVal in ipairs(data.Times) do
								if currentMinute == timeVal then
									targetString = "Raid:" .. tostring(data.ID);
									targetName = rName;
									break;
								end;
							end;
						end;
						if targetString then
							break;
						end;
					end;
				end;
				if not targetString then
					for _, dName in pairs(Config.TargetDefense) do
						local data = defenseDB[dName];
						if data and data.Times then
							for _, timeVal in ipairs(data.Times) do
								if currentMinute == timeVal then
									targetString = "Defense:" .. tostring(data.ID);
									targetName = dName;
									break;
								end;
							end;
						end;
						if targetString then
							break;
						end;
					end;
				end;

				if targetString then
					if not string.find(currentMap, "Dungeon:") and (not string.find(currentMap, "Raid:")) and (not string.find(currentMap, "Defense:")) then
						LastZone = currentMap;
					end;
					l:Notify({
						Title = "Auto Mode",
						Content = "Joining " .. targetName,
						Icon = "swords",
						Duration = 2
					});
					if Reliable then
						pcall(function()
							Reliable:FireServer("Join Gamemode", {
								targetString
							});
						end);
					end;
					task.wait(5);
				end;
				task.wait(1);
			end;
		else
			task.wait(1);
		end;
	end;
end;
task.spawn(function()
	while not Window.Destroyed do
		local anyRollActive = false;
		local rollList = {
			"Biju",
			"Race",
			"Sayajin",
			"Fruits",
			"Haki",
			"Breathing",
			"MagicEyes",
            "DemonArt",
			"Organization",
			"Titan"
		};
		for _, rollType in ipairs(rollList) do
			if Config["AutoRoll" .. rollType] then
				anyRollActive = true;
				if Reliable then
					pcall(function()
						Reliable:FireServer("Crate Roll Start", {
							rollType,
							false
						});
					end);
				end;
				task.wait(1.5);
			end;
		end;
		if not anyRollActive then
			task.wait(1);
		end;
	end;
end);
task.spawn(function()
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
	while not Window.Destroyed do
		local isRolling = false;
		local rollList = {
			"Biju",
			"Race",
			"Sayajin",
			"Fruits",
			"Haki",
			"Breathing",
			"MagicEyes",
            "DemonArt",
			"Organization",
			"Titan"
		};
		for _, rType in pairs(rollList) do
			if Config["AutoRoll" .. rType] then
				isRolling = true;
				break;
			end;
		end;
		if isRolling then
			local CrateUI = PlayerGui:FindFirstChild("Crate");
			if CrateUI then
				CrateUI.Parent = nil;
			end;
			local ScreenUI = PlayerGui:FindFirstChild("Screen");
			if ScreenUI and (not ScreenUI.Enabled) then
				ScreenUI.Enabled = true;
			end;
			local Topbar = PlayerGui:FindFirstChild("TopbarStandard");
			if Topbar and (not Topbar.Enabled) then
				Topbar.Enabled = true;
			end;
		end;
		task.wait(0.5);
	end;
end);
local InfoTab = Window:Tab({
	Title = "Info",
	Icon = "info"
});
local s, tUrl = pcall(function()
	return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
end);
local PlayerParagraph = InfoTab:Paragraph({
	Title = LocalPlayer.DisplayName,
	Desc = "User ID: " .. tostring(LocalPlayer.UserId) .. "\nKey Valid: Verifying...",
	Image = s and tUrl or "rbxassetid://84366761557806",
	ImageSize = 48,
	Buttons = {
		{
			Title = "Copy HWID",
			Icon = "copy",
			Callback = function()
				setclipboard(tostring(gethwid and gethwid() or LocalPlayer.UserId));
			end
		}
	}
});
task.spawn(function()
	while not Window.Destroyed do
		local success, result = pcall(function()
			if isfile(ExpiryFile) then
				return tonumber(readfile(ExpiryFile)) or 0;
			end;
			return 0;
		end);
		local statusText = "Checking...";
		if success and result > 0 then
			local diff = result - os.time();
			if diff > 0 then
				local h = math.floor(diff / 3600);
				local m = math.floor(diff % 3600 / 60);
				statusText = string.format("%02dh %02dm", h, m);
			else
				statusText = "EXPIRED";
			end;
		else
			statusText = "No Timer";
		end;
		if PlayerParagraph and PlayerParagraph.SetDesc then
			pcall(function()
				PlayerParagraph:SetDesc("User ID: " .. tostring(LocalPlayer.UserId) .. "\nKey Valid: " .. statusText);
			end);
		end;
		task.wait(1);
	end;
end);
local CommunitySection = InfoTab:Section({
	Title = "Community",
	Icon = "users",
	Opened = true
});
local DiscordInfo = InfoTab:Paragraph({
	Title = "Loading...",
	Desc = "...",
	Image = "rbxassetid://84366761557806",
	ImageSize = 42,
	Buttons = {
		{
			Title = "Copy Discord",
			Icon = "copy",
			Callback = function()
				setclipboard("https://discord.gg/cy6uMRmeZ");
			end
		}
	}
});
task.spawn(function()
	local API = "https://discord.com/api/v10/invites/cy6uMRmeZ?with_counts=true&with_expiration=true";
	local s, r = pcall(function()
		return HttpService:JSONDecode((l.Creator.Request({
			Url = API,
			Method = "GET"
		})).Body);
	end);
	if s and r and r.guild then
		DiscordInfo:SetTitle(r.guild.name);
		DiscordInfo:SetDesc("Members: " .. r.approximate_member_count .. "\nOnline: " .. r.approximate_presence_count);
	else
		DiscordInfo:SetTitle("Discord Error");
		DiscordInfo:SetDesc("Failed to fetch info.");
	end;
end);
local MainSection = Window:Section({
	Title = "Main Features",
	Icon = "sword",
	Opened = true
});

local FarmTab = MainSection:Tab({
	Title = "Farming",
	Icon = "swords"
});
local FarmingManagerSection = FarmTab:Section({
	Title = "Farming Manager",
	Icon = "activity",
	Opened = true
});
local FarmTabs = CreateTabButtons(FarmingManagerSection, {
    "Zone Farming",
    "Gamemodes"
})

-- Icons removed as per user request

EnemyDropdown = FarmingManagerSection:Dropdown({
	Title = "Select Enemy",
	Multi = false,
	Values = {},
	Flag = "TargetEnemies_Cfg",
	Callback = function(selectedItem)
		if IsLoadingConfig then
			return;
		end;
		SaveZoneConfig(CurrentZoneName, selectedItem);
	end
});
FarmTabs:Add("Zone Farming", EnemyDropdown);
local RefreshBtn = FarmingManagerSection:Button({
	Title = "Refresh List",
	Icon = "refresh-cw",
	Callback = function()
		EnemyDropdown:Refresh(RefreshEnemyData());
	end
});
FarmTabs:Add("Zone Farming", RefreshBtn);
local FarmToggle = FarmingManagerSection:Toggle({
	Title = "Auto Farm",
	Flag = "AutoFarm_Cfg",
	Callback = function(val)
		Config.AutoFarm = val;
		if val then
			task.spawn(LogicAutoFarm);
		end;
	end
});
FarmTabs:Add("Zone Farming", FarmToggle);
local DgnDrop = FarmingManagerSection:Dropdown({
	Title = "Select Dungeon",
	Multi = true,
	AllowNone = true,
	Flag = "DungeonDiff_Cfg",
	Values = dungeonList,
	Callback = function(val)
		local t = {};
		for _, v in pairs(val) do
			table.insert(t, type(v) == "table" and v.Value or v);
		end;
		Config.TargetDungeon = t;
	end
});
FarmTabs:Add("Gamemodes", DgnDrop);

task.spawn(function()
	while not Window.Destroyed do
		local t = os.date("*t");
		local currentTotalSeconds = t.min * 60 + t.sec;
		local newList = {};
		
		for _, item in ipairs(dungeonList) do
			local dName = item.Value;
			local data = dungeonDB[dName];
			if data then
				local startMin = data.Time;
				local startTotalSeconds = startMin * 60;
				local diff = startTotalSeconds - currentTotalSeconds;
				if diff < 0 then
					diff = diff + 3600;
				end;
				local m = math.floor(diff / 60);
				local s = diff % 60;
				local timeStr = string.format("%02d:%02d", m, s);
				
				table.insert(newList, {
					Title = item.Title,
					Value = item.Value,
					Desc = data.BaseDesc .. " | Starts in: " .. timeStr
				});
			else
				table.insert(newList, item);
			end;
		end;
		
		if DgnDrop and DgnDrop.Refresh then
			pcall(function()
				DgnDrop:Refresh(newList);
			end);
		end;
		task.wait(1);
	end;
end);
local RaidDrop = FarmingManagerSection:Dropdown({
	Title = "Select Raid",
	Multi = true,AllowNone = true,
	Flag = "RaidDiff_Cfg",
	Values = raidList,
	Callback = function(val)
		local t = {};
		for _, v in pairs(val) do
			table.insert(t, type(v) == "table" and v.Value or v);
		end;
		Config.TargetRaid = t;
	end
});
FarmTabs:Add("Gamemodes", RaidDrop);
local DefenseDrop = FarmingManagerSection:Dropdown({
	Title = "Select Defense",
	Multi = true,
	AllowNone = true,
	Flag = "DefenseDiff_Cfg",
	Values = defenseList,
	Callback = function(val)
		local t = {};
		for _, v in pairs(val) do
			table.insert(t, type(v) == "table" and v.Value or v);
		end;
		Config.TargetDefense = t;
	end
});
FarmTabs:Add("Gamemodes", DefenseDrop);

task.spawn(function()
	local function GetNextTimeDiff(times, currentMin, currentSec)
		if not times or #times == 0 then return 0 end
		table.sort(times)
		
		-- Find next time in current hour
		for _, t in ipairs(times) do
			if t > currentMin then
				return (t - currentMin) * 60 - currentSec
			end
		end
		
		-- If not found, get first time in next hour
		local firstTime = times[1]
		return (60 - currentMin + firstTime) * 60 - currentSec
	end

	while not Window.Destroyed do
		local t = os.date("*t")
		local currentMin = t.min
		local currentSec = t.sec
		
		-- Update Raid Dropdown
		local newRaidList = {}
		for _, item in ipairs(raidList) do
			local rName = item.Value
			local data = raidDB[rName]
			if data and data.Times then
				local diff = GetNextTimeDiff(data.Times, currentMin, currentSec)
				if diff < 0 then diff = 0 end -- Should not happen with logic above but safety
				
				local m = math.floor(diff / 60)
				local s = diff % 60
				local timeStr = string.format("%02d:%02d", m, s)
				
				table.insert(newRaidList, {
					Title = item.Title,
					Value = item.Value,
					Desc = data.BaseDesc .. " | Starts in: " .. timeStr
				})
			else
				table.insert(newRaidList, item)
			end
		end
		
		if RaidDrop and RaidDrop.Refresh then
			pcall(function() RaidDrop:Refresh(newRaidList) end)
		end
		
		-- Update Defense Dropdown
		local newDefenseList = {}
		for _, item in ipairs(defenseList) do
			local dName = item.Value
			local data = defenseDB[dName]
			if data and data.Times then
				local diff = GetNextTimeDiff(data.Times, currentMin, currentSec)
				if diff < 0 then diff = 0 end
				
				local m = math.floor(diff / 60)
				local s = diff % 60
				local timeStr = string.format("%02d:%02d", m, s)
				
				table.insert(newDefenseList, {
					Title = item.Title,
					Value = item.Value,
					Desc = data.BaseDesc .. " | Starts in: " .. timeStr
				})
			else
				table.insert(newDefenseList, item)
			end
		end
		
		if DefenseDrop and DefenseDrop.Refresh then
			pcall(function() DefenseDrop:Refresh(newDefenseList) end)
		end
		
		task.wait(1)
	end
end)

local ModeToggle = FarmingManagerSection:Toggle({
	Title = "Auto Join & Kill",
	Flag = "AutoDungeon_Cfg",
	Callback = function(val)
		Config.AutoDungeon = val;
		if val then
			task.spawn(LogicGamemodes);
		end;
	end
});
FarmTabs:Add("Gamemodes", ModeToggle);

-- ============================================================================
-- [GENERAL TAB & REST OF FILE 2]
-- ============================================================================
local GeneralTab = MainSection:Tab({
	Title = "General",
	Icon = "settings"
});

-- GENERAL MANAGER SECTION
local GeneralManagerSection = GeneralTab:Section({
    Title = "General Manager",
    Icon = "settings-2",
    Opened = true
})

local GeneralTabs = CreateTabButtons(GeneralManagerSection, {
    "Exchange",
    "Crate Roll"
})

-- Icons removed as per user request

local MaterialsModule = require(ReplicatedStorage.Scripts.Configs.General.Materials)
local TradeTokenInfo = MaterialsModule.TradeToken
local ExchangeList = {}
for k, v in pairs(MaterialsModule) do
    if v.Exchangeable and k ~= "TradeToken" then
        table.insert(ExchangeList, {Title = v.Display, Value = k})
    end
end
table.sort(ExchangeList, function(a,b) return a.Title < b.Title end)

local SelectedExToken = nil
local SelectedExIcon = nil
local PrevMaterialsDigest = nil
local ExchangeAmount = 1
local ExchangeIsBuying = false -- false = Sell Material (Material -> Trade), true = Buy Material (Trade -> Material)

-- Helper to get asset ID
local function GetIcon(id)
    return "rbxassetid://"..tostring(id)
end

local function GetMaterialsDigest()
    local pData = (getgenv()).PlayerData
    local keys = {}
    if pData and pData.Materials then
        for k,_ in pairs(pData.Materials) do
            table.insert(keys, k)
        end
    end
    table.sort(keys)
    return table.concat(keys, "|")
end

-- UI Elements for Exchange
local function BuildExchangeValues()
    local pData = (getgenv()).PlayerData
    local mats = {}
    for _, item in ipairs(ExchangeList) do
        local key = item.Value
        local info = MaterialsModule[key]
        local count = (pData and pData.Materials and pData.Materials[key]) or 0
        local img = info and info.Template and GetIcon(info.Template) or ""
        table.insert(mats, {
            Title = item.Title,
            Icon = img,
            Value = key,
        })
    end
    return mats
end

local PreviewGroup = GeneralManagerSection:Group()
GeneralTabs:Add("Exchange", PreviewGroup)

local MatPreview = PreviewGroup:Dropdown({
    Title = "Select Token",
    Desc = "None Selected",
    Image = "rbxassetid://84366761557806",
    ImageSize = 20,
    Values = BuildExchangeValues(),
    Multi = false,
    Callback = function(val)
        SelectedExToken = type(val) == "table" and val.Value or val
        SelectedExIcon = type(val) == "table" and val.Icon or nil
        local info = SelectedExToken and MaterialsModule[SelectedExToken] or nil
        if info and info.Template then
            MatPreview:SetTitle(info.Display)
            MatPreview:SetIcon(SelectedExIcon or GetIcon(info.Template), 30)
            local pData = (getgenv()).PlayerData
            local matCount = pData and pData.Materials and pData.Materials[SelectedExToken] or 0
            MatPreview:SetDesc(string.format("(%s/%s)", FormatNumber(ExchangeAmount), FormatNumber(matCount)))
        end
    end
})
MatPreview:Refresh(BuildExchangeValues())

local TradePreview = PreviewGroup:Paragraph({
    Title = TradeTokenInfo.Display,
    Desc = "Waiting...",
    Image = GetIcon(TradeTokenInfo.Template),
    ImageSize = 40
})


local ExchangePercent = 1
local ExSlider = GeneralManagerSection:Slider({
    Title = "Amount %",
    Min = 0,
    Max = 100,
    Default = 100,
    Callback = function(v)
        ExchangePercent = v / 100
    end
})
GeneralTabs:Add("Exchange", ExSlider)

local ExSwap = GeneralManagerSection:Toggle({
    Title = "Swap Direction (Buy Mode)",
    Desc = "OFF: Material -> Trade Token | ON: Trade Token -> Material",
    Callback = function(v)
        ExchangeIsBuying = v
    end
})
GeneralTabs:Add("Exchange", ExSwap)

local ExchangeButton = GeneralManagerSection:Button({
    Title = "Exchange",
    Icon = "check",
    Callback = function()
        if not SelectedExToken then 
            l:Notify({Title="Error", Content="Select a token first!", Icon="alert-triangle"})
            return 
        end
        
        -- Logic args based on prompt: "TokenName", BooleanSwap, Amount
        -- Example from prompt: "DemonToken", true, 1 (Buy Mode)
        -- Example from prompt: "SayajinToken", false, 1 (Sell Mode)
        
        local args = {
            "Convert Tokens",
            {
                SelectedExToken,
                ExchangeIsBuying,
                ExchangePercent
            }
        }
        
        if Reliable then
            pcall(function()
                Reliable:FireServer(unpack(args))
            end)
            l:Notify({Title="Exchange", Content="Request Sent!", Icon="send"})
        end
    end
})
GeneralTabs:Add("Exchange", ExchangeButton)

-- Update Exchange UI Loop
task.spawn(function()
    while not Window.Destroyed do
        local pData = (getgenv()).PlayerData
        local digest = GetMaterialsDigest()
        if digest ~= PrevMaterialsDigest then
            MatPreview:Refresh(BuildExchangeValues())
            PrevMaterialsDigest = digest
        end
        
        -- Calculate Amounts based on Decompiled Logic
        -- v2 logic: Buying (v_u4=true) -> 1, Selling (v_u4=false) -> 0.1
        -- Formula: floor(Source * Percent * v2) // v2 * v2
        -- Simplified:
        -- Buy: floor(Trade * P)
        -- Sell: floor(Mat * P / 10)
        
        local tradeCount = (pData and pData.Materials and pData.Materials["TradeToken"]) or 0
        local matCount = (SelectedExToken and pData and pData.Materials and pData.Materials[SelectedExToken]) or 0
        
        local inputAmount = 0
        local outputAmount = 0
        
        if ExchangeIsBuying then
            -- Buying: TradeToken -> Material
            -- Input: TradeToken * Percent
            -- Output: Input (1:1 ratio)
            inputAmount = math.floor(tradeCount * ExchangePercent)
            outputAmount = inputAmount
        else
            -- Selling: Material -> TradeToken
            -- Input: Material * Percent
            -- Output: Material * Percent / 10 (10:1 ratio)
            local rawInput = math.floor(matCount * ExchangePercent)
            -- Logic from decompile: floor(Mat * P * 0.1) // 0.1 * 0.1
            -- Effectively floor(rawInput / 10)
            outputAmount = math.floor(rawInput / 10)
            inputAmount = rawInput
        end

        if SelectedExToken then
            local info = MaterialsModule[SelectedExToken]
            if info and info.Template then
                MatPreview:SetTitle(info.Display)
                MatPreview:SetIcon(SelectedExIcon or GetIcon(info.Template), 30)
                
                -- Update Desc on Material Preview
                -- If Buying: Show +Output
                -- If Selling: Show -Input
                if ExchangeIsBuying then
                     MatPreview:SetDesc(string.format("Current: %s | +%s", FormatNumber(matCount), FormatNumber(outputAmount)))
                else
                     MatPreview:SetDesc(string.format("Current: %s | -%s", FormatNumber(matCount), FormatNumber(inputAmount)))
                end
            end
            
            -- Update Desc on Trade Token Preview
            -- If Buying: Show -Input
            -- If Selling: Show +Output
            if ExchangeIsBuying then
                TradePreview:SetDesc(string.format("Current: %s | -%s", FormatNumber(tradeCount), FormatNumber(inputAmount)))
            else
                TradePreview:SetDesc(string.format("Current: %s | +%s", FormatNumber(tradeCount), FormatNumber(outputAmount)))
            end
        else
            MatPreview:SetTitle("Select Token")
            MatPreview:SetDesc("None Selected")
            MatPreview:SetIcon("rbxassetid://84366761557806", 20)
            TradePreview:SetDesc("Waiting...")
        end
        task.wait(0.5)
    end
end)

local rollToggleData = {
	{
		"Biju",
		"AutoRollBiju"
	},
	{
		"Race",
		"AutoRollRace"
	},
	{
		"Sayajin",
		"AutoRollSayajin"
	},
	{
		"Fruits",
		"AutoRollFruits"
	},
	{
		"Haki",
		"AutoRollHaki"
	},
	{
		"Breathing",
		"AutoRollBreathing"
	},
	{
		"Organization",
		"AutoRollOrganization"
	},
    {
        "Titan",
        "AutoRollTitan"
    },
    {
        "MagicEyes",
        "AutoRollMagicEyes"
    },
    {
        "DemonArt",
        "AutoRollDemonArt"
    }
};
local _rollGroup;
local _rollCount = 0;
for i, rollData in ipairs(rollToggleData) do
    local rollType, configFlag = rollData[1], rollData[2];
    if _rollCount % 2 == 0 then
        _rollGroup = GeneralManagerSection:Group({});
        GeneralTabs:Add("Crate Roll", _rollGroup)
    end;
    local tokenKey = RollMaterialMap[rollType];
    local displayName = (MaterialsModule[tokenKey] and MaterialsModule[tokenKey].Display) or (RollDisplayNames[rollType] or tokenKey);
    local currentCount = (((getgenv()).PlayerData and (getgenv()).PlayerData.Materials) and (getgenv()).PlayerData.Materials[tokenKey]) or 0;
    local myToggle = _rollGroup:Toggle({
        Title = rollType,
        Flag = configFlag .. "_Cfg",
        Desc = displayName .. ": " .. FormatNumber(currentCount),
        Image = GetRollIconAsset(rollType),
        ImageSize = 24,
        Callback = function(val)
            Config[configFlag] = val;
        end
    });
    RollToggleUI[rollType] = myToggle;
    _rollCount = _rollCount + 1;
end;

-- [Auto Lock Maxed Rolls & Update Counts]
task.spawn(function()
	while not Window.Destroyed do
		local pData = (getgenv()).PlayerData;
		if pData then
            -- Update Counts
            if pData.Materials then
                for rollType, toggle in pairs(RollToggleUI) do
                    local tokenKey = RollMaterialMap[rollType];
                    local displayName = (MaterialsModule[tokenKey] and MaterialsModule[tokenKey].Display) or (RollDisplayNames[rollType] or tokenKey);
                    local currentCount = pData.Materials[tokenKey] or 0;
                    pcall(function()
                        if not Window.Closed then
                            toggle:SetDesc(displayName .. ": " .. FormatNumber(currentCount));
                        end
                    end);
                end;
            end;

            -- Check Maxed
			if pData.Vault then
				for rollType, toggle in pairs(RollToggleUI) do
					if pData.Vault[rollType] and pData.Vault[rollType]["7"] == true then
						pcall(function()
							toggle:Lock();
							toggle:SetTitle(rollType .. " [MAX]");
							if Config["AutoRoll" .. rollType] then
								Config["AutoRoll" .. rollType] = false;
								toggle:Set(false);
							end;
						end);
					end;
				end;
			end;
		end;
		task.wait(1);
	end;
end);

GeneralTab:Toggle({
	Title = "Auto Fuse Weapons",
	Flag = "AutoFuse_Cfg",
	Callback = function(val)
		Config.AutoFuse = val;
		if val then
			task.spawn(function()
				while Config.AutoFuse do
					if Window.Destroyed then
						break;
					end;
					if Reliable then
						pcall(function()
							Reliable:FireServer("Weapon Fuse All");
						end);
					end;
					task.wait(5);
				end;
			end);
		end;
	end
});
GeneralTab:Button({
	Title = "FPS Booster",
	Icon = "zap",
	Callback = function()
		(loadstring(game:HttpGet("https://raw.githubusercontent.com/khuyenbd88/RobloxKaitun/refs/heads/main/FPS%20Booster.lua")))();
	end
});
local AvatarSection = GeneralTab:Section({
	Title = "Avatar Manager",
	Icon = "shirt",
	Opened = true
});
local PreviewSection = AvatarSection:Paragraph({
	Title = "Avatar Preview",
	Desc = "Select avatar to view",
	Image = ""
});
local function UpdatePreview(avatarName)
	local container = PreviewSection.ParagraphFrame.UIElements.Container;
	if container:FindFirstChild("ViewportFrame") then
		container.ViewportFrame:Destroy();
	end;
	local VP = Instance.new("ViewportFrame");
	VP.Size = UDim2.new(1, 0, 0, 150);
	VP.BackgroundTransparency = 1;
	VP.Parent = container;
	local Assets = ReplicatedFirst:FindFirstChild("Assets") and ReplicatedFirst.Assets:FindFirstChild("Enemies");
	if Assets then
		local Model = Assets:FindFirstChild(avatarName);
		if Model then
			local Clone = Model:Clone();
			Clone.Parent = VP;
			local Cam = Instance.new("Camera");
			VP.CurrentCamera = Cam;
			Cam.Parent = VP;
			local Head = Clone:FindFirstChild("Head") or Clone.PrimaryPart;
			if Head then
				Cam.CFrame = CFrame.new(Head.CFrame.Position + Head.CFrame.LookVector * 4 + Vector3.new(0, 0.5, 0), Head.CFrame.Position);
			end;
			task.spawn(function()
				while VP.Parent do
					if Head then
						Clone:PivotTo(Clone:GetPivot() * CFrame.Angles(0, math.rad(1), 0));
					end;
					task.wait(0.03);
				end;
			end);
		end;
	end;
end;
AvatarDropdown = AvatarSection:Dropdown({
	Title = "Select Avatar",
	Description = "Loading...",
	Values = {},
	Multi = false,
	Flag = "Avatar_Select_Cfg",
	Callback = function(selectedItem)
		local avatarKey = type(selectedItem) == "table" and selectedItem.Value or selectedItem;
		if avatarKey then
			UpdatePreview(avatarKey);
			pcall(function()
				Reliable:FireServer("Avatar Equip", {
					avatarKey
				});
			end);
		end;
	end
});
repeat
	task.wait();
until (getgenv()).PlayerData;
local InitialAvatarList = GetAvatarsWithStats();
AvatarDropdown:Refresh(InitialAvatarList);
local StartEquipped = (getgenv()).PlayerData.Attributes and (getgenv()).PlayerData.Attributes.Avatar;
if StartEquipped then
	for _, item in ipairs(InitialAvatarList) do
		if item.Value == StartEquipped then
			AvatarDropdown:Select(item.Title);
			UpdatePreview(StartEquipped);
			break;
		end;
	end;
end;

local YenTab = MainSection:Tab({
	Title = "Upgrade",
	Icon = "chevrons-up"
});
local function GetStatsIcon()
	local icon = "bar-chart";
	pcall(function()
		icon = (game:GetService("Players")).LocalPlayer.PlayerGui.Screen.Hud.left.buttons.StatPoints.button.icon.Image;
	end);
	return icon;
end;
local YenMainSection = YenTab:Section({
	Title = "Stats Upgrade Manager",
	Icon = GetStatsIcon(),
	Opened = true
});
local function GetYenIcon()
	local icon = "rbxassetid://84366761557806";
	pcall(function()
		icon = (game:GetService("Players")).LocalPlayer.PlayerGui.Screen.Hud.left.yen.icon.Image;
	end);
	return icon;
end;
local function GetTrainerIcon()
	local icon = "rbxassetid://10723415903";
	pcall(function()
		icon = (game:GetService("Players")).LocalPlayer.PlayerGui.Screen.Hud.left.buttons.Arsenal.button.icon.Image;
	end);
	return icon;
end;
local YenTabs = CreateTabButtons(YenMainSection, {"Yen", "Token", "Rank", "Trainer"}) 
local upgradeOrder = {"Luck", "Damage", "Yen", "Mastery", "Critical"}

task.spawn(function()
    task.wait(0.1)
    
    local function SetupButton(btnName, iconId)
        local btn = YenTabs.ButtonObjects[btnName]
        if btn then
            local lbl = btn:FindFirstChildOfClass("TextLabel")
            if lbl then
                lbl.Size = UDim2.new(1, -25, 1, 0)
                lbl.Position = UDim2.new(0, 25, 0, 0)
                lbl.TextXAlignment = Enum.TextXAlignment.Left
            end

            local iconImg = Instance.new("ImageLabel")
            iconImg.Name = btnName.."Icon"
            iconImg.Parent = btn
            iconImg.Size = UDim2.fromOffset(20, 20)
            iconImg.AnchorPoint = Vector2.new(0, 0.5)
            iconImg.Position = UDim2.new(0, 0, 0.5, 0)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = iconId
            iconImg.ScaleType = Enum.ScaleType.Fit
        end
    end

    SetupButton("Yen", GetYenIcon())
    SetupButton("Token", "rbxassetid://124644932563791")
    SetupButton("Rank", GetDynamicRankIcon())
    SetupButton("Trainer", GetTrainerIcon())
end)

local _yenGroup
local _yenCount = 0
for _, name in ipairs(upgradeOrder) do
    if YenUpgradeConfig[name] then
        if _yenCount % 2 == 0 then
            _yenGroup = YenMainSection:Group({})
            YenTabs:Add("Yen", _yenGroup)
        end
        local myToggle = _yenGroup:Toggle({
            Title = name, Flag = "AutoYen_" .. name, Callback = function(val) Config["AutoYen_" .. name] = val end
        })
        YenUpgradeToggleUI[name] = myToggle 
        _yenCount = _yenCount + 1
    end
end

if TokenUpgradeConfig then
    local _tokenGroup
    local _tokenCount = 0
    local sortedTokens = {}
    for name, _ in pairs(TokenUpgradeConfig) do
        table.insert(sortedTokens, name)
    end
    table.sort(sortedTokens)

    for _, name in ipairs(sortedTokens) do
        if _tokenCount % 2 == 0 then
            _tokenGroup = YenMainSection:Group({})
            YenTabs:Add("Token", _tokenGroup)
        end
        local myToggle = _tokenGroup:Toggle({
            Title = name, Flag = "AutoToken_" .. name, Callback = function(val) Config["AutoToken_" .. name] = val end
        })
        TokenUpgradeToggleUI[name] = myToggle
        _tokenCount = _tokenCount + 1
    end
end

RankProgressUI = YenMainSection:Paragraph({ Title = "Rank Progress", Desc = "Waiting for data...", Image = GetDynamicRankIcon(), ImageSize = 40 })
YenTabs:Add("Rank", RankProgressUI)

local RankToggle = YenMainSection:Toggle({ Title = "Auto Rank Up", Flag = "AutoRankUp_Cfg", Callback = function(val) Config.AutoRankUp = val end })
YenTabs:Add("Rank", RankToggle)

local _chanceGroup
local _chanceCount = 0
for _, name in ipairs(ChanceUpgradeTypes) do
    if _chanceCount % 2 == 0 then
        _chanceGroup = YenMainSection:Group({})
        YenTabs:Add("Trainer", _chanceGroup)
    end
    local myToggle = _chanceGroup:Toggle({
        Title = "Loading...", 
        Flag = "AutoChance_" .. name, 
        Callback = function(val) 
            Config["AutoChance_" .. name] = val 
        end
    })
    ChanceUpgradeToggleUI[name] = myToggle
    _chanceCount = _chanceCount + 1
end

if MagicEyesModule then
    if _chanceCount % 2 == 0 then
        _chanceGroup = YenMainSection:Group({})
        YenTabs:Add("Trainer", _chanceGroup)
    end
    
    local MagicEyeToggle = _chanceGroup:Toggle({
        Title = "Magic Eye Upgrade",
        Image = "rbxassetid://84366761557806",
        ImageSize = 24,
        Desc = "Loading...",
        Flag = "AutoUpgradeMagicEyes_Cfg",
        Callback = function(val)
            Config.AutoUpgradeMagicEyes = val
            if val then
                task.spawn(function()
                    while Config.AutoUpgradeMagicEyes and not Window.Destroyed do
                        if Reliable then
                            pcall(function()
                                Reliable:FireServer("Crate Upgrade", {"MagicEyes"})
                            end)
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })
    
    task.spawn(function()
        local function FormatBonus(bonuses)
            local str = ""
            for k, v in pairs(bonuses) do
                local displayValue = math.floor(v * 10) / 10
                str = str .. k .. ": " .. FormatNumber(displayValue) .. " "
            end
            return str
        end

        while not Window.Destroyed do
            local pData = getgenv().PlayerData
			local currentToken = pData.Materials.UpgradeEyeToken or 0;
            if pData and pData.Attributes and pData.GachaLevel and MagicEyesModule and MagicEyesModule.List then
                -- Get Equipped Magic Eye Index
                local equippedEyeIndex = pData.Attributes.MagicEyes
                
                -- Get Upgrade Level
                local currentLevel = pData.GachaLevel.MagicEyes[tostring(equippedEyeIndex)]
                local equippedItemData = MagicEyesModule.List[equippedEyeIndex]
				if not Window.Closed then
					if equippedItemData and equippedItemData.Template then
						MagicEyeToggle:SetImage(GetIcon(equippedItemData.Template))
					end
				end
                
                if currentLevel then

                    local maxLevel = MagicEyesModule.MaxLevel or 50
                    
                    if currentLevel >= maxLevel then
                        if not Window.Closed then
                            MagicEyeToggle:SetDesc(string.format("Lvl: %s [MAX]", tostring(currentLevel)))
                            MagicEyeToggle:Lock()
                        end
                        if Config.AutoUpgradeMagicEyes then
                            Config.AutoUpgradeMagicEyes = false
                            MagicEyeToggle:Set(false)
                        end
                    elseif equippedItemData and equippedItemData.Bonus then
                        if not Window.Closed then
                            local cost = MagicEyesModule.GetCost(currentLevel)
                            local currentBonuses = MagicEyesModule.GetBonuses(currentLevel, equippedItemData.Bonus)
                            local nextBonuses = MagicEyesModule.GetBonuses(currentLevel + 1, equippedItemData.Bonus)
                            
                            local bonusStr = FormatBonus(currentBonuses)
                            local nextBonusStr = FormatBonus(nextBonuses)
                            
                            MagicEyeToggle:SetDesc(string.format(
                                "Used: %s(%s)\nLvl: %s/%s\nCost: %s	\nUpgrade Eyes Shard: %s", 
                                equippedItemData.Display, 
                                equippedItemData.Rarity, 
                                tostring(currentLevel), 
                                tostring(maxLevel),
                                FormatNumber(cost),
                                FormatNumber(currentToken)
                            ))
                        end
                        
                        local cost = MagicEyesModule.GetCost(currentLevel)
                        if currentToken < cost and Config.AutoUpgradeMagicEyes then
                            Config.AutoUpgradeMagicEyes = false
                            MagicEyeToggle:Set(false)
                        end
                    else
                        -- Fallback if item data is missing
                        if not Window.Closed then
                            local cost = MagicEyesModule.GetCost and MagicEyesModule.GetCost(currentLevel) or "?"
                            MagicEyeToggle:SetDesc(string.format("Lvl: %s | Cost: %s (Item Data Missing: Index %s)", tostring(currentLevel), FormatNumber(cost), tostring(equippedEyeIndex)))
                        end
                    end
                else
                    -- Fallback if level is not found
                    if not Window.Closed then
                        local itemName = equippedItemData and equippedItemData.Display or "Unknown"
                        MagicEyeToggle:SetDesc(string.format("Used: %s | Lvl: 0 (Upgrade not started)", itemName))
                    end
                end
            end
            task.wait(1)
        end
    end)
    _chanceCount = _chanceCount + 1
end

if DemonArtModule then
    if _chanceCount % 2 == 0 then
        _chanceGroup = YenMainSection:Group({})
        YenTabs:Add("Trainer", _chanceGroup)
    end
    
    local DemonArtToggle = _chanceGroup:Toggle({
        Title = "Demon Art Upgrade",
        Image = "rbxassetid://84366761557806", -- You might want to change this icon if there's a specific one for Demon Art
        ImageSize = 24,
        Desc = "Loading...",
        Flag = "AutoUpgradeDemonArt_Cfg",
        Callback = function(val)
            Config.AutoUpgradeDemonArt = val
            if val then
                task.spawn(function()
                    while Config.AutoUpgradeDemonArt and not Window.Destroyed do
                        if Reliable then
                            pcall(function()
                                Reliable:FireServer("Crate Upgrade", {"DemonArt"})
                            end)
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })
    
    task.spawn(function()
        local function FormatBonus(bonuses)
            local str = ""
            for k, v in pairs(bonuses) do
                local displayValue = math.floor(v * 10) / 10
                str = str .. k .. ": " .. FormatNumber(displayValue) .. " "
            end
            return str
        end

        while not Window.Destroyed do
            local pData = getgenv().PlayerData
            local currentToken = pData.Materials.UpgradeDemonToken or 0;
            if pData and pData.Attributes and pData.GachaLevel and DemonArtModule and DemonArtModule.List then
                -- Get Equipped Demon Art Index
                local equippedArtIndex = pData.Attributes.DemonArt
                
                -- Get Upgrade Level
                local currentLevel = pData.GachaLevel.DemonArt[tostring(equippedArtIndex)]
                local equippedItemData = DemonArtModule.List[equippedArtIndex]
				if not Window.Closed then
					if equippedItemData and equippedItemData.Template then
						DemonArtToggle:SetImage(GetIcon(equippedItemData.Template))
					end
				end
                
                if currentLevel then

                    local maxLevel = DemonArtModule.MaxLevel or 50
                    
                    if currentLevel >= maxLevel then
                        if not Window.Closed then
                            DemonArtToggle:SetDesc(string.format("Lvl: %s [MAX]", tostring(currentLevel)))
                            DemonArtToggle:Lock()
                        end
                        if Config.AutoUpgradeDemonArt then
                            Config.AutoUpgradeDemonArt = false
                            DemonArtToggle:Set(false)
                        end
                    elseif equippedItemData and equippedItemData.Bonus then
                        if not Window.Closed then
                            local cost = DemonArtModule.GetCost(currentLevel)
                            local currentBonuses = DemonArtModule.GetBonuses(currentLevel, equippedItemData.Bonus)
                            local nextBonuses = DemonArtModule.GetBonuses(currentLevel + 1, equippedItemData.Bonus)
                            
                            local bonusStr = FormatBonus(currentBonuses)
                            local nextBonusStr = FormatBonus(nextBonuses)
                            
                            DemonArtToggle:SetDesc(string.format(
                                "Used: %s(%s)\nLvl: %s/%s\nCost: %s	\nUpgrade Demon Art Shard: %s", 
                                equippedItemData.Display, 
                                equippedItemData.Rarity, 
                                tostring(currentLevel), 
                                tostring(maxLevel),
                                FormatNumber(cost),
                                FormatNumber(currentToken)
                            ))
                        end
                        
                        local cost = DemonArtModule.GetCost(currentLevel)
                        if currentToken < cost and Config.AutoUpgradeDemonArt then
                            Config.AutoUpgradeDemonArt = false
                            DemonArtToggle:Set(false)
                        end
                    else
                        -- Fallback if item data is missing
                        if not Window.Closed then
                            local cost = DemonArtModule.GetCost and DemonArtModule.GetCost(currentLevel) or "?"
                            DemonArtToggle:SetDesc(string.format("Lvl: %s | Cost: %s (Item Data Missing: Index %s)", tostring(currentLevel), FormatNumber(cost), tostring(equippedArtIndex)))
                        end
                    end
                else
                    -- Fallback if level is not found
                    if not Window.Closed then
                        local itemName = equippedItemData and equippedItemData.Display or "Unknown"
						local cost = DemonArtModule.GetCost(currentLevel+1)
                        DemonArtToggle:SetDesc(string.format("Used: %s | Lvl: 0 (Upgrade not started)\nCost: %s", itemName, FormatNumber(cost)))
                    end
                end
            end
            task.wait(1)
        end
    end)
    _chanceCount = _chanceCount + 1
end

local SettingsTab = Window:Tab({
	Title = "Settings",
	Icon = "settings-2"
});
local ConfigSection = SettingsTab:Section({
	Title = "Config Manager",
	Icon = "save",
	Opened = true
});
local ConfigName = "ANConfig";
SettingsTab:Input({
	Title = "Config Name",
	Placeholder = "ANConfig",
	Flag = "ConfigName_Input",
	Callback = function(txt)
		ConfigName = txt;
	end
});
SettingsTab:Button({
	Title = "Save Config",
	Icon = "save",
	Callback = function()
		(Window.ConfigManager:CreateConfig(ConfigName)):Save();
		if CurrentZoneName ~= "" and Config.SelectedEnemy then
			SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy);
		end;
		Window:Notify({
			Title = "Success",
			Content = "Saved!",
			Icon = "check"
		});
	end
});
SettingsTab:Button({
	Title = "Load Config",
	Icon = "upload",
	Callback = function()
		local cfg = Window.ConfigManager:GetConfig(ConfigName);
		LoadZoneDB();
		if cfg then
			cfg:Load();
			Window:Notify({
				Title = "Success",
				Content = "Loaded!",
				Icon = "check"
			});
		end;
	end
});
SettingsTab:Button({
	Title = "Delete Config",
	Icon = "trash",
	Callback = function()
		Window.ConfigManager:DeleteConfig(ConfigName);
		Window:Notify({
			Title = "Success",
			Content = "Deleted!",
			Icon = "trash"
		});
	end
});
local SecuritySection = SettingsTab:Section({
	Title = "Game Security",
	Icon = "shield",
	Opened = true
});
SettingsTab:Paragraph({
	Title = "Game Auto Reconnect",
	Desc = "Status: FROZEN by ANHub\nBypass is running automatically."
});
if Reliable then
	Reliable.OnClientEvent:Connect(function(msg, args)
		if msg == "Do Teleport" and type(args) == "table" then
			local targetZoneName = args[1];
			IsTeleporting = true;
			IsLoadingConfig = true;
			CurrentZoneName = targetZoneName;
			Config.SelectedEnemy = nil;
			if EnemyDropdown and EnemyDropdown.Select then
				pcall(function()
					EnemyDropdown:Select(nil);
				end);
			end;
			task.spawn(function()
				task.wait(2.5);
				local freshEnemies = RefreshEnemyData();
				CurrentZoneEnemiesCache = freshEnemies;
				if EnemyDropdown and EnemyDropdown.Refresh then
					pcall(function()
						EnemyDropdown:Refresh(freshEnemies);
					end);
				end;
				local savedEntry = Config.ZoneConfigurations[targetZoneName];
				if savedEntry then
					for _, enemy in ipairs(freshEnemies) do
						if enemy.Value == savedEntry.Value then
							Config.SelectedEnemy = enemy.Value;
							if EnemyDropdown and EnemyDropdown.Select then
								pcall(function()
									EnemyDropdown:Select(enemy.Value);
								end);
							end;
							break;
						end;
					end;
				end;
				IsLoadingConfig = false;
				IsTeleporting = false;
			end);
		end;
	end);
end;
task.spawn(function()
	local prevZone = "";
	local refreshTick = 0;
	while not Window.Destroyed do
		task.wait(0.5);
		if IsTeleporting then
			continue;
		end;
		if os.time() - refreshTick > 2 then
			RefreshEnemyData();
			refreshTick = os.time();
		end;
		local detectedZone = GetCurrentMapStatus();
		if detectedZone and detectedZone ~= "Unknown" and detectedZone ~= prevZone then
			prevZone = detectedZone;
			CurrentZoneName = detectedZone;
			Config.SelectedEnemy = nil;
			if EnemyDropdown and EnemyDropdown.Select then
				pcall(function()
					EnemyDropdown:Select(nil);
				end);
			end;
			IsLoadingConfig = true;
			local freshEnemies = RefreshEnemyData();
			CurrentZoneEnemiesCache = freshEnemies;
			pcall(function()
				EnemyDropdown:Refresh(freshEnemies);
			end);
			task.wait(0.2);
			local savedEntry = Config.ZoneConfigurations[detectedZone];
			local objectToSelect = nil;
			if savedEntry then
				for _, currentMob in ipairs(freshEnemies) do
					if currentMob.Value == savedEntry.Value then
						objectToSelect = currentMob;
						Config.SelectedEnemy = currentMob.Value;
						break;
					end;
				end;
			end;
			if objectToSelect then
				pcall(function()
					EnemyDropdown:Select(objectToSelect.Value);
				end);
			end;
			task.wait(0.2);
			IsLoadingConfig = false;
		end;
	end;
end);
local LastMorphCount = 0;
local LastEquippedAvatar = "";
task.spawn(function()
	while not Window.Destroyed do
		if not (getgenv()).PlayerData then
			ScanPlayerData();
		end;
		local Data = (getgenv()).PlayerData;
		if Data and Data.Attributes then
			local currentRank = Data.Attributes.Rank or 0;
			local currentMastery = Data.Attributes.Mastery or 0;
			local req = GetRankRequirement(currentRank);
			local currentBuff = GetRankBuff(currentRank);
			local nextBuff = GetRankBuff(currentRank + 1);
			if RankProgressUI and not Window.Closed then
				local percent = req > 0 and math.clamp(currentMastery / req, 0, 1) or 0;
				local barText = string.rep("█", math.floor(percent * 10)) .. string.rep("▒", 10 - math.floor(percent * 10));
				local buffText = currentRank >= MaxRankCap and "Buff: " .. FormatNumber(currentBuff) .. "% (MAX)" or "Buff: " .. FormatNumber(currentBuff) .. "% >> " .. FormatNumber(nextBuff) .. "%";
				RankProgressUI:SetTitle(string.format("Rank %d", currentRank));
				RankProgressUI:SetDesc(string.format("%s\n[%s] %d%%\n%s / %s", buffText, barText, math.floor(percent * 100), FormatNumber(currentMastery), FormatNumber(req)));
			end;
			if Config.AutoRankUp and currentMastery >= req and currentRank < MaxRankCap then
				if Reliable then
					pcall(function()
						Reliable:FireServer("RankUp");
					end);
				end;
			end;
			local currentMorphCount = 0;
			if Data.Morphs then
				for _ in pairs(Data.Morphs) do
					currentMorphCount = currentMorphCount + 1;
				end;
			end;
			local currentEquipped = Data.Attributes.Avatar or "";
			if currentMorphCount ~= LastMorphCount or currentEquipped ~= LastEquippedAvatar then
				LastMorphCount = currentMorphCount;
				LastEquippedAvatar = currentEquipped;
				if AvatarDropdown and AvatarDropdown.Refresh then
					AvatarDropdown:Refresh(GetAvatarsWithStats());
				end;
			end;
			if Data.YenUpgrades then
				local currentYen = Data.Attributes.Yen or 0;
				for name, configData in pairs(YenUpgradeConfig) do
					local lvl = Data.YenUpgrades[name] or 0;
					local cost = GetYenCost(lvl);
					local toggle = YenUpgradeToggleUI[name];
					if toggle and toggle.SetTitle and toggle.SetDesc then
						local maxLvl = configData.MaxLevel or 20;
						if lvl >= maxLvl then
							if not Window.Closed then
								toggle:SetTitle(name .. " [MAX]");
								toggle:Lock();
								toggle:SetDesc(string.format("Maxed Out (Buff: +%s%%)", FormatNumber(GetYenBuff(name, lvl))));
							end
						else
							if not Window.Closed then
								toggle:SetTitle(name .. " [" .. lvl .. "/" .. maxLvl .. "]");
								toggle:SetDesc(string.format("Cost: %s | Buff: +%s%%", FormatNumber(cost), FormatNumber(GetYenBuff(name, lvl))));
							end
							if Config["AutoYen_" .. name] and currentYen >= cost then
								if Reliable then
									pcall(function()
										Reliable:FireServer("Yen Upgrade", {
											name
										});
									end);
								end;
							end;
						end;
					end;
				end;
			end;
			if Data.TokenUpgrades then
				local currentToken = Data.Materials.UpgradeToken or 0;
				for name, configData in pairs(TokenUpgradeConfig) do
					local lvl = Data.TokenUpgrades[name] or 0;
					local cost = GetTokenCost(lvl);
					local toggle = TokenUpgradeToggleUI[name];
					if toggle and toggle.SetTitle and toggle.SetDesc then
						local maxLvl = configData.MaxLevel or 999;
						if lvl >= maxLvl then
							if not Window.Closed then
								toggle:Lock();
								toggle:SetTitle(name .. " [MAX]");
								toggle:SetDesc(string.format("Maxed Out (Buff: +%s%%)", FormatNumber(GetTokenBuff(name, lvl))));
							end
						else
							if not Window.Closed then
								toggle:SetTitle(name .. " [" .. lvl .. "/" .. maxLvl .. "]");
								toggle:SetDesc(string.format("Cost: %s | Buff: +%s%%\nUpgrade Shard: %s", FormatNumber(cost), FormatNumber(GetTokenBuff(name, lvl)), FormatNumber(currentToken)));
							end
							if Config["AutoToken_" .. name] and currentToken >= cost then
								if Reliable then
									pcall(function()
										Reliable:FireServer("Token Upgrade", {
											name
										});
									end);
								end;
							end;
						end;
					end;
				end;
			end;
			if Data.CrateUpgrades then
				for name, toggleObj in pairs(ChanceUpgradeToggleUI) do
					local mod = ChanceModules[name];
					if mod and toggleObj.SetTitle and toggleObj.SetDesc then
						local lvl = Data.CrateUpgrades[name] or 0;
						local maxLvl = mod.MAX_LEVEL or 10;
						local cost = mod.GetCost(lvl);
						local chance = string.format("%.1f", mod.GetChance(lvl));
						local tokenKey = mod.TOKEN_NAME or name .. "Token";
						local currentMaterial = Data.Materials[tokenKey] or 0;
						local displayName = tokenKey;
						if MaterialsModule[tokenKey] and MaterialsModule[tokenKey].Display then
							displayName = MaterialsModule[tokenKey].Display;
						end;
						if lvl >= maxLvl then
							if not Window.Closed then
								toggleObj:SetTitle(name .. " [MAX]");
								toggleObj:SetDesc("Max Level Reached");
								toggleObj:Lock();
							end
						else
							if not Window.Closed then
								toggleObj:SetTitle(string.format("%s [%d/%d]", name, lvl, maxLvl));
								toggleObj:SetDesc(string.format("Cost: %s | Chance: %s%%\n%s: %s", FormatNumber(cost), chance, displayName, FormatNumber(currentMaterial)));
							end
							if Config["AutoChance_" .. name] then
								if currentMaterial >= cost then
									if Reliable then
										Reliable:FireServer("Chance Upgrade", {
											name
										});
									end;
								end;
							end;
						end;
					end;
				end;
			end;
			if Data.Materials then
				for rollType, toggleObj in pairs(RollToggleUI) do
					local configKey = RollTypeToConfig[rollType];
					if Config[configKey] then
						local count = Data.Materials[RollMaterialMap[rollType]] or 0;
						if count < 10 then
							Config[configKey] = false;
							if toggleObj.Set then
								toggleObj:Set(false);
							end;
							l:Notify({
								Title = "Crate Roll Stopped",
								Content = "Insufficient " .. (RollDisplayNames[rollType] or rollType),
								Icon = "alert-triangle",
								Duration = 5
							});
						end;
					end;
				end;
			end;
		elseif RankProgressUI then
			RankProgressUI:SetDesc("Scanning Data...");
		end;
		task.wait(0.5);
	end;
end);
task.spawn(MaintainAutoStatus);
task.spawn(function()
	task.wait(1.5);
	local DefaultConfig = "ANConfig";
	local CM = Window.ConfigManager;
    
    -- Path manual diupdate ke FolderPath
	if not isfolder((FolderPath .. "/config")) then
		makefolder(FolderPath .. "/config");
	end;
	pcall(function()
        -- Path manual diupdate ke FolderPath
		if isfile(FolderPath .. "/config/" .. DefaultConfig .. ".json") then
			local cfg = CM:GetConfig(DefaultConfig) or CM:CreateConfig(DefaultConfig);
			cfg:Load();
			LoadZoneDB();
			l:Notify({
				Title = "Config",
				Content = "Restored ANConfig",
				Icon = "check",
				Duration = 2
			});
		else
			CM:CreateConfig(DefaultConfig);
		end;
	end);
	while not Window.Destroyed do
		task.wait(10);
		pcall(function()
			local cfg = Window.ConfigManager:GetConfig(DefaultConfig);
			if cfg then
				cfg:Save();
			else
				(CM:CreateConfig(DefaultConfig)):Save();
			end;
		end);
		if CurrentZoneName ~= "" and Config.SelectedEnemy then
			SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy);
		end;
	end;
end);
local AllSections = {
	CommunitySection,
	MainSection,
	FarmingManagerSection,
	RollSection,
	AvatarSection,
	YenMainSection,
	ConfigSection,
	SecuritySection
};
for _, sec in pairs(AllSections) do
	task.spawn(function()
		task.wait(0.1);
		if sec.Opened then
			sec:Open();
		end;
	end);
end;
Window:SelectTab(1);