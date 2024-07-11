## Changelog

### 0.12a Release

### Added
- Logic to pause game
- Ignore offset on menu and popup sprites

### Changes
- Move segment logic outside of game, to a new segment file

### 0.11a Release

### Added
- Dynamic friction, depends on radius
- Dark mode, selecting it from menu

### Changes
- A and B buttons increases radius, friction drecreases it
- Die condition is now radius == 1, just testing
- Move all game state managment to main
- Renamed player to ball, because that's what it is
- Redraw player based on angle

### Removed
- Jump mechanic. It just wasn't working.
- Globals file, now that dark mode has its own
- Remove map, will be reacreated if needed

### 0.10a Release

### Added
- new menu with buttons
- now B btn augments the RADIUS of the ball
- additional clean tasks 

### Changes
- Only use one font, the other one didn't look ok in the console, reduce space
- Player ball now admits radius changes 
- Size of build reduced
- inputHandlers added on game also

### Fixed
- rm warning on zip file not found.

### Removed
- fontcache
- font managment inside textfields
- cycle image, useless when resizing

### 0.09a Release

#### Added
- ui folder for assets that can be incapsulated
  - added version textfield inside
  - added new menu ui for popup
  - moved speedUI inside, renamed it to speedmeter
- playdate.inputHandlers implementation

#### Changes
- A and B button action flow on main now uses menu canClose
- Renamed menu to popup, because that is what it is
- Added imageDrawMode render conditional to textfield
- Make subtitle in popup be an alert in case of crack docked
- Improved crank alert

#### Fixed
- Menu didn't close when crank was docked

### 0.08a Release

#### Added
- Changelog file :P

#### Changes
- Decreased margin of menu background
- Segment generation now is limited to 10 segments max
- Camera X can now be negative, aligned centered to ball/screen
- Camera Y now with more positive offset
- Pop and segments counter UI now starts removed
- Angle resets on direction change
- Isolate segments operations, made drawSegments
- Augmented DIE LINE for testing purposes
- Now appears with more initial distance so it can starts backwards

#### Fixed
- FPS count decrease fixed with limited segments