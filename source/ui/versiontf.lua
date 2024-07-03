import 'fontcache'
import 'textfield'

function showVersion()
  local meta <const> = playdate.metadata
  local displayWidth <const> = playdate.display.getSize()
  local versionUI = Textfield:new(displayWidth-30, 10, meta.version..'.'..meta.buildNumber)
  versionUI:setFont(getFont('ui'))
  versionUI:add()
end
