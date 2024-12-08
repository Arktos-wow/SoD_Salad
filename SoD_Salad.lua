local dotPos = {
	[1] = {1, 98}, --melee        		-- 
	[2] = {-32, 131}, --healer    		-|
	[3] = {-20, 170}, --ranged    		-|Group 1 
	[4] = {22, 171}, --ranged     		-|
	[5] = {34, 132}, --healer/ranged    --
	[6] = {67, 71}, -- melee      		--
	[7] = {69, 118}, --healer     		-|
	[8] = {105, 137}, --ranged    		-|Group 2
	[9] = {134, 107}, --ranged    		-|
	[10] = {115, 70}, --healer/ranged   --
	[11] = {-66, 69}, -- melee    		--
	[12] = {-113, 69}, --healer   		-|
	[13] = {-132, 106}, --ranged  		-|Group 3
	[14] = {-66, 116}, --ranged   		-|
	[15] = {-103, 135}, --healer/ranged --
	[16] = {97, 4}, -- melee      		--
	[17] = {130, 37}, --healer    		-|
	[18] = {169, 24}, --ranged    		-|Group 4
	[19] = {170, -17}, --ranged   		-|
	[20] = {130, -30}, --healer/ranged  --
	[21] = {-93, 2}, -- melee     		--
	[22] = {-126, -31}, --healer  		-|
	[23] = {-166, -19}, --ranged  		-|Group 5
	[24] = {-166, 22}, --ranged   		-|
	[25] = {-127, 35}, --healer/ranged  --
	[26] = {69, -64}, -- melee    		--
	[27] = {117, -64}, --healer   		-|
	[28] = {135, -100}, --ranged  		-|Group 6
	[29] = {107, -129}, --ranged  		-|
	[30] = {70, -110}, --healer/ranged  --
	[31] = {-65, -65}, -- melee   		--
	[32] = {-65, -112}, --healer  		-|
	[33] = {-101, -131}, --ranged 		-|Group 7
	[34] = {-130, -102}, --ranged 		-|
	[35] = {-112, -66}, --healer/ranged --
	[36] = {3, -92}, -- melee     		--
	[37] = {36, -126}, --healer   		-|
	[38] = {24, -165}, --ranged   		-|Group 8
	[39] = {-18, -165}, --ranged  		-|
	[40] = {-30, -126} --healer/ranged  --
}

local classColors = {
	["warrior"] = {0.68, 0.51, 0.33},
	["rogue"] = {1.0, 0.96, 0.31},
	["mage"] = {0.21, 0.60, 0.74},
	["warlock"] = {0.48, 0.41, 0.69},
	["hunter"] = {0.47, 0.73, 0.25},
	["priest"] = {1.0, 1.00, 1.00},
	["paladin"] = {0.96, 0.55, 0.73},
	["druid"] = {1.0, 0.49, 0.04},
	["shaman"] = {0.0, 0.34, 0.77}
}

-- Player name
local Salad_PlayerName, _ = UnitName("player")

-- Backdrop configuration for frame
local backdrop = {
    bgFile = "Interface\\AddOns\\SoD_Salad\\Images\\CThun_Positioning.tga", -- Updated for SoD
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = false,
    edgeSize = 32,
    insets = { left = 12, right = 12, top = 12, bottom = 12 },
}

-- Frame creation
local frame = CreateFrame("Frame", "CthunRoom", UIParent, BackdropTemplateMixin and "BackdropTemplate")
frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetSize(534, 534) -- Width and height set in one call
frame:SetPoint("CENTER")
frame:SetBackdrop(backdrop)
frame:SetAlpha(1.0)
frame:SetUserPlaced(true)
frame:SetFrameStrata("HIGH")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", function()
	fillGrid()

-- Slider for opacity
local Salad_Slider = CreateFrame("Slider", "MySlider1", frame, "OptionsSliderTemplate")
Salad_Slider:SetPoint("BOTTOM", frame, "BOTTOMRIGHT", -80, 20)
Salad_Slider:SetMinMaxValues(0.05, 1.00)
Salad_Slider:SetValue(1.00)
Salad_Slider:SetValueStep(0.05)
getglobal(Salad_Slider:GetName() .. 'Low'):SetText('5%')
getglobal(Salad_Slider:GetName() .. 'High'):SetText('100%')
getglobal(Salad_Slider:GetName() .. 'Text'):SetText('Opacity')
Salad_Slider:SetScript("OnValueChanged", function(self)
    local value = self:GetValue()
    frame:SetAlpha(value)
end)

-- Header and drag functionality
local Salad_Header = CreateFrame("Frame", "Salad_Header", frame, BackdropTemplateMixin and "BackdropTemplate")
Salad_Header:SetPoint("TOP", frame, "TOP", 0, 12)
Salad_Header:SetSize(256, 64)
Salad_Header:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Header",
})

local Salad_Fontstring = Salad_Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Salad_Fontstring:SetPoint("CENTER", Salad_Header, "CENTER", 0, 12)
Salad_Fontstring:SetText("SoD Salad")

-- Drag functionality
local drag = CreateFrame("Frame", nil, frame)
drag:SetSize(256, 64)
drag:SetPoint("TOP", frame, "TOP", 0, 12)
drag:EnableMouse(true)
drag:SetScript("OnMouseDown", function()
    frame:StartMoving()
end)
drag:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
end)

