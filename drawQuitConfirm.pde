// =====================================================================
//  "Are you sure you want to quit?" window
//  confirmQuit: 0 = closed
//               1 = quit the game  (QUIT on the main menu)
//               2 = quit to menu   (QUIT TO MENU on the pause screen)
// =====================================================================

int confirmQuit = 0;

void drawQuitConfirm() {

  if (confirmQuit == 0) return;

  boolean exitGame = (confirmQuit == 1);

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // dim everything behind
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

  // blue title banner with red dots (same style as the other screens)
  fill(0, 90, 220);
  stroke(0, 40, 120);
  strokeWeight(4);
  rect(width/2, 200, 360, 56, 12);

  fill(220, 40, 40);
  noStroke();
  ellipse(width/2 - 165, 200, 10, 10);
  ellipse(width/2 + 165, 200, 10, 10);

  fill(255);
  textFont(fontHowTitle);
  textAlign(CENTER, CENTER);
  textSize(30);
  text(exitGame ? "QUIT GAME?" : "QUIT TO MENU?", width/2, 201);

  textFont(hudFont);
  fill(140, 90, 20);
  textSize(24);
  text(exitGame ? "AALIS KA NA BA?" : "SIGURADO KA BA?", width/2, 268);

  fill(0, 40, 120);
  textSize(18);
  if (exitGame) {
    text("THE GAME WILL CLOSE.", width/2, 318);
    text("LEADERBOARD SCORES ARE KEPT.", width/2, 344);
  } else {
    text("YOUR CURRENT RUN WILL NOT BE SAVED.", width/2, 318);
    text("LEADERBOARD SCORES ARE KEPT.", width/2, 344);
  }

  drawButton(width/2 - 120, 425, 200, 54, "CONFIRM");
  drawButton(width/2 + 120, 425, 200, 54, "CANCEL");
}