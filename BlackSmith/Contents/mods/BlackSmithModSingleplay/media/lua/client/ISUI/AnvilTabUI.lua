AnvilTabUI = ISPanelJoypad:derive("AnvilTabUI");
AnvilTabUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
AnvilTabUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
AnvilTabUI.addButtonX = 350
AnvilTabUI.favoriteButtonX = AnvilTabUI.addButtonX - 25

local addBtn = Furnace.textures.AddButton;

function AnvilTabUI:initialise()
    ISPanelJoypad.initialise(self);
    self:create();
end

function AnvilTabUI:setAnvilUI(instance)
    self.AnvilUI = instance
end

function AnvilTabUI:onFilterChange()
    self.parent:filter()
end

function AnvilTabUI:setCategoryType(tabType)
    self.tabType = tabType
end

function AnvilTabUI:doDrawFurnaceItem(y, item, alt)
    local baseItemDY = 0
    if item.item.name then
        baseItemDY = self.SMALL_FONT_HGT
        item.height = self.itemheight + baseItemDY + 37 
    end
    local favoriteY = y + 33
    if y + self:getYScroll() >= self.height then return y + item.height end
    if y + item.height + self:getYScroll() <= 0 then return y + item.height end

    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), item.height - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), item.height - 1, 0.3, 0.7, 0.35, 0.15);
    end
    
    if not (self.parent.tabType == Tab.Inject) then 
        local alpha = 0.3
        local favTexture = nil
        if item.index == self.selectedRow and not self:isMouseOverScrollBar() and self:isMouseOver() then
            local mouseX = self:getMouseX()
            favTexture = self.parent.favNotCheckedTex
            if mouseX > self.parent.favoriteButtonX and mouseX < (self.parent.favoriteButtonX+15) then 
                favTexture = self.parent.favCheckedTex
                alpha = 1
            end
        end
        if item.item.favorite then
            favTexture = self.parent.favoriteStar
            alpha = 1 
        end
        if favTexture then
            self:drawTexture(favTexture,self.parent.favoriteButtonX,  y + 32,alpha,1,1,1);
        end
    end

    local quantity = ""
    if item.item.quantity then
        quantity = " ("..item.item.quantity..")"
    end
    self:drawText(item.item.name..quantity, 42, y + 10, 1, 1, 1, a, UIFont.Small); 

    local FuelItemImg = Material.MaterialTexture.Fuel
    local Material1ItemImg = Material.MaterialTexture.Material1 
    local Material2ItemImg = Material.MaterialTexture.Material2
    local Material3ItemImg = Material.MaterialTexture.Material3
    local Material4ItemImg = Material.MaterialTexture.Material4
    local Material5ItemImg = Material.MaterialTexture.Material5

    local StartX = 20
    local IncrementX = 60
    if item.item.Fuelprice then
        self:drawTextureScaledAspect(FuelItemImg.texture, StartX, y + 55, FuelItemImg.scale, FuelItemImg.scale, 1, 1, 1, 1)
        self:drawText(""..item.item.Fuelprice, StartX+15, y + 55, 1, 1, 1, a, UIFont.Small);
        StartX = StartX + IncrementX
    end
    if item.item.Material1price then
        self:drawTextureScaledAspect(Material1ItemImg.texture, StartX, y + 55, Material1ItemImg.scale, Material1ItemImg.scale, 1, 1, 1, 1)
        self:drawText(""..item.item.Material1price, StartX+18, y + 55, 1, 1, 1, a, UIFont.Small);
        StartX = StartX + IncrementX
    end
    if item.item.Material2price then
        self:drawTextureScaledAspect(Material2ItemImg.texture, StartX, y + 55, Material2ItemImg.scale, Material2ItemImg.scale, 1, 1, 1, 1)
        self:drawText(""..item.item.Material2price, StartX+18, y + 55, 1, 1, 1, a, UIFont.Small);
        StartX = StartX + IncrementX
    end
    if item.item.Material3price then
        self:drawTextureScaledAspect(Material3ItemImg.texture, StartX, y + 55, Material3ItemImg.scale, Material3ItemImg.scale, 1, 1, 1, 1)
        self:drawText(""..item.item.Material3price, StartX+18, y + 55, 1, 1, 1, a, UIFont.Small);
        StartX = StartX + IncrementX
    end
    if item.item.Material4price then
        self:drawTextureScaledAspect(Material4ItemImg.texture, StartX, y + 55, Material4ItemImg.scale, Material4ItemImg.scale, 1, 1, 1, 1)
        self:drawText(""..item.item.Material4price, StartX+20, y + 55, 1, 1, 1, a, UIFont.Small);
        StartX = StartX + IncrementX
    end
    if item.item.Material5price then
        self:drawTextureScaledAspect(Material5ItemImg.texture, StartX, y + 55, Material5ItemImg.scale, Material5ItemImg.scale, 1, 1, 1, 1)
        self:drawText(""..item.item.Material5price, StartX+20, y + 55, 1, 1, 1, a, UIFont.Small);
        StartX = StartX + IncrementX
    end
    if item.item.Chance then
        self:drawText(FurnaceUIText.Chance.." "..item.item.Chance.." %", 42, y + 32, 1, 1, 1, a, UIFont.Small);
    elseif not item.item.Chance then
        self:drawText(FurnaceUIText.Chance.." 100 %", 42, y + 32, 1, 1, 1, a, UIFont.Small);           
    end
    local BaseTime = SandboxVars.Furnace.BaseTime
    if item.item.Time then
        local MakingTime = item.item.Time
        self:drawText(FurnaceUIText.Time.." "..(BaseTime+MakingTime).." "..FurnaceUIText.Sec, 150, y + 32, 1, 1, 1, a, UIFont.Small);
    elseif not item.item.Time then
        self:drawText(FurnaceUIText.Time.." "..BaseTime.." "..FurnaceUIText.Sec, 150, y + 32, 1, 1, 1, a, UIFont.Small);
    end


    if item.item.invItem or item.item.texture then
        local texture = item.item.texture
        if not texture then
            texture = item.item.invItem:getTex()
        end
        self:drawTextureScaledAspect(texture, 6, y+15, 30, 30, 1, 1, 1, 1) 
    end

    self:drawTextureScaledAspect(addBtn.texture, self.parent.addButtonX, y+28, addBtn.scale, addBtn.scale, 1, 1, 1, 1)

    return y + item.height;
