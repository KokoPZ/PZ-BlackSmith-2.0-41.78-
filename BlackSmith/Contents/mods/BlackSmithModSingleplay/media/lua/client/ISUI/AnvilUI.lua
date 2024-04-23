local Furnacefunction = require "Furnacefunction"
AnvilUI = ISCollapsableWindow:derive("AnvilUI");
AnvilUI.instance = nil;
AnvilUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
AnvilUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
AnvilUI.removeButtonX = 230
AnvilUI.furnaceItemsCache = {}
AnvilUI.reloadItems = false
AnvilUI.lastTab = "none"
AnvilUI.ItemInstanceCache = {}
local posX = 0
local posY = 0

local removeBtn = Furnace.textures.RemoveButton;
local width = 800
local height = 590

function AnvilUI:show(player,Anvil,CheckFurnace)
    self.CheckFurnace = CheckFurnace
    local FurnaceState = FIvnt.OutputSyncFurnace(self.CheckFurnace)
    local ActionInProgress = FIvnt.OutputSyncActionInProgress(self.CheckFurnace)
    self.FurnaceState = FurnaceState
    self.ActionInProgress = ActionInProgress

    local square = player:getSquare()
    posX = square:getX()
    posY = square:getY()
    if AnvilUI.instance==nil then
        AnvilUI.instance = AnvilUI:new (0, 0, width, height, player);
        AnvilUI.instance.Anvil = Anvil
        AnvilUI.instance:initialise();
        AnvilUI.instance:instantiate();
    end
    AnvilUI.instance.pinButton:setVisible(false)
    AnvilUI.instance.collapseButton:setVisible(false)
    AnvilUI.instance:addToUIManager();
    AnvilUI.instance:setVisible(true);
    return AnvilUI.instance;
end

function AnvilUI:update()
    local player = self.player
    if player:DistTo(posX, posY) > 2 then
        self:close()
    end
    self.SmithingLevel = player:getPerkLevel(Perks.Smithing)

    local FurnaceState = FIvnt.OutputSyncFurnace(self.CheckFurnace)
    local ActionInProgress = FIvnt.OutputSyncActionInProgress(self.CheckFurnace)
    self.FurnaceState = FurnaceState
    self.ActionInProgress = ActionInProgress
    local MeltingFuel ,MeltingMaterial1, MeltingMaterial2, MeltingMaterial3, MeltingMaterial4, MeltingMaterial5 = FIvnt.getUserMelting(self.CheckFurnace)
    local MeltingFuelValue = Material.format(MeltingFuel)
    self.MeltingFuelLabel:setName(""..MeltingFuelValue)
    local MeltingMaterial1Value = Material.format(MeltingMaterial1)
    self.MeltingMaterial1Label:setName(""..MeltingMaterial1Value)
    local MeltingMaterial2Value = Material.format(MeltingMaterial2)
    self.MeltingMaterial2Label:setName(""..MeltingMaterial2Value)
    local MeltingMaterial3Value = Material.format(MeltingMaterial3)
    self.MeltingMaterial3Label:setName(""..MeltingMaterial3Value)
    local MeltingMaterial4Value = Material.format(MeltingMaterial4)
    self.MeltingMaterial4Label:setName(""..MeltingMaterial4Value)
    local MeltingMaterial5Value = Material.format(MeltingMaterial5)
    self.MeltingMaterial5Label:setName(""..MeltingMaterial5Value)
    if self.FurnaceState then
        self:FurnaceOnSet()
    else
        self:FurnaceOffSet()
    end

    if self.SingActionInProgress then
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(false)
        self.cancelBuyButton.enable = true
        self.cancelBuyButton:setVisible(true)
        return 
    elseif self.ActionInProgress then 
        self.buyCartButton.enable = false
    end
    
    self:updateTotal()
end

function AnvilUI:doDrawCartItem(y, item, alt)
    local baseItemDY = 0
    if item.item.name then
        baseItemDY = self.SMALL_FONT_HGT
        item.height = self.itemheight + baseItemDY 
    end

    if y + self:getYScroll() >= self.height then return y + item.height end
    if y + item.height + self:getYScroll() <= 0 then return y + item.height end

    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), item.height - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), item.height - 1, 0.3, 0.7, 0.35, 0.15);
    end

    self:drawText(item.item.name, 40, y + 10, 1, 1, 1, a, UIFont.Small);

    if item.item.invItem or item.item.texture then
        local texture = item.item.texture
        if not texture then
            texture = item.item.invItem:getTex()
        end
        self:drawTextureScaledAspect(texture, 6, y+5, 30, 30, 1, 1, 1, 1)
    end

    self:drawTextureScaledAspect(removeBtn.texture, self.parent.removeButtonX + 35, y + 10, removeBtn.scale, removeBtn.scale, 1, 1, 1, 1)

    return y + item.height;
