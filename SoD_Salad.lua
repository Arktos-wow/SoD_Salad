-- Constants for dot positions
local dotPos = {
    -- Grouped and updated for clarity
    [1] = {1, 98}, -- Melee
    [2] = {-32, 131}, -- Healer
    [3] = {-20, 170}, -- Ranged
    [4] = {22, 171}, -- Ranged
    [5] = {34, 132}, -- Healer/Ranged
    -- Additional positions
    [6] = {67, 71}, -- Melee
    -- (Continue similar for other groups)
}

-- Updated class colors for better readability
local classColors = {
    warrior = {0.78, 0.61, 0.43},
    rogue = {1.0, 0.96, 0.41},
    mage = {0.25, 0.78, 0.92},
    warlock = {0.58, 0.51, 0.79},
    hunter = {0.67, 0.83, 0.45},
    priest = {1.0, 1.0, 1.0},
    paladin = {0.96, 0.55, 0.73},
    druid = {1.0, 0.49, 0.04},
    shaman = {0.0, 0.44, 0.87},
}

-- Player name
local Salad_PlayerName, _ = UnitName("player")

-- Backdrop configuration for frame
local backdrop = {
    bgFile = "Interface\\AddOns\\SoDCthun\\Images\\CThun_Positioning.tga", -- Updated for SoD
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

-- Register events
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", function()
    fillGrid()
end)
frame:Hide()

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
Salad_Fontstring:SetText("SoDCthun")

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

-- Tooltip creation
for i = 1, 40 do
    local dot = CreateFrame("Button", "Dot_" .. i, frame)
    dot:SetPoint("CENTER", frame, "CENTER", dotPos[i][1], dotPos[i][2])
    dot:SetSize(20, 20)
    local texdot = dot:CreateTexture("Texture_" .. i, "OVERLAY")
    texdot:SetAllPoints(dot)
    texdot:SetTexture("Interface\\AddOns\\SoDCthun\\Images\\playerdot.tga")
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
