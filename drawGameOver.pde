void drawGameOver() {

  imageMode(CORNER);
  image(gameover, 0, 0, width, height);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // NEW HIGH SCORE / NEW PERSONAL BEST ribbon.
  // Top-right corner: clear of the bus and the GAME OVER lettering.
  // Change these two numbers to move it.
  if (ribbonKind > 0) {
    drawRibbon(820, 70);
  }

  fill(255);

  textFont(fontBig);
  textAlign(CENTER, CENTER);
  textSize(60);
  text("YOUR SCORE: " + score, width/2, 420);

  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(26);
  shadowText("TIME: " + finalTime + "s      BEST: " + bestScore, width/2, 466);

  textSize(22);
  String who = (playerName.length() > 0) ? playerName : "GUEST";
  String rank = (lastRank > 0) ? "RANK #" + lastRank : "NOT RANKED";
  shadowText(who + "   |   " + rank, width/2, 500);

  drawButton(170, 565, 260, 62, "PLAY AGAIN");
  drawButton(500, 565, 260, 62, "LEADERBOARD");
  drawButton(830, 565, 260, 62, "MAIN MENU");
}

// red ribbon = new overall high score, blue ribbon = new personal best
void drawRibbon(float cx, float cy) {

  boolean isHighScore = (ribbonKind == 1);
  String label = isHighScore ? "NEW HIGH SCORE!" : "NEW PERSONAL BEST!";
  float pulse = 1 + 0.05 * sin(millis() / 120.0);

  pushMatrix();
  translate(cx, cy);
  rotate(0.12);
  scale(pulse);

  strokeWeight(4);
  if (isHighScore) {
    stroke(120, 0, 0);
    fill(220, 40, 40);
  } else {
    stroke(0, 40, 120);
    fill(0, 90, 220);
  }
  rect(0, 0, 330, 56, 12);

  noStroke();
  fill(255, 210, 0);
  drawStar(-148, 0, 13, 6);
  drawStar(148, 0, 13, 6);

  fill(255);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  fitTextSize(label, 250, 28);
  text(label, 0, -2);
  popMatrix();
}