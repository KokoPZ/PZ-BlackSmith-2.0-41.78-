FurnaceSpriteCursor = ISBuildingObject:derive("FurnaceSpriteCursor")
FurnaceSpriteCursor.instance = nil
FurnaceSpriteCursor.spriteIndex = 1

function FurnaceSpriteCursor:create(x, y, z, north, sprite)
	local cell = getWorld():getCell()
	local square = cell:getGridSquare(x, y, z)
	local furnace = IsoThumpable.new(cell, self.square, sprite, north, self)
	furnace:setSprite(sprite)
	furnace:setIsThumpable(false);
	square:AddSpecialObject(furnace)
	furnace:transmitCompleteItemToServer()
	getWorld():getCell():setDrag(nil, 0);

end

function FurnaceSpriteCursor:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)
end

function FurnaceSpriteCursor:isValid(square)
	return true
end

FurnaceSpriteCursor.toggleSprites = function (key)
	if FurnaceSpriteCursor.instance == nil then return end
	if not(key == getCore():getKey("Rotate building")) then return end
	local spriteIndex = FurnaceSpriteCursor.instance.spriteIndex
	if spriteIndex == 2 then
		spriteIndex = 1 
	else
		spriteIndex = 2
	end
	local nextSprite = FurnaceSpriteCursor.instance.sprites[spriteIndex]
	FurnaceSpriteCursor.instance.spriteIndex = spriteIndex
	FurnaceSpriteCursor.instance:setSprite(nextSprite)
	FurnaceSpriteCursor.instance:setNorthSprite(nextSprite)
end

function FurnaceSpriteCursor:new(character,sprites)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o.sprites = sprites
	o:setSprite(sprites[1])
	o:setNorthSprite(sprites[1])
	o.character = character
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	FurnaceSpriteCursor.instance = o
	return o
end

Events.OnKeyPressed.Add(FurnaceSpriteCursor.toggleSprites)