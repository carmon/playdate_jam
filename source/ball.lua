local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics

Ball = {}
Ball.__index = Ball

function Ball:new(x, y)
  local self = {}

  local radius = 25
  local angle = 0

  local dir = geo.point.new(0, 0)
  function self:setDir(x, y)
    dir.x = x
    dir.y = y
  end

  local sprite = gfx.sprite.new(gfx.image.new(radius*2, radius*2))
  gfx.pushContext(sprite:getImage())
    setColor('dark')
    gfx.fillCircleAtPoint(radius, radius, radius)
  gfx.popContext()
  sprite:add()
  sprite:moveTo(x, y)

  function self:getPos()
    return sprite:getPosition()
  end

  function self:update()
    if dir.x == 0 and dir.y == 0 then return end
    sprite:moveTo(sprite.x + (dir.x * 5), sprite.y + (dir.y * 5))
  end

  return self
end
