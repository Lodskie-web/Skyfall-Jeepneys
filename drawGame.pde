// =====================================================================
//  GAME SCREEN
// =====================================================================
void drawGame() {

  imageMode(CENTER);
  rectMode(CENTER);

  // ---------- game clock: only ticks while actually playing ----------
  int now = millis();
  int dt = min(now - lastMillis, 100);
  lastMillis = now;

  if (countdownActive) {
    updateCountdown();
    player.update();          // let the player line up during the countdown
  }

  boolean running = !isPaused && !countdownActive;

  if (running) {
    gameMs += dt;
    survivalTime = gameMs / 1000;   // real seconds (stops while paused)
    updateGame();
  }

  // ---------- draw the world ----------
  background(40, 70, 120);
  image(background, 80, 250, 1900, 800);
  drawEnvOverlay(1.0);              // sunset / night tint on the background

  player.display();

  for (Jeepney j : jeepneys) {
    j.display();
  }
  for (Pickup p : pickups) {
    p.display();
  }

  drawEnvOverlay(0.35);             // lighter tint over the vehicles too
  drawRain();

  // coffee slow-mo tint
  if (gameNow() < slowMoUntil) {
    noStroke();
    fill(150, 90, 30, 40);
    rect(width/2, height/2, width, height);
  }

  // floating popups (ARAY!, SAKTO!, ...)
  for (int i = popups.size() - 1; i >= 0; i--) {
    PopText pt = popups.get(i);
    pt.display();
    if (pt.isDead()) {
      popups.remove(i);
    }
  }

  // HUD is drawn LAST so it always sits on top
  drawHUD();

  if (countdownActive) {
    drawCountdown();
  }
  if (isPaused) {
    drawPauseMenu();
  }
}

// =====================================================================
//  HUD (Filipino-themed + animated)
// =====================================================================
void drawHUD() {

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // Detect a score change -> triggers the pop animation
  if (score != lastScore) {
    scorePopTime = millis();
    lastScore = score;
  }

  float t = millis() / 350.0;
  float baseY = 68;

  drawBunting();

  // Each panel bobs gently, slightly out of step with the others
  drawScorePanel(130,         baseY + sin(t) * 2);
  drawLivesPanel(width / 2,   baseY + sin(t + 1.5) * 2);
  drawTimePanel(width - 130,  baseY + sin(t + 3.0) * 2);

  drawStatusChips();
  drawRushBanner();
}

// Banderitas (fiesta bunting) swaying across the top
void drawBunting() {

  color[] flagColors = {
    color(0, 90, 220),     // blue
    color(220, 40, 40),    // red
    color(255, 210, 0),    // yellow
    color(255)             // white
  };

  float flagW = 40;
  float t = millis() / 300.0;

  // the string
  stroke(120, 80, 20);
  strokeWeight(3);
  line(0, 2, width, 2);

  // the little flags
  strokeWeight(1);
  stroke(60);
  for (int i = 0; i * flagW < width; i++) {
    float x = i * flagW;
    float sway = sin(t + i * 0.6) * 4;
    fill(flagColors[i % 4]);
    triangle(x + 2, 3, x + flagW - 2, 3, x + flagW / 2 + sway, 26);
  }
}

// Cream panel with a blue label tab (same look as the How To Play screen)
void drawHudPanel(float cx, float cy, float w, float h, String label, color border) {

  rectMode(CENTER);

  // cream body
  stroke(border);
  strokeWeight(4);
  fill(245, 235, 210);
  rect(cx, cy, w, h, 14);

  // blue label tab on the top edge
  stroke(0, 40, 120);
  strokeWeight(3);
  fill(0, 90, 220);
  rect(cx, cy - h/2, w * 0.7, 22, 8);

  // red dots on the tab
  noStroke();
  fill(220, 40, 40);
  ellipse(cx - w * 0.35 + 12, cy - h/2, 7, 7);
  ellipse(cx + w * 0.35 - 12, cy - h/2, 7, 7);

  // label
  fill(255);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(15);
  text(label, cx, cy - h/2 - 2);
}

// Big number with a golden drop shadow
void drawHudValue(String s, float x, float y, float scaleAmt, color c) {
  pushMatrix();
  translate(x, y);
  scale(scaleAmt);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(230, 180, 40);
  text(s, 2, 2);
  fill(c);
  text(s, 0, 0);
  popMatrix();
}

void drawScorePanel(float cx, float cy) {

  drawHudPanel(cx, cy, 200, 50, "SCORE", color(180, 130, 20));

  // 1 right after scoring, fades to 0 over 350 ms
  float pop = max(0, 1 - (millis() - scorePopTime) / 350.0);

  // gold star: twinkles all the time, spins when you score
  float twinkle = 1 + 0.08 * sin(millis() / 200.0);
  pushMatrix();
  translate(cx - 62, cy + 6);
  rotate(pop * TWO_PI);
  scale(twinkle + pop * 0.5);
  fill(255, 210, 0);
  stroke(180, 130, 20);
  strokeWeight(2);
  drawStar(0, 0, 15, 7);
  popMatrix();

  // number pops and flashes red when the score goes up
  color c = lerpColor(color(0, 40, 120), color(220, 40, 40), pop);
  drawHudValue(str(score), cx + 22, cy + 6, 1 + pop * 0.35, c);
}

