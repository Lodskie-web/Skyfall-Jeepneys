class Jeepney extends GameObject {
  float normalSpeed;
  int lane;

  boolean hit = false;        // already crashed into the player on this pass
  boolean passed = false;     // already went past the player (score was checked)
  float minDist = 99999;      // closest it got to the player (for SAKTO!)
  boolean rush = false;       // part of a rush-hour wave (removed when off-screen)
  boolean dead = false;
  int hitSlowUntil = 0;

  // normal jeepney: respawns forever in a free lane
  Jeepney() {
    super(width / 2, -300, 120, 160);
    normalSpeed = random(5, 10);
    respawn();
  }

  // rush-hour jeepney: one-time, in a chosen lane
  Jeepney(int laneIdx, float startY, float spd) {
    super(laneX(laneIdx) + random(-15, 15), startY, 120, 160);
    lane = laneIdx;
    normalSpeed = spd;
    rush = true;
  }

  void respawn() {
    float newY = random(-450, -100);
    lane = pickFreeLane(newY, this);
    x = laneX(lane) + random(-15, 15);   // small jitter so lane borders aren't permanently safe
    y = newY;
    hit = false;
    passed = false;
    minDist = 99999;
  }

  @Override
  void update() {

    float mult = 1;
    if (gameNow() < hitSlowUntil) mult *= 0.4;   // slowed after you get hit
    if (gameNow() < slowMoUntil)  mult *= 0.5;   // kape slow-mo

    y += normalSpeed * mult;
    normalSpeed = min(normalSpeed + 0.001, 14);  // slowly gets faster

    if (y > height + 90) {
      if (rush) {
        dead = true;
      } else {
        respawn();
      }
    }
  }

  @Override
  void display() {
    imageMode(CENTER);
    if (rush) tint(255, 215, 215);   // rush-hour jeepneys look slightly red
    image(jeepney1, x, y, w, h);
    noTint();

    // blue box = the jeepney's hitbox (press H in-game)
    if (showHitboxes) {
      rectMode(CORNERS);
      noFill();
      stroke(0, 200, 255);
      strokeWeight(2);
      rect(x - w * 0.36, y - h * 0.42, x + w * 0.36, y + h * 0.42);
      rectMode(CENTER);
    }
  }

  // Rectangle collision: the jeepney's box against the player's HEAD box and BODY box.
  // The jeepney box is a bit smaller than the picture so near-misses feel fair.
  boolean hitPlayer(Player p) {
    return p.hitsBox(x - w * 0.36, y - h * 0.42,
                     x + w * 0.36, y + h * 0.42);
  }

  void slowDown() {
    hitSlowUntil = gameNow() + 3000;
  }
}