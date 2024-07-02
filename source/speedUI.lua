import 'global'

local gfx <const> = playdate.graphics

local text
local bar

SpeedUI = {}
SpeedUI.__index = SpeedUI

function SpeedUI:new(x, y)
  local self = {}

  local txtImg
  gfx.pushContext()
    gfx.setFont(getFont('ui'))
    txtImg = gfx.imageWithText('Speed [0]', 150, 20)
  gfx.popContext()
  text = gfx.sprite.new(txtImg)
  text:setIgnoresDrawOffset(true)
  text:moveTo(x,y)
  
  bar = gfx.sprite.new(gfx.image.new(350, 5))
  bar:setIgnoresDrawOffset(true)
  bar:moveTo(x,y+15)

  local speed = 0
  function self:getSpeed()
    return speed
  end
  function self:setSpeed(value)
    speed = value
    self:draw()
  end

  function self:draw()
    local txtImg
    gfx.pushContext()
      gfx.setFont(getFont('ui'))
      txtImg = gfx.imageWithText('Speed ['..speed..']', 150, 20)
    gfx.popContext()
    text:setImage(txtImg)
  
    local img = bar:getImage()
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
  
  function self:add()
    text:add()
    bar:add()
  end
  
  function self:remove()
    text:remove()
    bar:remove()
  end

  return self
end




