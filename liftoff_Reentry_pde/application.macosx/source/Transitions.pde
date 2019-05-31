void transitionShow0to1() {
  blendMode(BLEND);
  transition0to1Dark+=3;
  println(transition0to1Dark);
  for (int s=0; s<blobs.size(); s++) {
    blobs.get(s).killMode1 = true;
  }
  if (transition0to1Dark>=255) {
    transition0to1Dark = 255;
    phase = 1; 
    transiting = false;
  }
  noStroke();
  colorMode(RGB, 255);
  fill(0, transition0to1Dark);
  rect(0, 0, width, height);
}
