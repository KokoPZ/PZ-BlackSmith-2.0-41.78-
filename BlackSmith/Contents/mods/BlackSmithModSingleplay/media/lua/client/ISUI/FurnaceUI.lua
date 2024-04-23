local Furnacefunction = require "Furnacefunction"
FurnaceUI = ISCollapsableWindow:derive("FurnaceUI");
FurnaceUI.instance = nil;
FurnaceUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
FurnaceUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
local posX = 0
local posY = 0

local removeBtn = Furnace.textures.RemoveButton;
local width = 600
local height = 310

function FurnaceUI:show(player,viewMode,furnace,CheckFurnace,x,y,z)
    self.CheckFurnace = CheckFurnace
    self.furnace = furnace
    self.checkx = x
    self.checky = y
    self.checkz = z
    sendClientCommand("FIvntS", "InputLastFurnaceID", {self.CheckFurnace})
    local FurnaceState = FIvnt.OutputSyncFurnace(self.CheckFurnace)
    local SelectMaterial = FIvnt.OutputSyncMaterial(self.CheckFurnace)
    local ActionInProgress = FIvnt.OutputSyncActionInProgress(self.CheckFurnace)
    local LastCheckTime = FIvnt.OutputSyncTime(self.CheckFurnace)
    local FurnaceTemp = FIvnt.OutputFurnaceTemp(self.CheckFurnace)
    local FurnaceTempState = FIvnt.OutputFurnaceTempState(self.CheckFurnace)
    local FurnaceOffTime = FIvnt.OutputFurnaceOffTime(self.CheckFurnace)
    self.FurnaceState = FurnaceState
    self.SelectMaterial = SelectMaterial
    self.ActionInProgress = ActionInProgress
    self.LastCheckTime = LastCheckTime
    self.FurnaceTemp = FurnaceTemp
    self.FurnaceTempState = FurnaceTempState
    self.FurnaceOffTime = FurnaceOffTime

    local square = player:getSquare()
    posX = square:getX()
    posY = square:getY()
    if FurnaceUI.instance==nil then
        FurnaceUI.instance = FurnaceUI:new (0, 0, width, height, player);
        FurnaceUI.instance.furnace = furnace
        FurnaceUI.instance:initialise();
        FurnaceUI.instance:instantiate();
    end
    FurnaceUI.instance.pinButton:setVisible(false)
    FurnaceUI.instance.collapseButton:setVisible(false)
    FurnaceUI.instance:addToUIManager();
    FurnaceUI.instance:setVisible(true);
    return FurnaceUI.instance;
end

