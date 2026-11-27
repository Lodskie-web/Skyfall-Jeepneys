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

  boolean hasShield = false;

  // Hitbox dimensions from main
  float headW = 40;
  float headH = 42;
  float bodyW = 30;
  float feetTrim = 8;

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

  // Head hitbox
  float headL() {
    return x - headW/2;
  }

  float headR() {
    return x + headW/2;
  }

  float headT() {
    return y - h/2;
  }

  float headB() {
    return y - h/2 + headH;
  }

  // Body hitbox
  float bodyL() {
    return x - bodyW/2;
  }

  float bodyR() {
    return x + bodyW/2;
  }

  float bodyT() {
    return y - h/2 + headH;
  }

  float bodyB() {
    return y + h/2 - feetTrim;
  }

  boolean hitsBox(float l, float t, float r, float b) {

    boolean head = rectsOverlap(
      l, t, r, b,
      headL(), headT(), headR(), headB()
      );

    boolean body = rectsOverlap(
      l, t, r, b,
      bodyL(), bodyT(), bodyR(), bodyB()
      );

    return head || body;
  }

  @Override
    void update() {

    // Keyboard (arrows or A/D) OR mouse
    if (leftHeld || rightHeld) {
      if (leftHeld) x -= keySpeed;
      if (rightHeld) x += keySpeed;
    } else if (mouseX != pmouseX) {
      x = mouseX;
    }

    x = constrain(x, 0, width);

    if (x > lastX + 2) {
      currentImg = playerRight;
      idleTimer = millis();
    } else if (x < lastX - 2) {
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

    // Check if player is invincible
    boolean invincible = millis() < invincibleUntil;

    // Preserve existing blinking behavior
    boolean visible = !invincible ||
      (millis() / 100) % 2 == 0;

    if (visible) {
      image(currentImg, x, y, w, h);
    }

    // Original Sampaguita shield visual from main
    if (hasShield) {
      drawShield();
    }

    // Optional hitbox display
    if (showHitboxes) {
      drawHitboxes();
    }
  }

  // Red = head box, orange = body box
  void drawHitboxes() {

    rectMode(CORNERS);
    noFill();
    strokeWeight(2);

    stroke(255, 0, 0);
    rect(headL(), headT(), headR(), headB());

    stroke(255, 160, 0);
    rect(bodyL(), bodyT(), bodyR(), bodyB());

    rectMode(CENTER);
  }

  // Ring of Sampaguita petals around the player
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

