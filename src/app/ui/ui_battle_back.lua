--
-- Author: Your Name
-- Date: 2015-03-03 21:33:47
--
local Ui_Battle_Back = class("Ui_Battle_Back", function()
    return display.newNode("Ui_Battle_Back")
end)

function Ui_Battle_Back:ctor()
	local back1 = display.newSprite("back.png")
    back1:setFlippedX(true)
    back1:setAnchorPoint(0,0)
    back1:setPosition(0,0)
    self:addChild(back1)

    local back2 = display.newSprite("back.png")
    back2:setAnchorPoint(0,0)
    back2:setPosition(back1:getContentSize().width,0)
    self:addChild(back2)

    self:setContentSize(back1:getContentSize().width*2,back1:getContentSize().height)

end

return Ui_Battle_Back