--[[
    SymFrames.lua
--]]

SymFrames = {}
local symf = SymFrames

symf["spacing"] = 0 -- distance from edge of Player/TargetFrame to vertical axis
symf["xofs"]  = 0 -- x coordinate of vertical axis
symf["yofs"]  = 0 -- y offset along vertical axis

--[[ Reset frames to center of screen ]]
function symf:Reset()
    self.spacing = 0
    self.xofs = 0
    self.yofs = 0
    -- self.Update()
end

--[[ Updates the position of player and target plates]]
function symf:Update()
    PlayerFrame:ClearAllPoints()
    TargetFrame:ClearAllPoints()

    PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER",
                         symf.xofs - symf.spacing,
                         symf.yofs)
    TargetFrame:SetPoint("LEFT", UIParent, "CENTER",
                         symf.spacing + symf.xofs,
                         symf.yofs)
end

function SymFrames_Sync()
    symf.spacing_slider.slider:SetValue(symf.spacing)
    symf.xofs_slider.slider:SetValue(symf.xofs)
    symf.yofs_slider.slider:SetValue(symf.yofs)

    symf.spacing_slider.editbox:SetCursorPosition(0)
    symf.xofs_slider.editbox:SetCursorPosition(0)
    symf.yofs_slider.editbox:SetCursorPosition(0)
end

function SymFrames_LoadVars()
    if not SymFrames_vars or type(SymFrames_vars) ~= "table" then
        SymFrames_vars = {}
        SymFrames_SaveVars()
    end
    symf.spacing = SymFrames_vars["spacing"]
    symf.xofs = SymFrames_vars["xofs"]
    symf.yofs = SymFrames_vars["yofs"]

    -- print("loading vars ", symf.spacing, ", ", symf.xofs, ", ", symf.yofs)
end

function SymFrames_SaveVars()
    if not SymFrames_vars or type(SymFrames_vars) ~= "table" then
        SymFrames_vars = {}
    end
    SymFrames_vars["spacing"] = symf.spacing
    SymFrames_vars["xofs"] = symf.xofs
    SymFrames_vars["yofs"] = symf.yofs

    -- print("saving vars ", symf.spacing, ", ", symf.xofs, ", ", symf.yofs)
end

function SymFrames_SetupOptionsPanel(panel)
    --[[ Create Settings Menu ]]
    -- Create settings panel in interface options

    -- symf.settings_panel = CreateFrame("Frame", "settings_panel", UIParent, "SymFramesPanelTemplate")
    symf.settings_panel = panel

    symf.spacing_slider = CreateFrame("Frame", "spacing_slider", symf.settings_panel, "SymFramesSliderTemplate")
    symf.spacing_slider.title:SetText("Spacing")
    symf.spacing_slider.slider:SetScript("OnValueChanged",
                                         function(self, value)
                                             value = math.floor(value)
                                             SymFrames_SliderValueChanged(self, value)
                                             symf.spacing = value
                                             symf:Update()
                                         end
    )


    symf.xofs_slider = CreateFrame("Frame", "xofs_slider", symf.spacing_slider, "SymFramesSliderTemplate")
    symf.xofs_slider.title:SetText("X Offset")
    symf.xofs_slider.slider:SetScript("OnValueChanged",
                                      function(self, value)
                                          value = math.floor(value)
                                          SymFrames_SliderValueChanged(self, value)
                                          symf.xofs = value
                                          symf:Update()
                                      end
    )


    symf.yofs_slider = CreateFrame("Frame", "yofs_slider", symf.xofs_slider, "SymFramesSliderTemplate")
    symf.yofs_slider.title:SetText("Y Offset")
    symf.yofs_slider.slider:SetScript("OnValueChanged",
                                      function(self, value)
                                          value = math.floor(value)
                                          SymFrames_SliderValueChanged(self, value)
                                          symf.yofs = value
                                          symf:Update()
                                      end
    )
    symf.yofs_slider.slider:SetMinMaxValues(-400, 400)


    symf.xcenter_button = CreateFrame("Button", "xcenter_button", symf.yofs_slider, "SymFramesButtonTemplate")
    symf.xcenter_button:SetText("Center Vertical Axis")
    symf.xcenter_button:SetScript("PostClick",
                                  function(self, button, down)
                                      symf.xofs = 0
                                      SymFrames_Sync()
                                      symf:Update()
                                  end
    )


    symf.reset_button = CreateFrame("Button", "reset_button", symf.xcenter_button, "SymFramesButtonTemplate")
    symf.reset_button:SetText("Reset Position")
    symf.reset_button:SetScript("PostClick",
                                function(self, button, down)
                                    symf:Reset()
                                    SymFrames_Sync()
                                    symf:Update()
                                end
    )


    -- Load saved settings when available
    symf.settings_panel:RegisterEvent("PLAYER_ENTERING_WORLD")
    symf.settings_panel:SetScript("OnEvent",
                                  function(self, event)
                                      -- print("addon loaded")
                                      SymFrames_LoadVars()
                                      SymFrames_Sync()
                                      symf:Update()
                                      symf:goof_Noah()
                                  end
    )

    symf.spacing_slider.editbox:SetMaxLetters(4)
    symf.xofs_slider.editbox:SetMaxLetters(4)
    symf.yofs_slider.editbox:SetMaxLetters(4)

    symf.settings_panel.name = "SymFrames"
    symf.settings_panel.okay = function(self)
        SymFrames_SaveVars()
    end
    symf.settings_panel.cancel = function(self)
        SymFrames_LoadVars()
        SymFrames_Sync()
        symf:Update()
    end

    InterfaceOptions_AddCategory(symf.settings_panel)

end


CreateFrame("Frame", "settings_panel", UIParent, "SymFramesPanelTemplate")


--[[Goof: uncomment and insert a picture (data/goof.tga) to goof a friend]]
-- function symf:goof_Noah()
-- --    if (GetUnitName("player") == "Turbo") then
--     if (true) then
--         local portrait = PlayerFrame:CreateTexture("SymFrames_goof", "HIGHLIGHT")

--         portrait:SetSize(64, 64)
--         portrait:ClearAllPoints()
--         portrait:SetPoint("TOPLEFT", 42, -12)

--         portrait:SetTexture("Interface\\AddOns\\SymFrames\\data\\goof")
--         portrait:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
--     end
-- end

