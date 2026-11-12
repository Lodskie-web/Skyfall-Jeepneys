// =====================================================================
//  SFX: tones, horns and a siren generated with the Sound library's
//  oscillators, so no extra audio files are needed.
// =====================================================================

class Note {
  float freq;
  int startAt;
  int endAt;

  Note(float freq, int startAt, int endAt) {
    this.freq = freq;
    this.startAt = startAt;
    this.endAt = endAt;
  }
}

SqrOsc[] hornA = new SqrOsc[4];
SqrOsc[] hornB = new SqrOsc[4];
boolean[] hornActive = new boolean[4];
int[] hornOffAt = new int[4];
float[] hornPitches = { 370, 415, 440, 494, 523 };

SinOsc blip;
boolean blipPlaying = false;
ArrayList<Note> notes = new ArrayList<Note>();

SinOsc siren;
boolean sirenOn = false;
int sirenUntil = 0;

void sfxInit() {
  for (int i = 0; i < hornA.length; i++) {
    hornA[i] = new SqrOsc(this);
    hornB[i] = new SqrOsc(this);
  }
  blip = new SinOsc(this);
  siren = new SinOsc(this);
}

// returns null if the file isn't in the data folder
SoundFile loadOptionalSound(String fileName) {
  if (new File(dataPath(fileName)).exists()) {
    return new SoundFile(this, fileName);
  }
  return null;
}

// ---------- mute ----------
void toggleMute() {
  muted = !muted;
  applyMute();
}

void applyMute() {
  masterVolume.volume(muted ? 0 : 1);
}

// ---------- simple tones ----------
void queueNotes(float[] freqs, int stepMs) {
  if (muted) return;
  int t = millis();
  for (int i = 0; i < freqs.length; i++) {
    notes.add(new Note(freqs[i], t + i * stepMs, t + (i + 1) * stepMs - 15));
  }
}

void sfxBeep(float freq, int ms) {
  if (muted) return;
  int t = millis();
  notes.add(new Note(freq, t, t + ms));
}

void sfxCoin()        { queueNotes(new float[] { 988, 1319 }, 70); }
void sfxPowerUp()     { queueNotes(new float[] { 523, 659, 784, 1047 }, 80); }
void sfxNearMiss()    { queueNotes(new float[] { 784, 1175 }, 60); }
void sfxShieldBreak() { queueNotes(new float[] { 330, 220 }, 90); }

// ---------- rush hour: siren + honking ----------
void sfxRushStart() {
  if (rushSound != null) {
    rushSound.play();           // your own recording from data/rushHour.mp3
  } else {
    sfxSiren(2500);
  }
}

void sfxSiren(int durationMs) {
  if (muted || sirenOn) return;
  siren.freq(650);
  siren.amp(0.08);
  siren.play();
  sirenOn = true;
  sirenUntil = millis() + durationMs;
}

// one car honk (two square waves a bit apart, like a real horn)
void sfxHonk() {
  if (muted) return;
  int now = millis();
  for (int i = 0; i < hornA.length; i++) {
    if (!hornActive[i]) {
      float base = hornPitches[int(random(hornPitches.length))];
      hornA[i].freq(base);
      hornB[i].freq(base * 1.26);
      hornA[i].amp(0.04);
      hornB[i].amp(0.04);
      hornA[i].play();
      hornB[i].play();
      hornActive[i] = true;
      hornOffAt[i] = now + int(random(140, 420));
      return;
    }
  }
}

void sfxStopAll() {
  for (int i = 0; i < hornA.length; i++) {
    if (hornActive[i]) {
      hornA[i].stop();
      hornB[i].stop();
      hornActive[i] = false;
    }
  }
  if (blipPlaying) {
    blip.stop();
    blipPlaying = false;
  }
  if (sirenOn) {
    siren.stop();
    sirenOn = false;
  }
  notes.clear();
  if (rushSound != null && rushSound.isPlaying()) {
    rushSound.stop();
  }
}

// called every frame from draw()
void sfxUpdate() {

  int now = millis();

  // tones
  Note active = null;
  for (int i = notes.size() - 1; i >= 0; i--) {
    Note n = notes.get(i);
    if (now >= n.endAt) {
      notes.remove(i);
    } else if (now >= n.startAt) {
      active = n;
    }
  }
  if (active != null) {
    blip.freq(active.freq);
    if (!blipPlaying) {
      blip.amp(0.12);
      blip.play();
      blipPlaying = true;
    }
  } else if (blipPlaying) {
    blip.stop();
    blipPlaying = false;
  }

  // horns
  for (int i = 0; i < hornA.length; i++) {
    if (hornActive[i] && now >= hornOffAt[i]) {
      hornA[i].stop();
      hornB[i].stop();
      hornActive[i] = false;
    }
  }

  // siren sweeping up and down
  if (sirenOn) {
    if (now >= sirenUntil) {
      siren.stop();
      sirenOn = false;
    } else {
      siren.freq(650 + 250 * (1 + sin(now / 150.0)));
    }
  }
}