void drawHowToPlay() {

  background(255, 210, 40);

  rectMode(CENTER);

  textAlign(CENTER, CENTER);

  // ================= MAIN PANEL =================

  fill(245, 235, 210);

  stroke(180, 130, 20);

  strokeWeight(8);

  rect(width/2, height/2 - 20, 700, 500, 25);

  // ================= INNER BORDER =================

  noFill();

  stroke(230, 180, 40);

  strokeWeight(3);

  rect(width/2, height/2 - 20, 660, 460, 18);
  // ================= TOP TITLE =================

  fill(0, 90, 220);

  stroke(0, 40, 120);

  strokeWeight(4);

  rect(width/2, 85, 360, 60, 12);

  // Decorative red dots

  fill(220, 40, 40);

  noStroke();

  ellipse(width/2 - 165, 85, 10, 10);

  ellipse(width/2 - 150, 100, 10, 10);

  ellipse(width/2 + 165, 85, 10, 10);

  ellipse(width/2 + 150, 100, 10, 10);

  // Title text

  fill(255);

  PFont title = createFont("Arial Bold", 34);

  textFont(title);

  textSize(34);

  text("HOW TO PLAY", width/2, 87);

  // =====================================================

  // ICON + TEXT SECTION

  // =====================================================

  PFont body = createFont("Arial Bold", 26);

  textFont(body);

  textAlign(LEFT, CENTER);

  // ================= ICON 1 =================

  fill(255);

  stroke(0, 60, 140);

  strokeWeight(3);

  ellipse(250, 170, 75, 75);

  // Mouse icon

  fill(0);

  noStroke();

  rect(250, 175, 30, 45, 15);

  stroke(255);

  line(250, 175, 250, 160);

  // TEXT 1

  fill(0);

  text("MOVE THE CHARACTER\nUSING THE MOUSE.", 340, 170);

  // ================= ICON 2 =================

  fill(255);

  stroke(180, 40, 40);

  strokeWeight(3);

  ellipse(250, 260, 75, 75);

  imageMode(CENTER);

  image(jeepney1, 250, 255, 65, 65);
  // TEXT 2

  fill(0);

  text("DODGE THE FALLING\nJEEPNEYS.", 340, 260);

  // ================= ICON 3 =================

  fill(255);

  stroke(180, 140, 0);

  strokeWeight(3);

  ellipse(250, 350, 75, 75);

  // Star icon

  fill(255, 210, 0);

  noStroke();

  beginShape();

  vertex(250, 315);
  vertex(260, 340);
  vertex(288, 340);
  vertex(266, 356);
  vertex(275, 382);
  vertex(250, 366);
  vertex(225, 382);
  vertex(234, 356);
  vertex(212, 340);
  vertex(240, 340);

  endShape(CLOSE);

  // TEXT 3

  fill(0);

  text("SURVIVE AS LONG\nAS YOU CAN!", 340, 350);


  // =====================================================

  // BOTTOM DESIGN

  // =====================================================

  // Blue strip

  fill(0, 90, 220);

  stroke(0, 40, 120);

  strokeWeight(3);

  rect(width/2, 545, 700, 55, 0, 0, 18, 18);

  // Red strip

  fill(220, 40, 40);

  noStroke();

  rect(width/2, 570, 700, 28, 0, 0, 18, 18);

  // Stars

  fill(255, 210, 0);

  textAlign(CENTER, CENTER);

  textSize(38);

  text("★", width/2 - 220, 555);

  text("★", width/2 + 220, 555);;

  // Sun design

  fill(255, 200, 0);

  ellipse(width/2, 557, 75, 75);

  stroke(255, 200, 0);

  strokeWeight(5);

  for (int i = 0; i < 16; i++) {

    float angle = radians(i * 22.5);

    float x1 = width/2 + cos(angle) * 35;

    float y1 = 557 + sin(angle) * 35;

    float x2 = width/2 + cos(angle) * 55;

    float y2 = 557 + sin(angle) * 55;

    line(x1, y1, x2, y2);

  }
  // ================= ICON 4 =================

  fill(255);
  stroke(220, 40, 40);
  strokeWeight(3);

  ellipse(250, 440, 75, 75);


  // Heart icon
  fill(255, 0, 0);
  noStroke();

  textSize(85);
  text("♥", 250, 440);

  // TEXT 4
  fill(0);
  textSize(26);

  text("YOU HAVE ONLY 3 LIVES.", 500, 440);
  // ================= BACK BUTTON =================

  drawButton(width/2, 625, 220, 55, "BACK");

}
