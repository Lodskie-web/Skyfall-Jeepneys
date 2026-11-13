// =====================================================================
//  Player login + leaderboard data
//  Saved with Java's built-in Preferences: the system stores it
//  (registry on Windows, system settings on Mac/Linux). No .txt file.
// =====================================================================

class ScoreEntry {
  String name;
  int score;
  int time;

  ScoreEntry(String name, int score, int time) {
    this.name = name;
    this.score = score;
    this.time = time;
  }
}

java.util.prefs.Preferences prefs;

final int MAX_NAME = 12;
final int BOARD_SIZE = 10;
final int MAX_RECENT = 6;

ArrayList<ScoreEntry> board = new ArrayList<ScoreEntry>();
ArrayList<String> recentNames = new ArrayList<String>();
String playerName = "";

// game over info
int ribbonKind = 0;     // 0 = none, 1 = NEW HIGH SCORE, 2 = NEW PERSONAL BEST
int lastRank = 0;       // 0 = not on the board

// screens
String nameInput = "";
boolean startAfterName = false;
boolean editingName = false;      // true when the pencil button opened the name screen
int nameErrorUntil = 0;           // shows "name already taken" until this time
int leaderboardFrom = 0;          // which screen to return to from the leaderboard
int clearArmedUntil = 0;

// ---------------------------------------------------------------------
//  load / save
// ---------------------------------------------------------------------
void initLeaderboard() {
  try {
    prefs = java.util.prefs.Preferences.userRoot().node("skyFallJeepneyGame");
  } catch (Exception e) {
    prefs = null;
    println("Saved scores are not available on this computer: " + e);
  }
  loadFromPrefs();
}

void loadFromPrefs() {

  board.clear();
  recentNames.clear();
  playerName = "";

  if (prefs == null) return;

  try {
    playerName = prefs.get("playerName", "");

    String data = prefs.get("board", "");
    if (data.length() > 0) {
      String[] rows = split(data, ';');
      for (int i = 0; i < rows.length; i++) {
        String[] p = split(rows[i], '|');
        if (p.length == 3 && p[0].length() > 0) {
          board.add(new ScoreEntry(p[0], int(p[1]), int(p[2])));
        }
      }
    }

    String r = prefs.get("recent", "");
    if (r.length() > 0) {
      String[] parts = split(r, ';');
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].length() > 0) {
          recentNames.add(parts[i]);
        }
      }
    }
  } catch (Exception e) {
    println("Could not load saved scores: " + e);
  }

  sortBoard();
}

void savePrefs() {

  if (prefs == null) return;

  try {
    String b = "";
    for (int i = 0; i < board.size(); i++) {
      ScoreEntry e = board.get(i);
      if (i > 0) b += ";";
      b += e.name + "|" + e.score + "|" + e.time;
    }

    String r = "";
    for (int i = 0; i < recentNames.size(); i++) {
      if (i > 0) r += ";";
      r += recentNames.get(i);
    }

    prefs.put("board", b);
    prefs.put("recent", r);
    prefs.put("playerName", playerName);
    prefs.flush();
  } catch (Exception e) {
    println("Could not save scores: " + e);
  }
}

// ---------------------------------------------------------------------
//  leaderboard logic
// ---------------------------------------------------------------------
void sortBoard() {
  // highest score first (stable: ties keep their order)
  for (int i = 1; i < board.size(); i++) {
    ScoreEntry key = board.get(i);
    int j = i - 1;
    while (j >= 0 && board.get(j).score < key.score) {
      board.set(j + 1, board.get(j));
      j--;
    }
    board.set(j + 1, key);
  }
}

int findEntry(String name) {
  for (int i = 0; i < board.size(); i++) {
    if (board.get(i).name.equalsIgnoreCase(name)) {
      return i;
    }
  }
  return -1;
}

// called from endGame()
void submitScore(int sc, int tm) {

  ribbonKind = 0;
  lastRank = 0;

  if (playerName.length() == 0) {
    bestScore = max(bestScore, sc);
    return;
  }

  int topScore = (board.size() > 0) ? board.get(0).score : 0;
  int idx = findEntry(playerName);
  boolean personalBest = false;

  if (idx < 0) {
    board.add(new ScoreEntry(playerName, sc, tm));
    personalBest = sc > 0;
  } else if (sc > board.get(idx).score) {
    board.get(idx).score = sc;
    board.get(idx).time = tm;
    personalBest = true;
  }

  if (sc > 0 && sc > topScore) {
    ribbonKind = 1;                 // beat everybody
  } else if (personalBest) {
    ribbonKind = 2;                 // beat your own best
  }

  sortBoard();
  while (board.size() > BOARD_SIZE) {
    board.remove(board.size() - 1);
  }

  int pos = findEntry(playerName);
  lastRank = pos + 1;               // 0 means not on the board
  bestScore = (pos >= 0) ? board.get(pos).score : sc;

  savePrefs();
}

void addRecentName(String n) {
  for (int i = recentNames.size() - 1; i >= 0; i--) {
    if (recentNames.get(i).equalsIgnoreCase(n)) {
      recentNames.remove(i);
    }
  }
  recentNames.add(0, n);
  while (recentNames.size() > MAX_RECENT) {
    recentNames.remove(recentNames.size() - 1);
  }
}

// ---------------------------------------------------------------------
//  edit / delete the current player
// ---------------------------------------------------------------------

// rename the current player everywhere (scores are kept)
void renamePlayer(String raw) {

  String n = trim(raw).toUpperCase();
  if (n.length() == 0) return;

  // unchanged: just go back
  if (n.equalsIgnoreCase(playerName)) {
    gameState = 0;
    return;
  }

  // name already used by another player?
  boolean taken = findEntry(n) >= 0;
  for (String r : recentNames) {
    if (r.equalsIgnoreCase(n)) {
      taken = true;
    }
  }
  if (taken) {
    nameErrorUntil = millis() + 2500;
    return;
  }

  int idx = findEntry(playerName);
  if (idx >= 0) {
    board.get(idx).name = n;
  }
  for (int i = 0; i < recentNames.size(); i++) {
    if (recentNames.get(i).equalsIgnoreCase(playerName)) {
      recentNames.set(i, n);
    }
  }

  playerName = n;
  savePrefs();
  gameState = 0;
}

// delete the current player and their leaderboard entry, then log out
void deleteCurrentPlayer() {

  int idx = findEntry(playerName);
  if (idx >= 0) {
    board.remove(idx);
  }
  for (int i = recentNames.size() - 1; i >= 0; i--) {
    if (recentNames.get(i).equalsIgnoreCase(playerName)) {
      recentNames.remove(i);
    }
  }

  playerName = "";
  bestScore = 0;
  lastRank = 0;
  ribbonKind = 0;
  savePrefs();
}

void clearLeaderboard() {
  board.clear();
  bestScore = 0;
  lastRank = 0;
  ribbonKind = 0;
  savePrefs();
}

// shrinks the text size until s fits inside maxW pixels
void fitTextSize(String s, float maxW, float size) {
  textSize(size);
  while (size > 10 && textWidth(s) > maxW) {
    size -= 1;
    textSize(size);
  }
}