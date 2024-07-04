local gfx <const> = playdate.graphics

Textfield = {}
Textfield.__index = Textfield

function Textfield:new(x, y, field, value)
  local self = gfx.sprite.new()
  self:setIgnoresDrawOffset(true)
  self:moveTo(x,y)

  local drawMode = nil
  function self:setDrawMode(newDrawMode)
    if newDrawMode ~= drawMode then
      drawMode = newDrawMode
      self:updateImage()
    end
  end

  local f = field
  function self:setField(newField)
    if newField ~= f then 
      f = newField
      self:updateImage()
    end
  end
  local v = value
  function self:setValue(newValue)
    -- local round = math.floor(newValue)
    if newValue ~= v then 
      v = newValue
      self:updateImage()
    end
  end

  local MAX_TEXT_W, MAX_TEXT_H = 240, 50
  function self:updateImage()
    local text = ''
    if f ~= '' and f ~= nil then
      text = text..f
      if v ~= '' and v ~= nil then
        text = text..':: '
      end
    end
    if v ~= '' and v ~= nil then
      text = text..v
    end
    if text ~= '' then
      gfx.pushContext()
        if drawMode ~= nil then
          gfx.setImageDrawMode(drawMode)
        end
        local w, h = gfx.getTextSize(text)
        local img = gfx.imageWithText(text, w, h)
      gfx.popContext()
      self:setImage(img)
    end
  end

  self:updateImage()

  return self
end





