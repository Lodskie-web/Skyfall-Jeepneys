
void drawGame() {

  background(40, 70, 120);
  image(background, 80, 250, 1900, 800);

  survivalTime = (frameCount - startFrame) / 30;

  // HUD
  fill(255);
  rect(120, 40, 180, 50, 10);
  rect(width - 120, 40, 180, 50, 10);
  rect(width/2, 40, 180, 50, 10);

  fill(0);
  textSize(24);
  text("SCORE: " + score, 120, 40);
  text("TIME: " + survivalTime, width - 120, 40);
  text("LIVES LEFT: " + lives, width/2, 40);

  if (millis() < lifeFlashUntil) {
    if ((millis() / 100) % 2 == 0) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
  } else {
    fill(0);
  }

  text("LIVES LEFT: " + lives, width/2, 40);

  player.update();
  player.display();

  for (Jeepney j : jeepneys) {

    j.update();
    j.display();

    // Collision with invincibility protection
    if (j.hitPlayer(player) &&
        !j.scored &&
        millis() >= invincibleUntil) {

      j.scored = true;
      lives--;

      // Protect the player for 2 seconds
      invincibleUntil = millis() + 2000;

      lifeFlashUntil = millis() + 1500;

      for (Jeepney jeep : jeepneys) {
        jeep.slowDown();
      }

      bgMusic2.play();

      if (lives <= 0) {
        gameState = 3;
        bgMusic.stop();
      }
    }

    // Score when jeepney passes player
    if (!j.scored && j.y > player.y) {
      score++;
      j.scored = true;
    }
  }
}
