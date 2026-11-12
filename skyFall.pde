import processing.sound.*;
SoundFile bgMusic;
SoundFile bgMusic1;
SoundFile bgMusic2;
SoundFile rushSound;   // optional: put a real recording at data/rushHour.mp3 and it gets used
Sound masterVolume;    // used by the mute button

Player player;
ArrayList<Jeepney> jeepneys;
ArrayList<Pickup> pickups = new ArrayList<Pickup>();
ArrayList<PopText> popups = new ArrayList<PopText>();

int startFrame = 0;
int scoreBoard = 0;
int gameState = 0;      // 0 = menu, 1 = game, 2 = how to play, 3 = game over
int score = 0;
int survivalTime = 0;
int lives = 3;
final int MAX_LIVES = 5;

// ---- game clock / flags (the clock only ticks while actually playing) ----
int gameMs = 0;
int lastMillis = 0;
boolean isPaused = false;
boolean countdownActive = false;
int countdownStart = 0;
int lastCountStep = -1;
boolean muted = false;
boolean leftHeld = false;
boolean rightHeld = false;

// ---- difficulty / events ----
final int LANES = 8;
final int MAX_BASE_JEEPNEYS = 12;
final int SLOWMO_MS = 6000;
int nextJeepneyAt = 0;
int nextRushAt = 0;
int rushState = 0;          // 0 = none, 1 = warning, 2 = wave on screen
int rushStateUntil = 0;
int nextHonkAt = 0;

// ---- pickups ----
int nextCoinAt = 0;
int nextPowerupAt = 0;
int slowMoUntil = 0;
int lastNearMiss = -10000;

// ---- environment (change these scores to make it change sooner/later) ----
final int SUNSET_SCORE = 40;
final int NIGHT_SCORE = 90;
final int RAIN_SCORE = 140;
float envPhase = 0;         // 0 day -> 1 sunset -> 2 night (eases smoothly)
float rainAmount = 0;
int lastEnvStage = 0;
int nextLightning = 0;
int lightningUntil = 0;
float[] rainX = new float[160];
float[] rainY = new float[160];
float[] rainSpd = new float[160];

// ---- high score ----
int bestScore = 0;
boolean newHighScore = false;
int finalTime = 0;

// ---- HUD animation state ----
int lastScore = 0;
int scorePopTime = -10000;

// ---- fonts (all created once in setup) ----
PFont hudFont;
PFont fontBtn;
PFont fontBig;
PFont fontHowTitle;
PFont fontHowBody;
PFont bold;
PFont titleFont;

PImage background1;
PImage jeepney;
PImage jeepney1;
PImage background;
PImage gameover;

void setup() {
  size(1000, 650);
  frameRate(60);

  background = loadImage("backgroundG.png");
  background1 = loadImage("menuBackg.png");
  gameover = loadImage("gameOver.png");
  gameover.resize(width, height);
  bgMusic1 = new SoundFile(this, "jeepneyEng.mp3");
  bgMusic = new SoundFile(this, "traffic.mp3");
  bgMusic1.loop();
  bgMusic2 = new SoundFile(this, "crash.mp3");
  rushSound = loadOptionalSound("rushHour.mp3");
  masterVolume = new Sound(this);
  sfxInit();

  player = new Player();
  jeepney = loadImage("jeepney.png");
  jeepney1 = loadImage("jeepney1.png");
  jeepneys = new ArrayList<Jeepney>();

  for (int i = 0; i < 5; i++) {
    jeepneys.add(new Jeepney());
  }

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  titleFont = createFont("Arial Bold", 40);
  hudFont = createFont("Arial Bold", 30);
  fontBtn = createFont("Arial Bold", 28);
  fontBig = createFont("Arial Bold", 60);
  fontHowTitle = createFont("Arial Bold", 34);
  fontHowBody = createFont("Arial Bold", 26);

  initRain();
  loadBestScore();
}

void draw() {

  image(gameover, 0, 0);

  if (gameState == 0) {
    drawMenu();
  }

  else if (gameState == 1) {
    drawGame();
  }

  else if (gameState == 2) {
    drawHowToPlay();
  }

  else if (gameState == 3) {
    drawGameOver();
  }

  sfxUpdate();
}