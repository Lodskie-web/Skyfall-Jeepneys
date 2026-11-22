void drawGame() {

  background(40, 70, 120);
  image(background, 80, 250, 1900, 800);

  survivalTime = (frameCount - startFrame) / 30;

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

  // Draw HUD on top of the game
  drawHUD();
}
