local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

local MAX_FRAME = 8

local images
local frame = 1
local targetFrame = 1
function Player:init(r)
  Player.super.init(self)
  images = gfx.imagetable.new('images/cycle')
  self:setImage(images[frame])
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
      self:setImage(images[frame])
    end
  end
end
