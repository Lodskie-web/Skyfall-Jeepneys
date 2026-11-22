
import processing.sound.*;

SoundFile bgMusic;
SoundFile bgMusic1;
SoundFile bgMusic2;

Player player;
ArrayList<Jeepney> jeepneys;

int startFrame = 0;
int scoreBoard = 0;
int gameState = 0;
int score = 0;
int survivalTime = 0;
int lives = 3;
int lifeFlashUntil = 0;

// Hit invincibility timer
int invincibleUntil = 0;

PFont bold;
PFont titleFont;
PImage background1;
PImage jeepney;
PImage jeepney1;
PImage background;
PImage gameover;

void setup() {
  size(1000, 650);

  background = loadImage("backgroundG.png");
  background1 = loadImage("menuBackg.png");
  gameover = loadImage("gameOver.png");
  gameover.resize(width, height);

  bgMusic1 = new SoundFile(this, "jeepneyEng.mp3");
  bgMusic = new SoundFile(this, "traffic.mp3");
  bgMusic1.loop();
  bgMusic2 = new SoundFile(this, "crash.mp3");

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
}
