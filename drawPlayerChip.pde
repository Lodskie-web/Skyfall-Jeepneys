// =====================================================================
//  Player chip (top-left of the main menu): switch / edit / delete
//  + the "delete player?" confirmation window
// =====================================================================

// chip geometry (centre x/y and size)
final float PCX = 185;
final float PCY = 58;
final float PCW = 340;
final float PCH = 62;

boolean confirmDelete = false;

float pcLeft()        { return PCX - PCW/2; }
float pcRight()       { return PCX + PCW/2; }
float pcEditX()       { return pcRight() - 78; }
float pcDelX()        { return pcRight() - 36; }
float pcSwitchRight() { return pcEditX() - 28; }

boolean overCircle(float cx, float cy, float r) {
  return dist(mouseX, mouseY, cx, cy) < r;
}

// clicking the name area switches player (when logged out, the whole chip logs in)
boolean overPlayerSwitch() {
  if (playerName.length() == 0) {
    return overButton(PCX, PCY, PCW, PCH);
  }
  float w = pcSwitchRight() - pcLeft();
  return overButton(pcLeft() + w/2, PCY, w, PCH);
}

boolean overPlayerEdit() {
  return playerName.length() > 0 && overCircle(pcEditX(), PCY, 19);
}

boolean overPlayerDelete() {
  return playerName.length() > 0 && overCircle(pcDelX(), PCY, 19);
}

void drawPlayerChip() {

  float t = millis() / 1000.0;
  boolean loggedIn = playerName.length() > 0;
  boolean hoverMain = overPlayerSwitch() && !confirmDelete;

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // ---------- banderitas hanging above the chip ----------
  color[] cols = { color(0, 90, 220), color(220, 40, 40), color(255), color(255, 220, 60) };
  float top = PCY - PCH/2;
  float y0 = top - 12;

  stroke(110, 60, 10);
  strokeWeight(2);
  line(pcLeft() + 6, y0, pcRight() - 6, y0);

  strokeWeight(1);
  float fw = 26;
  int n = int((PCW - 24) / fw);
  for (int i = 0; i < n; i++) {
    float x0 = pcLeft() + 12 + i * fw;
    float sway = sin(t * 3 + i * 0.7) * 2.5;
    fill(cols[i % 4]);
    triangle(x0 + 1, y0, x0 + fw - 1, y0, x0 + fw/2 + sway, y0 + 15);
  }

  // ---------- chip body ----------
  if (hoverMain) {
    stroke(255);
    strokeWeight(5);
  } else {
    stroke(180, 130, 20);
    strokeWeight(4);
  }
  fill(245, 235, 210);
  rect(PCX, PCY, PCW, PCH, 16);

  noFill();
  stroke(230, 180, 40);
  strokeWeight(2);
  rect(PCX, PCY, PCW - 12, PCH - 12, 11);

  // ---------- avatar: person inside a spinning sun ----------
  float ax = pcLeft() + 36;
  pushMatrix();
  translate(ax, PCY);

  pushMatrix();
  rotate(t * 0.6);
  stroke(255, 200, 0);
  strokeWeight(3);
  for (int i = 0; i < 8; i++) {
    float a = i * TWO_PI / 8;
    line(cos(a) * 22, sin(a) * 22, cos(a) * 27, sin(a) * 27);
  }
  popMatrix();

  stroke(180, 130, 20);
  strokeWeight(3);
  if (loggedIn) {
    fill(0, 90, 220);
  } else {
    fill(150, 160, 185);
  }
  ellipse(0, 0, 38, 38);

  noStroke();
  fill(255);
  ellipse(0, -5, 13, 13);
  arc(0, 14, 26, 24, PI, TWO_PI);
  popMatrix();

  // ---------- name ----------
  float tx = ax + 36;
  float maxW = pcSwitchRight() - tx - 6;

  textFont(hudFont);
  textAlign(LEFT, CENTER);
  noStroke();

  fill(130, 90, 20);
  String small = loggedIn ? "CLICK TO SWITCH" : "MABUHAY!";
  fitTextSize(small, maxW, 11);
  text(small, tx, PCY - 15);

  if (loggedIn) {
    fill(0, 40, 120);
    fitTextSize(playerName, maxW, 22);
    text(playerName, tx, PCY + 7);
  } else {
    fill(220, 40, 40);
    fitTextSize("CLICK TO LOG IN", maxW, 19);
    text("CLICK TO LOG IN", tx, PCY + 7);
  }

  // divider
  stroke(230, 180, 40);
  strokeWeight(2);
  line(pcSwitchRight() + 2, PCY - 20, pcSwitchRight() + 2, PCY + 20);

  // ---------- edit + delete buttons ----------
  drawChipIconButton(pcEditX(), PCY, color(0, 90, 220), color(0, 40, 120), true, loggedIn, overPlayerEdit());
  drawChipIconButton(pcDelX(), PCY, color(220, 40, 40), color(120, 0, 0), false, loggedIn, overPlayerDelete());

  // ---------- tooltips ----------
  if (!confirmDelete) {
    textFont(hudFont);
    textAlign(CENTER, CENTER);
    textSize(14);
    if (overPlayerEdit()) {
      shadowText("EDIT NAME", pcEditX(), PCY + PCH/2 + 14);
    }
    if (overPlayerDelete()) {
      shadowText("DELETE PLAYER", pcDelX() - 10, PCY + PCH/2 + 14);
    }
  }

  textAlign(CENTER, CENTER);
}

