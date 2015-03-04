--
-- Author: Your Name
-- Date: 2015-03-03 21:33:47
--
local Control_Build = class("Control_Build", function()
    return display.newNode("Control_Build")
end)


local kScanle = 1

function Control_Build:ctor()
  
end

function Control_Build:init(ui_battle_back)
	self.ui_battle_back = ui_battle_back

	self.back_width  = self.ui_battle_back:getContentSize().width 
	self.back_height = self.ui_battle_back:getContentSize().height
	self:setContentSize(self.back_width ,self.back_height)
	--处理触摸事件
    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event) return self:touch(event) end )
end

function Control_Build:touch(event)
    -- event.name 是触摸事件的状态：began, moved, ended, cancelled, added（仅限多点触摸）, removed（仅限多点触摸）
    -- event.points 包含所有触摸点，按照 events.point[id] = {x = ?, y = ?} 的结构组织
    if event.name == "began" or event.name == "added" then
        self:began(event)
    elseif event.name == "moved" then
        self:moved(event)
    elseif event.name == "removed" then
       
    else
       
    end

    -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
    return true

end

function Control_Build:began(event)
    local pointCnt = table.nums(event.points)
    for id, point in pairs(event.points) do
        if id == 0 or id == '0' then 
            self.preX_1 =  point.x
            self.preY_1 =  point.y
        else
            self.preX_2 =  point.x
            self.preY_2 =  point.y
        end
    end
end


function Control_Build:moved(event)

end

return Control_Build