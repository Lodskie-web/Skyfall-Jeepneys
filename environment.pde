// =====================================================================
//  Day -> sunset -> night -> rain, driven by the score
//  (change SUNSET_SCORE / NIGHT_SCORE / RAIN_SCORE in skyFall.pde)
// =====================================================================

void initRain() {
  for (int i = 0; i < rainX.length; i++) {
    rainX[i] = random(width);
    rainY[i] = random(height);
    rainSpd[i] = random(14, 22);
  }
}

void updateEnvironment() {

  int stage = 0;
  if (score >= RAIN_SCORE)       stage = 3;
  else if (score >= NIGHT_SCORE) stage = 2;
  else if (score >= SUNSET_SCORE) stage = 1;

  // ease smoothly toward the target look
  float targetPhase = min(stage, 2);
  envPhase += (targetPhase - envPhase) * 0.01;

  float targetRain = (stage == 3) ? 1 : 0;
  rainAmount += (targetRain - rainAmount) * 0.02;

  // announce each change once
  if (stage > lastEnvStage) {
    lastEnvStage = stage;
    if (stage == 1) {
      popup("HAPON NA!", width/2, height/2 - 60, color(255, 140, 40), color(255), 60, 2200);
    } else if (stage == 2) {
      popup("GABI NA!", width/2, height/2 - 60, color(60, 90, 220), color(255), 60, 2200);
    } else {
      popup("UMUULAN!", width/2, height/2 - 60, color(0, 90, 220), color(255), 60, 2200);
    }
  }

  // rain drops + lightning
  if (rainAmount > 0.03) {
    for (int i = 0; i < rainX.length; i++) {
      rainY[i] += rainSpd[i];
      rainX[i] -= 3;
      if (rainY[i] > height || rainX[i] < -10) {
        rainY[i] = random(-60, 0);
        rainX[i] = random(width + 100);
      }
    }

    int now = gameNow();
    if (rainAmount > 0.5 && now >= nextLightning) {
      lightningUntil = now + 140;
      nextLightning = now + int(random(5000, 11000));
    }
  }
}

// colour wash: none (day) -> orange (sunset) -> dark blue (night)
void drawEnvOverlay(float strength) {

  if (envPhase < 0.02) return;

  color c;
  float a;
  if (envPhase <= 1) {
    c = color(255, 120, 40);
    a = 95 * envPhase;
  } else {
    float k = envPhase - 1;
    c = lerpColor(color(255, 120, 40), color(10, 20, 70), k);
    a = lerp(95, 150, k);
  }

  noStroke();
  fill(red(c), green(c), blue(c), a * strength);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);
}

void drawRain() {

  if (rainAmount > 0.03) {
    stroke(190, 210, 255, 150);
    strokeWeight(2);
    int n = int(rainX.length * rainAmount);
    for (int i = 0; i < n; i++) {
      line(rainX[i], rainY[i], rainX[i] - 4, rainY[i] + 16);
    }

    noStroke();
    fill(40, 60, 90, 40 * rainAmount);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
  }

  // lightning flash
  if (gameNow() < lightningUntil) {
    noStroke();
    fill(255, 255, 255, 90);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
  }
}