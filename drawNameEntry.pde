// =====================================================================
//  Player login / edit-name screen
// =====================================================================

void openNameEntry(boolean thenStart) {
  nameInput = "";
  startAfterName = thenStart;
  editingName = false;
  nameErrorUntil = 0;
  gameState = 4;
}

// rename the current player (pencil button on the menu chip)
void openEditName() {
  nameInput = playerName;
  startAfterName = false;
  editingName = true;
  nameErrorUntil = 0;
  gameState = 4;
}

// SAVE button / ENTER key
void submitName() {
  if (editingName) {
    renamePlayer(nameInput);
  } else {
    loginAs(nameInput);
  }
}

// saves the name as the active player (a "login")
void loginAs(String raw) {

  String n = trim(raw);
  if (n.length() == 0) return;

  playerName = n.toUpperCase();
  addRecentName(playerName);
  savePrefs();

  if (startAfterName) {
    startGame();
  } else {
    gameState = 0;
  }
}

// typing into the name box
void handleNameKey() {

  if (key == ENTER || key == RETURN) {
    submitName();
    return;
  }

  if (key == BACKSPACE) {
    if (nameInput.length() > 0) {
      nameInput = nameInput.substring(0, nameInput.length() - 1);
    }
    return;
  }

  if (key == CODED) return;

  char c = Character.toUpperCase(key);
  boolean ok = (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
            || c == '_' || c == '-'
            || (c == ' ' && nameInput.length() > 0);

  if (ok && nameInput.length() < MAX_NAME) {
    nameInput += c;
  }
}

// positions of the "returning players" chips (3 per row)
float nameChipX(int i) {
  return width/2 + ((i % 3) - 1) * 200;
}

float nameChipY(int i) {
  return 368 + (i / 3) * 52;
}

void drawNameEntry() {

  drawFilipinoBackground();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // ================= MAIN PANEL =================
  fill(245, 235, 210);
  stroke(180, 130, 20);
  strokeWeight(8);
  rect(width/2, 315, 700, 520, 25);

  noFill();
  stroke(230, 180, 40);
  strokeWeight(3);
  rect(width/2, 315, 660, 480, 18);

  // ================= TITLE BANNER =================
  fill(0, 90, 220);
  stroke(0, 40, 120);
  strokeWeight(4);
  rect(width/2, 88, 380, 60, 12);

  fill(220, 40, 40);
  noStroke();
  ellipse(width/2 - 165, 88, 10, 10);
  ellipse(width/2 + 165, 88, 10, 10);

  fill(255);
  textFont(fontHowTitle);
  textAlign(CENTER, CENTER);
  textSize(34);
  text(editingName ? "EDIT PLAYER" : "PLAYER LOGIN", width/2, 90);

  textFont(hudFont);
  textSize(24);
  fill(140, 90, 20);
  text(editingName ? "PALITAN ANG PANGALAN" : "SINO ANG LALARO?", width/2, 150);

  // ================= NAME BOX =================
  stroke(0, 90, 220);
  strokeWeight(4);
  fill(255);
  rect(width/2, 215, 440, 64, 14);

  textFont(hudFont);
  textSize(34);
  textAlign(LEFT, CENTER);
  float tx = width/2 - 200;

  if (nameInput.length() == 0) {
    fill(175);
    text("TYPE YOUR NAME", tx, 214);
  } else {
    fill(0, 40, 120);
    text(nameInput, tx, 214);
  }

  // blinking cursor
  if ((millis() / 500) % 2 == 0) {
    float cx = (nameInput.length() == 0) ? tx - 4 : tx + textWidth(nameInput) + 4;
    stroke(0, 40, 120);
    strokeWeight(3);
    line(cx, 192, cx, 238);
  }

  // hint, or an error if the name is already taken
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(15);
  if (millis() < nameErrorUntil) {
    fill(200, 20, 20);
    text("THAT NAME IS ALREADY TAKEN - TRY ANOTHER", width/2, 268);
  } else {
    fill(120, 90, 30);
    text("LETTERS, NUMBERS AND SPACE  -  MAX " + MAX_NAME + "  -  ENTER TO SAVE", width/2, 268);
  }

  // ================= RETURNING PLAYERS (login only) =================
  if (editingName) {

    textSize(18);
    fill(0, 90, 220);
    text("RENAMING KEEPS YOUR SCORES", width/2, 340);

  } else if (recentNames.size() > 0) {

    textSize(17);
    fill(0, 90, 220);
    text("RETURNING PLAYERS - CLICK YOUR NAME", width/2, 318);

    for (int i = 0; i < recentNames.size(); i++) {

      float cx = nameChipX(i);
      float cy = nameChipY(i);
      boolean hover = overButton(cx, cy, 180, 40);

      if (hover) {
        stroke(0, 90, 220);
        fill(255, 232, 160);
      } else {
        stroke(180, 130, 20);
        fill(255, 247, 225);
      }
      strokeWeight(3);
      rect(cx, cy, 180, 40, 12);

      noStroke();
      fill(0, 40, 120);
      textFont(hudFont);
      textAlign(CENTER, CENTER);
      fitTextSize(recentNames.get(i), 158, 18);
      text(recentNames.get(i), cx, cy - 1);
    }
  }

  // ================= BUTTONS =================
  String saveLabel = (!editingName && startAfterName) ? "SAVE & PLAY" : "SAVE";
  drawButton(width/2 - 130, 520, 240, 56, saveLabel);
  drawButton(width/2 + 130, 520, 200, 56, "BACK");
}