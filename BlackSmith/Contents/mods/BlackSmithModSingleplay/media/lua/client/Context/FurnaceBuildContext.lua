local FurnaceBuildContext = {}

FurnaceBuildContext.BuildContext = function(player, context, worldobjects)
    local playerObj = getSpecificPlayer(player)
    if playerObj:getVehicle() then
        return
    end

    local inv = playerObj:getInventory()
    
    if playerObj:getInventory():FindAndReturn('Base.SmithingMagazine') then
        local FurnaceBuildMain = context:addOption(FurnaceUIText.FurnaceBuildMain)
        local FurnaceBuildList = ISContextMenu:getNew(context)
        context:addSubMenu(FurnaceBuildMain, FurnaceBuildList)
        FurnaceBuildContext.FurnaceBuildMenuBuild(FurnaceBuildList, player, context)

        context:addSubMenu(FurnaceBuildMain, FurnaceBuildList)
        FurnaceBuildContext.FurnaceLightBuildMenuBuild(FurnaceBuildList, player, context)

        context:addSubMenu(FurnaceBuildMain, FurnaceBuildList)
        FurnaceBuildContext.AnvilBuildMenuBuild(FurnaceBuildList, player, context)
    end

end

FurnaceBuildContext.FurnaceBuildMenuBuild = function(subMenu, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    sprite = {}
    sprite.sprite = 'BS_Furnace_16'
    sprite.northSprite = 'BS_Furnace_16'
    sprite.southSprite = 'BS_Furnace_16'
    sprite.eastSprite = 'BS_Furnace_16'

    name = FurnaceUIText.FurnaceType1

    option = subMenu:addOption(name, nil, FurnaceBuildContext.BuildFurnace, sprite, player, name)

    local toolTip = ISToolTip:new()
    toolTip:initialise()
    toolTip:setVisible(false)
    option.toolTip = toolTip
    toolTip:setName(FurnaceType1)
    toolTip:setTexture("BS_Furnace_16");
    toolTip.description = getText(FurnaceUIText.FurnaceType1) .. " <LINE><LINE> " .. getText("Tooltip_StoneFurnace_Build_Tooltip") .. " <LINE><LINE> " .. getText("Tooltip_NeedItem") .. " <LINE> ";
    if playerInv:getItemCount("Base.Stone") < 50 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Stone") .. ": " ..playerInv:getItemCount("Base.Stone") .. " / 50" ..  " <LINE> ";
        option.notAvailable = true;
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Stone") .. ": " ..playerInv:getItemCount("Base.Stone") .. " / 50" .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.BucketConcreteFull") < 1 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.BucketConcreteFull") .. ": " ..playerInv:getItemCount("Base.BucketConcreteFull") .. " / 1" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.BucketConcreteFull") .. ": " ..playerInv:getItemCount("Base.BucketConcreteFull") .. " /1 " .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.Hammer") < 1 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Hammer") .. ": " ..playerInv:getItemCount("Base.Hammer") .. " / 1" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Hammer") .. ": " ..playerInv:getItemCount("Base.Hammer") .. " / 1" .. " <LINE> ";
    end
end

FurnaceBuildContext.FurnaceLightBuildMenuBuild = function(subMenu, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    sprite = {}
    sprite.sprite = 'BS_Furnace_16'
    sprite.northSprite = 'BS_Furnace_16'
    sprite.southSprite = 'BS_Furnace_16'
    sprite.eastSprite = 'BS_Furnace_16'

    name = FurnaceUIText.FurnaceType2

    option = subMenu:addOption(name, nil, FurnaceBuildContext.BuildFurnaceLight, sprite, player, name)

    local toolTip = ISToolTip:new()
    toolTip:initialise()
    toolTip:setVisible(false)
    option.toolTip = toolTip
    toolTip:setName(FurnaceType2)
    toolTip:setTexture("BS_Furnace_16");
    toolTip.description = getText(FurnaceUIText.FurnaceType2) .. " <LINE><LINE> " .. getText("Tooltip_StoneFurnaceLight_Build_Tooltip") .. " <LINE><LINE> " .. getText("Tooltip_NeedItem") .. " <LINE> ";
    if playerInv:getItemCount("Base.Stone") < 50 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Stone") .. ": " ..playerInv:getItemCount("Base.Stone") .. " / 50" ..  " <LINE> ";
        option.notAvailable = true;
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Stone") .. ": " ..playerInv:getItemCount("Base.Stone") .. " / 50" .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.BucketConcreteFull") < 1 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.BucketConcreteFull") .. ": " ..playerInv:getItemCount("Base.BucketConcreteFull") .. " / 1" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.BucketConcreteFull") .. ": " ..playerInv:getItemCount("Base.BucketConcreteFull") .. " /1 " .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.Battery") < 1 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Battery") .. ": " ..playerInv:getItemCount("Base.Battery") .. " / 1" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Battery") .. ": " ..playerInv:getItemCount("Base.Battery") .. " / 1" .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.Hammer") < 1 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Hammer") .. ": " ..playerInv:getItemCount("Base.Hammer") .. " / 1" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Hammer") .. ": " ..playerInv:getItemCount("Base.Hammer") .. " / 1" .. " <LINE> ";
    end
