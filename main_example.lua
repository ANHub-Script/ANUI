local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))();
-- local ANUI = require("./src/Init")

local Window = ANUI:CreateWindow({
    Title = "WindUI Sidebar Demo",
    Icon = "geist:window",
    Author = "Welcome to WindUI",
    Folder = "WindUI_SidebarDemo",
    Theme = "Dark",
    SideBarWidth = 220,
    HideSearchBar = false,
    User = { Enabled = true, Anonymous = true },
})

local Section = Window:Section({ Title = "Home", Icon = "home" })
local Tab = Section:Tab({ Title = "Welcome", Icon = "sparkles" })

ANUI:Notify({ Title = "Sidebar", Content = "Use Topbar button to toggle Sidebar", Duration = 4 })

task.delay(1.0, function()
    Window:CollapseSidebar()
end)

task.delay(3.0, function()
    Window:ExpandSidebar()
end)

local Window = ANUI:CreateWindow({
	Title = ".an hub | ANUI Library",
	Author = "by .an • AdityaNugraha",
	Folder = "anhub",
	Icon = "rbxassetid://84366761557806",
	IconSize = 22 * 2,
	NewElements = true,
	-- HideSearchBar = false,
	OpenButton = {
		Title = ".an UI",
		CornerRadius = UDim.new(1, 0),
		StrokeThickness = 3,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))
	}
});

do
	Window:Tag({
		Title = "v" .. ANUI.Version,
		Icon = "github",
		Color = Color3.fromHex("#1c1c1c")
	});
end;

-- ============================================================================
-- GLOBAL PROFILE CONFIGURATION
-- Konfigurasi profil utama disimpan di sini agar tidak perlu ditulis ulang
-- ============================================================================
local BaseProfile = {
	Banner = "rbxassetid://114772391775993",
	Avatar = "rbxassetid://84366761557806",
	Status = true,
	Badges = {
		{
			Icon = "geist:logo-discord",
			Title = "Discord",
			Desc = "Join ANHUB Discord",
			Callback = function()
				setclipboard("https://discord.gg/cy6uMRmeZ")
				if ANUI then
					ANUI:Notify({
						Title = "Discord",
						Content = "Invite link copied to clipboard!",
						Icon = "geist:logo-discord",
						Duration = 3
					})
				end
			end
		},
		{
			Icon = "youtube",
			Desc = "Subscribe to YouTube",
			Callback = function()
				setclipboard("https://www.youtube.com/@ANHubRoblox")
				if ANUI then
					ANUI:Notify({
						Title = "YouTube",
						Content = "Channel link copied!",
						Icon = "youtube",
						Duration = 3
					})
				end
			end
		}
	}
}

-- Fungsi Helper untuk menggabungkan BaseProfile dengan Data Custom (Title/Desc)
local function MakeProfile(customData)
	local profile = {}
	-- Copy data dasar
	for k, v in pairs(BaseProfile) do
		profile[k] = v
	end
	-- Timpa dengan data custom jika ada
	if customData then
		for k, v in pairs(customData) do
			profile[k] = v
		end
	end
	return profile
end

-- ============================================================================
-- UTILITIES
-- ============================================================================
local function parseJSON(luau_table, indent, level, visited)
	indent = indent or 2;
	level = level or 0;
	visited = visited or {};
	local currentIndent = string.rep(" ", level * indent);
	local nextIndent = string.rep(" ", (level + 1) * indent);
	if luau_table == nil then
		return "null";
	end;
	local dataType = type(luau_table);
	if dataType == "table" then
		if visited[luau_table] then
			return "\"[Circular Reference]\"";
		end;
		visited[luau_table] = true;
		local isArray = true;
		local maxIndex = 0;
		for k, _ in pairs(luau_table) do
			if type(k) == "number" and k > maxIndex then
				maxIndex = k;
			end;
			if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
				isArray = false;
				break;
			end;
		end;
		local count = 0;
		for _ in pairs(luau_table) do
			count = count + 1;
		end;
		if count ~= maxIndex and isArray then
			isArray = false;
		end;
		if count == 0 then
			return "{}";
		end;
		if isArray then
			if count == 0 then
				return "[]";
			end;
			local result = "[\n";
			for i = 1, maxIndex do
				result = result .. nextIndent .. parseJSON(luau_table[i], indent, level + 1, visited);
				if i < maxIndex then
					result = result .. ",";
				end;
				result = result .. "\n";
			end;
			result = result .. currentIndent .. "]";
			return result;
		else
			local result = "{\n";
			local first = true;
			local keys = {};
			for k in pairs(luau_table) do
				table.insert(keys, k);
			end;
			table.sort(keys, function(a, b)
				if type(a) == type(b) then
					return tostring(a) < tostring(b);
				else
					return type(a) < type(b);
				end;
			end);
			for _, k in ipairs(keys) do
				local v = luau_table[k];
				if not first then
					result = result .. ",\n";
				else
					first = false;
				end;
				if type(k) == "string" then
					result = result .. nextIndent .. "\"" .. k .. "\": ";
				else
					result = result .. nextIndent .. "\"" .. tostring(k) .. "\": ";
				end;
				result = result .. parseJSON(v, indent, level + 1, visited);
			end;
			result = result .. "\n" .. currentIndent .. "}";
			return result;
		end;
	elseif dataType == "string" then
		local escaped = luau_table:gsub("\\", "\\\\");
		escaped = escaped:gsub("\"", "\\\"");
		escaped = escaped:gsub("\n", "\\n");
		escaped = escaped:gsub("\r", "\\r");
		escaped = escaped:gsub("\t", "\\t");
		return "\"" .. escaped .. "\"";
	elseif dataType == "number" then
		return tostring(luau_table);
	elseif dataType == "boolean" then
		return luau_table and "true" or "false";
	elseif dataType == "function" then
		return "\"function\"";
	else
		return "\"" .. dataType .. "\"";
	end;
