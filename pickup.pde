// type: 0 = piso coin, 1 = pandesal (+1 life), 2 = kape (slow-mo), 3 = sampaguita (shield)
class Pickup extends GameObject {

  int type;
  float speed;
  float phase;

  Pickup(int type) {
    super(laneX(pickFreeLane(-40, null)) + random(-20, 20), -40, 44, 44);
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

    // pulsing glow so pickups are easy to spot
    noStroke();
    float glow = 56 + sin(t * 6) * 6;
    if (type == 0)      fill(255, 210, 0, 70);
    else if (type == 1) fill(255, 150, 60, 80);
    else if (type == 2) fill(150, 90, 40, 80);
    else                fill(255, 255, 255, 100);
    ellipse(0, 0, glow, glow);

    if (type == 0)      drawCoinIcon(t);
    else if (type == 1) drawPandesalIcon();
    else if (type == 2) drawKapeIcon(t);
    else                drawSampaguitaIcon(t);

    popMatrix();
  }
}

// ---------- icons (drawn around 0,0, about 40px wide) ----------

void drawCoinIcon(float t) {
  float sx = max(0.25, abs(cos(t * 3)));    // spinning coin
  pushMatrix();
  scale(sx, 1);

  stroke(180, 130, 20);
  strokeWeight(3);
  fill(255, 210, 0);
  ellipse(0, 0, 34, 34);

  noFill();
  strokeWeight(2);
  ellipse(0, 0, 24, 24);

  // peso sign: a P with two bars
  noStroke();
  fill(170, 100, 0);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("P", 0, -1);
  stroke(170, 100, 0);
  strokeWeight(2);
  line(-8, -3, 8, -3);
  line(-8, 2, 8, 2);
  popMatrix();
}

void drawPandesalIcon() {
  stroke(140, 80, 30);
  strokeWeight(2);
  fill(225, 160, 80);
  ellipse(0, 2, 40, 28);

  // slits on top
  stroke(160, 95, 35);
  strokeWeight(2);
  line(-10, -5, -6, 3);
  line(-2, -7, 2, 3);
  line(6, -5, 10, 3);

  // highlight
  noStroke();
  fill(255, 220, 150, 160);
  ellipse(-5, -5, 14, 6);
}

void drawKapeIcon(float t) {
  // steam
  noFill();
  stroke(255, 255, 255, 220);
  strokeWeight(2);
  for (int s = -1; s <= 1; s += 2) {
    beginShape();
    for (int k = 0; k <= 5; k++) {
      vertex(s * 5 + sin(t * 5 + k * 0.9 + s) * 2.5, -9 - k * 3);
    }
    endShape();
  }

  // saucer
  stroke(90, 70, 50);
  strokeWeight(2);
  fill(245);
  ellipse(0, 13, 38, 9);

  // handle
  noFill();
  stroke(90, 70, 50);
  strokeWeight(3);
  arc(12, 3, 14, 11, -HALF_PI, HALF_PI);

  // cup
  stroke(90, 70, 50);
  strokeWeight(2);
  fill(255);
  rect(0, 3, 24, 20, 3, 3, 10, 10);

  // coffee
  noStroke();
  fill(100, 55, 20);
  ellipse(0, -5, 20, 6);
}

void drawSampaguitaIcon(float t) {
  // leaves
  noStroke();
  fill(60, 160, 70);
  pushMatrix();
  translate(-12, 10);
  rotate(0.5);
  ellipse(0, 0, 18, 7);
  popMatrix();
  pushMatrix();
  translate(12, 10);
  rotate(-0.5);
  ellipse(0, 0, 18, 7);
  popMatrix();

  // petals
  stroke(190, 190, 175);
  strokeWeight(1);
  fill(255);
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    rotate(i * TWO_PI / 6 + t * 0.4);
    ellipse(9, 0, 15, 9);
    popMatrix();
  }

  // center
  noStroke();
  fill(255, 210, 0);
  ellipse(0, 0, 8, 8);
}