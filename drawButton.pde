void drawButton(float x, float y,
                float w, float h,
                String label) {

  boolean hover =
    mouseX > x - w/2 &&
    mouseX < x + w/2 &&
    mouseY > y - h/2 &&
    mouseY < y + h/2;

  // ================= BUTTON COLORS =================
  color topColor;
  color bottomColor;
  color borderColor;

  // START GAME = RED
  if (label.equals("START GAME")) {
    topColor = color(255, 80, 60);
    bottomColor = color(180, 20, 20);
    borderColor = color(120, 0, 0);
  }

  // HOW TO PLAY + PLAY AGAIN = YELLOW (FIXED)
  else if (label.equals("HOW TO PLAY") || label.equals("PLAY AGAIN")) {
    topColor = color(255, 230, 50);
    bottomColor = color(230, 170, 0);
    borderColor = color(160, 110, 0);
  }

  // QUIT / DEFAULT = BLUE
  else {
    topColor = color(70, 140, 255);
    bottomColor = color(20, 70, 200);
    borderColor = color(0, 40, 120);
  }

  // Hover glow
  if (hover) {
    stroke(255);
    strokeWeight(4);
  } else {
    stroke(borderColor);
    strokeWeight(3);
  }

  // ================= MAIN BUTTON =================
  fill(bottomColor);
  rect(x, y, w, h, 15);

  // Top glossy layer
  noStroke();
  fill(topColor);
  rect(x, y - 5, w - 8, h/2, 12);

  // Inner body
  fill(lerpColor(topColor, bottomColor, 0.5));
  rect(x, y + 8, w - 8, h - 20, 12);

  // Decorative circles
  fill(255, 220);
  ellipse(x - w/2 + 18, y, 10, 10);
  ellipse(x + w/2 - 18, y, 10, 10);

  // ================= TEXT =================
  fill(255);

  PFont boldFont = createFont("Arial Bold", 28);
  textFont(boldFont);
  textAlign(CENTER, CENTER);

  // Black text for yellow button
  if (label.equals("HOW TO PLAY") || label.equals("PLAY AGAIN")) {
    fill(0);
  }

  text(label, x, y - 2);
}
