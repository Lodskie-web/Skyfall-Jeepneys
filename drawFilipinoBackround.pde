// =====================================================================
//  Filipino-themed animated background + frame
//  (used by How To Play, Leaderboard and Player Login)
// =====================================================================

void drawFilipinoBackground() {

  float t = millis() / 1000.0;

  rectMode(CENTER);
  background(255, 196, 30);

  drawBackgroundRays(t);
  drawConfetti(t);

  // hanging parols (star lanterns), one on each side
  drawParol(68, 20, 150, 30, color(220, 40, 40), t, 0);
  drawParol(width - 68, 20, 150, 30, color(0, 90, 220), t, 2.5);

  // flag sun on the left, three stars on the right
  drawFlagSun(68, 330, 34, t);
  drawFlagStars(width - 68, 330, t);

  // woven diamond stacks lower down
  drawDiamondStack(68, 500, t);
  drawDiamondStack(width - 68, 500, t + 1.5);

  drawBanderitas(t);
  drawWeaveBorder();
}

// rotating sunburst, like the sun on the Philippine flag
void drawBackgroundRays(float t) {

  float cx = width / 2;
  float cy = height / 2;
  int n = 28;                      // wedges (every other one is painted lighter)
  float step = TWO_PI / n;
  float rot = t * 0.08;
  float R = 800;

  noStroke();
  fill(255, 224, 90);
  for (int i = 0; i < n; i += 2) {
    float a = rot + i * step;
    triangle(cx, cy,
             cx + cos(a) * R, cy + sin(a) * R,
             cx + cos(a + step) * R, cy + sin(a + step) * R);
  }
}

// confetti triangles drifting down (same idea as the game over art)
void drawConfetti(float t) {

  color[] cols = { color(220, 40, 40), color(0, 90, 220), color(255), color(255, 140, 0) };

  noStroke();
  for (int i = 0; i < 22; i++) {
    float x = (i * 173.0 + 40) % width;
    float speed = 18 + (i % 5) * 7;
    float y = (i * 97.0 + t * speed) % (height + 80) - 40;
    float sway = sin(t * 0.8 + i) * 14;
    float s = 9 + (i % 4) * 3;

    pushMatrix();
    translate(x + sway, y);
    rotate(t * (0.6 + (i % 3) * 0.3) + i);
    fill(cols[i % 4]);
    triangle(-s, s * 0.7, s, s * 0.7, 0, -s);
    popMatrix();
  }
}

// parol: hanging star lantern that sways and glows
void drawParol(float x, float topY, float len, float r, color c, float t, float phase) {

  float swing = 0.09 * sin(t * 1.4 + phase);

  pushMatrix();
  translate(x, topY);
  rotate(swing);

  // string
  stroke(110, 60, 10);
  strokeWeight(2);
  line(0, 0, 0, len - r);

  translate(0, len);          // now at the middle of the parol

  // soft glow
  noStroke();
  fill(255, 255, 210, 70 + 40 * sin(t * 3 + phase));
  ellipse(0, 0, r * 3.2, r * 3.2);

  // tails
  color[] tailCols = { color(0, 90, 220), color(255, 240, 150), color(220, 40, 40) };
  for (int i = -1; i <= 1; i++) {
    float sway = sin(t * 3 + i * 1.3 + phase) * 4;
    float bx = i * r * 0.3;
    float tip = (i == 0) ? r * 1.8 : r * 1.4;
    fill(tailCols[i + 1]);
    triangle(bx - 4, r * 0.5, bx + 4, r * 0.5, bx + sway, tip);
  }

  // star body
  fill(c);
  stroke(100, 20, 20);
  strokeWeight(2);
  drawStar(0, 0, r, r * 0.46);

  // bright inner star + glowing center
  noStroke();
  fill(255, 230, 80);
  drawStar(0, 0, r * 0.58, r * 0.26);
  fill(255, 255, 255, 190 + 60 * sin(t * 5 + phase));
  ellipse(0, 0, r * 0.3, r * 0.3);

  popMatrix();
}

// spinning sun: 8 long red rays, 8 short blue rays, golden core
void drawFlagSun(float cx, float cy, float r, float t) {

  pushMatrix();
  translate(cx, cy);
  rotate(t * 0.5);
  noStroke();

  fill(220, 40, 40);
  for (int i = 0; i < 8; i++) {
    float a = i * TWO_PI / 8;
    triangle(cos(a - 0.2) * r * 0.45, sin(a - 0.2) * r * 0.45,
             cos(a + 0.2) * r * 0.45, sin(a + 0.2) * r * 0.45,
             cos(a) * r, sin(a) * r);
  }

  fill(0, 90, 220);
  for (int i = 0; i < 8; i++) {
    float a = (i + 0.5) * TWO_PI / 8;
    triangle(cos(a - 0.16) * r * 0.45, sin(a - 0.16) * r * 0.45,
             cos(a + 0.16) * r * 0.45, sin(a + 0.16) * r * 0.45,
             cos(a) * r * 0.82, sin(a) * r * 0.82);
  }

  fill(255, 235, 90);
  stroke(180, 100, 0);
  strokeWeight(3);
  ellipse(0, 0, r, r);

  noStroke();
  fill(255);
  ellipse(0, 0, r * 0.4, r * 0.4);
  popMatrix();
}

