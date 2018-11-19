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
void transitionShow1to2() {
  transition0to1Dark = 0;
  transition1to2Dark +=5;  
  if (transition1to2Dark>=255) {
    transition1to2Dark = 255;
    phase = 2; 
    transiting = false;
  }
}
void transitionShow2to3() {
  transition2to3Dark+=5;
  if (transition2to3Dark>=255) {
    transition2to3Dark = 255;
    phase = 3; 
    transiting = false;
  }
  blendMode(BLEND);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  fill(0, transition2to3Dark);
  rect(0, 0, width, height);
}
void transitionShow3to0() {
  transition3to0Dark++;
  println(transition3to0Dark);
  if (transition3to0Dark>=255) {
    transition3to0Dark = 255;
    phase = 0; 
    transiting = false;
  }  
  blendMode(BLEND);  
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  fill(0, transition3to0Dark);
  rect(0, 0, width, height);
}
