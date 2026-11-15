// =====================================================================
//  Player chip (top-left of the main menu) + "delete player?" window
// =====================================================================

boolean confirmDelete = false;

void drawPlayerChip(float cx, float cy, float w, float h) {

  boolean hover = overButton(cx, cy, w, h);
  boolean loggedIn = playerName.length() > 0;

  rectMode(CENTER);

  // cream card with a gold frame
  if (hover) {
    stroke(255);
    strokeWeight(4);
  } else {
    stroke(180, 130, 20);
    strokeWeight(3);
  }
  fill(245, 235, 210);
  rect(cx, cy, w, h, 14);

  noFill();
  stroke(230, 180, 40);
  strokeWeight(2);
  rect(cx, cy, w - 10, h - 10, 10);

  // avatar
  float ax = cx - w/2 + 27;
  stroke(180, 130, 20);
  strokeWeight(2);
  if (loggedIn) {
    fill(0, 90, 220);
  } else {
    fill(150, 160, 185);
  }
  ellipse(ax, cy, 34, 34);

  noStroke();
  fill(255);
  ellipse(ax, cy - 5, 11, 11);
  arc(ax, cy + 12, 22, 20, PI, TWO_PI);

  // text
  float tx = ax + 27;
  float maxW = cx + w/2 - tx - 10;

  textFont(hudFont);
  textAlign(LEFT, CENTER);

  fill(130, 90, 20);
  String small = loggedIn ? "CLICK TO CHANGE PLAYER" : "NO PLAYER YET";
  fitTextSize(small, maxW, 11);
  text(small, tx, cy - 12);

  fill(0, 40, 120);
  String n = loggedIn ? playerName : "LOG IN";
  fitTextSize(n, maxW, 20);
  text(n, tx, cy + 8);

  textAlign(CENTER, CENTER);
}

// ---------------------------------------------------------------------
//  "Delete player?" window (drawn on top of the player login screen)
// ---------------------------------------------------------------------
void drawDeleteConfirm() {

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // dim the screen
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