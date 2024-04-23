
FurnaceInjectUI = ISCollapsableWindow:derive("FurnaceInjectUI");
FurnaceInjectUI.instance = nil;
FurnaceInjectUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
FurnaceInjectUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
FurnaceInjectUI.removeButtonX = 230
FurnaceInjectUI.furnaceItemsCache = {}
FurnaceInjectUI.totalFuel = 0
FurnaceInjectUI.totalMaterial1 = 0
FurnaceInjectUI.totalMaterial2 = 0
FurnaceInjectUI.totalMaterial3 = 0
FurnaceInjectUI.totalMaterial4 = 0
FurnaceInjectUI.totalMaterial5 = 0
FurnaceInjectUI.reloadItems = false
FurnaceInjectUI.lastTab = "none"
FurnaceInjectUI.ItemInstanceCache = {}
local posX = 0
local posY = 0

local removeBtn = Furnace.textures.RemoveButton;
local width = 770
local height = 520

function FurnaceInjectUI:show(player,furnace,CheckFurnace)

    self.CheckFurnace = CheckFurnace
    local ActionInProgress = FIvnt.OutputSyncActionInProgress(self.CheckFurnace)
    self.ActionInProgress = ActionInProgress

    local square = player:getSquare()
    posX = square:getX()
    posY = square:getY()
    if FurnaceInjectUI.instance==nil then
        FurnaceInjectUI.instance = FurnaceInjectUI:new (0, 0, width, height, player);
        FurnaceInjectUI.instance.furnace = furnace
        FurnaceInjectUI.instance:initialise();
        FurnaceInjectUI.instance:instantiate();
    end
    FurnaceInjectUI.instance.pinButton:setVisible(false)
    FurnaceInjectUI.instance.collapseButton:setVisible(false)
    FurnaceInjectUI.instance:addToUIManager();
    FurnaceInjectUI.instance:setVisible(true);
    return FurnaceInjectUI.instance;
end

function FurnaceInjectUI:update()
    local player = self.player
    if player:DistTo(posX, posY) > 2 then
        self:close()
    end
    local ActionInProgress = FIvnt.OutputSyncActionInProgress(self.CheckFurnace)
    self.ActionInProgress = ActionInProgress

    local Fuel,Material1,Material2,Material3,Material4,Material5 = FIvnt.getUserFIvnt(self.CheckFurnace)
    local FuelFormatted = Material.format(Fuel)
    self.IvntFuelLabel:setName(""..FuelFormatted)
    local Material1Formatted = Material.format(Material1)
    self.IvntMaterial1Label:setName(""..Material1Formatted)
    local Material2Formatted = Material.format(Material2)
    self.IvntMaterial2Label:setName(""..Material2Formatted)
    local Material3Formatted = Material.format(Material3)
    self.IvntMaterial3Label:setName(""..Material3Formatted)
    local Material4Formatted = Material.format(Material4)
    self.IvntMaterial4Label:setName(""..Material4Formatted)
    local Material5Formatted = Material.format(Material5)
    self.IvntMaterial5Label:setName(""..Material5Formatted)

    if self.SingActionInProgress then
        self.InjectCartButton.enable = false
        self.InjectCartButton:setVisible(false)
        self.cancelInjectButton.enable = true
        self.cancelInjectButton:setVisible(true)
        return 
    elseif self.ActionInProgress then 
        self.InjectCartButton.enable = false
    end
    self:updateTotal()
end

function FurnaceInjectUI:doDrawCartItem(y, item, alt)
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

function FurnaceInjectUI:onMouseMove(dx, dy)
    self.mouseOver = true;
	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
	end
    if FurnaceInjectUI.instance.panel.activeView.view.furnaceItems:isMouseOver() then return end
    if FurnaceInjectUI.instance.cartItems:isMouseOver() then return end
    FurnaceInjectUI.instance:toggleTooltip(false)
end

function FurnaceInjectUI:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self,x, y)
end

function FurnaceInjectUI:onMouseDownCartItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
	if self.selectedRow then
        local selectedRow = self.items[self.selectedRow]
        if not selectedRow then return end
        if self.removeBtn then
		    FurnaceInjectUI.instance:removeFromCart(selectedRow)
        end
    end
