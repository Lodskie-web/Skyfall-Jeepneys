class PopText {
  String msg;
  float x, y;
  int born;
  int life = 1000;   // how long it stays on screen (ms)

  PopText(String msg, float x, float y) {
    this.msg = msg;
    this.x = constrain(x, 80, width - 80);   // keep it on screen
    this.y = y;
    this.born = millis();
  }

  boolean isDead() {
    return millis() - born > life;
  }

  void display() {
    float p = (millis() - born) / (float) life;   // 0 -> 1 over its lifetime

    float rise   = p * 70;                          // floats upward
    float alpha  = 255 * (1 - p * p);               // fades out near the end
    float pop    = 1 + 0.5 * max(0, 1 - p * 6);     // big "pop" at the start
    float wobble = sin(millis() / 40.0) * 0.12 * (1 - p);   // shakes like "ouch!"

    pushMatrix();
    translate(x, y - rise);
    rotate(wobble);
    scale(pop);

    textFont(hudFont);
    textAlign(CENTER, CENTER);
    textSize(46);

    // white outline
    fill(255, alpha);
    for (int dx = -3; dx <= 3; dx += 3) {
      for (int dy = -3; dy <= 3; dy += 3) {
        text(msg, dx, dy);
      }
    }

    // red text on top
    fill(220, 40, 40, alpha);
    text(msg, 0, 0);

    popMatrix();
  }
}
