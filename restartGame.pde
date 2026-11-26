void restartGame() {

  lives = 3;
  jeepneys.clear();

  for (int i = 0; i < 5; i++) {
    jeepneys.add(new Jeepney());
  }

  score = 0;
  startFrame = frameCount;
  scoreBoard = frameCount;

  // Reset game clock
  gameMs = 0;
  lastMillis = millis();
  survivalTime = 0;

  // Reset pause state
  isPaused = false;

  // Stop existing sound effects
  sfxStopAll();

  // Start countdown
  countdownActive = true;
  countdownStart = millis();
  lastCountStep = -1;

  // Reset difficulty timer
  nextJeepneyAt = int(random(15000, 20000));

  // Reset invincibility
  invincibleUntil = 0;
  lifeFlashUntil = 0;
}