void restartGame() {
  lives = 3;
  jeepneys.clear();
  pickups.clear();
  popups.clear();

  // game clock + countdown
  gameMs = 0;
  lastMillis = millis();
  isPaused = false;
  countdownActive = true;
  countdownStart = millis();
  lastCountStep = -1;

  score = 0;
  startFrame = frameCount;
  scoreBoard = frameCount;
  survivalTime = 0;
  ribbonKind = 0;
  lastRank = 0;

  // difficulty + events
  nextJeepneyAt = int(random(15000, 20000));
  nextRushAt = int(random(50000, 65000));
  rushState = 0;
  nextCoinAt = int(random(2500, 4500));
  nextPowerupAt = int(random(9000, 14000));
  slowMoUntil = 0;
  lastNearMiss = -10000;

  // environment
  envPhase = 0;
  rainAmount = 0;
  lastEnvStage = 0;
  nextLightning = 0;
  lightningUntil = 0;

  // HUD animation
  lastScore = 0;
  scorePopTime = -10000;

  player.reset();
  sfxStopAll();

  for (int i = 0; i < 5; i++) {
    jeepneys.add(new Jeepney());
  }
}

// called when lives reach 0
void endGame() {
  gameState = 3;
  isPaused = false;
  bgMusic.stop();
  sfxStopAll();

  finalTime = survivalTime;
  submitScore(score, finalTime);    // saves to the leaderboard under the logged-in name
}