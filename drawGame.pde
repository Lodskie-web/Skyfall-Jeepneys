void drawGame() {

  // Update the game clock using real elapsed time
  int now = millis();
  int dt = min(now - lastMillis, 100);
  lastMillis = now;

  gameMs += dt;
  survivalTime = gameMs / 1000;

  // ---------- difficulty: one more jeepney every 15-20 seconds ----------
if (gameNow() >= nextJeepneyAt) {
  if (baseJeepneyCount() < MAX_BASE_JEEPNEYS) {
    jeepneys.add(new Jeepney());

    popup("DAGDAG JEEPNEY!", width/2, 215,
      color(255, 210, 0), color(0, 40, 120), 38, 1600);
  }

  nextJeepneyAt = gameNow() + int(random(15000, 20000));
}

  background(40, 70, 120);
  image(background, 80, 250, 1900, 800);

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
