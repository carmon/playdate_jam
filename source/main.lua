-- CoreLibs dependencies
import 'CoreLibs/sprites'
import 'CoreLibs/graphics' -- necessary for 'imageWithText'

import 'color'
import 'game'
import 'popup'

import 'font/whiteglove'
useWhiteglove()

import 'ui/versiontf'
showVersion()

local STATE_INIT <const>, STATE_READY <const>, STATE_PLAYING <const>, STATE_PAUSED <const>, STATE_OVER <const> = 0, 1, 2, 3, 4
MAX_SPEED = 50

local gameState = STATE_INIT

local ACTION_START <const> = 'Start game'
local ACTION_RESET <const> = 'Retry'
local ACTION_RETURN <const> = 'Return'
local GAME_TITLE <const> = 'WHEEL STORY'
local GAME_PAUSED <const> = 'Game paused'
local GAME_OVER <const> = 'Game Over'

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

function pauseGame()
  gameState = STATE_PAUSED
  popup:open(GAME_PAUSED, ACTION_RETURN)
end

function playdate.deviceWillLock()
  if gameState == STATE_PLAYING then pauseGame() end
end

function playdate.update()
  if gameState == STATE_INIT or gameState == STATE_PAUSED or gameState == STATE_OVER then
    popup:update()
  elseif gameState == STATE_PLAYING then
    game:update()
    if game:isDead() then
      gameState = STATE_OVER
      popup:open(GAME_OVER, ACTION_RESET)
    end
  end
  
  playdate.graphics.sprite.update()
	-- playdate.timer.updateTimers()
  playdate.drawFPS(0, 0)
end

popup:open(GAME_TITLE, ACTION_START)