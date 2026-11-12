class Player extends GameObject {

  PImage playerIdle;
  PImage playerLeft;
  PImage playerRight;
  PImage currentImg;

  float lastX;
  int idleTimer;

  float keySpeed = 10;

  // ---- invincibility / blink / shield ----
  int invincibleUntil = 0;
  int hitTime = -10000;
  boolean hasShield = false;

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
    hitTime = gameNow();
    invincibleUntil = hitTime + 2000;   // change 2000 to adjust the duration
  }

  boolean isInvincible() {
    return gameNow() < invincibleUntil;
  }

  void reset() {
    invincibleUntil = 0;
    hitTime = -10000;
    hasShield = false;
    x = mouseX;
    lastX = x;
    currentImg = playerIdle;
  }

  @Override
  void update() {

    // keyboard (arrows or A/D) OR mouse
    if (leftHeld || rightHeld) {
      if (leftHeld)  x -= keySpeed;
      if (rightHeld) x += keySpeed;
    } else if (mouseX != pmouseX) {
      x = mouseX;
    }
    x = constrain(x, 0, width);

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

    if (hasShield) {
      drawShield();
    }
  }

  // ring of sampaguita petals around the player
  void drawShield() {
    pushMatrix();
    translate(x, y);
    rotate(millis() / 600.0);
    noStroke();
    for (int i = 0; i < 8; i++) {
      float a = i * TWO_PI / 8;
      pushMatrix();
      translate(cos(a) * 62, sin(a) * 62);
      rotate(a);
      fill(255);
      ellipse(0, 0, 22, 10);
      fill(255, 210, 0);
      ellipse(0, 0, 5, 5);
      popMatrix();
    }
    popMatrix();

    noFill();
    stroke(255, 255, 255, 90);
    strokeWeight(4);
    ellipse(x, y, 124, 124);
  }
}