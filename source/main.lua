import 'global'
import 'game'
import 'popup'

import 'font/whiteglove'
useWhiteglove()

import 'ui/versiontf'
showVersion()

local game = Game:new()
local popup = Popup:new()

function startGame()
  popup:close()
  if gameState == STATE_INIT then
    game:start()
  elseif gameState == STATE_OVER then
    game:reset()
  end
  gameState = STATE_PLAYING
end

function playdate.update()
  if gameState == STATE_INIT or gameState == STATE_OVER then
    popup:update()
  elseif gameState == STATE_PLAYING then
    game:update()
    if game:isDead() then
      gameState = STATE_OVER
      popup:open()
    end
  end
  playdate.graphics.sprite.update()
	-- playdate.timer.updateTimers()
  playdate.drawFPS(0, 0)
end

popup:setStartGameHandler(startGame)
popup:open()