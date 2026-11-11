void drawMenu() {
  imageMode(CORNER);
  image(background1, 0, 0, width, height);
  
  drawButton(width/2, 375, 250, 60, "START GAME");
  drawButton(width/2, 455, 250, 60, "HOW TO PLAY");
  drawButton(width/2, 545, 250, 60, "QUIT");

 
}
