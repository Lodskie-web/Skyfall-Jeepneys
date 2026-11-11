class Player extends GameObject {

  PImage playerIdle;
  PImage playerLeft;
  PImage playerRight;
  PImage currentImg;

  float lastX;
  int idleTimer;

  // ---- invincibility / blink ----
  int invincibleUntil = 0;
  int hitTime = -10000;

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  void setX(float newX) {
    x = newX;
  }

  Player() {

    super(width/2, height - 75, 70, 120);

    playerIdle = loadImage("playerIdle.png");
    playerLeft = loadImage("playerLeft.png");
    playerRight = loadImage("playerRight.png");

    currentImg = playerIdle;

    lastX = x;
    idleTimer = millis();
  }

  // Called when a jeepney hits the player: 2 seconds of blinking + invincibility
  void hit() {
    hitTime = millis();
    invincibleUntil = hitTime + 2000;   // change 2000 to adjust the duration
  }

  boolean isInvincible() {
    return millis() < invincibleUntil;
  }

  void reset() {
    invincibleUntil = 0;
    hitTime = -10000;
  }

  @Override
  void update() {
    setX(mouseX);

    if (x > lastX + 2) {
      currentImg = playerRight;
      idleTimer = millis();
    }
    else if (x < lastX - 2) {
      currentImg = playerLeft;
      idleTimer = millis();
    }

    if (millis() - idleTimer > 100) {
      currentImg = playerIdle;
    }

    lastX = x;
  }

  @Override
  void display() {
    imageMode(CENTER);

    // Blink: every 120 ms swap between normal and a faint "ghost" version
    if (isInvincible() && (millis() / 120) % 2 == 0) {
      tint(255, 60);
    }

    image(currentImg, x, y, w, h);
    noTint();
  }
}
