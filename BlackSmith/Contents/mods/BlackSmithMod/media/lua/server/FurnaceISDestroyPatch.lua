local FurnaceoldCanDestroy = ISDestroyCursor.canDestroy
function ISDestroyCursor:canDestroy(object)
	if not (isAdmin()) then
		local sprite = object:getSprite()
		if sprite then 
			local spriteName = sprite:getName()
			if spriteName then
				if(string.find(spriteName,Furnace.spritePrefix)) then 
					return false
				end
			end
		end
	end
	return FurnaceoldCanDestroy(self,object)
end