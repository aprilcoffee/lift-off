public void mode(int theA) {
}
public void sig(int theA, int theB) {
  /*
  targetSystemLineA
   targetSystemLineB
   targetSystemShow
   photoTrigger //ShowImageGrid
   photoKill
   waterTrigger
   ChangeObservationStar
   photoTriggerImage
   */
  //println(theA, theB);
  
  signalChange[theA][theB] = !signalChange[theA][theB];
  if (theA == 1) {
    switch(theB) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      break;
    case 8:

      break;
    case 9:
      break;
    case 10:
      break;
    case 11:
      break;
    case 12:
      break;
    case 13:
      break;
    case 14:
      break;
    }
  } 
  /*
  addStarTrigger
   showHalf //together
   showHalfTrigger //together
   showAllgeo
   changeTexture
   textureOn
   crashSide
   startMove
   */
  else if (theA==2) {
    switch(theB) {
    case 0:        
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      break;
    case 8:
      break;    
    case 9:
      break;  
    case 10:
      break;
    case 11:
      break;
    case 12:
      break;
    }
  }
}

public void con(int theA, int theB, int theC) {
  println(theA, theB, theC);
  if (theA==3) {
    switch (theB) {
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    case 9:
    case 10:
      break;
    case 11:      
      break;
    case 12:      
      break;
    }
  }
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
