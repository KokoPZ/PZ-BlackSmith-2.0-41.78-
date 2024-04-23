Furnace = Furnace or {}
Furnace.Items = Furnace.Items or {}
Furnace.Tabs = Furnace.Tabs or {}
Furnace.Inject = Furnace.Inject or {}
Furnace.InjectisBlacklist = false
Furnace.SellisWhitelist = true
Furnace.defaultPrice = 1
Furnace.defaultPriceBroken = 1

Furnace.spritePrefix = "BS_Furnace_16"
Furnace.spritePrefix2 = "BS_Furnace_17"
Furnace.spritePrefix3 = "BS_Furnace_18"

Furnace.textures = {
	AddButton = {
		texture = getTexture("media/textures/FurnaceUI_Add.png"),
		scale = 20
	},
	RemoveButton= {
		texture = getTexture("media/textures/FurnaceUI_Remove.png"),
		scale = 20
	},
	PreviewButton= {
		texture = getTexture("media/textures/FurnaceUI_Preview.png"),
		scale = 20
	},
	Browse= {
		texture = getTexture("media/textures/FurnaceUI_Browse.png"),
		scale = 20
	},
	Cart= {
		texture = getTexture("media/textures/FurnaceUI_Cart.png"),
		scale = 30
	},
	Sort= {
		texture = getTexture("media/textures/FurnaceUI_Sort.png"),
	},
	MoveAll= {
		texture = getTexture("media/textures/FurnaceUI_MoveAll.png"),
	},
	FurnaceOn = {
		texture = getTexture("media/textures/FurnaceUI_FurnaceOn.png"),
	},
	FurnaceOff = {
		texture = getTexture("media/textures/FurnaceUI_FurnaceOff.png"),
	},
}

Tab = Tab or {}
Tab["Inject"] = "Inject"
Furnace.Tabs[Tab.Inject] = getText("IGUI_Tab_Inject")
