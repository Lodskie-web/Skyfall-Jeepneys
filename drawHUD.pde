int hudLastScore = 0;
int hudScorePopTime = 0;

void drawHUD() {

  pushStyle();

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // Detect when the score changes
  if (score != hudLastScore) {
    hudScorePopTime = millis();
    hudLastScore = score;
  }

  float t = millis() / 350.0;
  float baseY = 70;

  drawBunting();

  // Slightly floating HUD panels
  drawScorePanel(130, baseY + sin(t) * 2);
  drawLivesPanel(width / 2, baseY + sin(t + 1.5) * 2);
  drawTimePanel(width - 130, baseY + sin(t + 3.0) * 2);

  // Active power-up indicators
  drawStatusChips();

  popStyle();
}


// Filipino fiesta banderitas
void drawBunting() {

  color[] flagColors = {
    color(0, 90, 220),
    color(220, 40, 40),
    color(255, 210, 0),
    color(255)
  };

  float flagW = 40;
  float t = millis() / 300.0;

  stroke(120, 80, 20);
  strokeWeight(3);
  line(0, 2, width, 2);

  stroke(60);
  strokeWeight(1);

  for (int i = 0; i * flagW < width; i++) {

    float x = i * flagW;
    float sway = sin(t + i * 0.6) * 4;

    fill(flagColors[i % 4]);

    triangle(
      x + 2, 3,
      x + flagW - 2, 3,
      x + flagW / 2 + sway, 26
      );
  }
}


// Cream panel with blue label tab
void drawHudPanel(
  float cx, float cy,
  float w, float h,
  String label
  ) {

  stroke(180, 130, 20);
  strokeWeight(4);

  fill(245, 235, 210);
  rect(cx, cy, w, h, 14);

  // Blue label tab
  stroke(0, 40, 120);
  strokeWeight(3);

  fill(0, 90, 220);
  rect(cx, cy - h/2, w * 0.7, 22, 8);

  // Red decorations
  noStroke();
  fill(220, 40, 40);

  ellipse(cx - w * 0.35 + 12, cy - h/2, 7, 7);
  ellipse(cx + w * 0.35 - 12, cy - h/2, 7, 7);

  fill(255);
  textFont(hudFont);
  textSize(15);
  text(label, cx, cy - h/2 - 2);
}


// Draw the HUD numbers with a golden shadow
void drawHudValue(
  String value,
  float x, float y,
  float scaleAmount,
  color valueColor
  ) {

  pushMatrix();

  translate(x, y);
  scale(scaleAmount);

  textFont(hudFont);
  textSize(30);

  fill(230, 180, 40);
  text(value, 2, 2);

  fill(valueColor);
  text(value, 0, 0);

  popMatrix();
}


// Score panel with spinning star
void drawScorePanel(float cx, float cy) {

  drawHudPanel(cx, cy, 200, 58, "SCORE");

  float pop = constrain(
    1 - (millis() - hudScorePopTime) / 350.0,
    0, 1
    );

  float twinkle = 1 + 0.08 * sin(millis() / 200.0);

  pushMatrix();

  translate(cx - 62, cy + 7);
  rotate(pop * TWO_PI);
  scale(twinkle + pop * 0.5);

  fill(255, 210, 0);
  stroke(180, 130, 20);
  strokeWeight(2);

  drawStar(0, 0, 15, 7);

  popMatrix();

  color numberColor = lerpColor(
    color(0, 40, 120),
    color(220, 40, 40),
    pop
    );

  drawHudValue(
    str(score),
    cx + 22,
    cy + 7,
    1 + pop * 0.35,
    numberColor
    );
}


// Lives panel with beating hearts
void drawLivesPanel(float cx, float cy) {

  boolean invincible = millis() < invincibleUntil;

  boolean blinkOn = invincible &&
    (millis() / 100) % 2 == 0;

  drawHudPanel(cx, cy, 200, 58, "LIVES LEFT");

  float beat = 1 + 0.12 * sin(millis() / 180.0);

  // Display at least 3 hearts and up to 5
  int heartCount = max(3, lives);

  float spacing = heartCount <= 3 ? 48 : 38;
  float heartSize = heartCount <= 3 ? 30 : 26;

  for (int i = 0; i < heartCount; i++) {

    pushMatrix();

    float heartX = cx + (i - (heartCount - 1) / 2.0) * spacing;

    translate(heartX, cy + 8);

    if (i < lives) {

      scale(beat);

      stroke(140, 0, 0);
      strokeWeight(2);

      if (blinkOn) {
        fill(255);
      } else {
        fill(220, 40, 40);
      }
    } else {

      stroke(150);
      strokeWeight(2);
      fill(210, 200, 180);
    }

    drawHeart(0, 0, heartSize);

    popMatrix();
  }
}


// Time panel with spinning sun
void drawTimePanel(float cx, float cy) {

  drawHudPanel(cx, cy, 200, 58, "TIME");

  pushMatrix();

  translate(cx - 62, cy + 7);
  rotate(millis() / 1500.0);

  stroke(255, 170, 0);
  strokeWeight(3);

  for (int i = 0; i < 8; i++) {

    float angle = i * TWO_PI / 8;

    line(
      cos(angle) * 11,
      sin(angle) * 11,
      cos(angle) * 19,
      sin(angle) * 19
      );
  }

  fill(255, 210, 0);
  stroke(180, 130, 20);
  strokeWeight(2);

  ellipse(0, 0, 18, 18);

  popMatrix();

  drawHudValue(
    survivalTime + "s",
    cx + 22,
    cy + 7,
    1,
    color(0, 40, 120)
    );
}


