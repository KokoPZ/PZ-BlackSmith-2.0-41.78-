local Furnacefunction = {}

 function Furnacefunction.trimString(str,limit)
    local len = string.len(str)
    if len > limit then
        str = string.sub(str,1,limit-3) .. "..."
    end
    return str
end

function Furnacefunction.drainablePrice(item,price)
    if instanceof(item, "DrainableComboItem") then
        price = math.floor(price*item:getUsedDelta())
        if price<=0 then
            price = 1
        end  
    end
    return price
end

function Furnacefunction.drainablePrice2(item,Fuelprice)
    if instanceof(item, "DrainableComboItem") then
        if Fuelprice then
            Fuelprice = math.floor(Fuelprice*item:getUsedDelta())
            if Fuelprice<=0 then
                Fuelprice = 1
            end
        end
        return Fuelprice
    end
    return Fuelprice
end

function Furnacefunction.MeltingMaterial(MeltingTime, Material, Fuel, SelectFuel)

    local MeltingAmount = SandboxVars.Furnace.MeltingAmount 
    local TenminFuel = (SandboxVars.Furnace.FurnaceOnFuel + SelectFuel)
    local FurnaceOnFuel = TenminFuel * MeltingTime 
    local FuelAmount = math.floor(Fuel / TenminFuel) 

    local OnFuelMelting = MeltingAmount * MeltingTime 
    local NoFuelMelting = MeltingAmount * FuelAmount

    if FurnaceOnFuel > Fuel then 
        if FuelAmount > MeltingTime then
            return math.min(Material, OnFuelMelting)
        elseif FuelAmount <= MeltingTime then
            return math.min(Material, NoFuelMelting)
        end
    elseif FurnaceOnFuel <= Fuel then
        return math.min(Material, OnFuelMelting)
    end 

end

function Furnacefunction.Smithing(Material, SmithingLevel, State)
    local LevelReductionRate = SandboxVars.Furnace.LevelReductionRate
    local LevelIncreaseRate = SandboxVars.Furnace.LevelIncreaseRate
    local Smithing = 0
    if State == "Make" then
        Smithing = Material * LevelReductionRate * SmithingLevel * 0.01
    elseif State == "Melting" then
        Smithing = (Material * LevelIncreaseRate * 0.1) + (Material * LevelIncreaseRate * SmithingLevel * 0.01)
    end

    return math.floor(Smithing)
end

function Furnacefunction.MeltingFuel(MeltingTime, Material, Fuel, SelectFuel)
    local MeltingAmount = SandboxVars.Furnace.MeltingAmount 
    local TenminFuel = (SandboxVars.Furnace.FurnaceOnFuel + SelectFuel)
    local FurnaceOnFuel = TenminFuel * MeltingTime 
    local FuelAmount = math.floor(TenminFuel / Fuel) 

    local OnFuelMelting = MeltingAmount * MeltingTime
    local NoFuelMelting = MeltingAmount * FuelAmount 

    if FurnaceOnFuel > Fuel then 
        if FuelAmount > MeltingTime then
            return math.min(Material, OnFuelMelting)
        elseif FuelAmount <= MeltingTime then
            return math.min(Material, NoFuelMelting)
        end
    elseif FurnaceOnFuel <= Fuel then
        return math.min(Material, OnFuelMelting)
    end 

end

function Furnacefunction.MaxTimeCalculations(Time, SmithingLevel)
    local TimeValue = Time
    local LevelReductionTimeRate = SandboxVars.Furnace.LevelReductionTimeRate
    MaxTime = math.floor(TimeValue*SmithingLevel*LevelReductionTimeRate*0.01)
    return MaxTime
end

local furnaceItems = {}
function Furnacefunction.logFurnace(coords,action)
    local username = getPlayer():getUsername()
    if not action then
        action = "Purchase"
    end
    local log = username .." ".. coords.x ..",".. coords.y ..",".. coords.z .." "..action.." ["
    local first = true
    for k,v in pairs(furnaceItems) do
        if first then
            first = false
            log = log .. k.."="..v
        else
            log = log.."," .. k.."="..v
        end
    end
    log = log.."]"
    furnaceItems = {}
    sendClientCommand("FLS", "TransactionFurnaceLog", {log})
end

function Furnacefunction.buildLogFurnace(type,quantity)
    if not furnaceItems[type] then
        local count = 1
        if quantity then count = quantity end
        furnaceItems[type] = count
    else
        furnaceItems[type] = furnaceItems[type] + 1
    end
end

return Furnacefunction