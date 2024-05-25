local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

local images
function Player:init(x, y, r)
  Player.super.init(self)
  self:moveTo(x,y)
  images = gfx.imagetable.new('images/cycle')
  self:setImage(images[1])
end

function Player:update()
  -- print('Player:update')
end
