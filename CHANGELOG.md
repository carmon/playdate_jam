## Changelog

### 0.08a.3 - 03-07-2024  

#### Added
- ui folder for assets that can be incapsulated
  - added version textfield inside
- some testing files for menu (temp) with font

#### Changes
- A and B button action flow on main now uses menu canClose

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