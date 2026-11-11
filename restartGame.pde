void restartGame() {
  lives = 3;
  jeepneys.clear();

  for (int i = 0; i < 5; i++) {
    jeepneys.add(new Jeepney());
  }

  score = 0;
  startFrame = frameCount;

  score = 0;
  scoreBoard = frameCount;

  // reset HUD animation + invincibility for the new run
  lastScore = 0;
  scorePopTime = -10000;
  player.reset();

  // NEW: clear any leftover popups
  popups.clear();
}
