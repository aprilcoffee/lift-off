
public void bpm(int theA) {
  currentBeat = theA;
}
public void mode(int theA) {
}
public void sig(int theA, int theB) {
  SG[theA][theB] = true;

  if (theA==2) {
    switch(theB) {
    case 0:
      SG[2][1] = false;
      break;
    case 1:
      SG[2][0] = false;
      break;
    }
  }
  /*
  Phase2
   [2][0] targetSystemLineA 
   [2][1] targetSystemLineB
   [2][2] targetSystemShow
   [2][3] photoTrigger //ShowImageGrid
   [2][4] photoKill
   [2][5] waterTrigger
   [2][6] ChangeObservationStar
   [2][7] photoTriggerImage
   [2][8] photoSpin
   [2][9] phase1CornerCall
   [2][10] spinMoveFaster
   
   Phase4
   [4][0] addStarTrigger
   [4][1] showHalf //together
   [4][2] showHalfTrigger //together
   [4][3] showAllgeo
   [4][4] changeTexture
   [4][5] textureOn
   [4][6] crashSide
   [4][7] startMove
   */
}
public void con(int theA, int theB, int theC) {
  CN[theA][theB] = theC;
  if (theA==2 && theB==1) {
    glitchReset();
  }
  /*
  Phase2
   [2][0] 0 photoTriggerImageRect
   [2][0] 1 photoTriggerImageBW
   [2][0] 2 photoTriggerImage
   
   [2][1] 0 glitchTrigger
   [2][1] 1 glitchReset
   
   */
}
boolean returnOSC(int input) {
  if (input==0)return false;
  else return true;
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  //println();
  //println("Note Off:");
  //println("--------");
  //println("Channel:"+channel);
  //println("Pitch:"+pitch);
  //println("Velocity:"+velocity);

  /*
   OscMessage myMessage = new OscMessage("/test");
   myMessage.add(phase);
   if (channel==0) {
   if (pitch>=96 && pitch<=103) {
   if (midiBusing[pitch-96]==true)midiBusing[pitch-96]=false;
   else midiBusing[pitch-96]=true;
   myMessage.add(pitch-96);
   if (midiBusing[pitch-96]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   oscP5.send(myMessage, myRemoteLocation);
   } else if (pitch>=112 && pitch<=119) {
   if (midiBusing[pitch-104]==true)midiBusing[pitch-104]=false;
   else midiBusing[pitch-104]=true;
   myMessage.add(pitch-104);
   if (midiBusing[pitch-104]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   oscP5.send(myMessage, myRemoteLocation);
   } else if (pitch==104) {
   if (midiBusing[16]==true)midiBusing[16]=false;
   else midiBusing[16]=true;
   myMessage.add(16);
   if (midiBusing[16]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   oscP5.send(myMessage, myRemoteLocation);
   } else if (pitch==120) {
   if (midiBusing[17]==true)midiBusing[17]=false;
   else midiBusing[17]=true;
   myMessage.add(17);
   if (midiBusing[17]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   }
   oscP5.send(myMessage, myRemoteLocation);
   }*/
}
void soundCheck() {
  fft.analyze();
  input.amp(1);
  volume = loudness.analyze();
  volume*=1000;
  //println(volume);
  volume = norm(volume, 0, 100);
}
