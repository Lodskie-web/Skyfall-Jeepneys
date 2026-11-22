class PopText {
  String msg;
  float x, y;
  float txtSize;
  int born;
  int life;
  color fillC;
  color outlineC;

  PopText(String msg, float x, float y, color fillC, color outlineC, float txtSize, int life) {
    this.msg = msg;
    this.x = constrain(x, 160, width - 160);
    this.y = y;
    this.fillC = fillC;
    this.outlineC = outlineC;
    this.txtSize = txtSize;
    this.life = life;
    this.born = millis();
  }

  boolean isDead() {
    return millis() - born > life;
  }

  void display() {
    float p = constrain((millis() - born) / (float) life, 0, 1);

    float rise = p * 70;
    float alpha = 255 * (1 - p * p);
    float pop = 1 + 0.5 * max(0, 1 - p * 6);
    float wobbleAmt = (life <= 1200) ? 0.12 : 0.02;
    float wobble = sin(millis() / 40.0) * wobbleAmt * (1 - p);

    pushMatrix();
    translate(x, y - rise);
    rotate(wobble);
    scale(pop);

    textAlign(CENTER, CENTER);
    textSize(txtSize);

    // Outline
    float o = txtSize / 15.0;
    fill(outlineC, alpha);

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        text(msg, dx * o, dy * o);
      }
    }

    // Main text
    fill(fillC, alpha);
    text(msg, 0, 0);

    popMatrix();
  }
}
