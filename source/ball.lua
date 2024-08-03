local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics

Ball = {}
Ball.__index = Ball

function Ball:new(x, y)
  local self = {}

  local radius = 15
  local angle = 0

  local dir = geo.point.new(0, 0)
  function self:setDir(x, y)
    dir.x = x
    dir.y = y
  end

  local sprite = gfx.sprite.new(gfx.image.new(radius*2, radius*2))
  gfx.pushContext(sprite:getImage())
    setColor('dark')
    gfx.drawCircleAtPoint(radius, radius, radius)
  gfx.popContext() 
  sprite:add()
  sprite:moveTo(x, y)

  function self:isMoving()
    return not (dir.x == 0 and dir.y == 0)
  end

  function self:getPos()
    return sprite:getPosition()
  end

  function self:update()
    if dir.x == 0 and dir.y == 0 then return end
    local xTmp = sprite.x + (dir.x * 5)
    local yTmp = sprite.y + (dir.y * 5)
    -- print('ball:update -> dir ', dir)
    -- print('ball:update -> moveTo ', xTmp, yTmp)
    sprite:moveTo(xTmp, yTmp)
  end

  return self
end