end

function AnvilTabUI:onMouseDownFurnaceItem(x, y)
    ISScrollingListBox.onMouseDown(self,x, y)
	if self.selectedRow then
        local selectedRow = self.items[self.selectedRow]
        if not selectedRow then return end
        if self.favoriteBtn then
            if not (self.parent.tabType == Tab.Inject) then 
                self.parent:manageFavorites(self.selectedRow)
            end
            return
        end
        if self.addBtn then
		    self.parent:addToCart(self.selectedRow)
        end
    end
end

function AnvilTabUI:manageFavorites(selectedRow)
    local item = self.furnaceItems.items[selectedRow].item
    local AnvilFavorites = self.AnvilUI.player:getModData().AnvilFavorites
    local check = not item.favorite
    if check then
        local data = copyTable(item)
        data.name = nil
        data.invItem = nil
        if item.items then
            data.items = item.items
        end
        AnvilFavorites[item.type] = data
    else
        if self.tabType == Tab.Favorite then
            self.furnaceItems:removeItemByIndex(selectedRow)
        end
        AnvilFavorites[item.type] = nil
    end
    item.favorite = check
    self.AnvilUI.reloadItems = true
end

function AnvilTabUI:onMouseMoveFurnaceItem(dx, dy)
    local list = self.parent.furnaceItems
    if not list then return end
    list.selectedRow = nil
    list.favoriteBtn = nil
    list.addBtn = nil
	if list:isMouseOverScrollBar() or not list:isMouseOver() then self.parent.AnvilUI:toggleTooltip(false) return end
	local rowIndex = list:rowAt(list:getMouseX(), list:getMouseY())
    if not rowIndex then self.parent.AnvilUI:toggleTooltip(false) return end
    local selectedRow = list.items[rowIndex]
    if not selectedRow then self.parent.AnvilUI:toggleTooltip(false) return end
    list.selectedRow = rowIndex
    local mouseX = self:getMouseX()
    if mouseX > self.parent.favoriteButtonX and mouseX < (self.parent.favoriteButtonX+20) then
        list.favoriteBtn = true
    end
    if mouseX > self.parent.addButtonX then
        list.addBtn = true
    end
    if not selectedRow.item then self.parent.AnvilUI:toggleTooltip(false) return end
    self.parent.AnvilUI:toggleTooltip(true,selectedRow.item)
end

function AnvilTabUI:prerender()
    self.furnaceItems.doDrawItem = AnvilTabUI.doDrawFurnaceItem;
    self.furnaceItems.onMouseMove = AnvilTabUI.onMouseMoveFurnaceItem;
    self.furnaceItems.onMouseDown = AnvilTabUI.onMouseDownFurnaceItem;
end

