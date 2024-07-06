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

function normalizeAngle(a)
  if a >= 360 then a = a - 360 end
  if a < 0 then a = a + 360 end
  return a
end

local angle = 0
function Player:addToAngle(value)
  angle += value
  angle = normalizeAngle(angle)
  self:draw()
end

function Player:draw()
  local image = self:getImage()
  local s = image:getSize()
  local r = s/2
  
  local crankRads = math.rad(angle)
  local x = math.sin(crankRads)
  local y = -1 * math.cos(crankRads)

  x = (r/2 * x) + r
  y = (r/2 * y) + r

  gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillCircleAtPoint(r, r, r)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillCircleAtPoint(x, y, r/2)
  gfx.popContext()
end