// ================= POWER-UP STATUS CHIPS =================

void drawStatusChips() {

  float chipX = 95;
  float chipY = 125;

  if (gameNow() < slowMoUntil) {

    float frac = (slowMoUntil - gameNow()) / (float) SLOWMO_MS;

    drawStatusChip(chipX, chipY, 2, "SLOW-MO", frac);

    chipX += 140;
  }

  if (player.hasShield) {
    drawStatusChip(chipX, chipY, 3, "SHIELD", -1);
  }
}


void drawStatusChip(
  float x, float y,
  int iconType,
  String label,
  float frac
  ) {

  rectMode(CENTER);

  stroke(180, 130, 20);
  strokeWeight(3);

  fill(245, 235, 210);
  rect(x, y, 130, 32, 12);

  pushMatrix();

  translate(x - 47, y + 2);
  scale(0.6);

  if (iconType == 2) {
    drawKapeIcon(millis() / 1000.0);
  } else {
    drawSampaguitaIcon(millis() / 1000.0);
  }

  popMatrix();

  noStroke();
  fill(0, 40, 120);

  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(14);

  text(label, x + 14, (frac >= 0) ? y - 5 : y);

  // Time-left bar
  if (frac >= 0) {

    fill(200, 190, 160);
    rect(x + 14, y + 8, 70, 5, 3);

    fill(220, 40, 40);

    float w = 70 * constrain(frac, 0, 1);

    rect(x - 21 + w / 2, y + 8, w, 5, 3);
  }
}


// Five-point star shape
void drawStar(
  float cx, float cy,
  float outerR, float innerR
  ) {

  beginShape();

  for (int i = 0; i < 10; i++) {

    float r = (i % 2 == 0) ? outerR : innerR;
    float angle = -HALF_PI + i * PI / 5;

    vertex(
      cx + cos(angle) * r,
      cy + sin(angle) * r
      );
  }

  endShape(CLOSE);
}


// Heart shape
void drawHeart(float cx, float cy, float s) {

  beginShape();

  vertex(cx, cy + s * 0.35);

  bezierVertex(
    cx - s * 0.6, cy - s * 0.1,
    cx - s * 0.5, cy - s * 0.6,
    cx, cy - s * 0.25
    );

  bezierVertex(
    cx + s * 0.5, cy - s * 0.6,
    cx + s * 0.6, cy - s * 0.1,
    cx, cy + s * 0.35
    );

  endShape(CLOSE);
}


// ================= PICKUP ICONS =================

// Coin icon
void drawCoinIcon(float t) {

  float sx = max(0.25, abs(cos(t * 3)));

  pushMatrix();
  scale(sx, 1);

  stroke(180, 130, 20);
  strokeWeight(3);
  fill(255, 210, 0);
  ellipse(0, 0, 34, 34);

  noFill();
  strokeWeight(2);
  ellipse(0, 0, 24, 24);

  // Peso sign
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


// Pandesal icon
void drawPandesalIcon() {

  stroke(140, 80, 30);
  strokeWeight(2);
  fill(225, 160, 80);
  ellipse(0, 2, 40, 28);

  // Slits on top
  stroke(160, 95, 35);
  strokeWeight(2);

  line(-10, -5, -6, 3);
  line(-2, -7, 2, 3);
  line(6, -5, 10, 3);

  // Highlight
  noStroke();
  fill(255, 220, 150, 160);
  ellipse(-5, -5, 14, 6);
}


// Kape icon
void drawKapeIcon(float t) {

  // Steam
  noFill();
  stroke(255, 255, 255, 220);
  strokeWeight(2);

  for (int s = -1; s <= 1; s += 2) {

    beginShape();

    for (int k = 0; k <= 5; k++) {
      vertex(
        s * 5 + sin(t * 5 + k * 0.9 + s) * 2.5,
        -9 - k * 3
        );
    }

    endShape();
  }

  // Saucer
  stroke(90, 70, 50);
  strokeWeight(2);
  fill(245);
  ellipse(0, 13, 38, 9);

  // Handle
  noFill();
  stroke(90, 70, 50);
  strokeWeight(3);
  arc(12, 3, 14, 11, -HALF_PI, HALF_PI);

  // Cup
  stroke(90, 70, 50);
  strokeWeight(2);
  fill(255);
  rect(0, 3, 24, 20, 3, 3, 10, 10);

  // Coffee
  noStroke();
  fill(100, 55, 20);
  ellipse(0, -5, 20, 6);
}


// Sampaguita icon
void drawSampaguitaIcon(float t) {

  // Leaves
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

  // Petals
  stroke(190, 190, 175);
  strokeWeight(1);
  fill(255);

  for (int i = 0; i < 6; i++) {

    pushMatrix();

    rotate(i * TWO_PI / 6 + t * 0.4);
    ellipse(9, 0, 15, 9);

    popMatrix();
  }

  // Center
  noStroke();
  fill(255, 210, 0);
  ellipse(0, 0, 8, 8);
}
