require "TimedActions/ISBaseTimedAction"

FurnaceBellowsAction = ISBaseTimedAction:derive("FurnaceBellowsAction");

function FurnaceBellowsAction:isValid() 
    local Fuel, Material1, Material2, Material3, Material4, Material5 = FIvnt.getUserFIvnt(self.Check)
    self.UseBellowsFuel = SandboxVars.Furnace.UseBellowsFuel
    if Fuel >= self.UseBellowsFuel and self.character:getInventory():FindAndReturn('Base.Bellows') then
        return true;
    end
    return false;
end

function FurnaceBellowsAction:update() 
    if not self.furnaceUI:getIsVisible() then 
        self:forceStop()
    end
end

function FurnaceBellowsAction:waitToStart() 
    return false;
end

function FurnaceBellowsAction:start() 
    self:setActionAnim("RemoveGrass")
    -- self.character:getEmitter():playSound("My_sound")
end

function FurnaceBellowsAction:stop()
    ISBaseTimedAction.stop(self);
end

function FurnaceBellowsAction:perform() 
    local FurnaceTemp = FIvnt.OutputFurnaceTemp(self.Check)
    if FurnaceTemp <= 1700 then
        FurnaceTemp = FurnaceTemp + SandboxVars.Furnace.UseBellowsTemp
    else
        FurnaceTemp = 2000
    end
    sendClientCommand("FIvntS", "InputFurnaceTemp", {self.Check, FurnaceTemp})
    sendClientCommand("FIvntS", "Remove", {self.Check, self.UseBellowsFuel,0,0,0,0,0})
    local Amount = 40
    self.character:getXp():AddXP(Perks.Smithing, Amount)
    ISBaseTimedAction.perform(self);
end

function FurnaceBellowsAction:new(character, furnaceUI, Check) 
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
    o.maxTime = 500; 
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end