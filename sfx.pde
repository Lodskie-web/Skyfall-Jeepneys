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

SinOsc blip;
boolean blipPlaying = false;

ArrayList<Note> notes = new ArrayList<Note>();


void sfxInit() {
  blip = new SinOsc(this);
}


void sfxBeep(float freq, int ms) {

  if (muted) return;

  int t = millis();
  notes.add(new Note(freq, t, t + ms));
}


// ================= MUTE =================

void toggleMute() {
  muted = !muted;
  applyMute();
}


void applyMute() {
  masterVolume.volume(muted ? 0 : 1);
}


// ================= STOP SOUND EFFECTS =================

void sfxStopAll() {

  if (blipPlaying) {
    blip.stop();
    blipPlaying = false;
  }

  notes.clear();
}


// Called every frame from draw()
void sfxUpdate() {

  int now = millis();

  Note active = null;

  for (int i = notes.size() - 1; i >= 0; i--) {

    Note n = notes.get(i);

    if (now >= n.endAt) {
      notes.remove(i);
    } else if (now >= n.startAt) {
      active = n;
    }
  }

  if (active != null && !muted) {

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
}
