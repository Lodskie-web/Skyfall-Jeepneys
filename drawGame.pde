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

      // ARAY popup
      popup("ARAY!", player.getX(), player.getY() - 80,
        color(220, 40, 40), color(255), 46, 1000);

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

  // Display and remove expired popups
  for (int i = popups.size() - 1; i >= 0; i--) {
    PopText pt = popups.get(i);
    pt.display();

    if (pt.isDead()) {
      popups.remove(i);
    }
  }

  // Draw HUD on top of the game
  drawHUD();
}

void popup(String msg, float x, float y, color fillC, color outlineC, float txtSize, int life) {
  popups.add(new PopText(msg, x, y, fillC, outlineC, txtSize, life));
}