void drawLivesPanel(float cx, float cy) {

  boolean invincible = player.isInvincible();
  boolean blinkOn = invincible && (millis() / 100) % 2 == 0;

  // panel border flashes red while the player is invincible
  color border = blinkOn ? color(220, 40, 40) : color(180, 130, 20);
  drawHudPanel(cx, cy, 200, 50, "LIVES LEFT", border);

  // little shake right after getting hit
  float sinceHit = gameNow() - player.hitTime;
  float shake = (sinceHit < 400) ? random(-3, 3) : 0;

  // heartbeat, faster when only 1 life remains
  float beatSpeed = (lives == 1) ? 90.0 : 180.0;
  float beat = 1 + 0.12 * sin(millis() / beatSpeed);

  // 3 hearts normally, more when you collect pandesal
  int n = max(3, lives);
  float spacing = (n <= 3) ? 50 : 38;
  float heartSize = (n <= 3) ? 30 : 26;

  for (int i = 0; i < n; i++) {

    pushMatrix();
    translate(cx + (i - (n - 1) / 2.0) * spacing + shake, cy + 6);

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
      // empty heart
      stroke(150);
      strokeWeight(2);
      fill(210, 200, 180);
    }

    drawHeart(0, 0, heartSize);
    popMatrix();
  }
}

void drawTimePanel(float cx, float cy) {

  drawHudPanel(cx, cy, 200, 50, "TIME", color(180, 130, 20));

  // spinning sun (from the Philippine flag)
  pushMatrix();
  translate(cx - 62, cy + 6);
  rotate(millis() / 1500.0);

  stroke(255, 170, 0);
  strokeWeight(3);
  for (int i = 0; i < 8; i++) {
    float a = i * TWO_PI / 8;
    line(cos(a) * 11, sin(a) * 11, cos(a) * 19, sin(a) * 19);
  }

  fill(255, 210, 0);
  stroke(180, 130, 20);
  strokeWeight(2);
  ellipse(0, 0, 18, 18);
  popMatrix();

  drawHudValue(survivalTime + "s", cx + 22, cy + 6, 1, color(0, 40, 120));
}

// small pills under the score panel for active power-ups
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

void drawStatusChip(float x, float y, int iconType, String label, float frac) {

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

  // time-left bar
  if (frac >= 0) {
    fill(200, 190, 160);
    rect(x + 14, y + 8, 70, 5, 3);
    fill(220, 40, 40);
    float w = 70 * constrain(frac, 0, 1);
    rect(x - 21 + w / 2, y + 8, w, 5, 3);
  }
}

// flashing banner during rush hour
void drawRushBanner() {

  if (rushState == 0) return;

  boolean flash = (millis() / 250) % 2 == 0;
  String msg = (rushState == 1) ? "RUSH HOUR PAPARATING!" : "RUSH HOUR!";
  color bg = flash ? color(220, 40, 40) : color(255, 210, 0);
  color fg = flash ? color(255) : color(0, 40, 120);

  rectMode(CENTER);
  stroke(0, 40, 120);
  strokeWeight(4);
  fill(bg);
  rect(width/2, 135, 380, 42, 12);

  fill(fg);
  noStroke();
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(msg, width/2, 134);
}

// 5-point star
void drawStar(float cx, float cy, float outerR, float innerR) {
  beginShape();
  for (int i = 0; i < 10; i++) {
    float r = (i % 2 == 0) ? outerR : innerR;
    float a = -HALF_PI + i * PI / 5;
    vertex(cx + cos(a) * r, cy + sin(a) * r);
  }
  endShape(CLOSE);
}

// Heart shape (s = overall size)
void drawHeart(float cx, float cy, float s) {
  beginShape();
  vertex(cx, cy + s * 0.35);
  bezierVertex(cx - s * 0.6, cy - s * 0.1, cx - s * 0.5, cy - s * 0.6, cx, cy - s * 0.25);
  bezierVertex(cx + s * 0.5, cy - s * 0.6, cx + s * 0.6, cy - s * 0.1, cx, cy + s * 0.35);
  endShape(CLOSE);
}

// =====================================================================
//  PAUSE MENU
// =====================================================================
float pauseBtnY(int i) {
  return height/2 - 90 + i * 80;
}

void drawPauseMenu() {

  rectMode(CENTER);

  // dim everything behind
  noStroke();
  fill(0, 0, 0, 150);
  rect(width/2, height/2, width, height);

  // panel
  fill(245, 235, 210);
  stroke(180, 130, 20);
  strokeWeight(8);
  rect(width/2, height/2, 420, 440, 25);

  noFill();
  stroke(230, 180, 40);
  strokeWeight(3);
  rect(width/2, height/2, 390, 410, 18);

  // title banner
  fill(0, 90, 220);
  stroke(0, 40, 120);
  strokeWeight(4);
  rect(width/2, height/2 - 160, 260, 56, 12);

  fill(220, 40, 40);
  noStroke();
  ellipse(width/2 - 115, height/2 - 160, 10, 10);
  ellipse(width/2 + 115, height/2 - 160, 10, 10);

  fill(255);
  textFont(fontHowTitle);
  textAlign(CENTER, CENTER);
  textSize(34);
  text("PAUSED", width/2, height/2 - 158);

  drawButton(width/2, pauseBtnY(0), 280, 64, "RESUME");
  drawButton(width/2, pauseBtnY(1), 280, 64, muted ? "SOUND: OFF" : "SOUND: ON");
  drawButton(width/2, pauseBtnY(2), 280, 64, "QUIT TO MENU");

  fill(90, 60, 10);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("P / ESC = RESUME     M = MUTE", width/2, height/2 + 180);
}