end;
local function tableToClipboard(luau_table, indent)
	indent = indent or 4;
	local jsonString = parseJSON(luau_table, indent);
	setclipboard(jsonString);
	return jsonString;
end;

-- ============================================================================
-- UI IMPLEMENTATION
-- ============================================================================

do
	-- 1. SIDEBAR CARD (Hanya Hiasan, Tidak Bisa Diklik)
	-- Menggunakan MakeProfile agar lebih ringkas
	Window:Tab({
		Profile = MakeProfile({
			Title = "AdityaNugraha",
			Desc = "Admin",
	Badges = {
		{
			Icon = "geist:logo-discord",
			Desc = "Join ANHUB Discord",
			Callback = function()
				setclipboard("https://discord.gg/cy6uMRmeZ")
				if ANUI then
					ANUI:Notify({
						Title = "Discord",
						Content = "Invite link copied to clipboard!",
						Icon = "geist:logo-discord",
						Duration = 3
					})
				end
			end
		},
		{
			Icon = "youtube",
			Desc = "Subscribe to YouTube",
			Callback = function()
				setclipboard("https://www.youtube.com/@ANHubRoblox")
				if ANUI then
					ANUI:Notify({
						Title = "YouTube",
						Content = "Channel link copied!",
						Icon = "youtube",
						Duration = 3
					})
				end
			end
		}
	}
		}),
		SidebarProfile = true -- AKTIFKAN MODE SIDEBAR CARD
	})

	-- 2. TAB BIASA (Isinya ada Profil Header Besar)
	local UserTab = Window:Tab({
		Title = "Example Profile Content",
		Icon = "user",
		
		-- Menggunakan MakeProfile lagi, kali ini untuk header konten
		Profile = MakeProfile({
			Title = "User Settings",
			Desc = "Manage your account details here"
		}),
		
		SidebarProfile = false -- Mode Tab Biasa
	})
	
	UserTab:Button({ Title = "Change Password", Callback = function() end })
	UserTab:Button({ Title = "Log Out", Icon = "log-out", Callback = function() end })
end;

local ElementsSection = Window:Section({
	Title = "Elements"
});
local ConfigUsageSection = Window:Section({
	Title = "Config Usage"
});
local OtherSection = Window:Section({
	Title = "Other"
});

