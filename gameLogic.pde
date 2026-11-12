// =====================================================================
//  Everything that happens while the game is actually running
// =====================================================================

int gameNow() {
  return gameMs;
}

float laneX(int lane) {
  return (lane + 0.5) * (width / (float) LANES);
}

void updateGame() {

  int now = gameNow();

  player.update();
  updateEnvironment();
  updateRushHour();

  // ---------- difficulty: one more jeepney every 15-20 seconds ----------
  if (now >= nextJeepneyAt) {
    if (baseJeepneyCount() < MAX_BASE_JEEPNEYS) {
      jeepneys.add(new Jeepney());
      popup("DAGDAG JEEPNEY!", width/2, 215, color(255, 210, 0), color(0, 40, 120), 38, 1600);
    }
    nextJeepneyAt = now + int(random(15000, 20000));
  }

  // ---------- spawn pickups ----------
  if (now >= nextCoinAt) {
    pickups.add(new Pickup(0));
    nextCoinAt = now + int(random(2500, 5000));
  }
  if (now >= nextPowerupAt) {
    pickups.add(new Pickup(randomPowerupType()));
    nextPowerupAt = now + int(random(14000, 22000));
  }

  // ---------- jeepneys ----------
  for (Jeepney j : jeepneys) {
    j.update();

    // remember how close it got (for the SAKTO! bonus)
    float d = dist(j.x, j.y, player.getX(), player.getY());
    if (!j.passed && d < j.minDist) {
      j.minDist = d;
    }

    // collision
    if (!j.hit && j.hitPlayer(player)) {
      j.hit = true;           // a jeepney that touched you never gives points
      playerHit();
    }

    // jeepney passed the player
    if (!j.passed && j.y > player.y) {
      j.passed = true;

      if (!j.hit) {
        score += j.rush ? 2 : 1;            // rush-hour jeepneys are worth double

        // near miss: it got close but never touched you
        if (j.minDist < 95 && now - lastNearMiss > 1200) {
          lastNearMiss = now;
          score += 2;
          popup("SAKTO! +2", player.getX(), player.getY() - 90,
                color(255, 210, 0), color(0, 40, 120), 42, 900);
          sfxNearMiss();
        }
      }
    }
  }

  // remove rush-hour jeepneys that left the screen
  for (int i = jeepneys.size() - 1; i >= 0; i--) {
    if (jeepneys.get(i).dead) {
      jeepneys.remove(i);
    }
  }

  // ---------- pickups ----------
  for (int i = pickups.size() - 1; i >= 0; i--) {
    Pickup p = pickups.get(i);
    p.update();

    if (dist(p.x, p.y, player.getX(), player.getY()) < 60) {
      collectPickup(p);
      pickups.remove(i);
    } else if (p.y > height + 60) {
      pickups.remove(i);
    }
  }
}

// what happens when a jeepney touches the player
void playerHit() {

  if (player.isInvincible()) return;

  // sampaguita shield absorbs the hit
  if (player.hasShield) {
    player.hasShield = false;
    player.invincibleUntil = gameNow() + 1000;
    popup("ILAG!", player.getX(), player.getY() - 80, color(0, 90, 220), color(255), 46, 1000);
    sfxShieldBreak();
    return;
  }

  lives--;
  player.hit();        // starts the 2-second blink + invincibility
  popup("ARAY!", player.getX(), player.getY() - 80, color(220, 40, 40), color(255), 46, 1000);
  bgMusic2.play();

  for (Jeepney jeep : jeepneys) {
    jeep.slowDown();
  }

  if (lives <= 0) {
    endGame();
  }
}

// 0 = piso coin, 1 = pandesal, 2 = kape, 3 = sampaguita
void collectPickup(Pickup p) {

  if (p.type == 0) {
    score += 5;
    popup("+5", p.x, p.y - 30, color(255, 210, 0), color(120, 70, 0), 40, 800);
    sfxCoin();
  }
  else if (p.type == 1) {
    if (lives < MAX_LIVES) {
      lives++;
    } else {
      score += 5;
    }
    popup("+1 BUHAY!", p.x, p.y - 30, color(220, 40, 40), color(255), 42, 1100);
    sfxPowerUp();
  }
  else if (p.type == 2) {
    slowMoUntil = gameNow() + SLOWMO_MS;
    popup("KAPE TIME!", p.x, p.y - 30, color(120, 70, 30), color(255), 42, 1100);
    sfxPowerUp();
  }
  else {
    player.hasShield = true;
    popup("SAMPAGUITA!", p.x, p.y - 30, color(255), color(40, 120, 50), 38, 1100);
    sfxPowerUp();
  }
}

