class Jeepney extends GameObject {

  float speed;
  float normalSpeed;

  int lane;

  boolean scored = false;
  boolean slowed = false;
  int slowUntil = 0;

  Jeepney() {
    super(width / 2, -300, 120, 160);

    normalSpeed = random(5, 10);
    speed = normalSpeed;

    respawn();
  }

  void respawn() {
    float newY = random(-450, -100);

    lane = pickFreeLane(newY, this);
    x = laneX(lane) + random(-15, 15);
    y = newY;

    scored = false;
  }

  @Override
    void update() {

    if (slowed && millis() > slowUntil) {
      speed = normalSpeed;
      slowed = false;
    }

    // Kape slows jeepney movement by half
    float mult = (gameNow() < slowMoUntil) ? 0.5 : 1;

    y += speed * mult;

    if (!slowed) {
      speed += 0.001;
      normalSpeed += 0.001;
    }

    if (y > height) {
      respawn();
    }
  }

  @Override
    void display() {
    imageMode(CENTER);
    image(jeepney1, x, y, w, h);
  }

  boolean hitPlayer(Player p) {
    return dist(x, y, p.getX(), p.getY()) < 60;
  }

  void slowDown() {
    slowed = true;
    speed = normalSpeed * 0.4;
    slowUntil = millis() + 3000;
  }
}
