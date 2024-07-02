local gfx <const> = playdate.graphics
local fonts = {}
function getFont(t)
  if fonts[t] ~= nil then return fonts[t] end
  if t == 'title' then
    fonts[t] = gfx.font.new('font/Parodius Da!')
  elseif t == 'ui' then
    fonts[t] = gfx.font.new('font/whiteglove-stroked')
  end
  return fonts[t]
end