
class Player extends GameObject {

  PImage playerIdle;
  PImage playerLeft;
  PImage playerRight;
  PImage currentImg;

  float lastX;
  int idleTimer;

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

    // Check if player is invincible
    boolean invincible = millis() < invincibleUntil;

    // Blink every 100 milliseconds
    boolean visible = !invincible ||
                      (millis() / 100) % 2 == 0;

    if (visible) {
      imageMode(CENTER);
      image(currentImg, x, y, w, h);
    }
  }
}
