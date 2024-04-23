require "TimedActions/ISBaseTimedAction"

AnvilMakeAction = ISBaseTimedAction:derive("AnvilMakeAction")
local Furnacefunction = require "Furnacefunction"

function AnvilMakeAction:isValid()
    local username = self.character:getUsername()
    local Check = self.Check
    local MeltingFuel, MeltingMaterial1, MeltingMaterial2, MeltingMaterial3, MeltingMaterial4, MeltingMaterial5 = FIvnt.getUserMelting(Check)
    local ticket = self.ticket
    return MeltingFuel >= ticket.Fuel and MeltingMaterial1 >= ticket.Material1 and MeltingMaterial2 >= ticket.Material2 and MeltingMaterial3 >= ticket.Material3 and MeltingMaterial4 >= ticket.Material4 and MeltingMaterial5 >= ticket.Material5
end

function AnvilMakeAction:waitToStart()
    return self.character:shouldBeTurning()
end

function AnvilMakeAction:update()
    if not self.AnvilUI:getIsVisible() then 
        self:forceStop()
    end
end

function AnvilMakeAction:start()
    self:setActionAnim("Build")
end

function AnvilMakeAction:stop()
    ISBaseTimedAction.stop(self)
end

function AnvilMakeAction:perform()
    local cartItems = self.AnvilUI.cartItems.items
    local playerInv = self.character:getInventory()
    for k,v in pairs(cartItems) do
        local item = v.item
        local packItems = item.items
        if packItems then
            local drop = item.drop
            local square = self.character:getSquare()
            for k,v in pairs(packItems) do
                if drop then
                    if v.quantity then
                        for i = 1,v.quantity,1 do
                            square:AddWorldInventoryItem(v.item, 0.0, 0.0, 0.0)
                            Furnacefunction.buildLogFurnace(v.item)
                        end
                    else
                        square:AddWorldInventoryItem(v.item, 0.0, 0.0, 0.0)
                        Furnacefunction.buildLogFurnace(v.item)
                    end
                else
                    if v.quantity then 
                        playerInv:AddItems(v.item,v.quantity);
                        Furnacefunction.buildLogFurnace(v.item,v.quantity)
                    else
                        playerInv:AddItem(v.item);
                        Furnacefunction.buildLogFurnace(v.item)
                    end
                end
            end
        else
            local Chance = item.Chance
            if Chance then
                local rand = ZombRand(0,100)
                if rand < Chance then
                    if item.quantity then
                        playerInv:AddItems(item.type,item.quantity);
                        Furnacefunction.buildLogFurnace(item.type,item.quantity)
                    else
                        playerInv:AddItem(item.type);
                        Furnacefunction.buildLogFurnace(item.type)
                    end
                end
            else
                if item.quantity then
                    playerInv:AddItems(item.type,item.quantity);
                    Furnacefunction.buildLogFurnace(item.type,item.quantity)
                else
                    playerInv:AddItem(item.type);
                    Furnacefunction.buildLogFurnace(item.type)
                end
            end
        end
    end
    local FurnaceSquare = self.Anvil:getSquare()
    local coords = {
        x = FurnaceSquare:getX(),
        y = FurnaceSquare:getY(),
        z = FurnaceSquare:getZ(),
    }
    Furnacefunction.logFurnace(coords)
    local Check = self.Check
    local ticket = self.ticket
    -- self.character:playSound("CashRegister")
    sendClientCommand("FIvntS", "Make", {Check,ticket.Fuel,ticket.Material1,ticket.Material2,ticket.Material3,ticket.Material4,ticket.Material5})
    local Amount = math.floor(self.XP * 0.1)
    self.character:getXp():AddXP(Perks.Smithing, Amount)
    self.AnvilUI.cartItems:clear()
    ISBaseTimedAction.perform(self)
end

function AnvilMakeAction:new(character,AnvilUI,ticket,ChangeMaxTime,Check)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.Check = Check
    o.AnvilUI = AnvilUI
    o.Anvil = AnvilUI.Anvil
    o.ticket = ticket
    o.stopOnWalk = true
    o.stopOnRun = true
    o.XP = ChangeMaxTime
    o.maxTime = ChangeMaxTime
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o
end 