import 'global'
import 'game'
import 'popup'

import 'ui/versiontf'
showVersion()

local game = Game:new()

local popup = Popup:new()
local isOpen = false --don't need this flag inside popup rn

function playdate.AButtonUp()
  if isOpen then
    if popup:canClose() then
      popup:close()
      isOpen = false
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
    if popup:canClose() then
      popup:close()
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
    popup:update()
  elseif gameState == STATE_PLAYING then
    game:update()
    if game:isDead() then
      gameState = STATE_OVER
      popup:open()
      isMenuOpen = true
    end
  end
  playdate.graphics.sprite.update()
	playdate.timer.updateTimers()
  playdate.drawFPS(0, 0)
end

popup:open()
isMenuOpen = true