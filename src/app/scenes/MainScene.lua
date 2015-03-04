
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

    local ui_battle_back = require ("app.ui.ui_battle_back"):new()
    self:addChild(ui_battle_back)

    local control_back =  require("app.control.control_back"):new()
    control_back:init(ui_battle_back)
    self:addChild(control_back)

    local test = require("app.ui.ui_battle_build"):new()
    ui_battle_back:addChild(test)

    local control_build =  require("app.control.control_build"):new()
    control_build:init(ui_battle_back)
    self:addChild(control_build)



end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