end

function AnvilUI:onMouseMove(dx, dy)
    self.mouseOver = true;
	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
	end
    if AnvilUI.instance.panel.activeView.view.furnaceItems:isMouseOver() then return end
    if AnvilUI.instance.cartItems:isMouseOver() then return end
    AnvilUI.instance:toggleTooltip(false)
end

function AnvilUI:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self,x, y)
end

function AnvilUI:onMouseDownCartItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
	if self.selectedRow then
        local selectedRow = self.items[self.selectedRow]
        if not selectedRow then return end
        if self.removeBtn then
		    AnvilUI.instance:removeFromCart(selectedRow)
        end
    end
end

local currentTooltip = nil
local invTooltip = nil
local itemPackTooltip = nil
function AnvilUI:toggleTooltip(show,item)
    if item then
        if item.invItem then
            if not invTooltip then
                invTooltip = ISToolTipInv:new(item.invItem)
            end
            currentTooltip = invTooltip
            item = item.invItem
            if itemPackTooltip then
                itemPackTooltip:removeFromUIManager()
                itemPackTooltip:setVisible(false)
            end
        else
            if not itemPackTooltip then
                itemPackTooltip = AnvilUITooltip:new();
            end
            if invTooltip then
                invTooltip:removeFromUIManager()
                invTooltip:setVisible(false)
            end
            currentTooltip = itemPackTooltip
        end
        currentTooltip:initialise();
        currentTooltip:addToUIManager()
        currentTooltip:setItem(item);
        currentTooltip:setOwner(self)
        currentTooltip:render();
        currentTooltip:setVisible(true)  
    end
    if not show and currentTooltip then
        currentTooltip:removeFromUIManager()
        currentTooltip:setVisible(false)
    end
end

function AnvilUI:onMouseMoveCartItem(dx, dy)
    local list = AnvilUI.instance.cartItems
    if not list then return end
    list.selectedRow = nil
    list.removeBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then AnvilUI.instance:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then AnvilUI.instance:toggleTooltip(false) return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then AnvilUI.instance:toggleTooltip(false) return end
    local mouseX = self:getMouseX()
    list.selectedRow = rowIndex
    if mouseX > self.parent.removeButtonX then
        list.removeBtn = true
    end
    if not selectedRow.item.items then AnvilUI.instance:toggleTooltip(false) return end
    AnvilUI.instance:toggleTooltip(true,selectedRow.item)
end

function AnvilUI:createCategories()
    for k,v in pairs(Anvil.Tabs) do 
        local tab = AnvilTabUI:new(0, 0, self.width, self.panel.height - self.panel.tabHeight); 
        tab:initialise();
        tab:setAnchorRight(true)
        tab:setAnchorBottom(true)
        tab:setAnvilUI(AnvilUI.instance)
        tab:setCategoryType(k)
        self.panel:addView(v, tab);
        tab.parent = self;
    end
end

function AnvilUI:getItemInstance(type)
    local item = self.ItemInstanceCache[type]
    if not item then
        item = InventoryItemFactory.CreateItem(type)
        if item then
            self.ItemInstanceCache[type] = item
        end
    end
    return item
end

