local fonts = {}
function getFont(t)
  if fonts[t] ~= nil then return fonts[t] end
  if t == 'menu' then
    fonts[t] = playdate.graphics.font.new('font/Parodius Da!')
  elseif t == 'textfield' then
    fonts[t] = playdate.graphics.font.new('font/whiteglove-stroked')
  return fonts[t]
end