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

  // ================= GAME (pause menu buttons) =================
  else if (gameState == 1) {

    if (isPaused) {

      if (overButton(width/2, pauseBtnY(0), 280, 64)) {
        setPaused(false);
        return;
      }

      if (overButton(width/2, pauseBtnY(1), 280, 64)) {
        toggleMute();
        return;
      }

      if (overButton(width/2, pauseBtnY(2), 280, 64)) {
        goToMenu();
        return;
      }
    }
  }

  // ================= HOW TO PLAY =================
  else if (gameState == 2) {

    // FIXED: the button is drawn at y=625 (this used to check 640)
    if (overButton(width/2, 625, 220, 55)) {
      gameState = 0;
      return;
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
      goToMenu();
      return;
    }
  }
}

void keyPressed() {

  // ESC normally closes the sketch: block that and use it as pause / back
  if (key == ESC) {
    key = 0;
    if (gameState == 1) {
      togglePause();
    } else if (gameState == 2) {
      gameState = 0;
    } else if (gameState == 3) {
      goToMenu();
    }
    return;
  }

  if (key == CODED) {
    if (keyCode == LEFT)  leftHeld = true;
    if (keyCode == RIGHT) rightHeld = true;
  } else {
    if (key == 'a' || key == 'A') leftHeld = true;
    if (key == 'd' || key == 'D') rightHeld = true;
    if (key == 'p' || key == 'P') togglePause();
    if (key == 'm' || key == 'M') toggleMute();
  }
}

void keyReleased() {

  if (key == CODED) {
    if (keyCode == LEFT)  leftHeld = false;
    if (keyCode == RIGHT) rightHeld = false;
  } else {
    if (key == 'a' || key == 'A') leftHeld = false;
    if (key == 'd' || key == 'D') rightHeld = false;
  }
}

boolean overButton(float x, float y,
                   float w, float h) {

  return mouseX > x - w/2 &&
    mouseX < x + w/2 &&
    mouseY > y - h/2 &&
    mouseY < y + h/2;
}

void goToMenu() {
  isPaused = false;
  countdownActive = false;
  gameState = 0;
  bgMusic.stop();
  bgMusic1.loop();
  sfxStopAll();
}