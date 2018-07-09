local _, GW = ...
local CharacterMenuButton_OnLoad = GW.CharacterMenuButton_OnLoad
local CharacterMenuButtonBack_OnLoad = GW.CharacterMenuButtonBack_OnLoad
local Debug = GW.Debug

--local CHARACTER_PANEL_OPEN

local fmMenu

local function characterPanelToggle(frame)
    fmMenu:Hide()
    GwPaperDollBagItemList:Hide()
    GwPaperDollOutfits:Hide()
    GwPaperTitles:Hide()

    if frame == nil then
        GwDressingRoom:Hide()
        return
    end

    frame:Show()
    GwDressingRoom:Show()
end

local function toggleCharacter(tab, onlyShow)
    -- TODO: update bag frame to a secure stack, or at least the currency icon
    if InCombatLockdown() then
        return
    end

    if tab == "ReputationFrame" then
        if not onlyShow then
            GwCharacterWindow:SetAttribute("keytoggle", true)
        end
        GwCharacterWindow:SetAttribute("windowpanelopen", "reputation")
    elseif tab == "TokenFrame" then
        if not onlyShow then
            GwCharacterWindow:SetAttribute("keytoggle", true)
        end
        GwCharacterWindow:SetAttribute("windowpanelopen", "currency")
    else
        -- PaperDollFrame or any other value
        if not onlyShow then
            GwCharacterWindow:SetAttribute("keytoggle", true)
        end
        GwCharacterWindow:SetAttribute("windowpanelopen", "character")
    end
end

local function back_OnClick(self, button)
    characterPanelToggle(fmMenu)
end
--GW.PDButtonBack_OnClick = PDButtonBack_OnClick

local function menuItem_OnClick(self, button)
    characterPanelToggle(self.ToggleMe)
end

local function menu_SetupBackButton(self, fmBtn, key)
    fmBtn:SetText(GwLocalization[key])
    CharacterMenuButtonBack_OnLoad(fmBtn)
    fmBtn:SetScript("OnClick", back_OnClick)
end

local function LoadPaperDoll(tabContainer)
    --local fmPD = CreateFrame("Frame", "GwPaperDoll", tabContainer, "GwPaperDoll")
    GwPaperDoll = tabContainer
    local fmDoll = tabContainer

    fmMenu = CreateFrame("Frame", nil, tabContainer, "GwCharacterMenu")
    fmMenu.SetupBackButton = menu_SetupBackButton

    GW.LoadPDBagList(fmMenu)
    GW.LoadPDEquipset(fmMenu)
    GW.LoadPDTitles(fmMenu)

    fmMenu.equipmentMenu = CreateFrame("Button", nil, fmMenu, "GwCharacterMenuButtonTemplate")
    fmMenu.equipmentMenu.ToggleMe = GwPaperDollBagItemList
    fmMenu.equipmentMenu:SetScript("OnClick", menuItem_OnClick)
    fmMenu.equipmentMenu:SetText(GwLocalization["CHARACTER_MENU_EQUIPMENT"])
    fmMenu.equipmentMenu:ClearAllPoints()
    fmMenu.equipmentMenu:SetPoint("TOPLEFT", fmMenu, "TOPLEFT")

    fmMenu.outfitsMenu = CreateFrame("Button", nil, fmMenu, "GwCharacterMenuButtonTemplate")
    fmMenu.outfitsMenu.ToggleMe = GwPaperDollOutfits
    fmMenu.outfitsMenu:SetScript("OnClick", menuItem_OnClick)
    fmMenu.outfitsMenu:SetText(GwLocalization["CHARACTER_MENU_OUTFITS"])
    fmMenu.outfitsMenu:ClearAllPoints()
    fmMenu.outfitsMenu:SetPoint("TOPLEFT", fmMenu.equipmentMenu, "BOTTOMLEFT")

    fmMenu.titlesMenu = CreateFrame("Button", nil, fmMenu, "GwCharacterMenuButtonTemplate")
    fmMenu.titlesMenu.ToggleMe = GwPaperTitles
    fmMenu.titlesMenu:SetScript("OnClick", menuItem_OnClick)
    fmMenu.titlesMenu:SetText(GwLocalization["CHARACTER_MENU_TITLES"])
    fmMenu.titlesMenu:ClearAllPoints()
    fmMenu.titlesMenu:SetPoint("TOPLEFT", fmMenu.outfitsMenu, "BOTTOMLEFT")

    CharacterMenuButton_OnLoad(fmMenu.equipmentMenu, false)
    CharacterMenuButton_OnLoad(fmMenu.outfitsMenu, true)
    CharacterMenuButton_OnLoad(fmMenu.titlesMenu, false)

    CharacterFrame:SetScript(
        "OnShow",
        function()
            HideUIPanel(CharacterFrame)
        end
    )

    CharacterFrame:UnregisterAllEvents()

    hooksecurefunc("ToggleCharacter", toggleCharacter)
end
GW.LoadPaperDoll = LoadPaperDoll