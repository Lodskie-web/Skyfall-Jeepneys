void mousePressed() {

  // ================= MENU =================
  if (gameState == 0) {

    // the "delete player?" window is open: only its two buttons work
    if (confirmDelete) {
      if (overButton(width/2 - 120, 425, 200, 54)) {
        deleteCurrentPlayer();
        confirmDelete = false;
        return;
      }
      if (overButton(width/2 + 120, 425, 200, 54)) {
        confirmDelete = false;
        return;
      }
      return;
    }

    if (overButton(width/2, 375, 270, 54)) {
      if (playerName.length() == 0) {
        openNameEntry(true);      // first time: log in, then start playing
      } else {
        startGame();
      }
      return;
    }

    if (overButton(width/2, 440, 270, 54)) {
      gameState = 2;
      bgMusic.stop();
      return;
    }

    if (overButton(width/2, 505, 270, 54)) {
      openLeaderboard(0);
      return;
    }

    if (overButton(width/2, 570, 270, 54)) {
      exit();
      return;
    }

    // player chip: pencil = edit name, trash = delete, name area = switch player
    if (overPlayerEdit()) {
      openEditName();
      return;
    }

    if (overPlayerDelete()) {
      confirmDelete = true;
      return;
    }

    if (overPlayerSwitch()) {
      openNameEntry(false);
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

    if (overButton(width/2, 625, 220, 55)) {
      gameState = 0;
      return;
    }
  }

  // ================= GAME OVER =================
  else if (gameState == 3) {

    if (overButton(170, 565, 260, 62)) {
      startGame();
      return;
    }

    if (overButton(500, 565, 260, 62)) {
      openLeaderboard(3);
      return;
    }

    if (overButton(830, 565, 260, 62)) {
      goToMenu();
      return;
    }
  }

  // ================= PLAYER LOGIN / EDIT NAME =================
  else if (gameState == 4) {

    if (overButton(width/2 - 130, 520, 240, 56)) {
      submitName();
      return;
    }

    if (overButton(width/2 + 130, 520, 200, 56)) {
      gameState = 0;
      return;
    }

    // returning players (only on the login screen, not while editing)
    if (!editingName) {
      for (int i = 0; i < recentNames.size(); i++) {
        if (overButton(nameChipX(i), nameChipY(i), 180, 40)) {
          loginAs(recentNames.get(i));
          return;
        }
      }
    }
  }

  // ================= LEADERBOARD =================
  else if (gameState == 5) {

    if (overButton(300, 614, 220, 50)) {
      gameState = leaderboardFrom;
      return;
    }

    // CLEAR SCORES needs two clicks within 3 seconds
    if (overButton(700, 614, 280, 50)) {
      if (millis() < clearArmedUntil) {
        clearLeaderboard();
        clearArmedUntil = 0;
      } else {
        clearArmedUntil = millis() + 3000;
      }
      return;
    }
  }
}

void keyPressed() {

  // ESC normally closes the sketch: block that and use it as pause / back
  if (key == ESC) {
    key = 0;
    if (gameState == 0) {
      confirmDelete = false;
    } else if (gameState == 1) {
      togglePause();
    } else if (gameState == 2) {
      gameState = 0;
    } else if (gameState == 3) {
      goToMenu();
    } else if (gameState == 4) {
      gameState = 0;
    } else if (gameState == 5) {
      gameState = leaderboardFrom;
    }
    return;
  }

  // typing your name: letters must NOT trigger movement / pause / mute
  if (gameState == 4) {
    handleNameKey();
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

    // H = show / hide the collision hitboxes (handy for tuning)
    if ((key == 'h' || key == 'H') && gameState == 1) showHitboxes = !showHitboxes;
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

// starts a fresh run (menu START GAME, PLAY AGAIN, or right after logging in)
void startGame() {
  restartGame();
  bgMusic.loop();
  bgMusic1.stop();
  gameState = 1;
}

void goToMenu() {
  isPaused = false;
  countdownActive = false;
  confirmDelete = false;
  gameState = 0;
  bgMusic.stop();
  bgMusic1.loop();
  sfxStopAll();
}