end

local currentTooltip = nil
local invTooltip = nil
local itemPackTooltip = nil
function FurnaceInjectUI:toggleTooltip(show,item)
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
                itemPackTooltip = FurnaceInjectUITooltip:new();
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

function FurnaceInjectUI:onMouseMoveCartItem(dx, dy)
    local list = FurnaceInjectUI.instance.cartItems
    if not list then return end
    list.selectedRow = nil
    list.removeBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then FurnaceInjectUI.instance:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then FurnaceInjectUI.instance:toggleTooltip(false) return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then FurnaceInjectUI.instance:toggleTooltip(false) return end
    local mouseX = self:getMouseX()
    list.selectedRow = rowIndex
    if mouseX > self.parent.removeButtonX then
        list.removeBtn = true
    end
    if not selectedRow.item.items then FurnaceInjectUI.instance:toggleTooltip(false) return end
    FurnaceInjectUI.instance:toggleTooltip(true,selectedRow.item)
end

function FurnaceInjectUI:createCategories()
    for k,v in pairs(Furnace.Tabs) do 
        local tab = FurnaceInjectTabUI:new(0, 0, self.width, self.panel.height - self.panel.tabHeight);
        tab:initialise();
        tab:setAnchorRight(true)
        tab:setAnchorBottom(true)
        tab:setFurnaceInjectUI(FurnaceInjectUI.instance)
        tab:setCategoryType(k)
        self.panel:addView(v, tab);
        tab.parent = self;
    end
end

function FurnaceInjectUI:getItemInstance(type)
    local item = self.ItemInstanceCache[type]
    if not item then
        item = InventoryItemFactory.CreateItem(type)
        if item then
            self.ItemInstanceCache[type] = item
        end
    end
    return item
end

function FurnaceInjectUI:onActivateView()
    local character = self.player
    self.lodingSellTab = self.panel.activeView.view
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    local furnaceItems = tab.furnaceItems

    if self.reloadItems then
        furnaceItems:clear() 
    end

    if self.lastTab == Tab.Inject or tabType == Tab.Inject and self.cartItems then
        self.cartItems:clear()
    end

    self.lastTab = tabType

    if tabType == Tab.Inject then
        tab.moveAllButton.enable = true
        tab.moveAllButton:setVisible(true)
        furnaceItems:clear()
        
        local inventory = character:getInventory():getItems()
        for i = 0, inventory:size() -1 do
            local item = inventory:get(i)
            local itemType = item:getFullType()
            local itemInject = Furnace.Inject[itemType]
            local isBroken = item:isBroken()
            if not (Furnace.InjectBlacklist and itemInject) then
                if not (item:isEquipped() or item:isFavorite()) then 
                    if not (itemInject and itemInject.blacklisted) then
                        local v = {}
                        v.type = itemType
                        local Fuelprice = Furnace.defaultPrice
                        local Material1price = Furnace.defaultPrice
                        local Material2price = Furnace.defaultPrice
                        local Material3price = Furnace.defaultPrice
                        local Material4price = Furnace.defaultPrice
                        local Material5price = Furnace.defaultPrice
                        if itemInject then
                            v.Fuelprice = itemInject.Fuelprice
                            v.Material1price = itemInject.Material1price
                            v.Material2price = itemInject.Material2price
                            v.Material3price = itemInject.Material3price
                            v.Material4price = itemInject.Material4price
                            v.Material5price = itemInject.Material5price
                            if isBroken then
                                Fuelprice = itemInject.priceBroken or Furnace.defaultPriceBroken
                                Material1price  = itemInject.priceBroken or Furnace.defaultPriceBroken
                                Material2price  = itemInject.priceBroken or Furnace.defaultPriceBroken
                                Material3price  = itemInject.priceBroken or Furnace.defaultPriceBroken
                                Material4price  = itemInject.priceBroken or Furnace.defaultPriceBroken
                                Material5price  = itemInject.priceBroken or Furnace.defaultPriceBroken
                            else
                                Fuelprice = itemInject.Fuelprice or Furnace.defaultPrice
                                Material1price  = itemInject.Material1price or Furnace.defaultPrice
                                Material2price  = itemInject.Material2price or Furnace.defaultPrice
                                Material3price  = itemInject.Material3price or Furnace.defaultPrice
                                Material4price  = itemInject.Material4price or Furnace.defaultPrice
                                Material5price  = itemInject.Material5price or Furnace.defaultPrice
                            end
                        end
                        v.id = item:getID()
                        v.name = item:getName()
                        v.invItem = item
                        if Fuelprice > 0 or Material1price > 0 or Material2price > 0 or Material3price > 0 or Material4price > 0 or Material5price > 0 then
                            if Furnace.SellisWhitelist then 
                                if itemInject then
                                    furnaceItems:addItem(itemType,v);
                                end
                            else
                                furnaceItems:addItem(itemType,v);
                            end
                        end
                    end
                end
            end
        end
        return
    else
        if self.InjectCartButton then
            self.InjectCartButton.enable = false
            self.InjectCartButton:setVisible(true)
        end
    end

    if furnaceItems.count > 0 then return end

    if not self.reloadItems then
        if self.furnaceItemsCache[tabType] then furnaceItems.items = self.furnaceItemsCache[tabType] return end
    end
    
    self.furnaceItemsCache[tabType] = furnaceItems.items
    self.reloadItems = false 
