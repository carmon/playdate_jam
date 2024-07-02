local gfx <const> = playdate.graphics

class('Pop').extends(gfx.sprite)

local image

local startX
local startY
local height
function Pop:init(x, y, w, h)
  Pop.super.init(self)
  self:setIgnoresDrawOffset(true)
  self:moveTo(x,y)
  image = gfx.image.new(w, h)
  startX = 10
  height = h
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

function Pop:draw()
  gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    local w, h = image:getSize()
    gfx.fillRect(0,0,w,h)

    local x = math.cos(angle)
    local y = 1 * math.sin(angle)

    if y < 0 then
      startY = height-10
    else
      startY = 10
    end

    x = (RADIUS * x) + startX
    y = (RADIUS * y) + startY

    gfx.setColor(gfx.kColorWhite)
    gfx.drawLine(startX, startY, x, y, 2)
  gfx.popContext()
end
