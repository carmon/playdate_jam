local gfx <const> = playdate.graphics
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()

class('Map').extends(gfx.sprite)

local image

local x, y = displayWidth/2, displayHeight/4

function Map:init()
  Map.super.init(self)
  self:setIgnoresDrawOffset(true)
  self:moveTo(x,y)
  image = gfx.image.new(displayWidth/3, displayHeight/3)
  self:setImage(image)
end

function Map:setSegments(segments)
  local offsetX, offsetY = gfx.getDrawOffset()
  gfx.pushContext(image)
    local w, h = image:getSize()
    setColor('dark')
    gfx.fillRect(0,0,w,h)
    setColor('light')
    -- local x1, y1, x2, y2 = segments[1]:unpack()
    -- print(x,y,w,h)
    for i = 1, #segments do
      local x1, y1, x2, y2 = segments[i]:unpack()
      print(offsetX, offsetY)
      print(x1/4, y1/4, x2/4, y2/4)
      gfx.drawLine(offsetX+x1/4, offsetY+y1/4, offsetX+x2/4, offsetY+y2/4, 2)

      setColor('light')
    end
  gfx.popContext()
end