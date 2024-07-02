local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

local MAX_FRAME = 8

local images
local frame = 1
function Player:init(x, y, r)
  Player.super.init(self)
  self:moveTo(x,y)
  images = gfx.imagetable.new('images/cycle')
  self:setImage(images[frame])
end

function Player:nextFrame()
  frame += 1
  if frame > MAX_FRAME then
    frame = 1
  end
  self:setImage(images[frame])
end

function Player:prevFrame()
  frame -= 1
  if frame == 0 then
    frame = MAX_FRAME
  end
  self:setImage(images[frame])
end

function Player:update()
end