end


function FurnaceInjectUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 120
    local y = 90

    FurnaceOnImg = Furnace.textures.FurnaceOn
    FurnaceOffImg = Furnace.textures.FurnaceOff
    
    
    local IvntY = y-60
    local IvntYIncrementY = 30
    self.IvntLabel = ISLabel:new(x+310, IvntY, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.Invt, 1, 1, 1, 1, UIFont.Medium, true)
    local textWidthIvnt = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.Invt)
    local rightXMeltingIvnt = self.IvntLabel:getX() + textWidthIvnt
    self:addChild(self.IvntLabel);

    local IvntX = rightXMeltingIvnt+10
    local IvntX2 = rightXMeltingIvnt+10
    local IvntYIncrementX = 85

    self.IvntFuelTex = ISImage:new(IvntX, IvntY, 0, 0, FuelImg.texture);
    self.IvntFuelTex.scaledWidth = FuelImg.scale+5
    self.IvntFuelTex.scaledHeight = FuelImg.scale+5
    self:addChild(self.IvntFuelTex);

    self.IvntFuelLabel = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntFuelLabel);
    IvntX = IvntX + IvntYIncrementX

    self.IvntMaterial1Tex = ISImage:new(IvntX, IvntY, 0, 0, Material1Img.texture);
    self.IvntMaterial1Tex.scaledWidth = Material1Img.scale+5
    self.IvntMaterial1Tex.scaledHeight = Material1Img.scale+5
    self:addChild(self.IvntMaterial1Tex);

    self.IvntMaterial1Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial1Label);
    IvntX = IvntX + IvntYIncrementX

    self.IvntMaterial2Tex = ISImage:new(IvntX, IvntY, 0, 0, Material2Img.texture);
    self.IvntMaterial2Tex.scaledWidth = Material2Img.scale+5
    self.IvntMaterial2Tex.scaledHeight = Material2Img.scale+5
    self:addChild(self.IvntMaterial2Tex);

    self.IvntMaterial2Label = ISLabel:new(IvntX+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial2Label);
    IvntY = IvntY + IvntYIncrementY

    self.IvntMaterial3Tex = ISImage:new(IvntX2, IvntY, 0, 0, Material3Img.texture);
    self.IvntMaterial3Tex.scaledWidth = Material3Img.scale+5
    self.IvntMaterial3Tex.scaledHeight = Material3Img.scale+5
    self:addChild(self.IvntMaterial3Tex);

    self.IvntMaterial3Label = ISLabel:new(IvntX2+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial3Label);
    IvntX2 = IvntX2 + IvntYIncrementX

    self.IvntMaterial4Tex = ISImage:new(IvntX2, IvntY, 0, 0, Material4Img.texture);
    self.IvntMaterial4Tex.scaledWidth = Material4Img.scale+5
    self.IvntMaterial4Tex.scaledHeight = Material4Img.scale+5
    self:addChild(self.IvntMaterial4Tex);

    self.IvntMaterial4Label = ISLabel:new(IvntX2+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial4Label);
    IvntX2 = IvntX2 + IvntYIncrementX

    self.IvntMaterial5Tex = ISImage:new(IvntX2, IvntY, 0, 0, Material5Img.texture);
    self.IvntMaterial5Tex.scaledWidth = Material5Img.scale+5
    self.IvntMaterial5Tex.scaledHeight = Material5Img.scale+5
    self:addChild(self.IvntMaterial5Tex);

    self.IvntMaterial5Label = ISLabel:new(IvntX2+25, IvntY+2, FurnaceUI.SMALL_FONT_HGT, "0", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.IvntMaterial5Label);

    local RequireX = x+380
    local RequireY = y+265
    local RequireY2 = y+265
    local RequireXIncrementX = 85
    local RequireYIncrementY = 30
    self.RequireLabel = ISLabel:new(RequireX-60, RequireY, FurnaceUI.SMALL_FONT_HGT, FurnaceUIText.InjectInt, 1, 1, 1, 1, UIFont.Medium, true)
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

    self.cartItems = ISScrollingListBox:new(x+310, y-1, 310, 251); 
    self.cartItems.backgroundColor = {r = 16/255, g = 16/255, b = 16/255, a = 0.9};

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
    self.cartItems.doDrawItem = FurnaceInjectUI.doDrawCartItem;
    self.cartItems.onMouseMove = FurnaceInjectUI.onMouseMoveCartItem;
    self.cartItems.onMouseDown = FurnaceInjectUI.onMouseDownCartItem;
    self:addChild(self.cartItems);

    self.InjectCartButton = ISButton:new(x+315, y+372, 80,25,FurnaceUIText.Inject,self, FurnaceInjectUI.InjectCartBtn);
    self.InjectCartButton:initialise()
    self.InjectCartButton.enable = false
    self.InjectCartButton:setVisible(true)
    self:addChild(self.InjectCartButton);

    self.cancelInjectButton = ISButton:new(x+315, y+372, 80,25,FurnaceUIText.Cancel,self, FurnaceInjectUI.cancelInjectBtn);
    self.cancelInjectButton:initialise()
    self.cancelInjectButton.enable = false
    self.cancelInjectButton:setVisible(false)
    self:addChild(self.cancelInjectButton);     

    self.clearCartButton = ISButton:new(x+410, y+372, 80,25,FurnaceUIText.ClearCart,self, FurnaceInjectUI.clearCartBtn); 
    self.clearCartButton:initialise()
    self:addChild(self.clearCartButton);

