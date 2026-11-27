// ================= SCREEN-WIDE VISUAL EFFECTS =================

// KAPE: applies a warm tint while slow motion is active.
// Call this after drawing the game world, but before popups and HUD.
void drawCoffeeTint() {

  if (gameNow() < slowMoUntil) {
    noStroke();
    fill(150, 90, 30, 40);

    rectMode(CENTER);
    rect(width / 2, height / 2, width, height);
  }
}
