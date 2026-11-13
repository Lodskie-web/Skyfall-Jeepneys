void drawButton(float x, float y,
                float w, float h,
                String label) {

  boolean hover =
    mouseX > x - w/2 &&
    mouseX < x + w/2 &&
    mouseY > y - h/2 &&
    mouseY < y + h/2;

  // red = START GAME / CLEAR SCORES / DELETE, yellow = HOW TO PLAY / PLAY AGAIN / RESUME / SAVE,
  // white = LEADERBOARD, blue = the rest
  boolean isRed = label.equals("START GAME") || label.equals("CLEAR SCORES")
               || label.equals("DELETE") || label.startsWith("CONFIRM");
  boolean isYellow = label.equals("HOW TO PLAY") || label.equals("PLAY AGAIN")
                  || label.equals("RESUME") || label.startsWith("SAVE");
  boolean isWhite = label.equals("LEADERBOARD");

  // ================= BUTTON COLORS =================
  color topColor;
  color bottomColor;
  color borderColor;

  if (isRed) {
    topColor = color(255, 80, 60);
    bottomColor = color(180, 20, 20);
    borderColor = color(120, 0, 0);
  }

  else if (isYellow) {
    topColor = color(255, 230, 50);
    bottomColor = color(230, 170, 0);
    borderColor = color(160, 110, 0);
  }

  else if (isWhite) {
    topColor = color(255);
    bottomColor = color(196, 210, 238);
    borderColor = color(0, 40, 120);
  }

  else {
    topColor = color(70, 140, 255);
    bottomColor = color(20, 70, 200);
    borderColor = color(0, 40, 120);
  }

  // Hover glow (gold on the white button so it stays visible)
  if (hover) {
    if (isWhite) {
      stroke(255, 200, 0);
    } else {
      stroke(255);
    }
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

  // Decorative circles (red on the white button, white on the others)
  if (isWhite) {
    fill(220, 40, 40);
  } else {
    fill(255, 220);
  }
  ellipse(x - w/2 + 18, y, 10, 10);
  ellipse(x + w/2 - 18, y, 10, 10);

  // ================= TEXT =================
  textFont(fontBtn);
  textAlign(CENTER, CENTER);

  // shrink long labels so they always fit inside the button
  float ts = 28;
  textSize(ts);
  while (ts > 12 && textWidth(label) > w - 50) {
    ts -= 1;
    textSize(ts);
  }

  // black text on yellow, navy on white, white on the others
  if (isYellow) {
    fill(0);
  } else if (isWhite) {
    fill(0, 40, 120);
  } else {
    fill(255);
  }

  text(label, x, y - 2);
}

// white text with a soft shadow (readable on any background)
void shadowText(String s, float x, float y) {
  fill(0, 170);
  text(s, x + 2, y + 2);
  fill(255);
  text(s, x, y);
}