function AnvilUI:onActivateView()
    local character = self.player
    if not character:getModData().AnvilFavorites then
        character:getModData().AnvilFavorites = {}
    end
    self.lodingSellTab = self.panel.activeView.view
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    local furnaceItems = tab.furnaceItems

    if self.reloadItems then
        furnaceItems:clear() 
    end

    if self.lastTab == Tab.Inject or tabType == Tab.Inject then
        self.cartItems:clear()
    end
    self.lastTab = tabType

    if tabType == Tab.Favorite then
        furnaceItems:clear()
        local AnvilFavorites = character:getModData().AnvilFavorites
        for k,v in pairs(AnvilFavorites) do
            local furnaceItemDef = Anvil.Items[k]
            local item = self:getItemInstance(k)
            if furnaceItemDef then
                v.Fuelprice = furnaceItemDef.Fuelprice
                v.Material1price = furnaceItemDef.Material1price
                v.Material2price = furnaceItemDef.Material2price
                v.Material3price = furnaceItemDef.Material3price
                v.Material4price = furnaceItemDef.Material4price
                v.Material5price = furnaceItemDef.Material5price
            end
            if item then
                v.favorite = true
                v.type = k
                if not v.items then
                    v.invItem = item
                else
                    v.texture = item:getTex()
                end
                v.name = Furnacefunction.trimString(item:getName(),42)
                furnaceItems:addItem(k,v);
            else
                character:getModData().AnvilFavorites[k] = nil
            end
        end
        self.furnaceItemsCache[tabType] = furnaceItems.items
        return  
    end

    if furnaceItems.count > 0 then return end

    if not self.reloadItems then
        if self.furnaceItemsCache[tabType] then furnaceItems.items = self.furnaceItemsCache[tabType] return end
    end
    
    for k,v in pairs(Anvil.Items) do
        if v and (v.tab == tabType or tabType == Tab.All) then 
            local item = self:getItemInstance(k)
            if item then
                v.favorite = character:getModData().AnvilFavorites[k]
                v.type = k
                if not v.items then
                    v.invItem = item
                else
                    v.texture = item:getTex()
                end
                v.name = Furnacefunction.trimString(item:getName(),42)
                furnaceItems:addItem(k,v);
            end
        end
    end
    self.furnaceItemsCache[tabType] = furnaceItems.items
    self.reloadItems = false 
end

function AnvilUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 120
    local y = 90

    FurnaceOnImg = Furnace.textures.FurnaceOn
    FurnaceOffImg = Furnace.textures.FurnaceOff
    FuelImg = Material.MaterialTexture.Fuel
    Material1Img = Material.MaterialTexture.Material1
    Material2Img = Material.MaterialTexture.Material2
    Material3Img = Material.MaterialTexture.Material3
    Material4Img = Material.MaterialTexture.Material4
    Material5Img = Material.MaterialTexture.Material5

    local FurnaceStateTextY = y+390
    self.FurnaceStateLabel = ISLabel:new(x+330, FurnaceStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceState, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceStateLabel:setVisible(true)
    self:addChild(self.FurnaceStateLabel);
    local textWidthFurnaceState = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.FurnaceState)
    local rightXFurnaceState = self.FurnaceStateLabel:getX() + textWidthFurnaceState

    self.FurnaceStateOnLabel = ISLabel:new(rightXFurnaceState+10, FurnaceStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceStateON, 1, 0, 0, 1, UIFont.Medium, true)
    self.FurnaceStateOnLabel:setVisible(false)
    self:addChild(self.FurnaceStateOnLabel);

    self.FurnaceStateOffLabel = ISLabel:new(rightXFurnaceState+10, FurnaceStateTextY, FurnaceUI.MEDIUM_FONT_HGT, FurnaceUIText.FurnaceStateOFF, 1, 1, 1, 1, UIFont.Medium, true)
    self.FurnaceStateOffLabel:setVisible(true)
    self:addChild(self.FurnaceStateOffLabel);

    local MakingTimeY = y+360
    self.MakingTimeLabel = ISLabel:new(x+330, MakingTimeY, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.MakingTime, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MakingTimeLabel);
    local textWidthMakingTime = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.MakingTime)
    local rightXMakingTime = self.MakingTimeLabel:getX() + textWidthMakingTime

    self.MakingTimeValueLabel = ISLabel:new(rightXMakingTime+10, MakingTimeY, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MakingTimeValueLabel);
    
    local MeltingY = y-50
    local MelitngIncrementY = 25
    self.MeltingMatrialLabel = ISLabel:new(x+310, MeltingY, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.MeltingMatrial, 1, 1, 1, 1, UIFont.Medium, true)
    local textWidthMeltingMatrial = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.MeltingMatrial)
    local rightXMeltingMatrial = self.MeltingMatrialLabel:getX() + textWidthMeltingMatrial
    self:addChild(self.MeltingMatrialLabel);

    local MeltingX = rightXMeltingMatrial + 10
    local MeltingX2 = rightXMeltingMatrial + 10
    local MelitngIncrementX = 85

    self.MeltingFuelTex = ISImage:new(MeltingX, MeltingY, 0, 0, FuelImg.texture);
    self.MeltingFuelTex.scaledWidth = FuelImg.scale+5
    self.MeltingFuelTex.scaledHeight = FuelImg.scale+5
    self:addChild(self.MeltingFuelTex);

    self.MeltingFuelLabel = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingFuelLabel);
    MeltingX = MeltingX + MelitngIncrementX

    self.MeltingMaterial1Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material1Img.texture)
    self.MeltingMaterial1Tex.scaledWidth = Material1Img.scale+5
    self.MeltingMaterial1Tex.scaledHeight = Material1Img.scale+5
    self:addChild(self.MeltingMaterial1Tex);

    self.MeltingMaterial1Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial1Label);
    MeltingX = MeltingX + MelitngIncrementX

    self.MeltingMaterial2Tex = ISImage:new(MeltingX, MeltingY, 0, 0, Material2Img.texture);
    self.MeltingMaterial2Tex.scaledWidth = Material2Img.scale+5
    self.MeltingMaterial2Tex.scaledHeight = Material2Img.scale+5
    self:addChild(self.MeltingMaterial2Tex);

    self.MeltingMaterial2Label = ISLabel:new(MeltingX+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial2Label);
    MeltingY = MeltingY + MelitngIncrementY

    self.MeltingMaterial3Tex = ISImage:new(MeltingX2, MeltingY, 0, 0, Material3Img.texture);
    self.MeltingMaterial3Tex.scaledWidth = Material3Img.scale+5
    self.MeltingMaterial3Tex.scaledHeight = Material3Img.scale+5
    self:addChild(self.MeltingMaterial3Tex);

    self.MeltingMaterial3Label = ISLabel:new(MeltingX2+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial3Label);
    MeltingX2 = MeltingX2 + MelitngIncrementX

    self.MeltingMaterial4Tex = ISImage:new(MeltingX2, MeltingY, 0, 0, Material4Img.texture);
    self.MeltingMaterial4Tex.scaledWidth = Material4Img.scale+5
    self.MeltingMaterial4Tex.scaledHeight = Material4Img.scale+5
    self:addChild(self.MeltingMaterial4Tex);

    self.MeltingMaterial4Label = ISLabel:new(MeltingX2+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial4Label);
    MeltingX2 = MeltingX2 + MelitngIncrementX

    self.MeltingMaterial5Tex = ISImage:new(MeltingX2, MeltingY, 0, 0, Material5Img.texture);
    self.MeltingMaterial5Tex.scaledWidth = Material5Img.scale+5
    self.MeltingMaterial5Tex.scaledHeight = Material5Img.scale+5
    self:addChild(self.MeltingMaterial5Tex);

    self.MeltingMaterial5Label = ISLabel:new(MeltingX2+25, MeltingY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.MeltingMaterial5Label);

    local RequireX = x+390
    local RequireY = y+265
    local RequireY2 = y+265
    local RequireXIncrementX = 85
    local RequireYIncrementY = 30
    self.RequireLabel = ISLabel:new(RequireX-60, RequireY, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.Require, 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireLabel);

    self.RequireFuelTex = ISImage:new(RequireX, RequireY, 0, 0, FuelImg.texture);
    self.RequireFuelTex.scaledWidth = FuelImg.scale+5
    self.RequireFuelTex.scaledHeight = FuelImg.scale+5
    self:addChild(self.RequireFuelTex);

    self.RequireFuelLabel = ISLabel:new(RequireX+25, RequireY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireFuelLabel);
    RequireY = RequireY + RequireYIncrementY

    self.RequireMaterial1Tex = ISImage:new(RequireX, RequireY, 0, 0, Material1Img.texture);
    self.RequireMaterial1Tex.scaledWidth = Material1Img.scale+5
    self.RequireMaterial1Tex.scaledHeight = Material1Img.scale+5
    self:addChild(self.RequireMaterial1Tex);

    self.RequireMaterial1Label = ISLabel:new(RequireX+25, RequireY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireMaterial1Label);
    RequireY = RequireY + RequireYIncrementY

    self.RequireMaterial2Tex = ISImage:new(RequireX, RequireY, 0, 0, Material2Img.texture);
    self.RequireMaterial2Tex.scaledWidth = Material2Img.scale+5
    self.RequireMaterial2Tex.scaledHeight = Material2Img.scale+5
    self:addChild(self.RequireMaterial2Tex);

    self.RequireMaterial2Label = ISLabel:new(RequireX+25, RequireY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireMaterial2Label);
    RequireX = RequireX + RequireXIncrementX

    self.RequireMaterial3Tex = ISImage:new(RequireX, RequireY2, 0, 0, Material3Img.texture);
    self.RequireMaterial3Tex.scaledWidth = Material3Img.scale+5
    self.RequireMaterial3Tex.scaledHeight = Material3Img.scale+5
    self:addChild(self.RequireMaterial3Tex);

    self.RequireMaterial3Label = ISLabel:new(RequireX+25, RequireY2+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireMaterial3Label);
    RequireY2 = RequireY2 + RequireYIncrementY

    self.RequireMaterial4Tex = ISImage:new(RequireX, RequireY2, 0, 0, Material4Img.texture);
    self.RequireMaterial4Tex.scaledWidth = Material4Img.scale+5
    self.RequireMaterial4Tex.scaledHeight = Material4Img.scale+5
    self:addChild(self.RequireMaterial4Tex);

    self.RequireMaterial4Label = ISLabel:new(RequireX+25, RequireY2+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireMaterial4Label);
    RequireY2 = RequireY2 + RequireYIncrementY

    self.RequireMaterial5Tex = ISImage:new(RequireX, RequireY2, 0, 0, Material5Img.texture);
    self.RequireMaterial5Tex.scaledWidth = Material5Img.scale+5
    self.RequireMaterial5Tex.scaledHeight = Material5Img.scale+5
    self:addChild(self.RequireMaterial5Tex);

    self.RequireMaterial5Label = ISLabel:new(RequireX+25, RequireY2+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.RequireMaterial5Label);

    local th = self:titleBarHeight();
    self.panel = ISTabPanel:new(0, th, self.width, self.height-10);
    self.panel:initialise();
    self.panel:setAnchorRight(true)
    self.panel:setAnchorBottom(true)
    self.panel.borderColor = { r = 0, g = 0, b = 0, a = 0};
    self.panel.onActivateView = self.onActivateView;
    self.panel.target = self;
    self.panel:setEqualTabWidth(false)
    self:addChild(self.panel);
    self:createCategories()
    self:activateFirstTab() 

    self.cartItems = ISScrollingListBox:new(x+320, y-1, 310, 251); 
    self.cartItems.backgroundColor = {r = 16/255, g = 16/255, b = 16/255, a = 1};

    self.cartItems:initialise();
    self.cartItems:instantiate();
    self.cartItems:setAnchorRight(false)
    self.cartItems:setAnchorBottom(true)
    self.cartItems.font = UIFont.NewSmall;
    self.cartItems.itemheight = 2 + self.MEDIUM_FONT_HGT  + 4;
    self.cartItems.selected = 1;
    self.cartItems.joypadParent = self;
    self.cartItems.drawBorder = false;
    self.cartItems.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.cartItems.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self.cartItems.doDrawItem = AnvilUI.doDrawCartItem;
    self.cartItems.onMouseMove = AnvilUI.onMouseMoveCartItem;
    self.cartItems.onMouseDown = AnvilUI.onMouseDownCartItem;
    self:addChild(self.cartItems);

    self.buyCartButton = ISButton:new(x+330, y+446, 80,25,FurnaceUIText.BuyCart,self, AnvilUI.buyCartBtn); 
    self.buyCartButton:initialise()
    self.buyCartButton.enable = false
    self.buyCartButton:setVisible(true)
    self:addChild(self.buyCartButton);

    self.cancelBuyButton = ISButton:new(x+330, y+446, 80,25,FurnaceUIText.Cancel,self, AnvilUI.cancelBuyBtn);
    self.cancelBuyButton:initialise()
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    self:addChild(self.cancelBuyButton);   
    
    self.clearCartButton = ISButton:new(x+425, y+446, 80,25,FurnaceUIText.ClearCart,self, AnvilUI.clearCartBtn);
    self.clearCartButton:initialise()
    self:addChild(self.clearCartButton);

