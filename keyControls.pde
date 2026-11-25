void keyPressed() {

  // Prevent ESC from closing the sketch
  if (key == ESC) {
    key = 0;
    return;
  }

  if (key == CODED) {
    if (keyCode == LEFT)  leftHeld = true;
    if (keyCode == RIGHT) rightHeld = true;
  } else {
    if (key == 'a' || key == 'A') leftHeld = true;
    if (key == 'd' || key == 'D') rightHeld = true;
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
