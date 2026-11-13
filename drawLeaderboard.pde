// =====================================================================
//  Leaderboard screen (top 10 players)
// =====================================================================

void openLeaderboard(int from) {
  leaderboardFrom = from;       // 0 = main menu, 3 = game over
  clearArmedUntil = 0;
  gameState = 5;
}

void drawLeaderboard() {

  drawFilipinoBackground();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // ================= MAIN PANEL =================
  fill(245, 235, 210);
  stroke(180, 130, 20);
  strokeWeight(8);
  rect(width/2, 305, 760, 500, 25);          // y 55 .. 555

  // ================= INNER BORDER =================
  noFill();
  stroke(230, 180, 40);
  strokeWeight(3);
  rect(width/2, 305, 720, 460, 18);

  // ================= TITLE BANNER =================
  fill(0, 90, 220);
  stroke(0, 40, 120);
  strokeWeight(4);
  rect(width/2, 85, 400, 60, 12);

  // decorative red dots (same as How To Play)
  fill(220, 40, 40);
  noStroke();
  ellipse(width/2 - 185, 85, 10, 10);
  ellipse(width/2 - 170, 100, 10, 10);
  ellipse(width/2 + 185, 85, 10, 10);
  ellipse(width/2 + 170, 100, 10, 10);

  // gold stars beside the banner
  fill(255, 210, 0);
  stroke(180, 130, 20);
  strokeWeight(2);
  drawStar(width/2 - 255, 85, 17, 8);
  drawStar(width/2 + 255, 85, 17, 8);

  fill(255);
  textFont(fontHowTitle);
  textAlign(CENTER, CENTER);
  textSize(34);
  text("LEADERBOARD", width/2, 87);

  // ================= COLUMN HEADERS =================
  textFont(hudFont);
  textSize(16);
  fill(0, 90, 220);
  textAlign(CENTER, CENTER);
  text("RANK", 190, 138);
  textAlign(LEFT, CENTER);
  text("NAME", 250, 138);
  textAlign(RIGHT, CENTER);
  text("SCORE", 640, 138);
  text("TIME", 810, 138);

  stroke(180, 130, 20);
  strokeWeight(2);
  line(150, 153, 850, 153);

  // ================= ROWS =================
  int me = findEntry(playerName);

  for (int i = 0; i < BOARD_SIZE; i++) {

    float y = 174 + i * 31;
    boolean filled = i < board.size();
    boolean mine = filled && i == me;

    // row background (your own row is highlighted in blue)
    if (mine) {
      stroke(0, 90, 220);
      strokeWeight(2);
      fill(190, 220, 255);
    } else {
      noStroke();
      if (i % 2 == 0) {
        fill(250, 243, 224);
      } else {
        fill(238, 224, 188);
      }
    }
    rect(width/2, y, 700, 27, 8);

    // rank medal: gold, silver, bronze, then plain
    noStroke();
    if (i == 0)      fill(255, 210, 0);
    else if (i == 1) fill(205, 208, 215);
    else if (i == 2) fill(205, 130, 60);
    else             fill(225, 210, 170);
    ellipse(190, y, 24, 24);

    fill(60, 40, 0);
    textFont(hudFont);
    textSize(15);
    textAlign(CENTER, CENTER);
    text(str(i + 1), 190, y - 1);

    if (filled) {
      ScoreEntry e = board.get(i);

      fill(0, 40, 120);
      textAlign(LEFT, CENTER);
      fitTextSize(e.name, 260, 21);
      text(e.name, 250, y - 1);

      textAlign(RIGHT, CENTER);
      textSize(23);
      text(str(e.score), 640, y - 1);

      textSize(19);
      text(e.time + "s", 810, y - 1);
    } else {
      fill(175, 150, 105);
      textAlign(LEFT, CENTER);
      textSize(21);
      text("- - -", 250, y - 1);
    }
  }

  // ================= FOOTER =================
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  textSize(17);
  fill(140, 90, 20);

  String foot;
  if (board.size() == 0) {
    foot = "NO SCORES YET - BE THE FIRST!";
  } else if (playerName.length() > 0) {
    foot = "PLAYING AS: " + playerName;
  } else {
    foot = "LOG IN FROM THE MAIN MENU TO SAVE YOUR SCORES";
  }
  text(foot, width/2, 487);

  // =====================================================
  // BOTTOM DESIGN (same as How To Play)
  // =====================================================

  // Blue strip
  fill(0, 90, 220);
  stroke(0, 40, 120);
  strokeWeight(3);
  rect(width/2, 545, 760, 55, 0, 0, 18, 18);

  // Red strip
  fill(220, 40, 40);
  noStroke();
  rect(width/2, 570, 760, 28, 0, 0, 18, 18);

  // Stars
  fill(255, 210, 0);
  noStroke();
  drawStar(width/2 - 235, 546, 19, 8);
  drawStar(width/2 + 235, 546, 19, 8);

  // Sun design (slowly turning)
  pushMatrix();
  translate(width/2, 557);

  fill(255, 200, 0);
  noStroke();
  ellipse(0, 0, 75, 75);

  rotate(millis() / 4000.0);
  stroke(255, 200, 0);
  strokeWeight(5);
  for (int i = 0; i < 16; i++) {
    float angle = radians(i * 22.5);
    line(cos(angle) * 35, sin(angle) * 35, cos(angle) * 55, sin(angle) * 55);
  }
  popMatrix();

  // ================= BUTTONS =================
  drawButton(300, 614, 220, 50, "BACK");

  boolean armed = millis() < clearArmedUntil;
  drawButton(700, 614, 280, 50, armed ? "CONFIRM CLEAR?" : "CLEAR SCORES");
}