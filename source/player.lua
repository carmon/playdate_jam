local gfx <const> = playdate.graphics

-- Player should be an instantiable 'ball', not a sprite
class('Player').extends(gfx.sprite)

local MAX_FRAME = 8

function createImgFromR(r)
  local r2 = r*2
  local image = gfx.image.new(r2, r2)
  gfx.pushContext(image)
    setColor('dark')
    gfx.fillCircleAtPoint(r, r, r)
    setColor('light')
    gfx.fillCircleAtPoint(r, r*.707, r/2)
  gfx.popContext()
  return image
end

local frame = 1
local targetFrame = 1
function Player:init(r)
  Player.super.init(self)
  self:setImage(createImgFromR(r))
end

function Player:setRadius(value)
  self:setImage(createImgFromR(value))
end

function Player:drawFrame(f)
  local image = self:getImage()
  local s = image:getSize()
  local r = s/2
  gfx.pushContext(image)
    setColor('dark')
    gfx.fillCircleAtPoint(r, r, r)
    setColor('light')
    if f == 1 then
      gfx.fillCircleAtPoint(r, r*.707, r/2)
    elseif f == 2 then
      gfx.fillCircleAtPoint(r*(2-.707), r*.707, r/2)
    elseif f == 3 then 
      gfx.fillCircleAtPoint(r*(2-.707), r, r/2)
    elseif f == 4 then
      gfx.fillCircleAtPoint(r*(2-.707), r*(2-.707), r/2)
    elseif f == 5 then
      gfx.fillCircleAtPoint(r, r*(2-.707), r/2)
    elseif f == 6 then
      gfx.fillCircleAtPoint(r*.707, r*(2-.707), r/2)
    elseif f == 7 then
      gfx.fillCircleAtPoint(r*.707, r, r/2)
    elseif f == 8 then
      gfx.fillCircleAtPoint(r*.707, r*.707, r/2)
    end
  gfx.popContext()
end

function Player:update()
  if CURRENT_SPEED ~= 0 then
    local coeficient = CURRENT_SPEED/MAX_SPEED
    targetFrame += coeficient
    if targetFrame ~= frame then
      frame = math.floor(targetFrame)
      if frame == 0 then
        frame = MAX_FRAME
        targetFrame = MAX_FRAME
      end
      if frame > MAX_FRAME then
        frame = 1
        targetFrame = 1
      end
      self:drawFrame(frame)
    end
  end
end
