local gfx <const> = playdate.graphics

class('Pop').extends(gfx.sprite)

local image

local centerX
local centerY
function Pop:init(x, y, w, h)
  Pop.super.init(self)
  self:setIgnoresDrawOffset(true)
  self:moveTo(x,y)
  image = gfx.image.new(w, h)
  centerX = w/2
  centerY = h-10
  self:setImage(image)
end

function normalizeAngle(a)
  if a >= 360 then a = a - 360 end
  if a < 0 then a = a + 360 end
  return a
end

local RADIUS <const> = 30
local angle = 0
function Pop:setAngle(value)
  angle = normalizeAngle(value)
end

function degreesToCoords(angle)
  local crankRads = math.rad(angle)
  local x = math.sin(crankRads)
  local y = -1 * math.cos(crankRads)

  x = (RADIUS * x) + centerX
  y = (RADIUS * y) + centerY

  return x,y
end

function Pop:update()
  gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    local w, h = image:getSize()
    gfx.fillRect(0,0,w,h)

    local x, y = degreesToCoords(angle)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawLine(centerX, centerY, x, y, 2)
  gfx.popContext()
end
