local gfx <const> = playdate.graphics

Ball = {}
Ball.__index = Ball

function Ball:new(r)
  local self = {}

  local angle = 0
  local radius = r

  local sprite = gfx.sprite.new()
  local function updateImageSize()
    sprite:setImage(gfx.image.new(radius*2, radius*2))
  end
  updateImageSize()

  function self:getPos()
    return sprite.x, sprite.y
  end

  function self:setPos(x, y)
    sprite:moveTo(x, y)
  end

  function self:setRadius(r)
    radius = r
    updateImageSize()
    self:draw()
  end

  function self:setSpeed(s)
    angle += s
    if angle >= 360 then angle = angle - 360 end
    if angle < 0 then angle = angle + 360 end
    self:draw()
  end

  function self:draw()
    local image = sprite:getImage()
    local crankRads = math.rad(angle)
    local x = math.sin(crankRads)
    local y = -1 * math.cos(crankRads)

    local halfRad = radius/2
    x = (halfRad * x) + radius
    y = (halfRad * y) + radius

    gfx.pushContext(image)
      gfx.setColor(gfx.kColorBlack)
      gfx.fillCircleAtPoint(radius, radius, radius)
      gfx.setColor(gfx.kColorWhite)
      gfx.fillCircleAtPoint(x, y, halfRad)
    gfx.popContext()
  end

  self:draw()
  sprite:add()

  return self
end