end

FurnaceBuildContext.AnvilBuildMenuBuild = function(subMenu, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    sprite = {}
    sprite.sprite = 'BS_Furnace_18'
    sprite.northSprite = 'BS_Furnace_18'
    sprite.southSprite = 'BS_Furnace_18'
    sprite.eastSprite = 'BS_Furnace_18'

    name = FurnaceUIText.AnvilType1

    option = subMenu:addOption(name, nil, FurnaceBuildContext.BuildAnvil, sprite, player, name)

    local toolTip = ISToolTip:new()
    toolTip:initialise()
    toolTip:setVisible(false)
    option.toolTip = toolTip
    toolTip:setName(AnvilType1)
    toolTip:setTexture("BS_Furnace_18");
    toolTip.description = getText(FurnaceUIText.AnvilType1) .. " <LINE><LINE> " .. getText("Tooltip_Anvil_Build_Tooltip") .. " <LINE><LINE> " .. getText("Tooltip_NeedItem") .. " <LINE> ";
    if playerInv:getItemCount("Base.Log") < 3 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Log") .. ": " ..playerInv:getItemCount("Base.Log") .. " / 3" ..  " <LINE> ";
        option.notAvailable = true;
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Log") .. ": " ..playerInv:getItemCount("Base.Log") .. " / 3" .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.SheetMetal") < 5 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.SheetMetal") .. ": " ..playerInv:getItemCount("Base.SheetMetal") .. " / 5" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.SheetMetal") .. ": " ..playerInv:getItemCount("Base.SheetMetal") .. " / 5" .. " <LINE> ";
    end
    if playerInv:getItemCount("Base.Hammer") < 1 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Hammer") .. ": " ..playerInv:getItemCount("Base.Hammer") .. " / 1" ..  " <LINE> ";
        option.notAvailable = true
    else
        toolTip.description = toolTip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Hammer") .. ": " ..playerInv:getItemCount("Base.Hammer") .. " / 1" .. " <LINE> ";
    end
end

FurnaceBuildContext.BuildFurnaceLight = function(ignoreThisArgument, sprite, player, name)
    local Furnace = ISLightSource:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

    Furnace.offsetX = 5;
    Furnace.offsetY = 5;
    Furnace.baseItem = "Base.Battery";
    Furnace.radius = 10;
    Furnace.fuel = "Base.Battery";
    
    Furnace.canBeAlwaysPlaced = true
    Furnace.isContainer = true
    Furnace.canBeLockedByPadlock = true
    function Furnace:getHealth()
        return 5000
    end
    Furnace.containerType = 'BS_Furnace'
    Furnace.player = player
    Furnace.name = name
	Furnace.maxTime = 200;
    Furnace.modData['use:Base.BucketConcreteFull'] = 4
    Furnace.modData['need:Base.Stone'] = 50
    Furnace.modData['xp:Woodwork'] = 53
     
    getCell():setDrag(Furnace, player);
end

FurnaceBuildContext.BuildFurnace = function(ignoreThisArgument, sprite, player, name)
    local Furnace = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)
    
    Furnace.canBeAlwaysPlaced = true
    Furnace.isContainer = true
    Furnace.canBeLockedByPadlock = true
    Furnace.containerType = 'BS_Furnace'
    function Furnace:getHealth()
        return 5000
    end
    Furnace.player = player
    Furnace.name = name
	Furnace.maxTime = 200;
    Furnace.modData['use:Base.BucketConcreteFull'] = 4
    Furnace.modData['need:Base.Stone'] = 50
    Furnace.modData['xp:Woodwork'] = 5
     
    getCell():setDrag(Furnace, player);
end

FurnaceBuildContext.BuildAnvil= function(ignoreThisArgument, sprite, player, name)
    local Furnace = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)
    
    Furnace.canBeAlwaysPlaced = true
    Furnace.isContainer = true
    Furnace.canBeLockedByPadlock = true
    function Furnace:getHealth()
        return 5000
    end
    Furnace.containerType = 'BS_Furnace'
    Furnace.player = player
    Furnace.name = name
	Furnace.maxTime = 200;
    Furnace.modData['need:Base.Log'] = 3
    Furnace.modData['need:Base.SheetMetal'] = 5
    Furnace.modData['xp:Woodwork'] = 5;
     
    getCell():setDrag(Furnace, player);
end

Events.OnPreFillWorldObjectContextMenu.Add(FurnaceBuildContext.BuildContext)