function AnvilTabUI:addToCart(selectedRow)
    local item = self.furnaceItems.items[selectedRow]
    if self.AnvilUI.actionInProgress then return end
    self.AnvilUI:toggleTooltip(false)
    self.AnvilUI.cartItems:addItem(item.text,item.item);
    if self.tabType == Tab.Inject then
        self.furnaceItems:removeItemByIndex(selectedRow)
    end
    self.AnvilUI.cartItems:setYScroll(-10000);
end

function AnvilTabUI:filter()
    local filterText = string.trim(self.filterEntry:getInternalText())
    local tabType = self.tabType
    self.furnaceItems.items = self.AnvilUI.furnaceItemsCache[tabType]
    filterText = string.lower(filterText)
    local furnaceItems = self.furnaceItems.items
    self.furnaceItems:clear()
    for k,v in ipairs(furnaceItems) do
        if string.contains(string.lower(v.item.name), filterText) then
            if tabType == Tab.Favorite then
                if v.item.favorite then
                    self.furnaceItems:addItem(v.text,v.item);
                end
            else
                self.furnaceItems:addItem(v.text,v.item);
            end
        end
    end
end

function AnvilTabUI:create()
    local x = 30
    local y = 50

    self.filterLabel = ISLabel:new(x, y-20, 1,FurnaceUIText.Search,1,1,1,1,UIFont.Small, true);
    self:addChild(self.filterLabel);

    local width = (x - getTextManager():MeasureStringX(UIFont.Small, FurnaceUIText.Search)+180); 
    self.filterEntry = ISTextEntryBox:new("", getTextManager():MeasureStringX(UIFont.Small,FurnaceUIText.Search)+40, y-30, width, 1); 
    self.filterEntry:initialise();
    self.filterEntry:instantiate();
    self.filterEntry:setText("");
    self.filterEntry:setClearButton(true);
    self.filterEntry.onTextChange = AnvilTabUI.onFilterChange
    self:addChild(self.filterEntry);
    self.lastText = self.filterEntry:getInternalText();

    self.sortPriceButton = ISButton:new(x+250, y-30, 25,25,"",self, AnvilTabUI.sortPriceBtn); 
    self.sortPriceButton.borderColor.a = 0.0;
    self.sortPriceButton.backgroundColor.a = 0;
    self.sortPriceButton.backgroundColorMouseOver.a = 0;
    self.sortPriceButton:setImage(Furnace.textures.Sort.texture)
    self.sortPriceButton:initialise()
    self.sortPriceButton.enable = true
    self:addChild(self.sortPriceButton);
    
    self.furnaceItems = ISScrollingListBox:new(x, y, 400, 474);
    self.furnaceItems.backgroundColor = {r = 16/255, g = 16/255, b = 16/255, a = 1};
    self.furnaceItems:initialise();
    self.furnaceItems:instantiate();
    self.furnaceItems.font = UIFont.NewSmall;
    self.furnaceItems.itemheight = 2 + self.MEDIUM_FONT_HGT  + 4;
    self.furnaceItems.selected = 0;
    self.furnaceItems.joypadParent = self;
    self.furnaceItems.drawBorder = false;
    self.furnaceItems.SMALL_FONT_HGT = self.SMALL_FONT_HGT
    self.furnaceItems.MEDIUM_FONT_HGT = self.MEDIUM_FONT_HGT
    self:addChild(self.furnaceItems);
end

local function getSortTotalprice(item)
    local total = 0
    total = total + (item.Fuelprice or 0)
    total = total + (item.Material1price or 0)
    total = total + (item.Material2price or 0)
    total = total + (item.Material3price or 0)
    total = total + (item.Material4price or 0)
    total = total + (item.Material5price or 0)
    return total
end

local sortToggle = true
function AnvilTabUI:sortPriceBtn()
    local items = self.furnaceItems.items
    table.sort(items, function(v1,v2) 
        local total1 = getSortTotalprice(v1.item)
        local total2 = getSortTotalprice(v2.item)
        if sortToggle then 
            return total1<total2 
        end return total1>total2
    end)
    self.furnaceItems.items = items
    sortToggle = not sortToggle
end


function AnvilTabUI:new (x, y, width, height)
    local o = {};
    o = ISPanelJoypad:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.favoriteStar = getTexture("media/ui/FavoriteStar.png");
    o.favCheckedTex = getTexture("media/ui/FavoriteStarChecked.png");
    o.favNotCheckedTex = getTexture("media/ui/FavoriteStarUnchecked.png");
    o.favWidth = o.favoriteStar and o.favoriteStar:getWidth() or 13
    o:noBackground();
    self.parent = o;
    return o;
end