function FurnaceUI:update()
    local player = self.player
    if player:DistTo(posX, posY) > 2 then
        self:close()
    end
    self.SmithingLevel = player:getPerkLevel(Perks.Smithing)
    local WorldAge = getGameTime():getWorldAgeHours()
    local FurnaceState = FIvnt.OutputSyncFurnace(self.CheckFurnace)
    local SelectMaterial = FIvnt.OutputSyncMaterial(self.CheckFurnace)
    local ActionInProgress = FIvnt.OutputSyncActionInProgress(self.CheckFurnace)
    local LastCheckTime = FIvnt.OutputSyncTime(self.CheckFurnace)
    local FurnaceTemp = FIvnt.OutputFurnaceTemp(self.CheckFurnace)
    local FurnaceTempState = FIvnt.OutputFurnaceTempState(self.CheckFurnace)
    local FurnaceOffTime = FIvnt.OutputFurnaceOffTime(self.CheckFurnace)
    self.FurnaceState = FurnaceState
    self.SelectMaterial = SelectMaterial
    self.ActionInProgress = ActionInProgress
    self.LastCheckTime = LastCheckTime
    self.FurnaceTemp = FurnaceTemp
    self.FurnaceTempState = FurnaceTempState
    self.FurnaceOffTime = FurnaceOffTime

    local Fuel, Material1, Material2, Material3, Material4, Material5 = FIvnt.getUserFIvnt(self.CheckFurnace)
    local FuelFormatted = Material.format(Fuel)
    self.IvntFuelLabel:setName(""..FuelFormatted)
    local Material1Formatted = Material.format(Material1)
    self.IvntMaterial1Label:setName(""..Material1Formatted)
    local Material2Formatted = Material.format(Material2)
    self.IvntMaterial2Label:setName(""..Material2Formatted)
    local Material3Formatted = Material.format(Material3)
    self.IvntMaterial3Label:setName(""..Material3Formatted)
    local Material4Formatted = Material.format(Material4)
    self.IvntMaterial4Label:setName(""..Material4Formatted)
    local Material5Formatted = Material.format(Material5)
    self.IvntMaterial5Label:setName(""..Material5Formatted)

    local MeltingFuel ,MeltingMaterial1, MeltingMaterial2, MeltingMaterial3, MeltingMaterial4, MeltingMaterial5 = FIvnt.getUserMelting(self.CheckFurnace)
    local MeltingFuelValue = Material.format(MeltingFuel)
    self.MeltingFuelLabel:setName(""..MeltingFuelValue)
    local MeltingMaterial1Value = Material.format(MeltingMaterial1)
    self.MeltingMaterial1Label:setName(""..MeltingMaterial1Value)
    local MeltingMaterial2Value = Material.format(MeltingMaterial2)
    self.MeltingMaterial2Label:setName(""..MeltingMaterial2Value)
    local MeltingMaterial3Value = Material.format(MeltingMaterial3)
    self.MeltingMaterial3Label:setName(""..MeltingMaterial3Value)
    local MeltingMaterial4Value = Material.format(MeltingMaterial4)
    self.MeltingMaterial4Label:setName(""..MeltingMaterial4Value)
    local MeltingMaterial5Value = Material.format(MeltingMaterial5)
    self.MeltingMaterial5Label:setName(""..MeltingMaterial5Value)

    local FurnaceTempFormatted = Material.format(FurnaceTemp)
    self.FurnaceTempValueLabel:setName(""..FurnaceTempFormatted.." "..FurnaceUIText.Temp)

    if self.SelectMaterial == "Fuel" then
        self:SelectFuelTextSet()
        self.SelectFuel = SandboxVars.Furnace.SelectFuel
        self.MeltingTempValueText:setName(""..SandboxVars.Furnace.FuelMeltingTemp.." "..FurnaceUIText.Temp)
    elseif self.SelectMaterial == "Material1" then
        self:SelectMaterial1TextSet()
        self.SelectFuel = SandboxVars.Furnace.SelectMaterial1
        self.MeltingTempValueText:setName(""..SandboxVars.Furnace.Material1MeltingTemp.." "..FurnaceUIText.Temp)
    elseif self.SelectMaterial == "Material2" then
        self:SelectMaterial2TextSet()
        self.SelectFuel = SandboxVars.Furnace.SelectMaterial2
        self.MeltingTempValueText:setName(""..SandboxVars.Furnace.Material2MeltingTemp.." "..FurnaceUIText.Temp)
    elseif self.SelectMaterial == "Material3" then
        self:SelectMaterial3TextSet()
        self.SelectFuel = SandboxVars.Furnace.SelectMaterial3
        self.MeltingTempValueText:setName(""..SandboxVars.Furnace.Material3MeltingTemp.." "..FurnaceUIText.Temp)
    elseif self.SelectMaterial == "Material4" then
        self:SelectMaterial4TextSet()
        self.SelectFuel = SandboxVars.Furnace.SelectMaterial4
        self.MeltingTempValueText:setName(""..SandboxVars.Furnace.Material4MeltingTemp.." "..FurnaceUIText.Temp)
    elseif self.SelectMaterial == "Material5" then
        self:SelectMaterial5TextSet()
        self.SelectFuel = SandboxVars.Furnace.SelectMaterial5
        self.MeltingTempValueText:setName(""..SandboxVars.Furnace.Material5MeltingTemp.." "..FurnaceUIText.Temp)
    else
        self:SelectNilTextSet()
        self.SelectFuel = 0
        self.MeltingTempValueText:setName("0".." "..FurnaceUIText.Temp)
    end
    local ReturnSmithingLevel = self.SmithingLevel
    if self.SmithingLevel == 0 then
        ReturnSmithingLevel = 1
    end
        
    self.GlobalTemp = math.ceil(getWorld():getGlobalTemperature()) + 10
    local RemoveFuel, RemoveMaterial1, RemoveMaterial2, RemoveMaterial3, RemoveMaterial4, RemoveMaterial5 = 0,0,0,0,0,0
    local ReturnFuel, ReturnMaterial1, ReturnMaterial2, ReturnMaterial3, ReturnMaterial4, ReturnMaterial5 = 0,0,0,0,0,0
    if self.FurnaceState then
        if self.FurnaceTempState == "StayTemp" then
            self:StayTempBtnSet()
        elseif self.FurnaceTempState == "Tempup" then
            self:TempupBtnSet()
        end
        local SatisfactionTime = WorldAge - self.LastCheckTime
        if SatisfactionTime >= 0.016667 then
            local MeltingTimeValue = math.floor(SatisfactionTime / 0.016667) 
            local FurnaceOnFuel = (SandboxVars.Furnace.FurnaceOnFuel + self.SelectFuel) * MeltingTimeValue
            if FurnaceOnFuel > Fuel then
                local TimeAmount = math.floor((SandboxVars.Furnace.FurnaceOnFuel + self.SelectFuel) / Fuel)
                local NofireTime = MeltingTimeValue - TimeAmount
                self.FurnaceTemp = self.FurnaceTemp - (NofireTime * SandboxVars.Furnace.TempdownRate)
                self.FurnaceOffTime = WorldAge
                self.FurnaceState = false
                self:ChangeSprite()
                sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, Fuel, 0, 0, 0, 0, 0})
                sendClientCommand("FIvntS", "InputFurnaceTemp", {self.CheckFurnace, self.FurnaceTemp})
                sendClientCommand("FIvntS", "InputSyncFurnace", {self.CheckFurnace, self.FurnaceState})
                sendClientCommand("FIvntS", "InputFurnaceOffTime", {self.CheckFurnace, self.FurnaceOffTime})
                sendClientCommand("FIvntS", "InputFurnaceTempState", {self.CheckFurnace, self.FurnaceTempState})
            else
                if self.FurnaceTempState == "Tempup" then
                    self.FurnaceTemp = self.FurnaceTemp + (SandboxVars.Furnace.TempupRate * MeltingTimeValue)
                    if self.FurnaceTemp >= 2000 then
                        self.FurnaceTemp = 2000
                        self.FurnaceTempState = "StayTemp"
                    end
                    sendClientCommand("FIvntS", "InputFurnaceTemp", {self.CheckFurnace, self.FurnaceTemp})
                    self.SelectFuel = self.SelectFuel + SandboxVars.Furnace.TempupFuel
                    sendClientCommand("FIvntS", "InputFurnaceTempState", {self.CheckFurnace, self.FurnaceTempState})
                end
                if self.SelectMaterial == "Fuel" then
                    local MeltingAmount = Furnacefunction.MeltingFuel(MeltingTimeValue, Fuel, Fuel, self.SelectFuel)
                    local MeltingTemp = SandboxVars.Furnace.FuelMeltingTemp
                    if MeltingTemp <= self.FurnaceTemp then
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel+MeltingAmount, 0, 0, 0, 0, 0})
                        MeltingAmount = Furnacefunction.Smithing(MeltingAmount, self.SmithingLevel, "Melting")
                        sendClientCommand("FIvntS", "MeltingInject", {self.CheckFurnace, MeltingAmount, 0, 0, 0, 0, 0})
                    else
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})
                    end
                elseif self.SelectMaterial == "Material1" then
                    local MeltingAmount = Furnacefunction.MeltingMaterial(MeltingTimeValue, Material1, Fuel, self.SelectFuel)
                    local MeltingTemp = SandboxVars.Furnace.Material1MeltingTemp
                    if MeltingTemp <= self.FurnaceTemp then
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, MeltingAmount, 0, 0, 0, 0})
                        MeltingAmount = Furnacefunction.Smithing(MeltingAmount, self.SmithingLevel, "Melting")
                        sendClientCommand("FIvntS", "MeltingInject", {self.CheckFurnace, 0, MeltingAmount, 0, 0, 0, 0})
                    else
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})
                    end
                elseif self.SelectMaterial == "Material2" then
                    local MeltingAmount = Furnacefunction.MeltingMaterial(MeltingTimeValue, Material2, Fuel, self.SelectFuel)
                    local MeltingTemp = SandboxVars.Furnace.Material2MeltingTemp
                    if MeltingTemp <= self.FurnaceTemp then
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, MeltingAmount, 0, 0, 0})
                        MeltingAmount = Furnacefunction.Smithing(MeltingAmount, self.SmithingLevel, "Melting")
                        sendClientCommand("FIvntS", "MeltingInject", {self.CheckFurnace, 0, 0, MeltingAmount, 0, 0, 0}) 
                    else
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})
                    end           
                elseif self.SelectMaterial == "Material3" then
                    local MeltingAmount = Furnacefunction.MeltingMaterial(MeltingTimeValue, Material3, Fuel, self.SelectFuel)
                    local MeltingTemp = SandboxVars.Furnace.Material3MeltingTemp
                    if MeltingTemp <= self.FurnaceTemp then
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, MeltingAmount, 0, 0})
                        MeltingAmount = Furnacefunction.Smithing(MeltingAmount, self.SmithingLevel, "Melting")
                        sendClientCommand("FIvntS", "MeltingInject", {self.CheckFurnace, 0, 0, 0, MeltingAmount, 0, 0})
                    else
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})
                    end
                elseif self.SelectMaterial == "Material4" then
                    local MeltingAmount = Furnacefunction.MeltingMaterial(MeltingTimeValue, Material4, Fuel, self.SelectFuel)
                    local MeltingTemp = SandboxVars.Furnace.Material4MeltingTemp
                    if MeltingTemp <= self.FurnaceTemp then
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, MeltingAmount, 0})
                        MeltingAmount = Furnacefunction.Smithing(MeltingAmount, self.SmithingLevel, "Melting")
                        sendClientCommand("FIvntS", "MeltingInject", {self.CheckFurnace, 0, 0, 0, 0, MeltingAmount, 0})
                    else
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})
                    end
                elseif self.SelectMaterial == "Material5" then
                    local MeltingAmount = Furnacefunction.MeltingMaterial(MeltingTimeValue, Material5, Fuel, self.SelectFuel)
                    local MeltingTemp = SandboxVars.Furnace.Material5MeltingTemp
                    if MeltingTemp <= self.FurnaceTemp then
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, MeltingAmount})
                        MeltingAmount = Furnacefunction.Smithing(MeltingAmount, self.SmithingLevel, "Melting")
                        sendClientCommand("FIvntS", "MeltingInject", {self.CheckFurnace, 0, 0, 0, 0, 0, MeltingAmount})  
                    else
                        sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})
                    end
                else
                    sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, FurnaceOnFuel, 0, 0, 0, 0, 0})        
                end
            end
            if not (MeltingFuel == 0) and self.FurnaceTemp <= SandboxVars.Furnace.FuelMeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.FuelMeltingTemp * MeltingFuel)
                RemoveFuel = math.ceil((MeltingFuel - MeltingTempValue) - ((MeltingFuel - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnFuel = math.ceil(RemoveFuel * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnFuel = math.ceil(RemoveFuel * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial1 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material1MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material1MeltingTemp * MeltingMaterial1)
                RemoveMaterial1 = math.ceil((MeltingMaterial1 - MeltingTempValue) - ((MeltingMaterial1 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial1 = math.ceil(RemoveMaterial1 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial1 = math.ceil(RemoveMaterial1 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial2 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material2MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material2MeltingTemp * MeltingMaterial2)
                RemoveMaterial2 = math.ceil((MeltingMaterial2 - MeltingTempValue) - ((MeltingMaterial2 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial2 = math.ceil(RemoveMaterial2 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial2 = math.ceil(RemoveMaterial2 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial3 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material3MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material3MeltingTemp * MeltingMaterial3)
                RemoveMaterial3 = math.ceil((MeltingMaterial3 - MeltingTempValue) - ((MeltingMaterial3 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial3 = math.ceil(RemoveMaterial3 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial3 = math.ceil(RemoveMaterial3 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial4 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material4MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material4MeltingTemp * MeltingMaterial4)
                RemoveMaterial4 = math.ceil((MeltingMaterial4 - MeltingTempValue) - ((MeltingMaterial4 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial4 = math.ceil(RemoveMaterial4 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial4 = math.ceil(RemoveMaterial4 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial5 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material5MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material5MeltingTemp * MeltingMaterial5)
                RemoveMaterial5 = math.ceil((MeltingMaterial5 - MeltingTempValue) - ((MeltingMaterial5 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial5 = math.ceil(RemoveMaterial5 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial5 = math.ceil(RemoveMaterial5 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if RemoveFuel > 0 or RemoveMaterial1 > 0 or RemoveMaterial2 > 0 or RemoveMaterial3 > 0 or RemoveMaterial4 > 0 or RemoveMaterial5 > 0 then
                sendClientCommand("FIvntS", "Make", {self.CheckFurnace,RemoveFuel,RemoveMaterial1,RemoveMaterial2,RemoveMaterial3,RemoveMaterial4,RemoveMaterial5})
                sendClientCommand("FIvntS", "Inject", {self.CheckFurnace,ReturnFuel,ReturnMaterial1,ReturnMaterial2,ReturnMaterial3,ReturnMaterial4,ReturnMaterial5})
            end
            self.LastCheckTime = WorldAge
            sendClientCommand("FIvntS", "InputSyncTime", {self.CheckFurnace,self.LastCheckTime})
        end
    elseif not self.FurnaceState then
        local FurnaceOffSatisfactionTime = WorldAge - self.FurnaceOffTime
        if self.FurnaceTemp <= self.GlobalTemp then
            self.FurnaceTemp = self.GlobalTemp
            self.FurnaceTempState = "Nofire"
            sendClientCommand("FIvntS", "InputFurnaceTemp", {self.CheckFurnace, self.FurnaceTemp})
            self.FurnaceTempStateNofireLabel:setVisible(true)
            self.FurnaceTempStateFireLabel:setVisible(false)
            self.FurnaceTempStateTempupLabel:setVisible(false)
            self.FurnaceTempStateTempdownLabel:setVisible(false)
            self.FurnaceTempStateTempUseBellowsLabel:setVisible(false)
        elseif self.FurnaceTemp > self.GlobalTemp then
            self.FurnaceTempStateNofireLabel:setVisible(false)
            self.FurnaceTempStateFireLabel:setVisible(false)
            self.FurnaceTempStateTempupLabel:setVisible(false)
            self.FurnaceTempStateTempdownLabel:setVisible(true)
            self.FurnaceTempStateTempUseBellowsLabel:setVisible(false)
            if FurnaceOffSatisfactionTime >= 0.016667 then
                local TempdownTimeValue = math.floor(FurnaceOffSatisfactionTime / 0.016667)
                local TempdownRate = SandboxVars.Furnace.TempdownRate
                self.FurnaceTemp = self.FurnaceTemp - (TempdownRate * TempdownTimeValue)
                self.FurnaceOffTime = WorldAge
                sendClientCommand("FIvntS", "InputFurnaceTemp", {self.CheckFurnace, self.FurnaceTemp})
                sendClientCommand("FIvntS", "InputFurnaceOffTime", {self.CheckFurnace, self.FurnaceOffTime})
            end
        end
        if FurnaceOffSatisfactionTime >= 0.016667 then
            if not (MeltingFuel == 0) and self.FurnaceTemp <= SandboxVars.Furnace.FuelMeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.FuelMeltingTemp * MeltingFuel)
                RemoveFuel = math.ceil((MeltingFuel - MeltingTempValue) - ((MeltingFuel - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnFuel = math.ceil(RemoveFuel * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnFuel = math.ceil(RemoveFuel * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial1 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material1MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material1MeltingTemp * MeltingMaterial1)
                RemoveMaterial1 = math.ceil((MeltingMaterial1 - MeltingTempValue) - ((MeltingMaterial1 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial1 = math.ceil(RemoveMaterial1 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial1 = math.ceil(RemoveMaterial1 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial2 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material2MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material2MeltingTemp * MeltingMaterial2)
                RemoveMaterial2 = math.ceil((MeltingMaterial2 - MeltingTempValue) - ((MeltingMaterial2 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial2 = math.ceil(RemoveMaterial2 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial2 = math.ceil(RemoveMaterial2 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial3 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material3MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material3MeltingTemp * MeltingMaterial3)
                RemoveMaterial3 = math.ceil((MeltingMaterial3 - MeltingTempValue) - ((MeltingMaterial3 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial3 = math.ceil(RemoveMaterial3 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial3 = math.ceil(RemoveMaterial3 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial4 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material4MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material4MeltingTemp * MeltingMaterial4)
                RemoveMaterial4 = math.ceil((MeltingMaterial4 - MeltingTempValue) - ((MeltingMaterial4 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial4 = math.ceil(RemoveMaterial4 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial4 = math.ceil(RemoveMaterial4 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if not (MeltingMaterial5 == 0) and self.FurnaceTemp <= SandboxVars.Furnace.Material5MeltingTemp then
                local MeltingTempValue = math.floor(self.FurnaceTemp / SandboxVars.Furnace.Material5MeltingTemp * MeltingMaterial5)
                RemoveMaterial5 = math.ceil((MeltingMaterial5 - MeltingTempValue) - ((MeltingMaterial5 - MeltingTempValue) * self.SmithingLevel / 100))
                -- ReturnMaterial5 = math.ceil(RemoveMaterial5 * ReturnSmithingLevel / 100 * SandboxVars.Furnace.MaterialReturnRate)
                ReturnMaterial5 = math.ceil(RemoveMaterial5 * ((SandboxVars.Furnace.MinimumReturnRate + (ReturnSmithingLevel * SandboxVars.Furnace.MaterialReturnRate)) / 100))
            end
            if RemoveFuel > 0 or RemoveMaterial1 > 0 or RemoveMaterial2 > 0 or RemoveMaterial3 > 0 or RemoveMaterial4 > 0 or RemoveMaterial5 > 0 then
                sendClientCommand("FIvntS", "Make", {self.CheckFurnace,RemoveFuel,RemoveMaterial1,RemoveMaterial2,RemoveMaterial3,RemoveMaterial4,RemoveMaterial5})
                sendClientCommand("FIvntS", "Inject", {self.CheckFurnace,ReturnFuel,ReturnMaterial1,ReturnMaterial2,ReturnMaterial3,ReturnMaterial4,ReturnMaterial5})
                self.FurnaceOffTime = WorldAge
                sendClientCommand("FIvntS", "InputFurnaceOffTime", {self.CheckFurnace, self.FurnaceOffTime})
            end
        end 
        self.UseBellowsButton.enable = false
        self.TempupButton.enable = false
        self.StayTempButton.enable = false
    end
    if self.SingActionInProgress then
        self.FurnaceOnButton.enable = false
        self.FurnaceOnButton:setVisible(false)
        self.FurnaceOffButton:setVisible(false)
        self.cancelFurnaceStartButton:setVisible(true)
        return    
    elseif self.ActionInProgress then 
        self.UseBellowsButton.enable = false
        self.FurnaceOnButton.enable = false
        self.FurnaceOffButton.enable = false
    elseif not self.FurnaceState and (Fuel >= SandboxVars.Furnace.StartFuel) then
        self:FurnaceOffBtnSet()
        self.FurnaceOnButton.enable = true
        self.cancelFurnaceStartButton:setVisible(false)
    elseif not self.FurnaceState and (Fuel < SandboxVars.Furnace.StartFuel) then
        self:FurnaceOffBtnSet()
        self.FurnaceOnButton.enable = false
        self.cancelFurnaceStartButton:setVisible(false)
    elseif self.FurnaceState then
        self:FurnaceOnBtnSet()
        self.cancelFurnaceStartButton:setVisible(false)
        if player:getInventory():FindAndReturn('Base.Bellows') then
            self.UseBellowsButton.enable = true
        else
            self.UseBellowsButton.enable = false
        end
    end
end

function FurnaceUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 20
    local y = 30

    FurnaceOnImg = Furnace.textures.FurnaceOn
    FurnaceOffImg = Furnace.textures.FurnaceOff
    FuelImg = Material.MaterialTexture.Fuel
    Material1Img = Material.MaterialTexture.Material1
    Material2Img = Material.MaterialTexture.Material2
    Material3Img = Material.MaterialTexture.Material3
    Material4Img = Material.MaterialTexture.Material4
    Material5Img = Material.MaterialTexture.Material5

    local TextureScaled = 160
    self.FurnaceOnTexture = ISImage:new(x-20, y-10, 0, 0, FurnaceOnImg.texture);
    self.FurnaceOnTexture.scaledWidth = TextureScaled
    self.FurnaceOnTexture.scaledHeight = TextureScaled
    self.FurnaceOnTexture:setVisible(false)
    self:addChild(self.FurnaceOnTexture);
    
    self.FurnaceOffTexture = ISImage:new(x-20, y-10, 0, 0, FurnaceOffImg.texture);
    self.FurnaceOffTexture.scaledWidth = TextureScaled
    self.FurnaceOffTexture.scaledHeight = TextureScaled
    self.FurnaceOffTexture:setVisible(true)
    self:addChild(self.FurnaceOffTexture);

    local buttonX = x+20
    local buttonY = y+165
    local buttonX2 = buttonX+130
    local buttonY2 = y+165
    local buttonYIncrement = 35
    self.FurnaceOnButton = ISButton:new(buttonX, buttonY, 100,25,FurnaceUIText.FurnaceOnBtn,self, FurnaceUI.FurnaceOnBtn);
    self.FurnaceOnButton:initialise()
    self.FurnaceOnButton.enable = false
    self.FurnaceOnButton:setVisible(true)
    self:addChild(self.FurnaceOnButton);

    self.FurnaceOffButton = ISButton:new(buttonX, buttonY, 100,25,FurnaceUIText.FurnaceOffBtn,self, FurnaceUI.FurnaceOffBtn);
    self.FurnaceOffButton:initialise()
    self.FurnaceOffButton:setVisible(false)
    self:addChild(self.FurnaceOffButton);

    self.cancelFurnaceStartButton = ISButton:new(buttonX, buttonY, 100,25,FurnaceUIText.Cancel,self, FurnaceUI.cancelFurnaceStartBtn);
    self.cancelFurnaceStartButton:initialise()
    self.cancelFurnaceStartButton:setVisible(false)
    self:addChild(self.cancelFurnaceStartButton);
    buttonY = buttonY + buttonYIncrement

    self.InjectButton = ISButton:new(buttonX, buttonY, 100,25,FurnaceUIText.InjectBtn,self, FurnaceUI.InjectBtn);
    self.InjectButton:initialise()
    self:addChild(self.InjectButton);
    buttonY = buttonY + buttonYIncrement

    self.SelectButton = ISButton:new(buttonX, buttonY, 100,25,FurnaceUIText.SelectBtn,self, FurnaceUI.SelectBtn);
    self.SelectButton:initialise()
    self:addChild(self.SelectButton);

    self.UseBellowsButton = ISButton:new(buttonX2, buttonY2, 100,25,FurnaceUIText.UseBellowsBtn,self, FurnaceUI.UseBellowsBtn);
    self.UseBellowsButton:initialise()
    self.UseBellowsButton.enable = false
    self.UseBellowsButton:setVisible(true)
    self:addChild(self.UseBellowsButton);

    self.CancelUseBellowsButton = ISButton:new(buttonX2, buttonY2, 100,25,FurnaceUIText.cancel,self, FurnaceUI.CancelUseBellowsBtn);
    self.CancelUseBellowsButton:initialise()
    self.CancelUseBellowsButton:setVisible(false)
    self:addChild(self.CancelUseBellowsButton);
    buttonY2 = buttonY2 + buttonYIncrement

    self.TempupButton = ISButton:new(buttonX2, buttonY2, 100,25,FurnaceUIText.TempupBtn,self, FurnaceUI.TempupBtn);
    self.TempupButton:initialise()
    self.TempupButton.enable = false
    self:addChild(self.TempupButton);
    buttonY2 = buttonY2 + buttonYIncrement

    self.StayTempButton = ISButton:new(buttonX2, buttonY2, 100,25,FurnaceUIText.StayTempBtn,self, FurnaceUI.StayTempBtn);
    self.StayTempButton:initialise()
    self.StayTempButton.enable = false
    self:addChild(self.StayTempButton);
    

    local LabelX = x+140
    local FurnaceStateTextY = y+10
    self.FurnaceStateLabel = ISLabel:new(LabelX, FurnaceStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceState, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceStateLabel:setVisible(true)
    self:addChild(self.FurnaceStateLabel);
    local textWidthFurnaceState = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.FurnaceState)
    local rightXFurnaceState = self.FurnaceStateLabel:getX() + textWidthFurnaceState

    self.FurnaceStateOnLabel = ISLabel:new(rightXFurnaceState+10, FurnaceStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceStateON, 1, 0, 0, 1, UIFont.Medium, true)
    self.FurnaceStateOnLabel:setVisible(false)
    self:addChild(self.FurnaceStateOnLabel);

    self.FurnaceStateOffLabel = ISLabel:new(rightXFurnaceState+10, FurnaceStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceStateOFF, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceStateOffLabel:setVisible(true)
    self:addChild(self.FurnaceStateOffLabel);
    
    local MaterialTextY = y+40
    self.SelectText = ISLabel:new(LabelX, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectText, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectText:setVisible(true)
    self:addChild(self.SelectText);
    local textWidthSelectText = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.SelectText)
    local rightXSelectText = self.SelectText:getX() + textWidthSelectText

    self.SelectNilText = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectNilText, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectNilText:setVisible(true)
    self:addChild(self.SelectNilText);

    self.SelectFuelText = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectFuelText, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectFuelText:setVisible(false)
    self:addChild(self.SelectFuelText);

    self.SelectMaterial1Text = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial1Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial1Text:setVisible(false)
    self:addChild(self.SelectMaterial1Text);

    self.SelectMaterial2Text = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial2Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial2Text:setVisible(false)
    self:addChild(self.SelectMaterial2Text);

    self.SelectMaterial3Text = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial3Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial3Text:setVisible(false)
    self:addChild(self.SelectMaterial3Text);

    self.SelectMaterial4Text = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial4Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial4Text:setVisible(false)
    self:addChild(self.SelectMaterial4Text);

    self.SelectMaterial5Text = ISLabel:new(rightXSelectText+10, MaterialTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial5Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial5Text:setVisible(false)
    self:addChild(self.SelectMaterial5Text);

    local FurnaceTempTextY = y+70
    self.FurnaceTempLabel = ISLabel:new(LabelX, FurnaceTempTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTemp, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempLabel:setVisible(true)
    self:addChild(self.FurnaceTempLabel);
    local textWidthFurnaceTemp = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.FurnaceTemp)
    local rightXFurnaceTemp = self.FurnaceTempLabel:getX() + textWidthFurnaceTemp

    self.FurnaceTempValueLabel = ISLabel:new(rightXFurnaceTemp+10, FurnaceTempTextY, FurnaceUI.MEDIUM_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempValueLabel:setVisible(true)
    self:addChild(self.FurnaceTempValueLabel);

    local FurnaceTempStateTextY = y+100
    self.FurnaceTempStateLabel = ISLabel:new(LabelX, FurnaceTempStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTempState, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempStateLabel:setVisible(true)
    self:addChild(self.FurnaceTempStateLabel);
    local textWidthFurnaceTempState = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.FurnaceTempState)
    local rightXFurnaceTempState = self.FurnaceTempStateLabel:getX() + textWidthFurnaceTempState

    self.FurnaceTempStateNofireLabel = ISLabel:new(rightXFurnaceTempState+10, FurnaceTempStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTempStateNofire, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempStateNofireLabel:setVisible(true)
    self:addChild(self.FurnaceTempStateNofireLabel);

    self.FurnaceTempStateFireLabel = ISLabel:new(rightXFurnaceTempState+10, FurnaceTempStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTempStateFire, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempStateFireLabel:setVisible(false)
    self:addChild(self.FurnaceTempStateFireLabel);

    self.FurnaceTempStateTempupLabel = ISLabel:new(rightXFurnaceTempState+10, FurnaceTempStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTempStateTempup, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempStateTempupLabel:setVisible(false)
    self:addChild(self.FurnaceTempStateTempupLabel);

    self.FurnaceTempStateTempdownLabel = ISLabel:new(rightXFurnaceTempState+10, FurnaceTempStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTempStateTempdown, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempStateTempdownLabel:setVisible(false)
    self:addChild(self.FurnaceTempStateTempdownLabel);

    self.FurnaceTempStateTempUseBellowsLabel = ISLabel:new(rightXFurnaceTempState+10, FurnaceTempStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceTempStateTempUseBellows, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceTempStateTempUseBellowsLabel:setVisible(false)
    self:addChild(self.FurnaceTempStateTempUseBellowsLabel);

    local MeltingTempTextY = y+130
    self.MeltingTempText = ISLabel:new(LabelX, MeltingTempTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.MeltingTempText, 1, 1, 1, 1, UIFont.Medium, true)
    self.MeltingTempText:setVisible(true)
    self:addChild(self.MeltingTempText);
    local textWidthMeltingTempText = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.MeltingTempText)
    local rightXMeltingTempText = self.MeltingTempText:getX() + textWidthMeltingTempText
    
    self.MeltingTempValueText = ISLabel:new(rightXMeltingTempText+10, MeltingTempTextY, FurnaceUI.MEDIUM_FONT_HGT, "0"..FurnaceUIText.Temp, 1, 1, 1, 1, UIFont.Medium, true)
    self.MeltingTempValueText:setVisible(true)
    self:addChild(self.MeltingTempValueText);

    local IvntX = x+350
    local IvntY = y+65
    local IvntYIncrementY = 30
    self.IvntLabel = ISLabel:new(IvntX+25, IvntY-30, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.Invt, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntLabel);

    self.IvntFuelTex = ISImage:new(IvntX, IvntY, 0, 0, FuelImg.texture);
    self.IvntFuelTex.scaledWidth = FuelImg.scale+5
    self.IvntFuelTex.scaledHeight = FuelImg.scale+5
    self:addChild(self.IvntFuelTex);

    self.IvntFuelLabel = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntFuelLabel);
    IvntY = IvntY + IvntYIncrementY

    self.IvntMaterial1Tex = ISImage:new(IvntX, IvntY, 0, 0, Material1Img.texture);
    self.IvntMaterial1Tex.scaledWidth = Material1Img.scale+5
    self.IvntMaterial1Tex.scaledHeight = Material1Img.scale+5
    self:addChild(self.IvntMaterial1Tex);

    self.IvntMaterial1Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial1Label);
    IvntY = IvntY + IvntYIncrementY

    self.IvntMaterial2Tex = ISImage:new(IvntX, IvntY, 0, 0, Material2Img.texture);
    self.IvntMaterial2Tex.scaledWidth = Material2Img.scale+5
    self.IvntMaterial2Tex.scaledHeight = Material2Img.scale+5
    self:addChild(self.IvntMaterial2Tex);

    self.IvntMaterial2Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial2Label);
    IvntY = IvntY + IvntYIncrementY

    self.IvntMaterial3Tex = ISImage:new(IvntX, IvntY, 0, 0, Material3Img.texture);
    self.IvntMaterial3Tex.scaledWidth = Material3Img.scale+5
    self.IvntMaterial3Tex.scaledHeight = Material3Img.scale+5
    self:addChild(self.IvntMaterial3Tex);

    self.IvntMaterial3Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial3Label);
    IvntY = IvntY + IvntYIncrementY

    self.IvntMaterial4Tex = ISImage:new(IvntX, IvntY, 0, 0, Material4Img.texture);
    self.IvntMaterial4Tex.scaledWidth = Material4Img.scale+5
    self.IvntMaterial4Tex.scaledHeight = Material4Img.scale+5
    self:addChild(self.IvntMaterial4Tex);

    self.IvntMaterial4Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial4Label);
    IvntY = IvntY + IvntYIncrementY

    self.IvntMaterial5Tex = ISImage:new(IvntX, IvntY, 0, 0, Material5Img.texture);
    self.IvntMaterial5Tex.scaledWidth = Material5Img.scale+5
    self.IvntMaterial5Tex.scaledHeight = Material5Img.scale+5
    self:addChild(self.IvntMaterial5Tex);

    self.IvntMaterial5Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial5Label);

    local MeltingX = IvntX+110
    local MeltingY = y+65
    local MelitngYIncrementY = 30
    self.MeltingMatrialLabel = ISLabel:new(MeltingX+25, MeltingY-28, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.MeltingMatrial, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMatrialLabel);

    self.MeltingFuelTex = ISImage:new(MeltingX, MeltingY, 0, 0, FuelImg.texture);
    self.MeltingFuelTex.scaledWidth = FuelImg.scale+5
    self.MeltingFuelTex.scaledHeight = FuelImg.scale+5
    self:addChild(self.MeltingFuelTex);

    self.MeltingFuelLabel = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingFuelLabel);
    MeltingY = MeltingY + MelitngYIncrementY

    self.MeltingMaterial1Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material1Img.texture)
    self.MeltingMaterial1Tex.scaledWidth = Material1Img.scale+5
    self.MeltingMaterial1Tex.scaledHeight = Material1Img.scale+5
    self:addChild(self.MeltingMaterial1Tex);

    self.MeltingMaterial1Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial1Label);
    MeltingY = MeltingY + MelitngYIncrementY

    self.MeltingMaterial2Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material2Img.texture);
    self.MeltingMaterial2Tex.scaledWidth = Material2Img.scale+5
    self.MeltingMaterial2Tex.scaledHeight = Material2Img.scale+5
    self:addChild(self.MeltingMaterial2Tex);

    self.MeltingMaterial2Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial2Label);
    MeltingY = MeltingY + MelitngYIncrementY

    self.MeltingMaterial3Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material3Img.texture);
    self.MeltingMaterial3Tex.scaledWidth = Material3Img.scale+5
    self.MeltingMaterial3Tex.scaledHeight = Material3Img.scale+5
    self:addChild(self.MeltingMaterial3Tex);

    self.MeltingMaterial3Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial3Label);
    MeltingY = MeltingY + MelitngYIncrementY

    self.MeltingMaterial4Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material4Img.texture);
    self.MeltingMaterial4Tex.scaledWidth = Material4Img.scale+5
    self.MeltingMaterial4Tex.scaledHeight = Material4Img.scale+5
    self:addChild(self.MeltingMaterial4Tex);

    self.MeltingMaterial4Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial4Label);
    MeltingY = MeltingY + MelitngYIncrementY

    self.MeltingMaterial5Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material5Img.texture);
    self.MeltingMaterial5Tex.scaledWidth = Material5Img.scale+5
    self.MeltingMaterial5Tex.scaledHeight = Material5Img.scale+5
    self:addChild(self.MeltingMaterial5Tex);

    self.MeltingMaterial5Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial5Label);


    -- self.TestButton = ISButton:new(buttonX2+120, buttonY2, 100,25,FurnaceUIText.StayTempBtn,self, FurnaceUI.TestBtn);
    -- self.TestButton:initialise()
    -- self.TestButton.enable = true
    -- self:addChild(self.TestButton);

end

-- function FurnaceUI:TestBtn()
--     local WorldAge = getGameTime():getWorldAgeHours()
--     local worlTemp = getWorld():getGlobalTemperature()
--     print(WorldAge)
--     print(worlTemp)
-- end

function FurnaceUI:ChangeSprite()
    if self.checkx and self.checky and self.checkz then
        local x = self.checkx
        local y = self.checky
        local z = self.checkz
        local square = getWorld():getCell():getGridSquare(x, y, z)
        if square then
            local objects = square:getObjects()
            local objname = objects:get(1):getSprite()
            for i = 0, objects:size() - 1 do
                local object = objects:get(i)
                if object:getSprite() == getSprite("BS_Furnace_16") then
                    object:setSprite(getSprite("BS_Furnace_17"))
                    if isClient() then object:transmitUpdatedSpriteToServer(); end
                    break
                end
                if object:getSprite() == getSprite("BS_Furnace_17") then
                    object:setSprite(getSprite("BS_Furnace_16"))
                    if isClient() then object:transmitUpdatedSpriteToServer(); end
                    break 
                end
            end
        end
    end
end

function FurnaceUI:InjectBtn()
    FurnaceInjectUI:show(self.player, self.furnace, self.CheckFurnace)
end

function FurnaceUI:SelectBtn()
    MaterialSelectUI:show(self.player, self.furnace, self.CheckFurnace)
end

function FurnaceUI:render()
    ISCollapsableWindow.render(self);
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if self.SingActionInProgress then
        if not currentAction then 
            self.ActionInProgress = false 
            self.SingActionInProgress = false
            sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
            return 
        end
        if not (currentAction.Type == "AnvilMakeAction" or currentAction.Type == "FurnaceInjectAction" or currentAction.Type == "FurnaceStartAction" or currentAction.Type == "FurnaceBellowsAction") then 
            self.ActionInProgress = false 
            self.SingActionInProgress = false
            sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
            return 
        end
    self:drawProgressBar(10, 20, 50, 10, currentAction.action:getJobDelta(), self.fgBar)
    end
    
end

function FurnaceUI:cancelFurnaceStartBtn()
    self.cancelFurnaceStartButton.enable = false
    self.cancelFurnaceStartButton:setVisible(false)
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then return end
    if not (currentAction.Type == "FurnaceStartAction") and not (currentAction.Type == "FurnaceBellowsAction") then return end
    currentAction.action:forceStop()
end

function FurnaceUI:FurnaceOnBtn()
    self.ActionInProgress = true
    self.SingActionInProgress = true
    sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
    self.cancelFurnaceStartButton.enable = true
    self.cancelFurnaceStartButton:setVisible(true)
    local StartFuel = SandboxVars.Furnace.StartFuel
    local action = FurnaceStartAction:new(self.player,self,self.CheckFurnace);
    ISTimedActionQueue.add(action);
    self.LastCheckTime = getGameTime():getWorldAgeHours()
    sendClientCommand("FIvntS", "InputSyncTime", {self.CheckFurnace, self.LastCheckTime})
    sendClientCommand("FIvntS", "Remove", {self.CheckFurnace, StartFuel, 0, 0, 0, 0, 0})
    self.FurnaceTempState = "StayTemp"
    sendClientCommand("FIvntS", "InputFurnaceTempState", {self.CheckFurnace, self.FurnaceTempState})
end

function FurnaceUI:FurnaceOffBtn()
    self.FurnaceOffTime = getGameTime():getWorldAgeHours() 
    sendClientCommand("FIvntS", "InputFurnaceOffTime", {self.CheckFurnace, self.FurnaceOffTime})
    self:FurnaceOffBtnSet()
    self:ChangeSprite()
    self.FurnaceState = false
    self.FurnaceTempState = "Tempdown"
    sendClientCommand("FIvntS", "InputSyncFurnace", {self.CheckFurnace, self.FurnaceState})
    sendClientCommand("FIvntS", "InputFurnaceTempState", {self.CheckFurnace, self.FurnaceTempState})
end

function FurnaceUI:UseBellowsBtn()
    self.ActionInProgress = true
    self.SingActionInProgress = true
    sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
    self.cancelFurnaceStartButton.enable = true
    self.cancelFurnaceStartButton:setVisible(true)
    self.UseBellowsButton.enable = false
    local action = FurnaceBellowsAction:new(self.player,self,self.CheckFurnace);
    ISTimedActionQueue.add(action);
end

function FurnaceUI:TempupBtn()
    self.FurnaceTempState = "Tempup"
    sendClientCommand("FIvntS", "InputFurnaceTempState", {self.CheckFurnace, self.FurnaceTempState})
    self:TempupBtnSet()
end

function FurnaceUI:StayTempBtn()
    self.FurnaceTempState = "StayTemp"
    sendClientCommand("FIvntS", "InputFurnaceTempState", {self.CheckFurnace, self.FurnaceTempState})
    self:StayTempBtnSet()
end

function FurnaceUI:UseBellowsBtnSet()
    self.UseBellowsButton:setVisible(true)
    self.TempupButton.enable = true
    self.StayTempButton.enable = true
    self.FurnaceTempStateNofireLabel:setVisible(false)
    self.FurnaceTempStateFireLabel:setVisible(false)
    self.FurnaceTempStateTempupLabel:setVisible(false)
    self.FurnaceTempStateTempdownLabel:setVisible(false)
    self.FurnaceTempStateTempUseBellowsLabel:setVisible(true)
end

function FurnaceUI:TempupBtnSet()
    self.UseBellowsButton:setVisible(true)
    self.TempupButton.enable = false
    self.StayTempButton.enable = true
    self.FurnaceTempStateNofireLabel:setVisible(false)
    self.FurnaceTempStateFireLabel:setVisible(false)
    self.FurnaceTempStateTempupLabel:setVisible(true)
    self.FurnaceTempStateTempdownLabel:setVisible(false)
    self.FurnaceTempStateTempUseBellowsLabel:setVisible(false)
end

function FurnaceUI:StayTempBtnSet()
    self.UseBellowsButton:setVisible(true)
    self.TempupButton.enable = true
    self.StayTempButton.enable = false
    self.FurnaceTempStateNofireLabel:setVisible(false)
    self.FurnaceTempStateFireLabel:setVisible(true)
    self.FurnaceTempStateTempupLabel:setVisible(false)
    self.FurnaceTempStateTempdownLabel:setVisible(false)
    self.FurnaceTempStateTempUseBellowsLabel:setVisible(false)
end

function FurnaceUI:FurnaceOnBtnSet()
    self.FurnaceOffButton.enable = true
    self.FurnaceOnButton:setVisible(false)
    self.FurnaceOffButton:setVisible(true)
    self.FurnaceStateOnLabel:setVisible(true)
    self.FurnaceStateOffLabel:setVisible(false)
    self.FurnaceOnTexture:setVisible(true)
    self.FurnaceOffTexture:setVisible(false)
end

function FurnaceUI:FurnaceOffBtnSet()
    self.FurnaceOnButton:setVisible(true)
    self.FurnaceOnButton.enable = true
    self.FurnaceOffButton:setVisible(false)
    self.FurnaceStateOnLabel:setVisible(false)
    self.FurnaceStateOffLabel:setVisible(true)
    self.FurnaceOnTexture:setVisible(false)
    self.FurnaceOffTexture:setVisible(true)
end

function FurnaceUI:SelectFuelTextSet()
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(true)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function FurnaceUI:SelectMaterial1TextSet()
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(true)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end
function FurnaceUI:SelectMaterial2TextSet()
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(true)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function FurnaceUI:SelectMaterial3TextSet()
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(true)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function FurnaceUI:SelectMaterial4TextSet()
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(true)
    self.SelectMaterial5Text:setVisible(false)
end

function FurnaceUI:SelectMaterial5TextSet()
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(true)
end

function FurnaceUI:SelectNilTextSet()
    self.SelectNilText:setVisible(true)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function FurnaceUI:close()
	ISCollapsableWindow.close(self);
    self:removeFromUIManager()
end

function FurnaceUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2) + 300;
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    o.title = FurnaceUIText.FurnaceUITitle;
    o.player = player
    o.resizable = false;
    return o
end