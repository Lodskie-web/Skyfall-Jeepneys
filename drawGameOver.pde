void drawGameOver() {

  imageMode(CORNER);
  image(gameover, 0, 0, width, height);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // NEW HIGH SCORE ribbon (move the 345 if it overlaps your artwork)
  if (newHighScore) {
    float pulse = 1 + 0.06 * sin(millis() / 120.0);
    pushMatrix();
    translate(width/2, 345);
    scale(pulse);
    stroke(120, 0, 0);
    strokeWeight(4);
    fill(220, 40, 40);
    rect(0, 0, 440, 56, 12);
    noStroke();
    fill(255, 210, 0);
    drawStar(-190, 0, 14, 6);
    drawStar(190, 0, 14, 6);
    fill(255);
    textFont(hudFont);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("NEW HIGH SCORE!", 0, -2);
    popMatrix();
  }

  fill(255);

  textFont(fontBig);
  textAlign(CENTER, CENTER);
  textSize(60);

  text("YOUR SCORE: " + score, width/2, 420);

  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(26);
  shadowText("TIME: " + finalTime + "s      BEST: " + bestScore, width/2, 468);

  fill(0);
  drawButton(350, 520, 280, 70, "PLAY AGAIN");
  drawButton(650, 520, 280, 70, "MAIN MENU");

}