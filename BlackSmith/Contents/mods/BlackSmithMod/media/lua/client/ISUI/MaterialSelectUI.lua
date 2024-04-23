
MaterialSelectUI = ISCollapsableWindow:derive("MaterialSelectUI");
MaterialSelectUI.instance = nil;
MaterialSelectUI.SMALL_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
MaterialSelectUI.MEDIUM_FONT_HGT = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
local width = 250
local height = 350

function MaterialSelectUI:show(player,furnace,CheckFurnace)
    self.CheckFurnace = CheckFurnace
    local square = player:getSquare()
    posX = square:getX()
    posY = square:getY()
    if MaterialSelectUI.instance==nil then
        MaterialSelectUI.instance = MaterialSelectUI:new (0, 0, width, height, player);
        MaterialSelectUI.instance.furnace = furnace
        MaterialSelectUI.instance:initialise();
        MaterialSelectUI.instance:instantiate();
    end
    MaterialSelectUI.instance.pinButton:setVisible(false)
    MaterialSelectUI.instance.collapseButton:setVisible(false)
    MaterialSelectUI.instance:addToUIManager();
    MaterialSelectUI.instance:setVisible(true);
    return MaterialSelectUI.instance;
end

function MaterialSelectUI:update()
    local player = self.player
    if player:DistTo(posX, posY) > 2 then
        self:close()
    end
    local SelectMaterial = FIvnt.OutputSyncMaterial(self.CheckFurnace)
    self.SelectMaterial = SelectMaterial

    if self.SelectMaterial == "Fuel" then
        self:SelectFuelTextSet()
    elseif self.SelectMaterial == "Material1" then
        self:SelectMaterial1TextSet()
    elseif self.SelectMaterial == "Material2" then
        self:SelectMaterial2TextSet()
    elseif self.SelectMaterial == "Material3" then
        self:SelectMaterial3TextSet()
    elseif self.SelectMaterial == "Material4" then
        self:SelectMaterial4TextSet()
    elseif self.SelectMaterial == "Material5" then
        self:SelectMaterial5TextSet()
    else
        self:SelectNilTextSet()
    end

end

