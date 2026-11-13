// press H during a game to show / hide the hitboxes
boolean showHitboxes = false;

// true when two rectangles (left, top, right, bottom) overlap
boolean rectsOverlap(float l1, float t1, float r1, float b1,
                     float l2, float t2, float r2, float b2) {
  return l1 < r2 && r1 > l2 && t1 < b2 && b1 > t2;
}

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

  // ---- hitbox (tune these to match your sprite; press H in-game to see them) ----
  float headW = 40;      // width of the head box
  float headH = 42;      // head box height, measured down from the top of the sprite
  float bodyW = 30;      // width of the body box under the head
  float feetTrim = 8;    // pixels ignored at the very bottom of the sprite

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

  // true if the box (left, top, right, bottom) touches the head OR the body
  boolean hitsBox(float l, float t, float r, float b) {

    float top = y - h/2;

    boolean head = rectsOverlap(l, t, r, b,
                                x - headW/2, top,
                                x + headW/2, top + headH);

    boolean body = rectsOverlap(l, t, r, b,
                                x - bodyW/2, top + headH,
                                x + bodyW/2, y + h/2 - feetTrim);

    return head || body;
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

    if (showHitboxes) {
      drawHitboxes();
    }
  }

  // red = head box, orange = body box
  void drawHitboxes() {

    float top = y - h/2;

    rectMode(CORNERS);
    noFill();
    strokeWeight(2);

    stroke(255, 0, 0);
    rect(x - headW/2, top, x + headW/2, top + headH);

    stroke(255, 160, 0);
    rect(x - bodyW/2, top + headH, x + bodyW/2, y + h/2 - feetTrim);

    rectMode(CENTER);
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