local gfx <const> = playdate.graphics

class('Pop').extends(gfx.sprite)

local image

local startX
local startY

function Pop:init(x, y, w, h)
  Pop.super.init(self)
  self:setIgnoresDrawOffset(true)
  self:moveTo(x,y)
  image = gfx.image.new(w, h)
  startX = 10
  startY = h/2
  self:setImage(image)
end

local RADIUS <const> = 130
local angle = 0
function Pop:getAngle()
  return angle
end
function Pop:setAngle(value)
  angle = value
end

function Pop:update()
  gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    local w, h = image:getSize()
    gfx.fillRect(0,0,w,h)

    x = (RADIUS * math.cos(angle)) + startX
    y = (RADIUS * math.sin(angle)) + startY

    gfx.setColor(gfx.kColorWhite)
    gfx.drawLine(startX, startY, x, y, 2)
  gfx.popContext()
end
