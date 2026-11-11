// =====================================================================
//  GAME SCREEN
// =====================================================================
void drawGame() {

  background(40, 70, 120);
  image(background, 80, 250, 1900, 800);

  survivalTime = (frameCount - startFrame) / 30;

  player.update();
  player.display();

  for (Jeepney j : jeepneys) {

    j.update();
    j.display();

    // ---------- Collision ----------
    if (!j.scored && j.hitPlayer(player)) {
      j.scored = true;   // a jeepney that touched you never gives points

      // Only lose a life if the player is NOT invincible
      if (!player.isInvincible()) {
        lives--;
        player.hit();        // starts the 2-second blink + invincibility
        popups.add(new PopText("ARAY!", player.getX(), player.getY() - 80));   // NEW
        bgMusic2.play();

        for (Jeepney jeep : jeepneys) {
          jeep.slowDown();
        }

        if (lives <= 0) {
          gameState = 3;
          bgMusic.stop();
        }
      }
    }

    // ---------- Score when jeepney passes player ----------
    if (!j.scored && j.y > player.y) {
      score++;
      j.scored = true;
    }
  }

  // ---------- NEW: ARAY! popups ----------
  for (int i = popups.size() - 1; i >= 0; i--) {
    PopText p = popups.get(i);
    p.display();
    if (p.isDead()) {
      popups.remove(i);
    }
  }

  // HUD is drawn LAST so it always sits on top of the jeepneys
  drawHUD();
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
  float sinceHit = millis() - player.hitTime;
  float shake = (sinceHit < 400) ? random(-3, 3) : 0;

  // heartbeat, faster when only 1 life remains
  float beatSpeed = (lives == 1) ? 90.0 : 180.0;
  float beat = 1 + 0.12 * sin(millis() / beatSpeed);

  for (int i = 0; i < 3; i++) {

    pushMatrix();
    translate(cx + (i - 1) * 50 + shake, cy + 6);

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

    drawHeart(0, 0, 30);
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