void drawChipIconButton(float cx, float cy, color fillC, color edgeC,
                        boolean pencil, boolean enabled, boolean hover) {

  boolean lit = hover && !confirmDelete;

  pushMatrix();
  translate(cx, cy);
  if (lit) {
    scale(1.15);
  }

  if (lit) {
    stroke(255, 210, 0);
  } else {
    stroke(edgeC);
  }
  strokeWeight(3);

  if (enabled) {
    fill(fillC);
  } else {
    fill(190, 190, 195);
  }
  ellipse(0, 0, 34, 34);

  noStroke();
  fill(255);
  if (pencil) {
    drawPencilIcon();
  } else {
    drawTrashIcon(enabled ? fillC : color(190, 190, 195));
  }
  popMatrix();
}

void drawPencilIcon() {
  pushMatrix();
  rotate(-QUARTER_PI);
  noStroke();
  fill(255);
  rect(2, 0, 14, 6);                       // body
  fill(255, 215, 120);
  triangle(-5, -3, -5, 3, -11, 0);         // wooden tip
  fill(255, 140, 140);
  rect(10.5, 0, 3, 6);                     // eraser
  popMatrix();
}

void drawTrashIcon(color holeColor) {
  noStroke();
  fill(255);
  rect(0, -7, 16, 3, 1);                   // lid
  rect(0, -10, 6, 3, 1);                   // handle
  quad(-6, -4, 6, -4, 5, 9, -5, 9);        // can
  stroke(holeColor);
  strokeWeight(1.5);
  line(-2, -1, -2, 6);
  line(2, -1, 2, 6);
  noStroke();
}

// ---------------------------------------------------------------------
//  "Delete player?" window (drawn on top of the main menu)
// ---------------------------------------------------------------------
void drawDeleteConfirm() {

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // dim the menu
  noStroke();
  fill(0, 0, 0, 170);
  rect(width/2, height/2, width, height);

  // panel
  fill(245, 235, 210);
  stroke(180, 130, 20);
  strokeWeight(8);
  rect(width/2, 325, 540, 320, 25);

  noFill();
  stroke(230, 180, 40);
  strokeWeight(3);
  rect(width/2, 325, 500, 280, 18);

  // red banner (warning)
  fill(220, 40, 40);
  stroke(120, 0, 0);
  strokeWeight(4);
  rect(width/2, 200, 360, 56, 12);

  fill(255, 210, 0);
  stroke(180, 130, 20);
  strokeWeight(2);
  drawStar(width/2 - 160, 200, 14, 6);
  drawStar(width/2 + 160, 200, 14, 6);

  noStroke();
  fill(255);
  textFont(fontHowTitle);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("DELETE PLAYER?", width/2, 201);

  textFont(hudFont);
  fill(140, 90, 20);
  textSize(22);
  text("SIGURADO KA BA?", width/2, 262);

  fill(220, 40, 40);
  fitTextSize(playerName, 440, 34);
  text(playerName, width/2, 305);

  fill(0, 40, 120);
  textSize(16);
  text("THIS REMOVES THE PLAYER AND THEIR SCORES", width/2, 342);
  text("FROM THE LEADERBOARD. IT CANNOT BE UNDONE.", width/2, 364);

  drawButton(width/2 - 120, 425, 200, 54, "DELETE");
  drawButton(width/2 + 120, 425, 200, 54, "CANCEL");
}