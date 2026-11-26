void mousePressed() {

  // ================= MENU =================
  if (gameState == 0) {

    if (overButton(width/2, 375, 250, 60)) {
      restartGame();
      bgMusic.loop();
      bgMusic1.stop();
      gameState = 1;
      return;
    }

    if (overButton(width/2, 455, 250, 60)) {
      gameState = 2;
      bgMusic.stop();
      return;
    }

    if (overButton(width/2, 545, 250, 60)) {
      exit();
      return;
    }
  }

  // ================= HOW TO PLAY =================
  else if (gameState == 2) {

    if (overButton(width/2, 621, 220, 55)) {
      gameState = 0;
      return;
    }
  }

  // ================= GAME =================
  else if (gameState == 1) {

    // Only the pause menu buttons work while paused
    if (isPaused) {

      // RESUME
      if (overButton(width/2, pauseBtnY(0), 280, 64)) {
        setPaused(false);
        return;
      }

      // SOUND ON / OFF
      if (overButton(width/2, pauseBtnY(1), 280, 64)) {
        toggleMute();
        return;
      }

      // QUIT TO MENU
      if (overButton(width/2, pauseBtnY(2), 280, 64)) {
        setPaused(false);
        countdownActive = false;

        gameState = 0;

        bgMusic.stop();
        bgMusic1.loop();

        sfxStopAll();
        return;
      }
    }
  }

  // ================= GAME OVER =================
  else if (gameState == 3) {

    if (overButton(350, 520, 280, 70)) {
      restartGame();
      bgMusic.loop();
      gameState = 1;
      return;
    }

    if (overButton(650, 520, 280, 70)) {
      gameState = 0;
      bgMusic.stop();
      bgMusic1.loop();
      return;
    }
  }
}


boolean overButton(float x, float y,
  float w, float h) {

  return mouseX > x - w/2 &&
    mouseX < x + w/2 &&
    mouseY > y - h/2 &&
    mouseY < y + h/2;
}