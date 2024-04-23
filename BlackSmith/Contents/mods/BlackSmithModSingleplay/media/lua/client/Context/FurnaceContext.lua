local FurnaceContext = FurnaceContext or {}

local function seekFurnaceTiles2(worldobject,spritePrefix,spritePrefix2)
    local wo = worldobject
    local found = false
    if not wo then return wo,found end
    local sprite = wo:getSprite()
    local spriteName = sprite:getName()
    if spriteName then
        if(string.find(spriteName,spritePrefix)) then 
            found = true
        elseif(string.find(spriteName,spritePrefix2)) then 
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

function Furnace.furnaceUI(worldobjects,playerNum,viewMode,clickedSquare,CheckFurnace,x,y,z)
    local player = getSpecificPlayer(playerNum)
    local username = player:getUsername()
    if not viewMode then
        clickedSquare = luautils.getCorrectSquareForWall(player, clickedSquare);
        local adjacent = AdjacentFreeTileFinder.Find(clickedSquare, player);
        if adjacent then
            local action = ISWalkToTimedAction:new(player, adjacent)
            local furnace = worldobjects[1]
            sendClientCommand("FIvntS", "CreateSharingIvnt", {CheckFurnace}) 
            sendClientCommand("FIvntS", "CreateLastFurnaceID", {username}) 
            action:setOnComplete(function() FurnaceUI:show(player,viewMode,furnace,CheckFurnace,x,y,z) end)
            ISTimedActionQueue.add(action)
        end
    else
        FurnaceUI:show(player,viewMode)
    end
end

function Furnace.FurnaceUIContextMenu(playerNum, context, worldobjects)
    local _,found = seekFurnaceTiles2(worldobjects[1],Furnace.spritePrefix,Furnace.spritePrefix2)
    if not found then return end
    local player = getSpecificPlayer(playerNum)
    local inventory = player:getInventory()
    local username = player:getUsername()
    local CheckObject = worldobjects[1]

    local x, y, z = getObjectPosition(worldobjects[1])
    local CheckFurnace = x..y..z

    if found and CheckFurnace then
        context:addOption(FurnaceUIText.FurnaceOpen, worldobjects, Furnace.furnaceUI, playerNum,false,clickedSquare,CheckFurnace,x,y,z);
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(Furnace.FurnaceUIContextMenu)