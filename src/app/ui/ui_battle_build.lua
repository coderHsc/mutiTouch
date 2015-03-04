--
-- Author: Your Name
-- Date: 2015-03-04 20:05:38
--
--
-- Author: Your Name
-- Date: 2015-03-03 21:33:47
--
local Ui_Battle_Build = class("Ui_Battle_Build", function()
    return display.newNode("Ui_Battle_Build")
end)

function Ui_Battle_Build:ctor()
	local testBuild = display.newSprite("build/2600.0.png", 200, 200)
	self:addChild(testBuild)

end

return Ui_Battle_Build