end

function FurnaceInjectUI:activateFirstTab()
    for k,v in pairs(Furnace.Tabs) do 
        self.panel:activateView(v)
        break;
    end
end

function FurnaceInjectUI:removeFromCart(selectedRow)
    if self.ActionInProgress then return end
    self:toggleTooltip(false)
    local tab = self.panel.activeView.view
    local tabType = tab.tabType
    if tabType == Tab.Inject then
        tab.furnaceItems:addItem(selectedRow.text,selectedRow.item)
    end
    self.cartItems:removeItem(selectedRow.text)
end

function FurnaceInjectUI:clearCartBtn()
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

function FurnaceInjectUI:cancelInjectBtn()
    local tabType = self.panel.activeView.view.tabType
    if tabType == Tab.Inject then 
        self.InjectCartButton.enable = true
        self.InjectCartButton:setVisible(true)
    end
    self.cancelInjectButton.enable = false
    self.cancelInjectButton:setVisible(false)
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.player)
    local currentAction = actionQueue.queue[1]
    if not currentAction then return end
    if not (currentAction.Type == "AnvilMakeAction" or currentAction.Type == "FurnaceInjectAction") then return end
    currentAction.action:forceStop()
end

function FurnaceInjectUI:InjectCartBtn()
    self.ActionInProgress = true
    self.SingActionInProgress = true
    sendClientCommand("FIvntS", "InputSyncActionInProgress", {self.CheckFurnace, self.ActionInProgress})
    local Check = self.CheckFurnace
    local action = FurnaceInjectAction:new(self.player,self,Check);
    ISTimedActionQueue.add(action);
    self.InjectCartButton.enable = false
    self.InjectCartButton:setVisible(false)
    self.cancelInjectButton.enable = true
    self.cancelInjectButton:setVisible(true)
