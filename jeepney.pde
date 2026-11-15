// ---------------------------------------------------------------------
//  Jeepney hitbox: built from the REAL pixels of jeepney1.png.
//  - The thin vertical speed lines above the jeepney are only an effect,
//    so they are NOT part of the hitbox (any horizontal stretch of pixels
//    narrower than ~6% of the picture width is ignored).
//  - What is left is the jeepney itself: roof sign, mirrors, bumper, wheels.
//  Press H in a game to see the hit area (cyan) and the player's boxes.
//
//  PIXEL_HITBOX = true  -> collisions use the exact outline (recommended)
//  PIXEL_HITBOX = false -> collisions use a plain rectangle around the outline
// ---------------------------------------------------------------------
final boolean PIXEL_HITBOX = true;

boolean[] jMask;           // true = this pixel of the picture counts as "jeepney"
PImage jMaskImg;           // cyan picture of the mask (debug view only)
int jImgW = 0;
int jImgH = 0;
boolean jeepneyBoxReady = false;

// bounding box of the jeepney as fractions of the picture. These are measured
// from the original jeepney1.png (body starts about 51% down) and are also
// the fallback if the picture can't be scanned.
float jbTop = 0.511;
float jbBottom = 1.0;
float jbLeft = 0.10;
float jbRight = 0.889;

void computeJeepneyHitbox() {

  jeepneyBoxReady = true;

  if (jeepney1 == null || jeepney1.width < 10 || jeepney1.height < 10) {
    return;
  }

  jImgW = jeepney1.width;
  jImgH = jeepney1.height;
  jeepney1.loadPixels();

  jMask = new boolean[jImgW * jImgH];

  int minSeg = max(8, int(jImgW * 0.06));     // thinner than this = speed line
  int solidCount = 0;
  int minX = jImgW;
  int maxX = -1;
  int minY = jImgH;
  int maxY = -1;

  for (int row = 0; row < jImgH; row++) {
    int run = 0;
    for (int col = 0; col <= jImgW; col++) {

      boolean solid = (col < jImgW) && alpha(jeepney1.pixels[row * jImgW + col]) > 40;

      if (solid) {
        run++;
      } else {
        if (run >= minSeg) {
          for (int k = col - run; k < col; k++) {
            jMask[row * jImgW + k] = true;
          }
          solidCount += run;
          minX = min(minX, col - run);
          maxX = max(maxX, col - 1);
          minY = min(minY, row);
          maxY = max(maxY, row);
        }
        run = 0;
      }
    }
  }

  float coverage = solidCount / (float) (jImgW * jImgH);
  boolean usable = (maxX > minX) && (maxY > minY)
                && coverage < 0.85 && (maxY - minY) > jImgH * 0.2;

  if (usable) {
    jbTop = minY / (float) jImgH;
    jbBottom = (maxY + 1) / (float) jImgH;
    jbLeft = minX / (float) jImgW;
    jbRight = (maxX + 1) / (float) jImgW;
    println("Jeepney hitbox built from the sprite: top " + nf(jbTop, 1, 2)
            + "  bottom " + nf(jbBottom, 1, 2)
            + "  left " + nf(jbLeft, 1, 2)
            + "  right " + nf(jbRight, 1, 2));
  } else {
    // no transparency in the picture (or nothing found): use the fallback rectangle
    for (int i = 0; i < jMask.length; i++) {
      jMask[i] = false;
    }
    for (int row = int(jbTop * jImgH); row < jImgH; row++) {
      for (int col = int(jbLeft * jImgW); col < int(jbRight * jImgW); col++) {
        jMask[row * jImgW + col] = true;
      }
    }
    println("Jeepney hitbox: could not scan the sprite, using the fallback rectangle.");
  }

  // cyan picture of the hit area (shown when you press H)
  jMaskImg = createImage(jImgW, jImgH, ARGB);
  jMaskImg.loadPixels();
  for (int i = 0; i < jMask.length; i++) {
    jMaskImg.pixels[i] = jMask[i] ? color(0, 220, 255, 150) : color(0, 0);
  }
  jMaskImg.updatePixels();
}

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
    if (!jeepneyBoxReady) computeJeepneyHitbox();
    normalSpeed = random(5, 10);
    respawn();
  }

  // rush-hour jeepney: one-time, in a chosen lane
  Jeepney(int laneIdx, float startY, float spd) {
    super(laneX(laneIdx) + random(-15, 15), startY, 120, 160);
    if (!jeepneyBoxReady) computeJeepneyHitbox();
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

  // bounding box of the jeepney body (the speed lines above it are not included)
  float boxL() { return x - w/2 + jbLeft * w; }
  float boxR() { return x - w/2 + jbRight * w; }
  float boxT() { return y - h/2 + jbTop * h; }
  float boxB() { return y - h/2 + jbBottom * h; }

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

    // cyan = the exact hit area of the jeepney (press H in-game)
    if (showHitboxes && jMaskImg != null) {
      image(jMaskImg, x, y, w, h);
    }
  }

  // true if any real jeepney pixel lies inside the screen rectangle (l, t, r, b)
  boolean spriteTouches(float l, float t, float r, float b) {

    float px = x - w/2;
    float py = y - h/2;

    float l2 = max(l, px);
    float r2 = min(r, px + w);
    float t2 = max(t, py);
    float b2 = min(b, py + h);

    if (l2 >= r2 || t2 >= b2) return false;

    for (float sy = t2; sy < b2 + 1; sy += 3) {
      for (float sx = l2; sx < r2 + 1; sx += 3) {
        int u = int((sx - px) / w * jImgW);
        int v = int((sy - py) / h * jImgH);
        if (u >= 0 && u < jImgW && v >= 0 && v < jImgH && jMask[v * jImgW + u]) {
          return true;
        }
      }
    }
    return false;
  }

  // Collision: the jeepney's outline against the player's HEAD box and BODY box.
  boolean hitPlayer(Player p) {

    // quick check first: does the player touch the jeepney's bounding box at all?
    if (!p.hitsBox(boxL(), boxT(), boxR(), boxB())) return false;

    if (!PIXEL_HITBOX || jMask == null) return true;

    // precise check: real jeepney pixels against the head box and the body box
    return spriteTouches(p.headL(), p.headT(), p.headR(), p.headB())
        || spriteTouches(p.bodyL(), p.bodyT(), p.bodyR(), p.bodyB());
  }

  void slowDown() {
    hitSlowUntil = gameNow() + 3000;
  }
}