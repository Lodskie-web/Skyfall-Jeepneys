// ================= PAUSE CONTROL =================

void setPaused(boolean p) {

  if (p == isPaused) return;

  isPaused = p;

  if (isPaused) {
    sfxStopAll();
  }
}


void togglePause() {

  if (gameState == 1 && !countdownActive) {
    setPaused(!isPaused);
  }
}


// ================= PAUSE MENU =================

float pauseBtnY(int i) {
  return height/2 - 60 + i * 80;
}


void drawPauseMenu() {

  rectMode(CENTER);
  noStroke();

  // Dark overlay
  fill(0, 0, 0, 150);
  rect(width/2, height/2, width, height);

  // Main panel
  fill(245, 235, 210);
  stroke(180, 130, 20);
  strokeWeight(8);
  rect(width/2, height/2, 420, 440, 25);

  // Inner border
  noFill();
  stroke(230, 180, 40);
  strokeWeight(3);
  rect(width/2, height/2, 390, 410, 18);

  // PAUSED header
  fill(0, 90, 220);
  stroke(0, 40, 120);
  strokeWeight(4);
  rect(width/2, height/2 - 160, 260, 56, 12);

  fill(220, 40, 40);
  noStroke();
  ellipse(width/2 - 115, height/2 - 160, 10, 10);
  ellipse(width/2 + 115, height/2 - 160, 10, 10);

  fill(255);
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  textSize(34);
  text("PAUSED", width/2, height/2 - 158);

  // Pause menu buttons
  drawButton(width/2, pauseBtnY(0), 280, 64, "RESUME");

  drawButton(width/2, pauseBtnY(1), 280, 64,
    muted ? "SOUND: OFF" : "SOUND: ON");

  drawButton(width/2, pauseBtnY(2), 280, 64, "QUIT TO MENU");

  // Keyboard instructions
  fill(90, 60, 10);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("P / ESC = RESUME     M = MUTE",
    width/2, height/2 + 180);
}