end

function FurnaceInjectUI:render()
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
    self:drawProgressBar(320, 70, 70, 10, currentAction.action:getJobDelta(), self.fgBar)
    end
end

function FurnaceInjectUI:updateTotal()
    local tabType = self.panel.activeView.view.tabType
    local totalFuel = 0
    local totalMaterial1 = 0
    local totalMaterial2 = 0
    local totalMaterial3 = 0
    local totalMaterial4 = 0
    local totalMaterial5 = 0

    self.RequireFuelLabel:setName(""..totalFuel)
    self.RequireMaterial1Label:setName(""..totalMaterial1)
    self.RequireMaterial2Label:setName(""..totalMaterial2)
    self.RequireMaterial3Label:setName(""..totalMaterial3)
    self.RequireMaterial4Label:setName(""..totalMaterial4)
    self.RequireMaterial5Label:setName(""..totalMaterial5)
    for k,v in pairs(self.cartItems.items) do
        local Fuelcost = v.item.Fuelprice
        local Material1Cost = v.item.Material1price
        local Material2Cost = v.item.Material2price
        local Material3Cost = v.item.Material3price
        local Material4Cost = v.item.Material4price
        local Material5Cost = v.item.Material5price
        if Fuelcost then
            local Fuelcost = v.item.Fuelprice
            totalFuel = totalFuel + Fuelcost
        end
        if Material1Cost then
            totalMaterial1 = totalMaterial1 + Material1Cost
        end
        if Material2Cost then
            totalMaterial2 = totalMaterial2 + Material2Cost
        end
        if Material3Cost then
            totalMaterial3 = totalMaterial3 + Material3Cost
        end
        if Material4Cost then
            totalMaterial4 = totalMaterial4 + Material4Cost
        end
        if Material5Cost then
            totalMaterial5 = totalMaterial5 + Material5Cost
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
    if self.ActionInProgress then return end

    if tabType == Tab.Inject then
        self.InjectCartButton.enable = false
        self.InjectCartButton:setVisible(true)
    end
    self.cancelInjectButton.enable = false
    self.cancelInjectButton:setVisible(false)

    self.totalFuel = totalFuel
    self.totalMaterial1 = totalMaterial1
    self.totalMaterial2 = totalMaterial2
    self.totalMaterial3 = totalMaterial3
    self.totalMaterial4 = totalMaterial4
    self.totalMaterial5 = totalMaterial5
    if totalFuel == 0 and totalMaterial1 == 0 and totalMaterial2 == 0 and totalMaterial3 == 0 and totalMaterial4 == 0 and totalMaterial5 == 0 then return end

    local Fuel,Material1,Material2,Material3,Material4,Material5 = FIvnt.getUserFIvnt(self.CheckFurnace)
    if tabType == Tab.Inject and (totalFuel > 0 or totalMaterial1 > 0 or totalMaterial2 > 0 or totalMaterial3 > 0 or totalMaterial4 > 0 or totalMaterial5 > 0) and not self.SingActionInProgress then 
        self.InjectCartButton.enable = true
        self.InjectCartButton:setVisible(true)
        self.cancelInjectButton.enable = false
        self.cancelInjectButton:setVisible(false)
        return
    end
end

function FurnaceInjectUI:close()
	ISCollapsableWindow.close(self);
    self:removeFromUIManager()
end

function FurnaceInjectUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2)-500;
        y = (getCore():getScreenHeight() / 2) - (height / 2)-115;
    end
    o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    o.fgBar = {r=0, g=0.6, b=0, a=0.7 }
    self.__index = self
    o.title = FurnaceUIText.FurnaceInjectUITitle;
    o.player = player 
    o.resizable = false;
    return o
end