end

function AnvilUI:activateFirstTab()
    for k,v in pairs(Anvil.Tabs) do 
        self.panel:activateView(v)
        break;
    end
end

function AnvilUI:removeFromCart(selectedRow)
    if self.ActionInProgress then return end
    self:toggleTooltip(false)
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    if tabType == Tab.Inject then
        tab.furnaceItems:addItem(selectedRow.text,selectedRow.item)
    end
    self.cartItems:removeItem(selectedRow.text)

end

function AnvilUI:clearCartBtn()
    if self.ActionInProgress then return end
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    if tabType == Tab.Inject then
        for k,v in pairs(self.cartItems.items) do
            tab.furnaceItems:addItem(v.item.type,v.item)
        end
    end
    self.cartItems:clear()
end

function AnvilUI:cancelBuyBtn()
    local tabType = self.panel.activeView.view.tabType
    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then return end
    if not (currentAction.Type == "AnvilMakeAction" or currentAction.Type == "FurnaceInjectAction") then return end
    currentAction.action:forceStop()
end

function AnvilUI:buyCartBtn()
    self.ActionInProgress = true
    self.SingActionInProgress = true
    sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
    local ticket = {}
    ticket.Fuel = self.totalFuel
    ticket.Material1 = self.totalMaterial1
    ticket.Material2 = self.totalMaterial2
    ticket.Material3 = self.totalMaterial3
    ticket.Material4 = self.totalMaterial4
    ticket.Material5 = self.totalMaterial5
    local ChangeMaxTime = self.ChangeMaxTime
    local action = AnvilMakeAction:new(self.player,self,ticket,ChangeMaxTime,self.CheckFurnace);
    ISTimedActionQueue.add(action);
    self.buyCartButton.enable = false
    self.buyCartButton:setVisible(false)
    self.cancelBuyButton.enable = true
    self.cancelBuyButton:setVisible(true)
