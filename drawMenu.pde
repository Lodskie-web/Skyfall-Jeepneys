void drawMenu() {
  imageMode(CORNER);
  image(background1, 0, 0, width, height);

  drawButton(width/2, 375, 270, 54, "START GAME");
  drawButton(width/2, 440, 270, 54, "HOW TO PLAY");
  drawButton(width/2, 505, 270, 54, "LEADERBOARD");
  drawButton(width/2, 570, 270, 54, "QUIT");

  // player chip (top-left)
  drawPlayerChip(125, 42, 230, 52);
}