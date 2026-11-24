int gameNow() {
  return gameMs;
}

float laneX(int lane) {
  return (lane + 0.5) * (width / (float) LANES);
}

// picks a lane with no other jeepney near the spawn height
int pickFreeLane(float newY, Jeepney self) {
  for (int tries = 0; tries < 15; tries++) {
    int l = int(random(LANES));
    boolean free = true;

    for (Jeepney o : jeepneys) {
      if (o != self && o.lane == l && abs(o.y - newY) < 240) {
        free = false;
        break;
      }
    }

    if (free) return l;
  }

  return int(random(LANES));
}
