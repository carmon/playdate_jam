local gfx <const> = playdate.graphics

local text
local bar

Speedmeter = {}
Speedmeter.__index = Speedmeter

function Speedmeter:new(x, y)
  local self = {}

  local txtImg
  gfx.pushContext()
    txtImg = gfx.imageWithText('Speed', 150, 20)
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
      txtImg = gfx.imageWithText('Speed', 150, 20)
    gfx.popContext()
    text:setImage(txtImg)
  
    local img = bar:getImage()
    gfx.pushContext(img)
      local w, h = img:getSize()
      setColor('light')
      gfx.fillRect(0,0,w,h)
      local x = w/2
      local d = w*(speed/MAX_SPEED)
      setColor('dark')
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




