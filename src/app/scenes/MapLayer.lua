--
-- Author: Your Name
-- Date: 2015-03-03 21:33:47
--
local MapLayer = class("MapLayer", function()
    return display.newNode("MapLayer")
end)


function MapLayer:ctor()

	local back1 = display.newSprite("back.png")
    back1:setFlippedX(true)
    back1:setAnchorPoint(0,0)
    --back1:setScale(kScanle)
    back1:setPosition(0,0)
    self:addChild(back1)
    --table.insert(backList,back1)

    local back2 = display.newSprite("back.png")
    back2:setAnchorPoint(0,0)
    --back2:setScale(kScanle)
    back2:setPosition(back1:getContentSize().width,0)
    self:addChild(back2)
    --table.insert(backList,back2)

    --maxHeight = (back1:getContentSize().height) * kScanle

    --maxWidth  = (back1:getContentSize().width ) * kScanle




end

return MapLayer