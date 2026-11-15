# SkyFall Jeepneys

> Dodge the falling jeepneys. Survive rush hour. Climb the leaderboard. Ay! Huli ka!

SkyFall Jeepneys is a Filipino-themed arcade survival game made with [Processing](https://processing.org/) (Java mode). You control a character at the bottom of a busy street while jeepneys rain down from above. Slide left and right to dodge them, grab Filipino-flavored power-ups, and last as long as you can as the day turns into sunset, night and rain.

Players log in with a name, and the game keeps a top-10 leaderboard, so friends and family can compete on the same computer.

<!-- Add screenshots here once you have them, for example:
![Main menu](docs/screenshots/menu.png)
![Gameplay](docs/screenshots/gameplay.png)
-->

## Table of contents

- [Features](#features)
- [Controls](#controls)
- [Scoring and power-ups](#scoring-and-power-ups)
- [Getting started](#getting-started)
- [Project structure](#project-structure)
- [Tuning the game](#tuning-the-game)
- [Versioning and releases](#versioning-and-releases)
- [Credits](#credits)

## Features

**Gameplay**
- Mouse, arrow-key or A/D movement.
- 3 lives. A hit gives you 2 seconds of blinking invincibility.
- Jeepneys fall in 8 lanes and get faster over time. A new jeepney joins every 15 to 20 seconds, up to 12.
- Fair collisions: the character has separate head and body hitboxes, and jeepneys use their real outline (the speed lines above them are ignored).
- Near-miss bonus: a "SAKTO!" popup and extra points when a jeepney barely misses you.
- Rush hour: a siren warns you, then waves of jeepneys come down with three free lanes to slip through.
- Day, sunset, night and rain with lightning as your score climbs.
- A 3-2-1-GO countdown before every run, and a pause menu with resume, mute and quit.

**Filipino theme**
- Jeepneys, pandesal, kape, sampaguita and piso coins.
- Swaying banderitas, parols, the flag's sun and stars, and a woven border on the menus.
- Tagalog popups and captions such as ARAY!, SAKTO!, DAGDAG JEEPNEY!, HAPON NA!, GABI NA!, UMUULAN! and SINO ANG LALARO?

**Players and leaderboard**
- Player login: type your name once and the game remembers it. Returning players can be picked from a list.
- Edit or delete a player from the login screen. Renaming keeps your scores.
- Top-10 leaderboard with name, best score and survival time, with your own row highlighted.
- NEW HIGH SCORE and NEW PERSONAL BEST ribbons on the game over screen.
- Quit confirmations, so you don't close the game or lose a run by accident.

**Sound**
- Background music and a crash sound effect.
- Coin, power-up, near-miss, countdown, siren and car-horn sounds are generated in code with the Sound library's oscillators, so they need no extra audio files.

## Controls

| Action | Keys |
|---|---|
| Move | Mouse, or Left / Right arrows, or A / D |
| Pause or resume | P or Esc |
| Mute or unmute | M |
| Show hitboxes (debug view, during a game) | H |
| Confirm a name | Enter |
| Back or cancel | Esc |

Esc does not close the game. It pauses, goes back, or closes a popup.

## Scoring and power-ups

| Event | Points |
|---|---|
| Dodge a jeepney | +1 |
| Dodge a rush-hour jeepney | +2 |
| Near miss (SAKTO!) | +2 |
| Piso coin | +5 |

| Pickup | Effect |
|---|---|
| Piso coin | +5 points |
| Pandesal | +1 life (up to 5) |
| Kape | Slow motion for 6 seconds |
| Sampaguita | A shield that absorbs your next hit |

## Getting started

### Requirements

- [Processing 4](https://processing.org/download)
- The **Sound** library for Processing: *Sketch > Import Library > Manage Libraries*, search for "Sound", and install it.
- Optional: [VS Code](https://code.visualstudio.com/) with the Processing extension.

### Run it

1. Clone the repository into a folder named `skyFall`:

   ```bash
   git clone https://github.com/YOUR-USERNAME/skyfall-jeepneys.git skyFall
   ```

   Processing requires the sketch folder name to match the main tab name, and the main tab is `skyFall.pde`.

2. Open `skyFall/skyFall.pde` in Processing and press **Run**, or open the folder in VS Code and use the Processing extension's run button.

### Required assets

The `data/` folder must contain these files:

| Type | Files |
|---|---|
| Images | `backgroundG.png`, `menuBackg.png`, `gameOver.png`, `jeepney.png`, `jeepney1.png`, `playerIdle.png`, `playerLeft.png`, `playerRight.png` |
| Audio | `jeepneyEng.mp3` (menu music), `traffic.mp3` (in-game music), `crash.mp3` |
| Optional | `rushHour.mp3`: a real rush-hour recording. If present, it replaces the generated siren and horns. |

### Where scores are saved

Players and the leaderboard are saved with Java's built-in Preferences, which the operating system stores (the registry on Windows, system settings on macOS and Linux). There is no score file in the project folder.

This means the leaderboard belongs to one computer and one user account. Use the **CLEAR SCORES** button on the leaderboard screen to reset it.

## Project structure

Processing merges all tabs (`.pde` files) in the sketch folder into one program.

| Tab | Purpose |
|---|---|
| `skyFall.pde` | Main tab: global variables, `setup()` and `draw()` |
| `gameLogic.pde` | Per-frame game update, collisions, scoring, rush hour, pause and countdown |
| `restartGame.pde` | New-run reset and end-of-game handling |
| `mousePressed.pde` | Mouse and keyboard input, `startGame()` and `goToMenu()` |
| `gameObject.pde` | Base class for game objects |
| `player.pde` | Player movement, invincibility, shield and hitboxes |
| `jeepney.pde` | Falling jeepneys and their pixel-accurate hitbox |
| `pickup.pde` | Coins and power-ups with their icons |
| `PopText.pde` | Floating popup text (ARAY!, SAKTO!, ...) |
| `environment.pde` | Sunset, night, rain and lightning |
| `sfx.pde` | Generated sound effects and mute |
| `leaderboard.pde` | Player login data, leaderboard logic and saving |
| `drawMenu.pde` | Main menu |
| `drawGame.pde` | In-game screen, HUD and pause menu |
| `drawGameOver.pde` | Game over screen and high score ribbon |
| `drawHowToPlay.pde` | How To Play screen |
| `drawNameEntry.pde` | Player login and edit-name screen |
| `drawLeaderboard.pde` | Leaderboard screen |
| `drawPlayerChip.pde` | Player chip on the menu and the delete-player popup |
| `drawQuitConfirm.pde` | Quit confirmation popup |
| `drawButton.pde` | Reusable styled button |
| `drawFilipinoBackground.pde` | Animated Filipino background and border |

## Tuning the game

| What | Where |
|---|---|
| Score where sunset, night and rain begin | `SUNSET_SCORE`, `NIGHT_SCORE`, `RAIN_SCORE` in `skyFall.pde` |
| Number of lanes and maximum jeepneys | `LANES`, `MAX_BASE_JEEPNEYS` in `skyFall.pde` |
| Invincibility length (milliseconds) | `hit()` in `player.pde` |
| Head and body hitbox size | `headW`, `headH`, `bodyW` in `player.pde` |
| Exact jeepney outline vs plain rectangle | `PIXEL_HITBOX` in `jeepney.pde` |

Press **H** during a game to see the hitboxes while you tune them.

## Versioning and releases

SkyFall follows [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`.

- **MAJOR**: changes that break compatibility with the previous version.
- **MINOR**: new features that don't break anything.
- **PATCH**: small fixes and polish.

Each version is marked with an annotated Git tag, and the notes for the main milestones are on the [Releases](../../releases) page.

| Tag | What it marks |
|---|---|
| `v1.0.0` | Original playable game: menu, mouse control, falling jeepneys, score, lives, timer and sound |
| `v1.1.0` | Better UI: lives, timer, banderitas and score panels |
| `v2.5.0` | Players, leaderboard, power-ups, rush hour, day/night/rain, pause menu and quit confirmations |
| `v2.6.0` | Game version shown on the main menu |

## Credits

Created by John Lloyd Maldo.

Built with [Processing](https://processing.org/) and the Processing Sound library.