// the three stars of the flag, twinkling
void drawFlagStars(float cx, float cy, float t) {

  float[] ox = { 0, -24, 24 };
  float[] oy = { -22, 16, 16 };

  stroke(0, 90, 220);
  strokeWeight(3);
  fill(255);
  for (int i = 0; i < 3; i++) {
    float s = 1 + 0.15 * sin(t * 3 + i * 2.1);
    pushMatrix();
    translate(cx + ox[i], cy + oy[i]);
    rotate(sin(t + i) * 0.15);
    scale(s);
    drawStar(0, 0, 15, 6.5);
    popMatrix();
  }
}

// three pulsing diamonds in the flag colors
void drawDiamondStack(float cx, float cy, float t) {

  color[] cols = { color(220, 40, 40), color(0, 90, 220), color(255) };

  stroke(110, 60, 10);
  strokeWeight(2);
  for (int i = 0; i < 3; i++) {
    float s = 1 + 0.12 * sin(t * 2.5 + i * 1.2);
    float h = 15 * s;
    float dy = (i - 1) * 34;
    fill(cols[i]);
    quad(cx, cy + dy - h, cx + h, cy + dy, cx, cy + dy + h, cx - h, cy + dy);
  }
}

// height of the string between anchor points (gentle swag)
float swagY(float x) {
  return 8 * sin(PI * ((x % 250) / 250.0));
}

// banderitas (fiesta bunting) swaying along the top
void drawBanderitas(float t) {

  color[] cols = { color(0, 90, 220), color(220, 40, 40), color(255), color(255, 235, 120) };
  float y0 = 22;
  float flagW = 30;

  // the string
  noFill();
  stroke(110, 60, 10);
  strokeWeight(2);
  beginShape();
  for (float x = 0; x <= width; x += 10) {
    vertex(x, y0 + swagY(x));
  }
  endShape();

  // the little flags
  strokeWeight(1);
  stroke(110, 60, 10);
  for (int i = 0; i * flagW < width; i++) {
    float x0 = i * flagW;
    float x1 = x0 + flagW;
    float xm = (x0 + x1) / 2;
    float sway = sin(t * 3 + i * 0.6) * 3;
    fill(cols[i % 4]);
    triangle(x0 + 2, y0 + swagY(x0 + 2),
             x1 - 2, y0 + swagY(x1 - 2),
             xm + sway, y0 + swagY(xm) + 20);
  }
}

// woven diamond border around the whole screen (red, gold, blue, white)
void drawWeaveBorder() {

  float b = 16;
  float h = b / 2 - 1.5;
  color[] cols = { color(220, 40, 40), color(255, 215, 0), color(0, 90, 220), color(255) };

  rectMode(CENTER);
  noStroke();

  // navy base strips
  fill(0, 35, 110);
  rect(width/2, b/2, width, b);
  rect(width/2, height - b/2, width, b);
  rect(b/2, height/2, b, height);
  rect(width - b/2, height/2, b, height);

  // diamonds along the top and bottom
  for (int i = 0; i * b < width; i++) {
    float cx = i * b + b/2;

    fill(cols[i % 4]);
    quad(cx, b/2 - h, cx + h, b/2, cx, b/2 + h, cx - h, b/2);

    fill(cols[(i + 2) % 4]);
    quad(cx, height - b/2 - h, cx + h, height - b/2, cx, height - b/2 + h, cx - h, height - b/2);
  }

  // diamonds along the left and right
  for (int j = 0; j * b < height; j++) {
    float cy = j * b + b/2;

    fill(cols[j % 4]);
    quad(b/2, cy - h, b/2 + h, cy, b/2, cy + h, b/2 - h, cy);

    fill(cols[(j + 2) % 4]);
    quad(width - b/2, cy - h, width - b/2 + h, cy, width - b/2, cy + h, width - b/2 - h, cy);
  }

  // thin gold line on the inner edge
  noFill();
  stroke(255, 215, 0);
  strokeWeight(2);
  rect(width/2, height/2, width - 2 * b, height - 2 * b);
}