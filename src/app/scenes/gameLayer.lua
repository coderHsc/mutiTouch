local GameLayer = class("GameLayer", function()
    return display.newScene("GameLayer")
end)

local backList = {}
local kScanle  = 1 
local maxHeight = 0
local maxWidth  = 0
function createTouchableSprite(p)
    local sprite = display.newScale9Sprite(p.image)
    sprite:setContentSize(p.size)

    local cs = sprite:getContentSize()
    local label = cc.ui.UILabel.new({
            UILabelType = 2,
            text = p.label,
            color = p.labelColor})
    label:align(display.CENTER)
    label:setPosition(cs.width / 2, label:getContentSize().height)
    sprite:addChild(label)
    sprite.label = label

    return sprite
end

function drawBoundingBox(parent, target, color)
    local cbb = target:getCascadeBoundingBox()
    local left, bottom, width, height = cbb.origin.x, cbb.origin.y, cbb.size.width, cbb.size.height
    local points = {
        {left, bottom},
        {left + width, bottom},
        {left + width, bottom + height},
        {left, bottom + height},
        {left, bottom},
    }
    local box = display.newPolygon(points, {borderColor = color})
    parent:addChild(box, 1000)
end

function GameLayer:began(event)
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

function GameLayer:pointDistance(x1,y1,x2,y2)

    return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)
end

function GameLayer:moved(event)
    local pointCnt = table.nums(event.points)

    if pointCnt == 1 then 
        for id, point in pairs(event.points) do
            --for k,v in pairs(backList) do 
                local preX,preY = self.mapLayer:getPosition()

                local nextX = preX+point.x-self.preX_1
                local nextY = preY+point.y-self.preY_1

                self.mapLayer:setPosition(nextX,nextY)
                local minVal = math.abs(maxWidth - display.width)
                -- if nextX >= (k-1)*maxWidth- maxWidth +minVal and nextX <= k*maxWidth - maxWidth then 
                --     self.mapLayer:setPositionX(nextX)
                -- elseif nextX < (k-1)*maxWidth- maxWidth then 
                --     self.mapLayer:setPositionX((k-1)*maxWidth- maxWidth)
                -- elseif nextX > (k-1)*maxWidth + maxWidth then 
                --      self.mapLayer:setPositionX(k*maxWidth - maxWidth )
                -- end

                -- if nextY >= -(maxHeight-display.height) and nextY <= 0 then 
                --     self.mapLayer:setPositionY(nextY)
                -- elseif nextY < -(maxHeight-display.height) then 
                --     self.mapLayer:setPositionY(-(maxHeight-display.height))
                -- elseif nextY > 0 then 
                --     self.mapLayer:setPositionY(0)
                -- end
            --end
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

        self.mapLayer:setScale(kScanle)

    end

end

function GameLayer:touch(event)

    -- event.name 是触摸事件的状态：began, moved, ended, cancelled, added（仅限多点触摸）, removed（仅限多点触摸）
    -- event.points 包含所有触摸点，按照 events.point[id] = {x = ?, y = ?} 的结构组织
    local str = {}
    for id, point in pairs(event.points) do
        str[table.nums(str) + 1] = string.format("id: %s, x: %0.2f, y: %0.2f", point.id, point.x, point.y)
    end 
    local pointsCount =table.nums(str)
    table.sort(str)
    self.labelPoints:setString(table.concat(str, "\n"))

    if event.name == "began" or event.name == "added" then
        self:began(event)
        self.touchIndex = self.touchIndex + 1
        for id, point in pairs(event.points) do
            local cursor = display.newSprite("Cursor.png")
                :pos(point.x, point.y)
                :scale(1.2)
                :addTo(self)
            self.cursors[id] = cursor
        end
       

    elseif event.name == "moved" then
        self:moved(event)
        for id, point in pairs(event.points) do
            local cursor = self.cursors[id]
            local rect = self.sprite:getBoundingBox()
            if cc.rectContainsPoint(rect, cc.p(point.x, point.y)) then
                -- 检查触摸点的位置是否在矩形内
                cursor:setPosition(point.x, point.y)
                cursor:setVisible(true)
            else
                cursor:setVisible(false)
            end
        end
    elseif event.name == "removed" then
        for id, point in pairs(event.points) do
            self.cursors[id]:removeSelf()
            self.cursors[id] = nil
        end
    else
        for _, cursor in pairs(self.cursors) do
            cursor:removeSelf()
        end
        self.cursors = {}
    end

    local label = string.format("sprite: %s , count = %d, index = %d", event.name, pointsCount, self.touchIndex)
    self.sprite.label:setString(label)

    if event.name == "ended" or event.name == "cancelled" then
        self.sprite.label:setString("")
        self.labelPoints:setString("")
    end

    -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
    return true
    
end
function GameLayer:initBackGround()

    local back1 = display.newSprite("back.png")
    back1:setFlippedX(true)
    back1:setAnchorPoint(0,0)
    back1:setScale(kScanle)
    back1:setPosition(0,0)
    self:addChild(back1)
    table.insert(backList,back1)

    local back2 = display.newSprite("back.png")
    back2:setAnchorPoint(0,0)
    back2:setScale(kScanle)
    back2:setPosition(back1:getContentSize().width*kScanle,0)
    self:addChild(back2)
    table.insert(backList,back2)

    maxHeight = (back1:getContentSize().height) * kScanle

    maxWidth  = (back1:getContentSize().width ) * kScanle


    print("xxxxxxxxxxxxxxxxxxx",maxWidth,maxHeight)
end

function GameLayer:ctor()
    
    self.mapLayer = require("app.scenes.MapLayer"):new()

    --print("xxxxxxxxxxxx",mapLayer:getContentSize().width)
    self:addChild(self.mapLayer)

    --self:initBackGround()
    self.cursors = {}
    self.touchIndex = 0

    -- createTouchableSprite() 定义在 includes/functions.lua 中
    self.sprite = createTouchableSprite({
            --image = "WhiteButton.png",
            size = cc.size(display.width, display.height),
            label = "TOUCH ME !",
            labelColor = cc.c3b(255, 0, 0)})
        :pos(display.cx, display.cy)
        :addTo(self)
    drawBoundingBox(self, self.sprite, cc.c4f(0, 1.0, 0, 1.0))

    self.labelPoints = cc.ui.UILabel.new({text = "", size = 24})
    :align(display.CENTER_TOP, display.cx, display.top - 120)
    :addTo(self)

    -- 启用触摸
    self.sprite:setTouchEnabled(true)
    -- 设置触摸模式
    self.sprite:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    -- self.sprite:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点（默认模式）
    -- 添加触摸事件处理函数
    self.sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event) return self:touch(event) end )

    cc.ui.UILabel.new({
        text = "注册多点触摸后，目标将收到所有触摸点的数据\nadded 和 removed 指示触摸点的加入和移除",
        size= 24})
        :align(display.CENTER, display.cx, display.top - 80)
        :addTo(self)
    --
end

function GameLayer:onEnter()
end

function GameLayer:onExit()
end


return GameLayer