do
	local ToggleTab = ElementsSection:Tab({
		Title = "Toggle",
		Icon = "arrow-left-right",
		Profile = MakeProfile({ Title = "Toggle Settings", Desc = "Configure toggles" }),
		SidebarProfile = false,
	});
	
	ToggleTab:Paragraph({
		Title = "Toggle Examples",
		Desc = "This tab showcases all supported Toggle features: classic toggle with animated drag, checkbox variant, per-item icons and icon sizing, default values, locking, global callbacks, and programmatic updates (Set, SetTitle, SetDesc)."
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Basic Toggle",
		Desc = "Standard toggle with animated slider (drag or click).",
		Callback = function(v)
			print("Basic Toggle:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Toggle with Description",
		Desc = "Shows a description under the title.",
		Callback = function(v)
			print("Toggle with Description:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Toggle with Left Image",
		Desc = "Image on the left, centered between title and desc.",
		Image = "rbxassetid://84366761557806",
		ImageSize = 24,
		Callback = function(v)
			print("Toggle with Left Image:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Toggle with Icon",
		Desc = "Shows an icon inside the slider when toggled.",
		Icon = "mouse",
		IconSize = 15,
		Value = true,
		Callback = function(v)
			print("Toggle with Icon:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Large Icon Toggle",
		Desc = "Custom icon size for the slider icon.",
		Icon = "settings",
		IconSize = 26,
		Callback = function(v)
			print("Large Icon Toggle:", v);
		end
	});
	ToggleTab:Space();
	local ProgrammaticToggle = ToggleTab:Toggle({
		Title = "Programmatic Toggle",
		Desc = "Demonstrates using Set() and updating title/desc via code.",
		Value = false,
		Callback = function(v)
			print("Programmatic Toggle:", v);
		end
	});
	ToggleTab:Button({
		Title = "Turn ON",
		Callback = function()
			ProgrammaticToggle:Set(true, true, false);
			ProgrammaticToggle:SetTitle("Programmatic Toggle (ON)");
			ProgrammaticToggle:SetDesc("Toggled on by code.");
		end
	});
	ToggleTab:Button({
		Title = "Turn OFF (no animation)",
		Callback = function()
			ProgrammaticToggle:Set(false, true, true);
			ProgrammaticToggle:SetTitle("Programmatic Toggle (OFF)");
			ProgrammaticToggle:SetDesc("Toggled off by code without animation.");
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Locked Toggle",
		Desc = "Locked state prevents user interaction.",
		Locked = true,
		Callback = function(v)
			print("Locked Toggle:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Checkbox",
		Desc = "Checkbox variant of toggle.",
		Type = "Checkbox",
		Callback = function(v)
			print("Checkbox:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Checkbox with Left Image",
		Desc = "Image left of text, centered vertically.",
		Type = "Checkbox",
		Image = "rbxassetid://84366761557806",
		ImageSize = 22,
		Callback = function(v)
			print("Checkbox with Left Image:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Checkbox (Default ON)",
		Desc = "Starts checked by default.",
		Type = "Checkbox",
		Value = true,
		Callback = function(v)
			print("Checkbox (Default ON):", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Checkbox with Icon",
		Desc = "Checkbox variant with custom icon.",
		Type = "Checkbox",
		Icon = "mouse-pointer-click",
		IconSize = 22,
		Callback = function(v)
			print("Checkbox with Icon:", v);
		end
	});
	ToggleTab:Space();
	ToggleTab:Toggle({
		Title = "Checkbox (Locked)",
		Desc = "Locked checkbox cannot be toggled.",
		Type = "Checkbox",
		Locked = true,
		Callback = function(v)
			print("Checkbox (Locked):", v);
		end
	});
end;

do
	local ButtonTab = ElementsSection:Tab({
		Title = "Button",
		Icon = "mouse-pointer-click",
		Profile = MakeProfile({ Title = "Toggle Settings", Desc = "Configure toggles",
		Sticky = false}),
		SidebarProfile = false,
	});
	ButtonTab:Paragraph({
		Title = "Button Examples",
		Desc = "Shows supported Button features: title and description, icon and themed icon, color tinting, icon alignment (left/right), justification (center/between), locked state, callbacks, programmatic updates, and UI Button variants (Primary, Secondary, White) via Dialog.",
	});
	local HighlightButton;
	HighlightButton = ButtonTab:Button({
		Title = "Highlight Button",
		Icon = "mouse",
		Callback = function()
			print("clicked highlight");
			HighlightButton:Highlight();
		end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Blue Button",
		Color = Color3.fromHex("#305dff"),
		Icon = "",
		Callback = function()
		end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Blue Button",
		Desc = "With description",
		Color = Color3.fromHex("#305dff"),
		Icon = "",
		Callback = function()
		end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Button",
		Desc = "Button example"
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Button",
		Locked = true
	});
	ButtonTab:Button({
		Title = "Button",
		Desc = "Button example",
		Locked = true
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Left Icon",
		Desc = "Icon aligned to the left",
		Icon = "mouse",
		IconAlign = "Left",
		Justify = "Center",
		Callback = function() end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Center Justified",
		Desc = "Text and icon in the title row",
		Icon = "settings",
		IconAlign = "Left",
		Justify = "Center",
		Callback = function() end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Themed Icon",
		Desc = "Icon follows theme colors",
		Icon = "palette",
		IconThemed = true,
		Callback = function() end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Colored Icon",
		Desc = "Icon tinted with custom color",
		Icon = "mouse-pointer-click",
		Color = Color3.fromHex("#f57c00"),
		Callback = function() end
	});
	ButtonTab:Space();
	local ProgBtn = ButtonTab:Button({
		Title = "Programmatic Button",
		Desc = "Will be updated by code",
		Icon = "edit",
		Callback = function() end
	});
	ButtonTab:Button({
		Title = "Update Above",
		Desc = "SetTitle and SetDesc",
		Icon = "chevron-right",
		Callback = function()
			ProgBtn:SetTitle("Programmatic Button (Updated)");
			ProgBtn:SetDesc("Updated by code");
			ProgBtn:Highlight();
		end
	});
	ButtonTab:Space();
	ButtonTab:Button({
		Title = "Show UI Button Variants",
		Desc = "Opens dialog with Primary/Secondary/White",
		Icon = "square-menu",
		Callback = function()
			Window:Dialog({
				Title = "UI Button Variants",
				Content = "Demonstrates components/ui Button variants.",
				Buttons = {
					{ Title = "Primary", Variant = "Primary", Icon = "chevron-right", Callback = function() end },
					{ Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
					{ Title = "White", Variant = "White", Icon = "chevron-right", Callback = function() end },
				}
			});
		end
	});
end;

do
	local GroupTab = ElementsSection:Tab({
		Title = "Groups",
		Icon = "layout-grid"
	});
	GroupTab:Paragraph({
		Title = "Group Element Examples",
		Desc = "Each group arranges its child elements horizontally with equal widths. Below are grouped examples for the main UI components: Button, Toggle/Checkbox, Dropdown, Input, Slider, and Code."
	});
	GroupTab:Space();
	GroupTab:Paragraph({
		Title = "Buttons Group",
		Desc = "Three buttons side by side."
	});
	do
		local GB = GroupTab:Group({});
		GB:Button({
			Title = "Primary",
			Color = Color3.fromHex("#305dff"),
			Icon = "mouse-pointer-click",
			Callback = function()
			end
		});
		GB:Button({
			Title = "Secondary",
			Icon = "mouse",
			Callback = function()
			end
		});
		GB:Button({
			Title = "Locked",
			Locked = true,
			Icon = "lock",
			Callback = function()
			end
		});
	end;
	GroupTab:Space();
	GroupTab:Paragraph({
		Title = "Toggle / Checkbox Group",
		Desc = "Mix of toggles and a checkbox side by side."
	});
	do
		local GT = GroupTab:Group({});
		GT:Toggle({
			Title = "Toggle",
			Callback = function(v)
				print("Toggle:", v);
			end
		});
		GT:Toggle({
			Title = "Toggle Icon",
			Icon = "mouse",
			IconSize = 20,
			Value = true,
			Callback = function(v)
				print("Toggle Icon:", v);
			end
		});
		GT:Toggle({
			Title = "Checkbox",
			Type = "Checkbox",
			Callback = function(v)
				print("Checkbox:", v);
			end
		});
	end;
	GroupTab:Space();
	GroupTab:Paragraph({
		Title = "Dropdowns Group",
		Desc = "Two dropdowns grouped."
	});
	do
		local GD = GroupTab:Group({});
		GD:Dropdown({
			Title = "Dropdown 1",
			Values = {
				"A",
				"B",
				"C"
			},
			Value = "A",
			Callback = function(v)
				print("Dropdown 1:", v);
			end
		});
		GD:Dropdown({
			Title = "Dropdown 2",
			Values = {
				{
					Title = "X",
					Desc = "First"
				},
				{
					Title = "Y"
				},
				{
					Title = "Z"
				}
			},
			SearchBarEnabled = true,
			Value = "Y",
			Callback = function(v)
				print("Dropdown 2:", v);
			end
		});
	end;
	GroupTab:Space();
	GroupTab:Paragraph({
		Title = "Inputs Group",
		Desc = "Two input fields grouped."
	});
	do
		local GI = GroupTab:Group({});
		GI:Input({
			Title = "Name",
			Placeholder = "Enter name",
			Callback = function(v)
				print("Name:", v);
			end
		});
		GI:Input({
			Title = "Email",
			Placeholder = "Enter email",
			Callback = function(v)
				print("Email:", v);
			end
		});
	end;
	GroupTab:Space();
	GroupTab:Paragraph({
		Title = "Sliders Group",
		Desc = "Two sliders grouped."
	});
	do
		local GS = GroupTab:Group({});
		GS:Slider({
			Title = "Volume",
			Value = {
				Min = 0,
				Max = 100,
				Default = 50
			},
			Callback = function(v)
				print("Volume:", v);
			end
		});
		GS:Slider({
			Title = "Brightness",
			Step = 0.1,
			Value = {
				Min = 0,
				Max = 1,
				Default = 0.5
			},
			Callback = function(v)
				print("Brightness:", v);
			end
		});
	end;
	GroupTab:Space();
	GroupTab:Paragraph({
		Title = "Code Blocks Group",
		Desc = "Two code blocks grouped."
	});
	do
		local GC = GroupTab:Group({});
		GC:Code({
			Title = "Lua",
			Code = "print('Hello from Group 1')"
		});
		GC:Code({
			Title = "Table",
			Code = "return {a = 1, b = 2}"
		});
	end;
end;

do
	local InputTab = ElementsSection:Tab({
		Title = "Input",
		Icon = "text-cursor-input"
	});
	InputTab:Input({
		Title = "Input",
		Icon = "mouse"
	});
	InputTab:Space();
	InputTab:Input({
		Title = "Input Textarea",
		Type = "Textarea",
		Icon = "mouse"
	});
	InputTab:Space();
	InputTab:Input({
		Title = "Input Textarea",
		Type = "Textarea"
	});
	InputTab:Space();
	InputTab:Input({
		Title = "Input",
		Desc = "Input example"
	});
	InputTab:Space();
	InputTab:Input({
		Title = "Input Textarea",
		Desc = "Input example",
		Type = "Textarea"
	});
	InputTab:Space();
	InputTab:Input({
		Title = "Input",
		Locked = true
	});
	InputTab:Input({
		Title = "Input",
		Desc = "Input example",
		Locked = true
	});
end;

do
	local DropdownTab = ElementsSection:Tab({
		Title = "Dropdown",
		Icon = "logs"
	});
	DropdownTab:Paragraph({
		Title = "Dropdown Examples",
		Desc = "This tab demonstrates all supported features of ANUI's Dropdown component, including single and multi selection, per-item icons and descriptions, dividers for grouping, images below title/description, locked items, optional search bar, configurable menu width, 'allow none' behavior, programmatic selection, and action-style menus with per-item callbacks."
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Locked Dropdown",
		Desc = "Locked Example",
		Locked = true,
		Values = {
			"Option 1"
		},
		Value = "Option 1",
		SearchBarEnabled = true,
		Callback = function(value)
			print("Selected:", value);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Basic",
		Desc = "Simple list of string values with a global selection callback.",
		Values = {
			"Option 1",
			"Option 2",
			"Option 3",
			"Option 4"
		},
		Value = "Option 1",
		SearchBarEnabled = true,
		Callback = function(value)
			print("Selected:", value);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "With Icons",
		Desc = "Each option is an object containing a title and an icon.",
		Values = {
			{
				Title = "Bird",
				Icon = "bird"
			},
			{
				Title = "House",
				Icon = "house"
			},
			{
				Title = "Settings",
				Icon = "settings"
			},
			{
				Title = "Trash",
				Icon = "trash-2"
			}
		},
		Value = {
			Title = "Bird",
			Icon = "bird"
		},
		SearchBarEnabled = true,
		Callback = function(option)
			print("Selected:", option.Title);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Title/Desc/Images Ordering",
		Desc = "Images are shown below the title if description is missing, or below the description when it exists.",
		ImageSize = UDim2.fromOffset(20, 20),
		ImagePadding = 6,
		Values = {
			{
				Title = "Alpha",
				Desc = "With description",
				Icon = "info",
				Images = {
					"rbxassetid://84366761557806",
					"bird"
				}
			},
			{
				Title = "Beta",
				Icon = "gift",
				Images = {
					"rbxassetid://84366761557806",
					"droplet"
				}
			},
			{
				Title = "Gamma",
				Desc = "Only description",
				Icon = "file-text"
			}
		},
		Value = {
			Title = "Alpha",
			Desc = "With description",
			Icon = "info"
		},
		SearchBarEnabled = true,
		Callback = function(option)
			print("Selected:", option.Title);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Title/Desc/Images Ordering",
		Desc = "Images are shown below the title if description is missing, or below the description when it exists.",
		Image = "rbxassetid://84366761557806",
		ImageSize = 40,
		ImagePadding = 6,
		Values = {
			{
				Title = "Alpha",
				Desc = "With description",
				Icon = "info",
				Images = {
					"rbxassetid://84366761557806",
					"bird"
				}
			},
			{
				Title = "Beta",
				Icon = "gift",
				Images = {
					"rbxassetid://84366761557806",
					"droplet"
				}
			},
			{
				Title = "Gamma",
				Desc = "Only description",
				Icon = "file-text"
			}
		},
		SearchBarEnabled = true,
		Callback = function(option) print("Selected:", option.Title) end
	})
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Multi-Select",
		Desc = "Select multiple options (global callback returns an array of selected items).",
		Values = {
			{
				Title = "Category A",
				Icon = "folder"
			},
			{
				Title = "Category B",
				Icon = "folder"
			},
			{
				Title = "Category C",
				Icon = "folder"
			},
			{
				Title = "Category D",
				Icon = "folder"
			}
		},
		Multi = true,
		SearchBarEnabled = true,
		Callback = function(values)
			local titles = {};
			for _, v in ipairs(values) do
				table.insert(titles, v.Title);
			end;
			print("Selected:", table.concat(titles, ", "));
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "With Descriptions",
		Desc = "Each option includes a description that appears under the title.",
		Values = {
			{
				Title = "Option A",
				Desc = "Ini adalah option A"
			},
			{
				Title = "Option B",
				Desc = "Ini adalah option B"
			},
			{
				Title = "Option C",
				Desc = "Ini adalah option C"
			}
		},
		Value = {
			Title = "Option A",
			Desc = "Ini adalah option A"
		},
		SearchBarEnabled = true,
		Callback = function(option)
			print("Selected:", option.Title);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Divider Grouping",
		Desc = "Use Type = 'Divider' to split options into visually separated groups.",
		Values = {
			{
				Title = "Group 1 - A",
				Icon = "star"
			},
			{
				Title = "Group 1 - B",
				Icon = "star"
			},
			{
				Type = "Divider"
			},
			{
				Title = "Group 2 - A",
				Icon = "heart"
			},
			{
				Title = "Group 2 - B",
				Icon = "heart"
			}
		},
		Value = {
			Title = "Group 1 - A",
			Icon = "star"
		},
		SearchBarEnabled = true,
		Callback = function(option)
			print("Selected:", option.Title);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Allow None",
		Desc = "When Multi is enabled, AllowNone lets you deselect the last remaining item.",
		Values = {
			"Option 1",
			"Option 2",
			"Option 3"
		},
		Value = nil,
		AllowNone = true,
		SearchBarEnabled = true,
		Callback = function(value)
			print("Selected:", value or "None");
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Locked Items",
		Desc = "Per-item locking disables selection for specific options.",
		Values = {
			{
				Title = "Usable A"
			},
			{
				Title = "Locked B",
				Locked = true
			},
			{
				Title = "Usable C"
			}
		},
		Value = "Usable A",
		SearchBarEnabled = true,
		Callback = function(value)
			print("Selected:", typeof(value) == "table" and value.Title or value);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Custom Width",
		Desc = "Manually define menu width instead of using auto-fit.",
		Values = {
			"Short",
			"Medium Option",
			"Veryyyyyyyy Long Option Name"
		},
		Value = "Short",
		MenuWidth = 250,
		SearchBarEnabled = true,
		Callback = function(value)
			print("Selected:", value);
		end
	});
	DropdownTab:Space();
	local ProgrammaticDD = DropdownTab:Dropdown({
		Title = "Programmatic Select",
		Desc = "Demonstrates using :Select() to set selection via code.",
		Values = {
			"Red",
			"Green",
			"Blue"
		},
		Value = "Red",
		SearchBarEnabled = false,
		Callback = function(value)
			print("Selected:", value);
		end
	});
	DropdownTab:Button({
		Title = "Select 'Blue' via code",
		Callback = function()
			ProgrammaticDD:Select("Blue");
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Multi (AllowNone = true)",
		Desc = "Multi-select with AllowNone, starting from a single string value.",
		Values = {
			{
				Title = "A"
			},
			{
				Title = "B"
			},
			{
				Title = "C"
			}
		},
		Value = "B",
		Multi = true,
		AllowNone = true,
		Callback = function(values)
			local titles = {};
			for _, v in ipairs(values) do
				table.insert(titles, v.Title);
			end;
			print("Selected:", table.concat(titles, ", "));
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Mixed Types",
		Desc = "Values can be strings or objects; selection works across both.",
		Values = {
			"Plain String",
			{
				Title = "Object Item",
				Icon = "info"
			},
			"Another String"
		},
		Value = "Plain String",
		SearchBarEnabled = true,
		Callback = function(value)
			print("Selected:", typeof(value) == "table" and value.Title or value);
		end
	});
	DropdownTab:Space();
	DropdownTab:Dropdown({
		Title = "Advanced Actions",
		Desc = "No global callback: items behave like an action menu using per-item callbacks.",
		Values = {
			{
				Title = "New file",
				Desc = "Create a new file",
				Icon = "file-plus",
				Callback = function()
					print("Clicked 'New File'");
				end
			},
			{
				Title = "Copy link",
				Desc = "Copy the file link",
				Icon = "copy",
				Callback = function()
					print("Clicked 'Copy link'");
				end
			},
			{
				Title = "Edit file",
				Desc = "Allows you to edit the file",
				Icon = "file-pen",
				Callback = function()
					print("Clicked 'Edit file'");
				end
			},
			{
				Type = "Divider"
			},
			{
				Title = "Delete file",
				Desc = "Permanently delete the file",
				Icon = "trash",
				Callback = function()
					print("Clicked 'Delete file'");
				end
			}
		}
	});
end;

do
	local ConfigElementsTab = ConfigUsageSection:Tab({
		Title = "Config Elements",
		Icon = "square-dashed-mouse-pointer"
	});
	ConfigElementsTab:Colorpicker({
		Flag = "ColorpickerTest",
		Title = "Colorpicker",
		Desc = "Colorpicker Description",
		Default = Color3.fromRGB(0, 255, 0),
		Transparency = 0,
		Locked = false,
		Callback = function(color)
			print("Background color: " .. tostring(color));
		end
	});
	ConfigElementsTab:Space();
	ConfigElementsTab:Dropdown({
		Flag = "DropdownTest",
		Title = "Advanced Dropdown",
		Values = {
			{
				Title = "Category A",
				Icon = "bird"
			},
			{
				Title = "Category B",
				Icon = "house"
			},
			{
				Title = "Category C",
				Icon = "droplet"
			}
		},
		Value = "Category A",
		Callback = function(option)
			print("Category selected: " .. option.Title .. " with icon " .. option.Icon);
		end
	});
	ConfigElementsTab:Dropdown({
		Flag = "DropdownTest2",
		Title = "Advanced Dropdown 2",
		Values = {
			{
				Title = "Category A",
				Icon = "bird"
			},
			{
				Title = "Category B",
				Icon = "house"
			},
			{
				Title = "Category C",
				Icon = "droplet",
				Locked = true
			}
		},
		Value = "Category A",
		Multi = true,
		Callback = function(options)
			local titles = {};
			for _, v in ipairs(options) do
				table.insert(titles, v.Title);
			end;
			print("Selected: " .. table.concat(titles, ", "));
		end
	});
	ConfigElementsTab:Space();
	ConfigElementsTab:Input({
		Flag = "InputTest",
		Title = "Input",
		Desc = "Input Description",
		Value = "Default value",
		InputIcon = "bird",
		Type = "Input",
		Placeholder = "Enter text...",
		Callback = function(input)
			print("Text entered: " .. input);
		end
	});
	ConfigElementsTab:Space();
	ConfigElementsTab:Keybind({
		Flag = "KeybindTest",
		Title = "Keybind",
		Desc = "Keybind to open ui",
		Value = "G",
		Callback = function(v)
			Window:SetToggleKey(Enum.KeyCode[v]);
		end
	});
	ConfigElementsTab:Space();
	ConfigElementsTab:Slider({
		Flag = "SliderTest",
		Title = "Slider",
		Step = 1,
		Value = {
			Min = 20,
			Max = 120,
			Default = 70
		},
		Callback = function(value)
			print(value);
		end
	});
	ConfigElementsTab:Space();
	ConfigElementsTab:Toggle({
		Flag = "ToggleTest",
		Title = "Toggle",
		Desc = "Toggle Description",
		Default = false,
		Callback = function(state)
			print("Toggle Activated" .. tostring(state));
		end
	});
end;
do
	local ConfigTab = ConfigUsageSection:Tab({
		Title = "Config Usage",
		Icon = "folder"
	});
	local ConfigManager = Window.ConfigManager;
	local ConfigName = "default";
	local ConfigNameInput = ConfigTab:Input({
		Title = "Config Name",
		Icon = "file-cog",
		Callback = function(value)
			ConfigName = value;
		end
	});
	ConfigTab:Space();
	local AutoLoadToggle = ConfigTab:Toggle({
		Title = "Enable Auto Load to Selected Config",
		Value = false,
		Callback = function(v)
			Window.CurrentConfig:SetAutoLoad(v);
		end
	});
	ConfigTab:Space();
	local AllConfigs = ConfigManager:AllConfigs();
	local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil;
	local AllConfigsDropdown = ConfigTab:Dropdown({
		Title = "All Configs",
		Desc = "Select existing configs",
		Values = AllConfigs,
		Value = DefaultValue,
		Callback = function(value)
			ConfigName = value;
			ConfigNameInput:Set(value);
			AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false);
		end
	});
	ConfigTab:Space();
	ConfigTab:Button({
		Title = "Save Config",
		Icon = "",
		Justify = "Center",
		Callback = function()
			Window.CurrentConfig = ConfigManager:Config(ConfigName);
			if Window.CurrentConfig:Save() then
				ANUI:Notify({
					Title = "Config Saved",
					Desc = "Config '" .. ConfigName .. "' saved",
					Icon = "check"
				});
			end;
			AllConfigsDropdown:Refresh(ConfigManager:AllConfigs());
		end
	});
	ConfigTab:Space();
	ConfigTab:Button({
		Title = "Load Config",
		Icon = "",
		Justify = "Center",
		Callback = function()
			Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName);
			if Window.CurrentConfig:Load() then
				ANUI:Notify({
					Title = "Config Loaded",
					Desc = "Config '" .. ConfigName .. "' loaded",
					Icon = "refresh-cw"
				});
			end;
		end
	});
	ConfigTab:Space();
	ConfigTab:Button({
		Title = "Print AutoLoad Configs",
		Icon = "",
		Justify = "Center",
		Callback = function()
			print(HttpService:JSONDecode(ConfigManager:GetAutoLoadConfigs()));
		end
	});
end;
do
	local InviteCode = "cy6uMRmeZ";
	local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true";
	local Response = (ANUI.cloneref(game:GetService("HttpService"))):JSONDecode((ANUI.Creator.Request({
		Url = DiscordAPI,
		Method = "GET",
		Headers = {
			["User-Agent"] = "ANUI/Example",
			Accept = "application/json"
		}
	})).Body);
	local DiscordTab = OtherSection:Tab({
		Title = "Discord"
	});
	if Response and Response.guild then
		DiscordTab:Section({
			Title = "Join our Discord server!",
			TextSize = 20
		});
		local DiscordServerParagraph = DiscordTab:Paragraph({
			Title = tostring(Response.guild.name),
			Desc = tostring("Members: " .. Response.approximate_member_count .. "\nOnline: " .. Response.approximate_presence_count),
			Image = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024",
			Thumbnail = "https://cdn.discordapp.com/banners/1300692552005189632/35981388401406a4b7dffd6f447a64c4.png?size=512",
			ImageSize = 48,
			Buttons = {
				{
					Title = "Copy link",
					Icon = "link",
					Callback = function()
						setclipboard("https://discord.gg/" .. InviteCode);
					end
				}
			}
		});
	end;
end;
local UpgradeTab = Window:Tab({
    Title = "Upgrade System",
    Icon = "hammer"
})

-- 1. Buat SATU Section Utama
-- local MainSection = UpgradeTab:Section({
--     Title = "Stats Upgrade Manager",
--     TextSize = 18
-- })

-- ============================================================================
-- LOGIC PENGATURAN ELEMEN
-- ============================================================================

-- Tabel untuk menyimpan elemen berdasarkan kategorinya
local Categories = {
    Yen = {},
    Token = {},
    Rank = {},
    Trainer = {},
    Mastery = {},
    Settings = {},
    Extra1 = {},
    Extra2 = {},
    Extra3 = {},
    Extra4 = {},
    Extra5 = {},
    Extra6 = {},
}

-- Fungsi Helper: Mendapatkan frame utama dari elemen
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    
    -- Coba cari property yang menyimpan object Element (seperti ParagraphFrame, ToggleFrame, dll)
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
    
    return nil
end

-- Fungsi Helper: Membuat elemen dan otomatis memasukkannya ke tabel kategori
-- (Ini supaya kita tidak perlu manual set Visible satu-satu)
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        
        -- Sembunyikan elemen saat pertama dibuat (default hidden)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- Fungsi Callback: Dipanggil saat tombol kategori dipencet
local function OnCategoryChanged(selectedCategory)
    for catName, elements in pairs(Categories) do
        -- Jika nama kategori cocok, set Visible = true, jika tidak false
        local isVisible = (catName == selectedCategory)
        
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end

-- ============================================================================
-- 1. TOMBOL KATEGORI (HORIZONTAL SCROLL)
-- ============================================================================

UpgradeTab:Category({
    Title = "Select Category",
    Default = "Yen", -- Kategori awal yang aktif
    Options = {
        {Title="Yen", Icon="coins"},
        {Title="Token", Icon="layers"},
        {Title="Rank", Icon="shield"},
        {Title="Trainer", Icon="sword"},
        {Title="Mastery", Icon="book"},
        {Title="Settings", Icon="settings"},
        {Title="Extra1", Icon="circle"},
        {Title="Extra2", Icon="circle"},
        {Title="Extra3", Icon="circle"},
        {Title="Extra4", Icon="circle"},
        {Title="Extra5", Icon="circle"},
        {Title="Extra6", Icon="circle"},
    },
    Callback = OnCategoryChanged -- Panggil fungsi update saat diklik
})

-- Spacer agar tidak terlalu mepet dengan tombol kategori
UpgradeTab:Space({Columns=1})

-- ============================================================================
-- 2. ISI KONTEN (SEMUA DALAM PARAGRAF PER KATEGORI)
-- ============================================================================

-- [KATEGORI: YEN]
local YenGroup = AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen currency" }))
YenGroup:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
YenGroup:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
YenGroup:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 500 Yen | x1.5 Yen" })

-- [KATEGORI: TOKEN]
local TokenGroup = AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
TokenGroup:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
TokenGroup:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
TokenGroup:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 500 Yen | x1.5 Yen" })

-- [KATEGORI: RANK]
local RankGroup = AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class\nPower: 500,000" }))
RankGroup:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })

-- [KATEGORI: TRAINER]
local TrainerGroup = AddElement("Trainer", UpgradeTab:Paragraph({ Title = "Trainer Manager", Desc = "Select and train with masters" }))
TrainerGroup:Dropdown({ Title = "Select Trainer", Values = {"Gojo", "Makima", "Yoriichi"}, Value = "Gojo" })
TrainerGroup:Button({ Title = "Train Now", Icon = "sword" })

-- [KATEGORI: MASTERY]
local MasteryGroup = AddElement("Mastery", UpgradeTab:Paragraph({ Title = "Mastery Skills", Desc = "Train your weapon mastery" }))
MasteryGroup:Slider({ Title = "Sword Mastery", Min = 0, Max = 100, Default = 25 })
MasteryGroup:Slider({ Title = "Magic Mastery", Min = 0, Max = 100, Default = 0 })

-- [KATEGORI: SETTINGS]
local SettingsGroup = AddElement("Settings", UpgradeTab:Paragraph({ Title = "Game Settings", Desc = "Manage automation" }))
SettingsGroup:Toggle({ Title = "Auto Farm", Value = false })
SettingsGroup:Toggle({ Title = "Auto Rank Up", Value = false })

-- [KATEGORI: EXTRAS (TESTING SCROLL)]
for i = 1, 6 do
    local catName = "Extra" .. i
    local ExtraGroup = AddElement(catName, UpgradeTab:Paragraph({ Title = catName .. " Content", Desc = "This is content for " .. catName }))
    ExtraGroup:Button({ Title = "Action " .. i, Icon = "zap" })
end


-- ============================================================================
-- 3. INISIALISASI
-- ============================================================================

-- Panggil sekali secara manual agar kategori default ("Yen") muncul saat script jalan
OnCategoryChanged("Yen")

Window:SelectTab(UpgradeTab.Index)