// picks a lane with no other jeepney near the spawn height (pass null for pickups)
int pickFreeLane(float newY, Jeepney self) {
  for (int tries = 0; tries < 15; tries++) {
    int l = int(random(LANES));
    boolean free = true;
    for (Jeepney o : jeepneys) {
      if (o != self && !o.dead && o.lane == l && abs(o.y - newY) < 240) {
        free = false;
        break;
      }
    }
    if (free) return l;
  }
  return int(random(LANES));
}

int baseJeepneyCount() {
  int n = 0;
  for (Jeepney j : jeepneys) {
    if (!j.rush) n++;
  }
  return n;
}

int rushJeepneyCount() {
  int n = 0;
  for (Jeepney j : jeepneys) {
    if (j.rush && !j.dead) n++;
  }
  return n;
}

int randomPowerupType() {
  int t = 1 + int(random(3));                 // 1, 2 or 3
  if (t == 1 && lives >= MAX_LIVES) {
    t = 2 + int(random(2));                   // no pandesal when lives are full
  }
  return t;
}

// =====================================================================
//  RUSH HOUR
// =====================================================================
void updateRushHour() {

  int now = gameNow();

  if (rushState == 0) {
    if (now >= nextRushAt) {
      rushState = 1;                 // warning (siren)
      rushStateUntil = now + 2500;
      sfxRushStart();
    }
  }
  else if (rushState == 1) {
    if (now >= rushStateUntil) {
      spawnRushWave();
      rushState = 2;
      nextHonkAt = now;
    }
  }
  else if (rushState == 2) {

    // honks while the wave is on screen
    if (now >= nextHonkAt) {
      if (rushSound == null) sfxHonk();
      nextHonkAt = now + int(random(180, 650));
    }

    // wave is over once all rush jeepneys have left the screen
    if (rushJeepneyCount() == 0) {
      rushState = 0;
      nextRushAt = now + int(random(55000, 70000));
    }
  }
}

void spawnRushWave() {

  popup("RUSH HOUR!", width/2, 300, color(220, 40, 40), color(255), 64, 1800);

  for (int r = 0; r < 3; r++) {

    // shuffle the lanes, then fill 5 of 8 so there are always 3 gaps to slip through
    ArrayList<Integer> laneList = new ArrayList<Integer>();
    for (int l = 0; l < LANES; l++) {
      laneList.add(l);
    }
    java.util.Collections.shuffle(laneList);

    for (int k = 0; k < LANES - 3; k++) {
      float startY = -150 - r * 400 - random(0, 60);
      jeepneys.add(new Jeepney(laneList.get(k), startY, random(8, 11)));
    }
  }
}

// =====================================================================
//  PAUSE
// =====================================================================
void setPaused(boolean p) {
  if (p == isPaused) return;
  isPaused = p;
  if (isPaused) {
    sfxStopAll();
  }
}

void togglePause() {
  if (gameState == 1 && !countdownActive) {
    setPaused(!isPaused);
  }
}

// =====================================================================
//  COUNTDOWN  (3 ... 2 ... 1 ... GO!)
// =====================================================================
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
  float stepT = (step < 3) ? (e - step * 900) / 900.0 : (e - 2700) / 700.0;
  stepT = constrain(stepT, 0, 1);

  String label;
  if (step == 0) label = "3";
  else if (step == 1) label = "2";
  else if (step == 2) label = "1";
  else label = "GO!";

  // dim the screen
  rectMode(CENTER);
  noStroke();
  fill(0, 0, 0, 90);
  rect(width/2, height/2, width, height);

  float pop = 1 + 1.2 * max(0, 1 - stepT * 4);        // starts big, snaps down
  int alpha = int(255 * (1 - pow(stepT, 4)));          // fades at the very end

  // spinning Philippine-flag sun behind the number
  drawSunBurst(width/2, height/2, 230 * pop, millis() / 900.0, alpha);

  pushMatrix();
  translate(width/2, height/2 - 6);
  scale(pop);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(190);

  color outline = (step == 3) ? color(220, 40, 40) : color(0, 40, 120);
  fill(outline, alpha);
  for (int dx = -6; dx <= 6; dx += 6) {
    for (int dy = -6; dy <= 6; dy += 6) {
      text(label, dx, dy);
    }
  }
  fill(255, alpha);
  text(label, 0, 0);
  popMatrix();

  // small caption
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(40);
  shadowText(step < 3 ? "HANDA NA?" : "TARA NA!", width/2, height/2 + 170);
}

void drawSunBurst(float cx, float cy, float r, float rot, int alpha) {
  pushMatrix();
  translate(cx, cy);
  rotate(rot);

  stroke(255, 200, 0, alpha);
  strokeWeight(10);
  for (int i = 0; i < 16; i++) {
    float a = i * TWO_PI / 16;
    line(cos(a) * r * 0.7, sin(a) * r * 0.7, cos(a) * r, sin(a) * r);
  }

  noStroke();
  fill(255, 210, 0, alpha);
  ellipse(0, 0, r * 1.2, r * 1.2);
  popMatrix();
}