end

function AnvilUI:render()
    ISCollapsableWindow.render(self);
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if self.SingActionInProgress then
        if not currentAction then 
            self.ActionInProgress = false 
            self.SingActionInProgress = false
            sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
            return 
        end
        if not (currentAction.Type == "AnvilMakeAction" or currentAction.Type == "FurnaceInjectAction") then 
            self.ActionInProgress = false 
            self.SingActionInProgress = false
            sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
            return 
        end
        self:drawProgressBar(400, 70, 70, 10, currentAction.action:getJobDelta(), self.fgBar)
    end
end

function AnvilUI:updateTotal()
    local tabType = self.panel.activeView.view.tabType
    local totalFuel = 0
    local totalMaterial1 = 0
    local totalMaterial2 = 0
    local totalMaterial3 = 0
    local totalMaterial4 = 0
    local totalMaterial5 = 0
    local MakingTime = 0

    self.RequireFuelLabel:setName(""..totalFuel)
    self.RequireMaterial1Label:setName(""..totalMaterial1)
    self.RequireMaterial2Label:setName(""..totalMaterial2)
    self.RequireMaterial3Label:setName(""..totalMaterial3)
    self.RequireMaterial4Label:setName(""..totalMaterial4)
    self.RequireMaterial5Label:setName(""..totalMaterial5)
    self.MakingTimeValueLabel:setName(""..(MakingTime/50).." "..FurnaceUIText.Sec)
    
    for k,v in pairs(self.cartItems.items) do
        if v.item.Fuelprice then
            local Fuelcost = v.item.Fuelprice
            local Levelcost = Furnacefunction.Smithing(v.item.Fuelprice, self.SmithingLevel, "Make")
            totalFuel = totalFuel + Fuelcost - Levelcost
        end
        if v.item.Material1price then
            local Material1cost = v.item.Material1price
            local Levelcost = Furnacefunction.Smithing(v.item.Material1price, self.SmithingLevel, "Make")
            totalMaterial1 = totalMaterial1 + Material1cost - Levelcost
        end
        if v.item.Material2price then
            local Material2cost = v.item.Material2price
            local Levelcost = Furnacefunction.Smithing(v.item.Material2price, self.SmithingLevel, "Make")
            totalMaterial2 = totalMaterial2 + Material2cost - Levelcost
        end
        if v.item.Material3price then
            local Material3cost = v.item.Material3price
            local Levelcost = Furnacefunction.Smithing(v.item.Material3price, self.SmithingLevel, "Make")
            totalMaterial3 = totalMaterial3 + Material3cost - Levelcost
        end
        if v.item.Material4price then
            local Material4cost = v.item.Material4price
            local Levelcost = Furnacefunction.Smithing(v.item.Material4price, self.SmithingLevel, "Make")
            totalMaterial4 = totalMaterial4 + Material4cost - Levelcost
        end
        if v.item.Material5price then
            local Material5cost = v.item.Material5price
            local Levelcost = Furnacefunction.Smithing(v.item.Material5price, self.SmithingLevel, "Make")
            totalMaterial5 = totalMaterial5 + Material5cost - Levelcost
        end
        local BaseTime = SandboxVars.Furnace.BaseTime
        if v.item.Time then
            local Timecost = (v.item.Time + BaseTime) * 50
            LevelTiemcost = Furnacefunction.MaxTimeCalculations(Timecost, self.SmithingLevel)
            MakingTime = MakingTime + Timecost - LevelTiemcost
        elseif not v.item.items then
            MakingTime = MakingTime + (BaseTime * 50) 
        end
    end

    if totalFuel > 0 then
        local totalFuelFormat = Material.format(totalFuel)
        self.RequireFuelLabel:setName(""..totalFuelFormat)
    end
    if totalMaterial1 > 0 then
        local totalMaterial1Format = Material.format(totalMaterial1)
        self.RequireMaterial1Label:setName(""..totalMaterial1Format)
    end
    if totalMaterial2 > 0 then
        local totalMaterial2Format = Material.format(totalMaterial2)
        self.RequireMaterial2Label:setName(""..totalMaterial2Format)
    end
    if totalMaterial3 > 0 then
        local totalMaterial3Format = Material.format(totalMaterial3)
        self.RequireMaterial3Label:setName(""..totalMaterial3Format)
    end
    if totalMaterial4 > 0 then
        local totalMaterial4Format = Material.format(totalMaterial4)
        self.RequireMaterial4Label:setName(""..totalMaterial4Format)
    end
    if totalMaterial5 > 0 then
        local totalMaterial5Format = Material.format(totalMaterial5)
        self.RequireMaterial5Label:setName(""..totalMaterial5Format)
    end
    if MakingTime > 0 then
        self.MakingTimeValueLabel:setName(""..(MakingTime/50).." "..FurnaceUIText.Sec)
    end

    self.cancelBuyButton.enable = false
    self.cancelBuyButton:setVisible(false)

    self.totalFuel = totalFuel
    self.totalMaterial1 = totalMaterial1
    self.totalMaterial2 = totalMaterial2
    self.totalMaterial3 = totalMaterial3
    self.totalMaterial4 = totalMaterial4
    self.totalMaterial5 = totalMaterial5
    self.ChangeMaxTime = MakingTime

    if totalFuel == 0 and totalMaterial1 == 0 and totalMaterial2 == 0 and totalMaterial3 == 0 and totalMaterial4 == 0 and totalMaterial5 == 0 then
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(true) 
        return 
    end
    if self.ActionInProgress then return end
    local username = self.player:getUsername()
    local MeltingFuel, MeltingMaterial1, MeltingMaterial2, MeltingMaterial3, MeltingMaterial4, MeltingMaterial5 = FIvnt.getUserMelting(self.CheckFurnace)
    if MeltingFuel >= totalFuel and MeltingMaterial1 >= totalMaterial1 and MeltingMaterial2 >= totalMaterial2 and MeltingMaterial3 >= totalMaterial3 and MeltingMaterial4 >= totalMaterial4 and MeltingMaterial5 >= totalMaterial5 and self.FurnaceState and not self.SingActionInProgress then
        self.buyCartButton.enable = true
        self.buyCartButton:setVisible(true)
        self.cancelBuyButton.enable = false
        self.cancelBuyButton:setVisible(false)
    elseif not self.FurnaceState then
        self.buyCartButton.enable = false
        self.buyCartButton:setVisible(true)
        self.cancelBuyButton.enable = false
        self.cancelBuyButton:setVisible(false)
    end
end

function AnvilUI:FurnaceOnSet()
    self.FurnaceStateOnLabel:setVisible(true)
    self.FurnaceStateOffLabel:setVisible(false)
end

function AnvilUI:FurnaceOffSet()
    self.FurnaceStateOnLabel:setVisible(false)
    self.FurnaceStateOffLabel:setVisible(true)
end


function AnvilUI:close()
	ISCollapsableWindow.close(self);
    self:removeFromUIManager()
end

function AnvilUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2)-500;
        y = (getCore():getScreenHeight() / 2) - (height / 2)-140;
    end
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    o.title = FurnaceUIText.AnvilUITitle;
    o.player = player
    o.resizable = false;
    return o
end