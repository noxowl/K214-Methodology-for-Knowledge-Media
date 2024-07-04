import ddf.minim.*;
Minim minim;
AudioPlayer bgm;
AudioSample testSE;

void soundSetup() {
  minim = new Minim(this);
  bgm = minim.loadFile("./data/sound/se6.wav");
  testSE = minim.loadSample("./data/sound/se6.wav");
}

void playBgm() {
  bgm.play(1000);
}

void triggerSE() {
  testSE.trigger();
}
