local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics

Ball = {}
Ball.__index = Ball

function Ball:new()
  local self = {}

  local radius
  local angle = 0

  local sprite = gfx.sprite.new()
  sprite:add()
  local function updateImageSize()
    sprite:setImage(gfx.image.new(radius*2, radius*2))
  end

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

  local slide = false
  function self:setSlide(v)
    slide = v
    self:draw()
  end
  function self:getSlide()
    return slide
  end

  local insidePos = geo.point.new(0, 0)
  function self:draw()
    local image = sprite:getImage()
    local crankRads = math.rad(angle)
    local x = math.sin(crankRads)
    local y = -1 * math.cos(crankRads)

    local halfRad = radius/2
    if not slide then
      insidePos.x = (halfRad * x) + radius
      insidePos.y = (halfRad * y) + radius
    end

    gfx.pushContext(image)
      gfx.clear()
      if not slide then
        setColor('dark')
        gfx.fillCircleAtPoint(radius, radius, radius)
        setColor('light')
        gfx.fillCircleAtPoint(insidePos.x, insidePos.y, halfRad)
      else
        gfx.setLineWidth(3)
        setColor('dark')
        gfx.drawCircleAtPoint(radius, radius, radius-2)
        gfx.setLineWidth(1)
        gfx.fillCircleAtPoint(insidePos.x, insidePos.y, halfRad)
      end
    gfx.popContext()
  end

  return self
end