-- Close button
local button = CreateFrame("Button", "CloseButton", frame)
button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
button:SetSize(32, 32)
button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
button:SetScript("OnClick", function()
    frame:Hide()
end)

--Create dot frames
for i=1,40 do
	dot = CreateFrame("Button", "Dot_"..i, frame)
	dot:SetPoint("CENTER", frame, "CENTER", dotPos[i][1], dotPos[i][2])
	dot:EnableMouse(true)
	dot:SetFrameLevel(dot:GetFrameLevel()+3)
	tooltip = CreateFrame("GameTooltip", "Tooltip_"..i, nil, "GameTooltipTemplate")
	local texdot = dot:CreateTexture("Texture_"..i, "OVERLAY")
	dot.texture = texdot
	texdot:SetAllPoints(dot)
	texdot:SetTexture("Interface\\AddOns\\Salad_Cthun\\Images\\playerdot.tga")
	texdot:Hide()
	dot:SetScript("OnEnter", function()
		tooltip:SetOwner(dot, "ANCHOR_RIGHT")
		tooltip:SetText("Empty")
		tooltip:Show()
	end)
	dot:SetScript("OnLeave", function()
		tooltip:Hide()
	end)
end

function newDot(dot, tooltip, texture, name, class)
	if (Salad_PlayerName == name) then
		dot:SetWidth(36)
		dot:SetHeight(36)
	else
		dot:SetWidth(20)
		dot:SetHeight(20)
	end
	
	if name ~= "Empty" then
		texture:SetVertexColor(classColors[class][1], classColors[class][2], classColors[class][3], 1.0)
		texture:Show()
	else
		texture:Hide()
	end

	dot:SetScript("OnEnter", function()
		tooltip:SetOwner(dot, "ANCHOR_RIGHT")
		tooltip:SetText(name)
		tooltip:Show()
	end)

	dot:SetScript("OnLeave", function()
		tooltip:Hide()
	end)
end

local dotRes = {{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 1
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 2
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}} -- group 8

function getRaidInfo()
	for i=1,40 do
		local name,_,subgroup,_,class = GetRaidRosterInfo(i);

		if (class == "Rogue" or class == "Warrior") then
			if dotRes[subgroup][1][1] == "Empty" or dotRes[subgroup][1][1] == name then
				dotRes[subgroup][1] = {name, class}
			elseif dotRes[subgroup][5][1] == "Empty" or dotRes[subgroup][5][1] == name then
				dotRes[subgroup][5] = {name, class}
			elseif dotRes[subgroup][2][1] == "Empty" or dotRes[subgroup][2][1] == name then
				dotRes[subgroup][2] = {name, class}
			elseif dotRes[subgroup][3][1] == "Empty" or dotRes[subgroup][3][1] == name then
				dotRes[subgroup][3] = {name, class}
			else
				dotRes[subgroup][4] = {name, class}
			end
		elseif (class == "Mage" or class == "Warlock" or class == "Hunter") then
			if dotRes[subgroup][3][1] == "Empty" or dotRes[subgroup][3][1] == name then
				dotRes[subgroup][3] = {name, class}
			elseif dotRes[subgroup][4][1] == "Empty" or dotRes[subgroup][4][1] == name then
				dotRes[subgroup][4] = {name, class}
			elseif dotRes[subgroup][5][1] == "Empty" or dotRes[subgroup][5][1] == name then
				dotRes[subgroup][5] = {name, class}
			elseif dotRes[subgroup][2][1] == "Empty" or dotRes[subgroup][2][1] == name then
				dotRes[subgroup][2] = {name, class}
			else 
				dotRes[subgroup][1] = {name, class}
			end
		elseif (class == "Priest" or class == "Paladin" or class == "Druid" or class == "Shaman") then
			if dotRes[subgroup][2][1] == "Empty" or dotRes[subgroup][2][1] == name then
				dotRes[subgroup][2] = {name, class}
			elseif dotRes[subgroup][5][1] == "Empty" or dotRes[subgroup][5][1] == name then
				dotRes[subgroup][5] = {name, class}
			elseif dotRes[subgroup][3][1] == "Empty" or dotRes[subgroup][3][1] == name then
				dotRes[subgroup][3] = {name, class}
			elseif dotRes[subgroup][4][1] == "Empty" or dotRes[subgroup][4][1] == name then
				dotRes[subgroup][4] = {name, class}
			else
				dotRes[subgroup][1] = {name, class}
			end
		end
	end
end


-- Fill grid logic (Updated to handle SoD changes dynamically)
function fillGrid()
    wipeReserves()
    getRaidInfo()
    for i = 1, 8 do
        for j = 1, 5 do
            local index = (i - 1) * 5 + j
            local dot = _G["Dot_" .. index]
            local texture = _G["Texture_" .. index]
            local name, class = dotRes[i][j][1], dotRes[i][j][2]
            if name and class then
                newDot(dot, texture, name, strlower(class))
            end
        end
    end
end

-- Wipe reserve table
function wipeReserves()
    for i = 1, 8 do
        for j = 1, 5 do
            dotRes[i][j] = { "Empty", "Empty" }
        end
    end
end

-- Slash commands
SLASH_SALAD1 = "/sdc"
SlashCmdList.SALAD = function(msg)
    if msg == "show" then
        frame:Show()
        fillGrid()
    elseif msg == "hide" then
        frame:Hide()
    else
        print("|cffffff00Commands: /sdc show, /sdc hide")
    end
end
