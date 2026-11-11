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

    if (overButton(width/2, 640, 220, 55)) {
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
