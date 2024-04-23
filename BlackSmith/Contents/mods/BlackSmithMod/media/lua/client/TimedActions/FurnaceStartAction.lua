require "TimedActions/ISBaseTimedAction"

FurnaceStartAction = ISBaseTimedAction:derive("FurnaceStartAction");

function FurnaceStartAction:isValid()
    local Fuel, Material1, Material2, Material3, Material4, Material5 = FIvnt.getUserFIvnt(self.Check)
    local StartFuel = SandboxVars.Furnace.StartFuel
    if Fuel >= StartFuel then
        return true;
    end
    return false;
end

function FurnaceStartAction:update() 
    if not self.furnaceUI:getIsVisible() then 
        self:forceStop()
    end
end

function FurnaceStartAction:waitToStart()
    return false;
end

function FurnaceStartAction:start() 
    self:setActionAnim("RemoveGrass")
    -- self.character:getEmitter():playSound("My_sound")
end

function FurnaceStartAction:stop()
    ISBaseTimedAction.stop(self);
end

function FurnaceStartAction:perform()
    local FurnaceTemp = FIvnt.OutputFurnaceTemp(self.Check)
    if FurnaceTemp < 500 then
        sendClientCommand("FIvntS", "InputFurnaceTemp", {self.Check, 500})
    end
    self.furnaceUI:ChangeSprite()
    sendClientCommand("FIvntS", "InputSyncFurnace", {self.Check, true})
    local Amount = 10
    self.character:getXp():AddXP(Perks.Smithing, Amount)
    ISBaseTimedAction.perform(self);
end

function FurnaceStartAction:new(character, furnaceUI, Check)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.furnaceUI = furnaceUI
    o.furnace = furnaceUI.furnace
    o.character = character;
    o.Check = Check
    o.stopOnWalk = true
    o.stopOnRun = true
    o.forceProgressBar = true
    o.maxTime = 100;
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end