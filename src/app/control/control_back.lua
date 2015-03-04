--
-- Author: Your Name
-- Date: 2015-03-03 21:33:47
--
local Control_Back = class("Control_Back", function()
    return display.newNode("Control_Back")
end)


local kScanle = 1

function Control_Back:ctor()
  
end

function Control_Back:init(ui_battle_back)
	self.ui_battle_back = ui_battle_back

	self.back_width  = self.ui_battle_back:getContentSize().width 
	self.back_height = self.ui_battle_back:getContentSize().height
	self:setContentSize(self.back_width ,self.back_height)
	--处理触摸事件
    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event) return self:touch(event) end )
end

function Control_Back:touch(event)
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

function Control_Back:began(event)
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

function Control_Back:pointDistance(x1,y1,x2,y2)
    return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)
end

function Control_Back:moved(event)
    local pointCnt = table.nums(event.points)

    if pointCnt == 1 then 
        for id, point in pairs(event.points) do
            local preX,preY = self.ui_battle_back:getPosition()
            local nextX = preX+point.x-self.preX_1
            local nextY = preY+point.y-self.preY_1

            self.ui_battle_back:setPosition(nextX,nextY)
            local minVal = math.abs(self.back_width/2 - display.width)

            if nextX >= -(self.back_width- display.width )and nextX <= 0 then 
            	self.ui_battle_back:setPositionX(nextX)
            elseif nextX <=  -(self.back_width- display.width ) then 
            	self.ui_battle_back:setPositionX( -(self.back_width- display.width ))
            elseif nextX >= 0 then 
            	self.ui_battle_back:setPositionX(0)
            end

            if nextY >= -(self.back_height-display.height) and nextY <= 0 then 
                self.ui_battle_back:setPositionY(nextY)
            elseif nextY < -(self.back_height-display.height) then 
                self.ui_battle_back:setPositionY(-(self.back_height-display.height))
            elseif nextY > 0 then 
                self.ui_battle_back:setPositionY(0)
            end

            self.preX_1 = point.x
            self.preY_1 = point.y
        end

    elseif pointCnt == 2 then
        local preDistance  = self:pointDistance(self.preX_1,self.preY_1,self.preX_2,self.preY_2)
        local x1,y1,x2,y2
        for id, point in pairs(event.points) do
            if id == '0' then 
                x1 = point.x
                y1 = point.y
                self.preX_1 =  point.x
                self.preY_1 =  point.y
            else
                x2 = point.x
                y2 = point.y
                self.preX_2 =  point.x
                self.preY_2 =  point.y
            end
        end
        local nextDistance = self:pointDistance(x1,y1,x2,y2)

        if nextDistance < preDistance then 
            kScanle  = kScanle - 0.01
        else
            kScanle  = kScanle + 0.01
        end

        -- for k,v in pairs(backList) do
        --     v:setScale(kScanle)

        --     maxHeight = (v:getContentSize().height) * kScanle
        --     maxWidth  = (v:getContentSize().width ) * kScanle
        -- end

        self.ui_battle_back:setScale(kScanle)

    end

end

return Control_Back