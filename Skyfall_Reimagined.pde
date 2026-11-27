import processing.sound.*;

SoundFile bgMusic;
SoundFile bgMusic1;
SoundFile bgMusic2;

Sound masterVolume;
boolean muted = false;
boolean isPaused = false;

Player player;
ArrayList<Jeepney> jeepneys;
ArrayList<PopText> popups;
ArrayList<Pickup> pickups;

int startFrame = 0;
int scoreBoard = 0;
int gameState = 0;
int score = 0;
int survivalTime = 0;
int lives = 3;
int lifeFlashUntil = 0;
int gameMs = 0;
int lastMillis = 0;

// 3-2-1-GO countdown
boolean countdownActive = false;
int countdownStart = 0;
int lastCountStep = -1;

final int LANES = 8;
int nextJeepneyAt = 0;
final int MAX_BASE_JEEPNEYS = 12;

// Power-ups
final int MAX_LIVES = 5;
final int SLOWMO_MS = 6000;

int nextCoinAt = 0;
int nextPowerupAt = 0;
int slowMoUntil = 0;

boolean leftHeld = false;
boolean rightHeld = false;

// Hit invincibility timer
int invincibleUntil = 0;

// Environment
final int SUNSET_SCORE = 40;
final int NIGHT_SCORE = 90;
final int RAIN_SCORE = 140;

float envPhase = 0;
float rainAmount = 0;
int lastEnvStage = 0;
int nextLightning = 0;
int lightningUntil = 0;

float[] rainX = new float[160];
float[] rainY = new float[160];
float[] rainSpd = new float[160];

PFont bold;
PFont titleFont;
PFont hudFont;

PImage background1;
PImage jeepney;
PImage jeepney1;
PImage background;
PImage gameover;

void setup() {
  frameRate(60);
  size(1000, 650);

  background = loadImage("backgroundG.png");
  background1 = loadImage("menuBackg.png");
  gameover = loadImage("gameOver.png");
  gameover.resize(width, height);

  bgMusic1 = new SoundFile(this, "jeepneyEng.mp3");
  bgMusic = new SoundFile(this, "traffic.mp3");
  bgMusic1.loop();
  bgMusic2 = new SoundFile(this, "crash.mp3");

  // Master volume for the mute feature
  masterVolume = new Sound(this);

  // Initialize countdown sound
  sfxInit();

  player = new Player();

  jeepney = loadImage("jeepney.png");
  jeepney1 = loadImage("jeepney1.png");

  jeepneys = new ArrayList<Jeepney>();
  popups = new ArrayList<PopText>();
  pickups = new ArrayList<Pickup>();

  for (int i = 0; i < 5; i++) {
    jeepneys.add(new Jeepney());
  }

  // Initialize environment rain
  initRain();

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  titleFont = createFont("Arial Bold", 40);
  hudFont = createFont("Arial Bold", 30);
}

void draw() {

  image(gameover, 0, 0);

  if (gameState == 0) {
    drawMenu();
  } else if (gameState == 1) {
    drawGame();
  } else if (gameState == 2) {
    drawHowToPlay();
  } else if (gameState == 3) {
    drawGameOver();
  }

  // Update sound effects every frame
  sfxUpdate();
}