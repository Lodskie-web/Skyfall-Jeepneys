void keyPressed() {

  // ESC pauses or resumes instead of closing the sketch
  if (key == ESC) {
    if (gameState == 1) {
      togglePause();
    }

    key = 0;
    return;
  }

  if (gameState == 1) {

    // P pauses or resumes
    if (key == 'p' || key == 'P') {
      togglePause();
      return;
    }

    // M toggles sound
    if (key == 'm' || key == 'M') {
      toggleMute();
      return;
    }
  }

  // Movement controls
  if (key == CODED) {
    if (keyCode == LEFT) leftHeld = true;
    if (keyCode == RIGHT) rightHeld = true;
  } else {
    if (key == 'a' || key == 'A') leftHeld = true;
    if (key == 'd' || key == 'D') rightHeld = true;
  }
}


void keyReleased() {

  if (key == CODED) {
    if (keyCode == LEFT) leftHeld = false;
    if (keyCode == RIGHT) rightHeld = false;
  } else {
    if (key == 'a' || key == 'A') leftHeld = false;
    if (key == 'd' || key == 'D') rightHeld = false;
  }
}