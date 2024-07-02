import 'global'
import 'fontcache'
import 'menu'
import 'game'

local gfx <const> = playdate.graphics
local displayWidth <const> = playdate.display.getSize()
local versionUI = Textfield:new(displayWidth-30, 10, '0.06a.1')
versionUI:setFont(getFont('ui'))
versionUI:add()

local menu = Menu:new()
local game = Game:new()

function playdate.AButtonUp()
  if gameState == STATE_INIT then
    menu:close()
    game:start()
    gameState = STATE_PLAYING
  elseif gameState == STATE_OVER then
    menu:close()
    game:reset()
    gameState = STATE_PLAYING
  elseif gameState == STATE_PLAYING then
    game:action()
  end
end

function playdate.BButtonUp()
  if gameState == STATE_INIT then
    menu:close()
    game:start()
    gameState = STATE_PLAYING
  elseif gameState == STATE_OVER then
    menu:close()
    game:reset()
    gameState = STATE_PLAYING
  elseif gameState == STATE_PLAYING then
    game:temp()
  end
end

function playdate.update()
  if gameState == STATE_INIT or gameState == STATE_OVER then
    menu:update()
  elseif gameState == STATE_PLAYING then
    game:update()
    if game:isDead() then
      gameState = STATE_OVER
      menu:open()
    end
  end
  gfx.sprite.update()
  playdate.drawFPS(0, 0)
end

menu:open()