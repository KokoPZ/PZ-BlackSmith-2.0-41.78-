Material = Material or {}

Material.MaterialTexture = {
	Fuel = {
		texture = getTexture("media/textures/Item_FurnaceFuel.png"),
		scale = 15
	},
	Material1 = {
		texture = getTexture("media/textures/Item_FurnaceMaterial1.png"),
		scale = 15
	},
	Material2 = {
		texture = getTexture("media/textures/Item_FurnaceMaterial2.png"),
		scale = 15
	},
	Material3 = {
		texture = getTexture("media/textures/Item_FurnaceMaterial3.png"),
		scale = 15
	},
	Material4 = {
		texture = getTexture("media/textures/Item_FurnaceMaterial4.png"),
		scale = 15
	},
	Material5 = {
		texture = getTexture("media/textures/Item_FurnaceMaterial5.png"),
		scale = 15
	},
}

function Material.format(quantity)
	_, found= string.find(quantity, '%.')
	if found then
		quantity = string.format("%.2f",quantity)
	end
	while true do  
        quantity, k = string.gsub(quantity, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then break end
    end
    return quantity
end