function MaterialSelectUI:createChildren()
    ISCollapsableWindow.createChildren(self);
    local x = 18
    local y = 20
    

    
    local MaterialTextX = x+20
    local MaterialTextY = y+20
    self.SelectText = ISLabel:new(MaterialTextX, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectText, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectText:setVisible(true)
    self:addChild(self.SelectText);
    local textWidthSelectText = getTextManager():MeasureStringX(UIFont.Medium, FurnaceUIText.SelectText)
    local rightXSelectText = self.SelectText:getX() + textWidthSelectText

    self.SelectNilText = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectNilText, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectNilText:setVisible(true)
    self:addChild(self.SelectNilText);

    self.SelectFuelText = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectFuelText, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectFuelText:setVisible(false)
    self:addChild(self.SelectFuelText);

    self.SelectMaterial1Text = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial1Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial1Text:setVisible(false)
    self:addChild(self.SelectMaterial1Text);

    self.SelectMaterial2Text = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial2Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial2Text:setVisible(false)
    self:addChild(self.SelectMaterial2Text);

    self.SelectMaterial3Text = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial3Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial3Text:setVisible(false)
    self:addChild(self.SelectMaterial3Text);

    self.SelectMaterial4Text = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial4Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial4Text:setVisible(false)
    self:addChild(self.SelectMaterial4Text);

    self.SelectMaterial5Text = ISLabel:new(rightXSelectText+10, MaterialTextY, MaterialSelectUI.MEDIUM_FONT_HGT, FurnaceUIText.SelectMaterial5Text, 1, 1, 1, 1, UIFont.Medium, true)
    self.SelectMaterial5Text:setVisible(false)
    self:addChild(self.SelectMaterial5Text);

    local MaterialBtnX = MaterialTextX
    local MaterialBtnY = y+55
    local MaterialBtnYIncrease = 35

    self.SelectFuelButton = ISButton:new(MaterialBtnX, MaterialBtnY, 180,25,FurnaceUIText.SelectFuel,self, MaterialSelectUI.SelectFuelBtn);
    self.SelectFuelButton:initialise()
    self.SelectFuelButton.enable = true
    self.SelectFuelButton:setVisible(true)
    self:addChild(self.SelectFuelButton);
    MaterialBtnY = MaterialBtnY + MaterialBtnYIncrease

    self.SelectMaterial1Button = ISButton:new(MaterialBtnX, MaterialBtnY, 180,25,FurnaceUIText.SelectMaterial1,self, MaterialSelectUI.SelectMaterial1Btn);
    self.SelectMaterial1Button:initialise()
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial1Button:setVisible(true)
    self:addChild(self.SelectMaterial1Button);
    MaterialBtnY = MaterialBtnY + MaterialBtnYIncrease

    self.SelectMaterial2Button = ISButton:new(MaterialBtnX, MaterialBtnY, 180,25,FurnaceUIText.SelectMaterial2,self, MaterialSelectUI.SelectMaterial2Btn);
    self.SelectMaterial2Button:initialise()
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial2Button:setVisible(true)
    self:addChild(self.SelectMaterial2Button);
    MaterialBtnY = MaterialBtnY + MaterialBtnYIncrease

    self.SelectMaterial3Button = ISButton:new(MaterialBtnX, MaterialBtnY, 180,25, FurnaceUIText.SelectMaterial3,self, MaterialSelectUI.SelectMaterial3Btn);
    self.SelectMaterial3Button:initialise()
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial3Button:setVisible(true)
    self:addChild(self.SelectMaterial3Button);
    MaterialBtnY = MaterialBtnY + MaterialBtnYIncrease

    self.SelectMaterial4Button = ISButton:new(MaterialBtnX, MaterialBtnY, 180,25,FurnaceUIText.SelectMaterial4,self, MaterialSelectUI.SelectMaterial4Btn);
    self.SelectMaterial4Button:initialise()
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial4Button:setVisible(true)
    self:addChild(self.SelectMaterial4Button);
    MaterialBtnY = MaterialBtnY + MaterialBtnYIncrease

    self.SelectMaterial5Button = ISButton:new(MaterialBtnX, MaterialBtnY, 180,25,FurnaceUIText.SelectMaterial5,self, MaterialSelectUI.SelectMaterial5Btn);
    self.SelectMaterial5Button:initialise()
    self.SelectMaterial5Button.enable = true
    self.SelectMaterial5Button:setVisible(true)
    self:addChild(self.SelectMaterial5Button);
    MaterialBtnY = MaterialBtnY + MaterialBtnYIncrease

    self.SelectCancelButton = ISButton:new(MaterialBtnX, MaterialBtnY, 180,30,FurnaceUIText.SelectCancel,self, MaterialSelectUI.SelectCancelBtn);
    self:addChild(self.SelectCancelButton);
end

function MaterialSelectUI:SelectCancelBtn()
    self.SelectMaterial = "nil"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectNilTextSet()
end

function MaterialSelectUI:SelectFuelBtn()
    self.SelectMaterial = "Fuel"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectMaterial1TextSet()
end

function MaterialSelectUI:SelectMaterial1Btn()
    self.SelectMaterial = "Material1"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectMaterial1TextSet()
end

function MaterialSelectUI:SelectMaterial2Btn()
    self.SelectMaterial = "Material2"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectMaterial2TextSet()
end

function MaterialSelectUI:SelectMaterial3Btn()
    self.SelectMaterial = "Material3"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectMaterial3TextSet()
end

function MaterialSelectUI:SelectMaterial4Btn()
    self.SelectMaterial = "Material4"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectMaterial4TextSet()
end

function MaterialSelectUI:SelectMaterial5Btn()
    self.SelectMaterial = "Material5"
    sendClientCommand("FIvntS", "InputSyncMaterial", {self.CheckFurnace, self.SelectMaterial})
    self:SelectMaterial5TextSet()
end

function MaterialSelectUI:SelectFuelTextSet()
    self.SelectFuelButton.enable = false
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial5Button.enable = true
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(true)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end
function MaterialSelectUI:SelectMaterial1TextSet()
    self.SelectFuelButton.enable = true
    self.SelectMaterial1Button.enable = false
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial5Button.enable = true
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(true)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end
function MaterialSelectUI:SelectMaterial2TextSet()
    self.SelectFuelButton.enable = true
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial2Button.enable = false
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial5Button.enable = true
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(true)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function MaterialSelectUI:SelectMaterial3TextSet()
    self.SelectFuelButton.enable = true
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial3Button.enable = false
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial5Button.enable = true
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(true)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function MaterialSelectUI:SelectMaterial4TextSet()
    self.SelectFuelButton.enable = true
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial4Button.enable = false
    self.SelectMaterial5Button.enable = true
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(true)
    self.SelectMaterial5Text:setVisible(false)
end

function MaterialSelectUI:SelectMaterial5TextSet()
    self.SelectFuelButton.enable = true
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial5Button.enable = false
    self.SelectNilText:setVisible(false)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(true)
end

function MaterialSelectUI:SelectNilTextSet()
    self.SelectFuelButton.enable = true
    self.SelectMaterial1Button.enable = true
    self.SelectMaterial2Button.enable = true
    self.SelectMaterial3Button.enable = true
    self.SelectMaterial4Button.enable = true
    self.SelectMaterial5Button.enable = true
    self.SelectNilText:setVisible(true)
    self.SelectFuelText:setVisible(false)
    self.SelectMaterial1Text:setVisible(false)
    self.SelectMaterial2Text:setVisible(false)
    self.SelectMaterial3Text:setVisible(false)
    self.SelectMaterial4Text:setVisible(false)
    self.SelectMaterial5Text:setVisible(false)
end

function MaterialSelectUI:close()
	ISCollapsableWindow.close(self);
    self:removeFromUIManager()
end


function MaterialSelectUI:new(x, y, width, height, player)
    local o = {}
    if x == 0 and y == 0 then 
        x = (getCore():getScreenWidth() / 2) - (width / 2)-425;
        y = (getCore():getScreenHeight() / 2) - (height / 2)+320;
    end
    o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = FurnaceUIText.MaterialSelectUITitle;
    o.player = player 
    o.resizable = false;
    return o
end