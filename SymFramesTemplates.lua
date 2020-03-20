--[[
    SymFramesTemplates.lua
--]]

local function Bound(value, lower, upper)
    return math.min(upper, math.max(lower, value))
end

function SymFrames_SliderValueChanged(self, value)
    if (self:IsEnabled()) then
        local parent = self:GetParent()
        parent.editbox:SetText(tostring(math.floor(value)))
    end
end

function SymFrames_EditBoxEnterPressed(self)
    if (self:IsEnabled()) then
        local parent = self:GetParent()

        local newval = tonumber(self:GetText())
        local lower, upper = parent.slider:GetMinMaxValues()
        newval = Bound(newval, lower, upper)

        parent.slider:SetValue(tostring(math.floor(newval)))
    end
end

function SymFrames_EditBoxEscPressed(self)
    local parent = self:GetParent()
    self:SetText(tostring(math.floor(parent.slider:GetValue())))
    self:ClearFocus()
end

function SymFrames_LButtonPostClick(self, button, down)
    if (self:IsEnabled()) then
        local parent = self:GetParent()
        local currentval = tonumber(parent.slider:GetValue())
        parent.slider:SetValue(tostring(currentval - 1))
    end
end

function SymFrames_RButtonPostClick(self, button, down)
    if (self:IsEnabled()) then
        local parent = self:GetParent()
        local currentval = tonumber(parent.slider:GetValue())
        parent.slider:SetValue(tostring(currentval + 1))
    end
end

function SymFrames_LButtonDown(self, button)
	if ( self:IsEnabled() ) then
      self.BG:SetTexture("Interface\\Buttons\\UI-MinusButton-Down")
	end
end

function SymFrames_LButtonUp(self, button)
	if ( self:IsEnabled() ) then
      self.BG:SetTexture("Interface\\Buttons\\UI-MinusButton-Up")
	end
end

function SymFrames_RButtonDown(self, button)
    if ( self:IsEnabled() ) then
        self.BG:SetTexture("Interface\\Buttons\\UI-PlusButton-Down")
    end
end

function SymFrames_RButtonUp(self, button)
    if ( self:IsEnabled() ) then
        self.BG:SetTexture("Interface\\Buttons\\UI-PlusButton-Up")
    end
end
