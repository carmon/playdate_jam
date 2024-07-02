Wheel Story: a playdate game 
=============================

A [playdate](https://play.date/) game made for fun!

It's about a wheel travelling trough a series of slopes.

### Releases
Check out [releases page](https://github.com/carmon/playdate_jam/releases) if you want to access latest working build.

## Content
- `.vscode` has the Visual Studio Code tasks:
  - Playdate Build: Ctrl+Shift+B to run (default build task)
  - Zip for Sideload: Zip build pdx folder to sideload and test in console (Linux only) 
  - Clean: Remove dir target and zip file
- `/source` is where the source code resides
  - `/font`: bitmap font folder
  - `/images`: images for in-game use
- `/support` is for external files (i.e. PSD, KRA), only folder should be present

### Requirements

- [Download Playdate SDK](https://play.date/dev/) and install

### Compile

- Windows: `pdc -sdkpath C:\Users\Carmon\Documents\PlaydateSDK source\ Build.pdx`
- Ubuntu: `pdc -sdkpath /opt/PlaydateSDK/ source/ Build.pdx`
- Everyone: `pdc -sdkpath [SDK_PATH] [SOURCE_DIR_PATH] [TARGET_DIR].pdx`

This creates the `Build.pdx` dir that contains the resulting compiled playdate game.

### Test 

- Use `Build.pdx` **dir** on `Playdate Simulator` program (installed with SDK)
- Use zip on [Playdate Sideload site](https://play.date/account/sideload/)