import 'global'
import 'menu'
import 'game'

import 'ui/versiontf'
showVersion()

local game = Game:new()

local menu = Menu:new()
local isMenuOpen = false --don't need this flag inside menu rn

function playdate.AButtonUp()
  if isMenuOpen then
    if menu:canClose() then
      menu:close()
      isMenuOpen = false
      if gameState == STATE_INIT then
        game:start()
      elseif gameState == STATE_OVER then
        game:reset()
      end
      gameState = STATE_PLAYING
    end
  else
    if gameState == STATE_PLAYING then
      game:action()
    end
  end
end

function playdate.BButtonUp()
  if isMenuOpen then
    if menu:canClose() then
      menu:close()
      isMenuOpen = false
      if gameState == STATE_INIT then
        game:start()
      elseif gameState == STATE_OVER then
        game:reset()
      end
      gameState = STATE_PLAYING
    end
  else
    if gameState == STATE_PLAYING then
      game:temp()
    end
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
      isMenuOpen = true
    end
  end
  playdate.graphics.sprite.update()
  playdate.drawFPS(0, 0)
end

menu:open()
isMenuOpen = true