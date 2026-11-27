// type: 0 = piso coin, 1 = pandesal (+1 life),
// 2 = kape (slow-mo), 3 = sampaguita (shield)

class Pickup extends GameObject {

  int type;
  float speed;
  float phase;

  Pickup(int type) {

    super(
      laneX(pickFreeLane(-40, null)) + random(-20, 20),
      -40,
      44,
      44
    );

    this.type = type;
    this.speed = random(4, 5.5);
    this.phase = random(TWO_PI);
  }

  @Override
  void update() {

    float mult = (gameNow() < slowMoUntil) ? 0.5 : 1;

    y += speed * mult;
  }

  @Override
  void display() {

    float t = millis() / 1000.0 + phase;

    pushMatrix();

    translate(x, y + sin(t * 4) * 3);

    // Pulsing glow
    noStroke();

    float glow = 56 + sin(t * 6) * 6;

    if (type == 0) {
      fill(255, 210, 0, 70);
    } else if (type == 1) {
      fill(255, 150, 60, 80);
    } else if (type == 2) {
      fill(150, 90, 40, 80);
    } else {
      fill(255, 255, 255, 100);
    }

    ellipse(0, 0, glow, glow);

    if (type == 0) {
      drawCoinIcon(t);
    } else if (type == 1) {
      drawPandesalIcon();
    } else if (type == 2) {
      drawKapeIcon(t);
    } else {
      drawSampaguitaIcon(t);
    }

    popMatrix();
  }
}