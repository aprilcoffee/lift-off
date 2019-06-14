void transitionShow0to1() {
  blendMode(BLEND);
  transition0to1Dark+=3;
  println("0To1 : " +transition0to1Dark);
  for (int s=0; s<blobs.size(); s++) {
    blobs.get(s).killMode1 = true;
  }
  if (transition0to1Dark>=255) {
    transition0to1Dark = 255;
    phase = 1; 
    transiting = false;
    //transition0to1Dark = 0;
  }
  noStroke();
  colorMode(RGB, 255);
  fill(0, transition0to1Dark);
  
  rect(0,0, width, 960);
}


void transitionShow4to0() {
  blendMode(BLEND);
  transition4to0Dark+=1;
  println("4To0 : " +transition4to0Dark);
  if (transition4to0Dark>=255) {
    transition4to0Dark = 255;
    phase = 0; 
    transiting = false;
    //transition0to1Dark = 0;
  }
  noStroke();
  colorMode(RGB, 255);
  fill(0, transition4to0Dark);
  rectMode(CORNER);
  rect(0, 0, width, 960);
}


void transitionShow1to2() {
  transition1to2Dark ++;  
  println("1To2 : " + transition1to2Dark);

  if (transition1to2Dark>=255) {
    transition1to2Dark = 255;
    phase = 2; 
    transiting = false;
    //transition1to2Dark=0;
  }
  //rectMode(LEFT);
  //colorMode(RGB, 255);
  //fill(0, transition1to2Dark);
  //rect(0, 0, width, height); 
  //noStroke();
}

void transitionShow3to4() {
  transition3to4Dark++;
  println("3To4 : "+transition3to4Dark);
  if (transition3to4Dark>=255) {
    transition3to4Dark = 255;
    phase = 4; 
    transiting = false;
    //transition3to4Dark = 0;
  }  
  blendMode(BLEND);  
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  fill(0, transition3to4Dark);
  rect(0, 0, width, height);
}

void transitionShow4to5() {
  transition4to5Dark++;
  println(transition4to5Dark);
  if (transition4to5Dark>=255) {
    transition4to5Dark = 255;
    phase = 0; 
    transiting = false;
    //transition4to5Dark = 0;
  }  
  blendMode(BLEND);  
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  fill(0, transition4to5Dark);
  rect(0, 0, width, height);
}
