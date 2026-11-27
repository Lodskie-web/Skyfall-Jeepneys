int gameNow() {
  return gameMs;
}


float laneX(int lane) {
  return (lane + 0.5) * (width / (float) LANES);
}


int pickFreeLane(float newY, Jeepney self) {

  for (int tries = 0; tries < 15; tries++) {

    int l = int(random(LANES));
    boolean free = true;

    for (Jeepney o : jeepneys) {

      if (o != self &&
        o.lane == l &&
        abs(o.y - newY) < 240) {

        free = false;
        break;
      }
    }

    if (free) {
      return l;
    }
  }

  return int(random(LANES));
}


int baseJeepneyCount() {
  return jeepneys.size();
}


// ================= POWER-UPS =================

// Randomly selects pandesal, kape, or sampaguita
int randomPowerupType() {

  int t = 1 + int(random(3));

  // Do not spawn pandesal when lives are already full
  if (t == 1 && lives >= MAX_LIVES) {
    t = 2 + int(random(2));
  }

  return t;
}


// What happens when a pickup is collected
void collectPickup(Pickup p) {

  if (p.type == 0) {

    // Piso coin: +5 points
    score += 5;

    popup("+5", p.x, p.y - 30,
      color(255, 210, 0), color(120, 70, 0), 40, 800);
  } else if (p.type == 1) {

    // Pandesal: +1 life, up to 5
    if (lives < MAX_LIVES) {
      lives++;
    } else {
      score += 5;
    }

    popup("+1 BUHAY!", p.x, p.y - 30,
      color(220, 40, 40), color(255), 42, 1100);
  } else if (p.type == 2) {

    // Kape: slow motion for 6 seconds
    slowMoUntil = gameNow() + SLOWMO_MS;

    popup("KAPE TIME!", p.x, p.y - 30,
      color(120, 70, 30), color(255), 42, 1100);
  } else {

    // Sampaguita: one-hit shield
    player.hasShield = true;

    popup("SAMPAGUITA!", p.x, p.y - 30,
      color(255), color(40, 120, 50), 38, 1100);
  }
}


// ================= COUNTDOWN =================

void updateCountdown() {

  int e = millis() - countdownStart;
  int step = (e < 2700) ? e / 900 : 3;

  if (step != lastCountStep) {
    lastCountStep = step;

    if (step < 3) {
      sfxBeep(440, 250);
    } else {
      sfxBeep(880, 500);
    }
  }

  if (e >= 3400) {
    countdownActive = false;
    lastMillis = millis();
  }
}


void drawCountdown() {

  int e = millis() - countdownStart;
  int step = (e < 2700) ? e / 900 : 3;

  float stepT = (step < 3)
    ? (e - step * 900) / 900.0
    : (e - 2700) / 700.0;

  stepT = constrain(stepT, 0, 1);

  String label;

  if (step == 0) label = "3";
  else if (step == 1) label = "2";
  else if (step == 2) label = "1";
  else label = "GO!";

  // Dim the screen
  rectMode(CENTER);
  noStroke();
  fill(0, 0, 0, 90);
  rect(width/2, height/2, width, height);

  float pop = 1 + 1.2 * max(0, 1 - stepT * 4);
  int alpha = int(255 * (1 - pow(stepT, 4)));

  // Spinning Philippine-flag sun
  drawSunBurst(width/2, height/2, 230 * pop,
    millis() / 900.0, alpha);

  pushMatrix();
  translate(width/2, height/2 - 6);
  scale(pop);

  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(190);

  color outline = (step == 3)
    ? color(220, 40, 40)
    : color(0, 40, 120);

  fill(outline, alpha);

  for (int dx = -6; dx <= 6; dx += 6) {
    for (int dy = -6; dy <= 6; dy += 6) {
      text(label, dx, dy);
    }
  }

  fill(255, alpha);
  text(label, 0, 0);
  popMatrix();

  // Caption
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(40);

  shadowText(
    step < 3 ? "HANDA NA?" : "TARA NA!",
    width/2,
    height/2 + 170
    );
}


void drawSunBurst(float cx, float cy,
  float r, float rot, int alpha) {

  pushMatrix();
  translate(cx, cy);
  rotate(rot);

  stroke(255, 200, 0, alpha);
  strokeWeight(10);

  for (int i = 0; i < 16; i++) {
    float a = i * TWO_PI / 16;

    line(
      cos(a) * r * 0.7,
      sin(a) * r * 0.7,
      cos(a) * r,
      sin(a) * r
      );
  }

  noStroke();
  fill(255, 210, 0, alpha);
  ellipse(0, 0, r * 1.2, r * 1.2);

  popMatrix();
}


void shadowText(String s, float x, float y) {

  fill(0, 170);
  text(s, x + 2, y + 2);

  fill(255);
  text(s, x, y);
}
