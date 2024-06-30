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
  centerX = 10
  centerY = h/2
  self:setImage(image)
end

local RADIUS <const> = 130
local angle = 0
function Pop:setAngle(value)
  angle = value
end

function degreesToCoords(angle)
  local x = math.cos(angle)
  local y = -1 * math.sin(angle)

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
