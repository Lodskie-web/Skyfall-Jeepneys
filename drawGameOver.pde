void drawGameOver() {

  imageMode(CORNER);
  image(gameover, 0, 0, width, height);

  fill(255);

  PFont boldFont = createFont("Arial Bold", 60);
  textFont(boldFont);

  textSize(60);

  text("YOUR SCORE: " + score, width/2, 420);

  fill(0);
  drawButton(350, 520, 280, 70, "PLAY AGAIN");
  drawButton(650, 520, 280, 70, "MAIN MENU");

}
