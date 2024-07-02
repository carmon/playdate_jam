import 'global'

local gfx <const> = playdate.graphics

class('Pop').extends(gfx.sprite)

local image

local startX
local startY

local speedText
local speedUI

function Pop:init(x, y, w, h)
  Pop.super.init(self)
  self:setIgnoresDrawOffset(true)
  self:moveTo(x,y)
  image = gfx.image.new(w, h)
  startX = 10
  startY = h/2
  self:setImage(image)

  local txtImg
  gfx.pushContext()
    gfx.setFont(getFont('ui'))
    txtImg = gfx.imageWithText('Speed [0]', 150, 20)
  gfx.popContext()
  speedText = gfx.sprite.new(txtImg)
  speedText:setIgnoresDrawOffset(true)
  speedText:moveTo(x,y+h-12)
  
  speedUI = gfx.sprite.new(gfx.image.new(150, 5))
  speedUI:setIgnoresDrawOffset(true)
  speedUI:moveTo(x,y+h)
end

local speed = 0
function Pop:getSpeed()
  return speed
end
function Pop:setSpeed(value)
  speed = value

  local txtImg
  gfx.pushContext()
    gfx.setFont(getFont('ui'))
    txtImg = gfx.imageWithText('Speed ['..value..']', 150, 20)
  gfx.popContext()
  speedText:setImage(txtImg)
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

  local img = speedUI:getImage()
  gfx.pushContext(img)
    local w, h = img:getSize()
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0,0,w,h)
    local x = w/2
    local d = w*(speed/MAX_SPEED)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(x,0,d,h)
  gfx.popContext()
end

function Pop:add()
  Pop.super.add(self)
  speedText:add()
  speedUI:add()
end

function Pop:remove()
  Pop.super.remove(self)
  speedText:remove()
  speedUI:remove()
end
