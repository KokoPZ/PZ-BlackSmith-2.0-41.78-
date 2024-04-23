require "TimedActions/ISBaseTimedAction"
local Furnacefunction = require "Furnacefunction"
FurnaceInjectAction = ISBaseTimedAction:derive("FurnaceInjectAction")

function FurnaceInjectAction:isValid()
    return true
end

function FurnaceInjectAction:waitToStart()
    return self.character:shouldBeTurning()
end

function FurnaceInjectAction:update()
    if not self.furnaceUI:getIsVisible() then 
        self:forceStop()
    end
end

function FurnaceInjectAction:start()
    self:setActionAnim("RemoveGrass")
end

function FurnaceInjectAction:stop()
    ISBaseTimedAction.stop(self)
end

function FurnaceInjectAction:perform()
    local cartItems = self.furnaceUI.cartItems.items
    local playerInv = self.character:getInventory()
    local inventoryItems = {}
    local inventory = self.character:getInventory():getItems()
    for i = 0, inventory:size() -1 do
        local item = inventory:get(i)
        if not (item:isEquipped() or item:isFavorite()) then
            inventoryItems[item:getID()] = item
        end
    end
    local totalFuel = 0
    local totalMaterial1 = 0
    local totalMaterial2 = 0
    local totalMaterial3 = 0
    local totalMaterial4 = 0
    local totalMaterial5 = 0
    for k,v in pairs(cartItems) do
        local item = v.item
        local invItem = inventoryItems[item.id]
        if invItem then
            if item.Fuelprice then
                totalFuel = totalFuel + item.Fuelprice
            end
            if item.Material1price then
                totalMaterial1 = totalMaterial1 + item.Material1price
            end
            if item.Material2price then
                totalMaterial2 = totalMaterial2 + item.Material2price
            end
            if item.Material3price then
                totalMaterial3 = totalMaterial3 + item.Material3price
            end
            if item.Material4price then
                totalMaterial4 = totalMaterial4 + item.Material4price
            end
            if item.Material5price then
                totalMaterial5 = totalMaterial5 + item.Material5price
            end
            invItem:getContainer():Remove(invItem)
        end
    end
    local FurnaceSquare = self.furnace:getSquare()
    local coords = {
        x = FurnaceSquare:getX(),
        y = FurnaceSquare:getY(),
        z = FurnaceSquare:getZ(),
    }
    local Check = self.Check
    local playerInv = self.character:getInventory()
    if totalFuel > 0 or totalMaterial1 > 0 or totalMaterial2 > 0 or totalMaterial3 > 0 or totalMaterial4 > 0 or totalMaterial5 > 0 then 
        self.character:playSound("CashRegister") 
        sendClientCommand("FIvntS", "Inject", {Check, totalFuel, totalMaterial1, totalMaterial2, totalMaterial3, totalMaterial4, totalMaterial5})
    end
    local Amount = math.floor((totalFuel + totalMaterial1 + totalMaterial2  + totalMaterial3 + totalMaterial4  + totalMaterial5) * 0.01)
    self.character:getXp():AddXP(Perks.Smithing, Amount)
    self.furnaceUI.cartItems:clear()
    ISBaseTimedAction.perform(self)
end

function FurnaceInjectAction:new(character,furnaceUI,Check)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.Check = Check
    o.furnaceUI = furnaceUI
    o.furnace = furnaceUI.furnace
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 250
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o
end 