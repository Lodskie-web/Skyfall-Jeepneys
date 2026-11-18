
void restartGame() {
  lives = 3;
  jeepneys.clear();

  for (int i = 0; i < 5; i++) {
    jeepneys.add(new Jeepney());
  }

  score = 0;
  startFrame = frameCount;
  scoreBoard = frameCount;

  // Reset invincibility
  invincibleUntil = 0;
  lifeFlashUntil = 0;
}
