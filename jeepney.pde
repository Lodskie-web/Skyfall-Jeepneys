class Jeepney extends GameObject {
  float speed;
  float normalSpeed;

  boolean scored = false;
  boolean slowed = false;
  int slowUntil = 0;

  Jeepney() {

    super(
      random(width),
      random(-500, -100), 120, 160);

    normalSpeed = random(5, 10);
    speed = normalSpeed;
  }

  @Override
  void update() {

    if (slowed && millis() > slowUntil) {
      speed = normalSpeed;
      slowed = false;
    }

    y += speed;

    if (!slowed) {
      speed += 0.001;
      normalSpeed += 0.001;
    }

    if (y > height) {
      y = random(-300, -50);
      x = random(width);
      scored = false;
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