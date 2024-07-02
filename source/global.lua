-- CoreLibs dependencies
import 'CoreLibs/sprites'
import 'CoreLibs/graphics' -- necessary for 'imageWithText'

-- globals cannot be const unless using luacheck (investigate further)
-- const
STATE_INIT, STATE_READY, STATE_PLAYING, STATE_PAUSED, STATE_OVER = 0, 1, 2, 3, 4
MAX_SPEED = 50

-- dynamic variables
gameState = STATE_INIT

-- dynamic options
DARK_MODE = false