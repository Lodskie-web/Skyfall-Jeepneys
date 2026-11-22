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

  for (int i = 0; i < 3; i++) {

    pushMatrix();

    float heartX = cx + (i - 1) * 48;

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

    drawHeart(0, 0, 30);

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
