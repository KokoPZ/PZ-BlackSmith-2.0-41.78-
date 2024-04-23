local AnvilContext = AnvilContext or {}

local function seekFurnaceTiles(worldobject,spritePrefix)
    local wo = worldobject
    local found = false
    if not wo then return wo,found end
    local sprite = wo:getSprite()
    local spriteName = sprite:getName()
    if spriteName then
        if(string.find(spriteName,spritePrefix)) then 
            found = true
        end
    end
    return wo, found
end

local function getObjectPosition(worldObject)
    if worldObject then
        local x, y, z = worldObject:getX(), worldObject:getY(), worldObject:getZ()
        return x, y, z
    else
        return nil 
    end
end

local function FoundFurnace(AnvilX, AnvilY, AnvilZ, range, spritePrefix, spritePrefix2)
    local FoundFurnace = false
    local CheckFurnace = 0
    for y = AnvilY - range, AnvilY + range do
        for x = AnvilX - range, AnvilX + range do
            local square = getCell():getGridSquare(x, y, AnvilZ)
            if square then
                local worldObjects = square:getObjects()
                for i = 0, worldObjects:size() - 1 do
                    local object = worldObjects:get(i)
                    if object then
                        local objSprite = object:getSprite()
                        if objSprite then
                            local objectName = objSprite:getName()
                            if objectName then
                                if string.find(objectName, spritePrefix) then
                                    FX, FY, FZ = getObjectPosition(object)
                                    CheckFurnace = FX..FY..FZ
                                    FoundFurnace = true
                                    return FoundFurnace, CheckFurnace
                                elseif string.find(objectName, spritePrefix2) then
                                    FX, FY, FZ = getObjectPosition(object)
                                    CheckFurnace = FX..FY..FZ
                                    FoundFurnace = true
                                    return FoundFurnace, CheckFurnace
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function AnvilContext.AnvilUI(worldobjects, playerNum, CheckFurnace)
    local player = getSpecificPlayer(playerNum)
    clickedSquare = luautils.getCorrectSquareForWall(player, clickedSquare);
    local adjacent = AdjacentFreeTileFinder.Find(clickedSquare, player);
    if adjacent then
        local action = ISWalkToTimedAction:new(player, adjacent)
        local Anvil = worldobjects[1]
        action:setOnComplete(function() AnvilUI:show(player, Anvil, CheckFurnace) end)
        ISTimedActionQueue.add(action)
    end

end

function AnvilContext.AnvilUIContextMenu(playerNum, context, worldobjects)
    local player = getSpecificPlayer(playerNum)
    local username = player:getUsername()
    local range = 5
    local AnvilX, AnvilY, AnvilZ = getObjectPosition(worldobjects[1])
    local FoundFurnace, CheckFurnace = FoundFurnace(AnvilX, AnvilY, AnvilZ, range, Furnace.spritePrefix, Furnace.spritePrefix2)
    local LastFurnaceID = FIvnt.OutputLastFurnaceID(username)
    local wo, found = seekFurnaceTiles(worldobjects[1],Furnace.spritePrefix3)

    if found and FoundFurnace and CheckFurnace == LastFurnaceID then
        local option = context:addOption(FurnaceUIText.OpenAnvil, worldobjects, AnvilContext.AnvilUI, playerNum, CheckFurnace)
    end


end

Events.OnPreFillWorldObjectContextMenu.Add(AnvilContext.AnvilUIContextMenu)