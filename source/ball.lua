local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics

Ball = {}
Ball.__index = Ball

function Ball:new()
  local self = {}

  local radius = 25
  local angle = 0

  local image = gfx.image.new(radius*2, radius*2)
  local sprite = gfx.sprite.new()
  gfx.pushContext(image)
    gfx.clear()
    setColor('dark')
    gfx.fillCircleAtPoint(radius, radius, radius)
  gfx.popContext()
  sprite:add()

  function self:getPos()
    return sprite.x, sprite.y
  end

  function self:setSpeed(s)
    angle += s
    if angle >= 360 then angle = angle - 360 end
    if angle < 0 then angle = angle + 360 end
    -- self:draw()
  end

  function self:draw()
    -- local image = sprite:getImage()
    -- local crankRads = math.rad(angle)
    -- local x = math.sin(crankRads)
    -- local y = -1 * math.cos(crankRads)

    -- local halfRad = radius/2
    -- if not slide then
    --   insidePos.x = (halfRad * x) + radius
    --   insidePos.y = (halfRad * y) + radius
    -- end

    
  end

  return self
end
