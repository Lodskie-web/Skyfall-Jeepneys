
void drawGame() {

  imageMode(CENTER);
  rectMode(CENTER);

  // Update the game clock
  int now = millis();
  int dt = min(now - lastMillis, 100);
  lastMillis = now;

  // Update countdown
  if (countdownActive) {
    updateCountdown();

    // Player movement continues during countdown
    player.update();
  }

  // Game only runs after countdown and when not paused
  boolean running = !isPaused && !countdownActive;

  if (running) {

    gameMs += dt;
    survivalTime = gameMs / 1000;

    // Update environment based on score
    updateEnvironment();

    // Player movement
    player.update();

    // Difficulty: one more jeepney every 15-20 seconds
    if (gameNow() >= nextJeepneyAt) {

      if (baseJeepneyCount() < MAX_BASE_JEEPNEYS) {
        jeepneys.add(new Jeepney());

        popup("DAGDAG JEEPNEY!", width/2, 215,
          color(255, 210, 0), color(0, 40, 120), 38, 1600);
      }

      nextJeepneyAt = gameNow() + int(random(15000, 20000));
    }

    // Spawn piso coins
    if (gameNow() >= nextCoinAt) {
      pickups.add(new Pickup(0));
      nextCoinAt = gameNow() + int(random(2500, 5000));
    }

    // Spawn other power-ups
    if (gameNow() >= nextPowerupAt) {
      pickups.add(new Pickup(randomPowerupType()));
      nextPowerupAt = gameNow() + int(random(14000, 22000));
    }
  }

  // ================= WORLD =================

  background(40, 70, 120);
  image(background, 80, 250, 1900, 800);

  player.display();

  // Jeepneys
  for (Jeepney j : jeepneys) {

    if (running) {
      j.update();

      // Track the closest distance for the SAKTO bonus
      trackNearMissDistance(j);
    }

    j.display();

    if (running) {

      // Collision with invincibility protection
      if (j.hitPlayer(player) &&
        !j.scored &&
        millis() >= invincibleUntil) {

        j.scored = true;

        // Sampaguita shield absorbs one collision
        if (player.hasShield) {

          player.hasShield = false;
          invincibleUntil = millis() + 1000;

          popup("ILAG!", player.getX(), player.getY() - 80,
            color(0, 90, 220), color(255), 46, 1000);
        } else {

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
      }

      // Jeepney passes player
      if (!j.scored && j.y > player.y) {

        // Normal passing score
        score++;
        j.scored = true;

        // Additional SAKTO near-miss bonus
        if (qualifiesForNearMiss(j)) {
          awardNearMissBonus();
        }
      }
    }
  }

  // ================= PICKUPS =================

  for (int i = pickups.size() - 1; i >= 0; i--) {

    Pickup p = pickups.get(i);

    if (running) {
      p.update();

      // Collect pickup
      if (dist(p.x, p.y, player.getX(), player.getY()) < 60) {
        collectPickup(p);
        pickups.remove(i);
        continue;
      }

      // Remove pickups that leave the screen
      if (p.y > height + 60) {
        pickups.remove(i);
        continue;
      }
    }

    p.display();
  }

  // ================= ENVIRONMENT EFFECTS =================

  drawEnvOverlay(0.35);
  drawRain();

  // ================= VISUAL EFFECTS =================

  // KAPE tint covers the world and pickups
  drawCoffeeTint();

  // ================= POPUPS =================

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

  // Countdown appears above the HUD
  if (countdownActive) {
    drawCountdown();
  }

  // Pause menu appears above everything
  if (isPaused) {
    drawPauseMenu();
  }
}


void popup(String msg, float x, float y,
  color fillC, color outlineC, float txtSize, int life) {

  popups.add(new PopText(msg, x, y, fillC, outlineC, txtSize, life));
}