public void mode(int theA) {
  transition = theA;
  transiting = true;
  for (int s=0; s<16; s++) {
    midiBusing[s]=false;
  }
}
public void test(int theA, int theB) {
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
  if (theA == 1) {
    switch(theB) {
    case 0:
      targetSystemLineA = true; 
      targetSystemLineB = false;
      break;
    case 1:
      targetSystemLineA = false;
      targetSystemLineB = true;
      break;
    case 2:
      targetSystemShow = true;
      break;
    case 3:
      ChangeObservationStar=true;
      break;
    case 4:
      waterTrigger = true;
      break;
    case 5:
      photoTrigger = true; //showImage
      break;
    case 6:
      photoTriggerImageRect = true;
      photoTriggerImageBW = false;
      photoTriggerImage = false;
      break;
    case 7:
      photoTriggerImageRect = false;
      photoTriggerImageBW = true;
      photoTriggerImage = false;
      break;
    case 8:
      photoTriggerImageRect = false;
      photoTriggerImageBW = false;
      photoTriggerImage = true;
      break;
    case 9:
      photoKill = true;
      break;
    case 10:
      photoSpin = true;
      break;
    case 11:
      phase1CornerCall = true;
      break;
    case 12:
      glitchTrigger = true;
      break;
    case 13:
      glitchTrigger = false;
      glitchReset();
      break;
    case 14:
      spinMoveFaster=true;
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
      addStarTrigger=true;
      break;
    case 1:
      showHalf =true; //together
      showHalfTrigger=true; //together
      break;
    case 2:
      changeTexture = true;
      break;
    case 3:
      textureOn = true;
      break;
    case 4:
      showAllgeo = true;
      break;
    case 5:
      startMove = true;
      break;
    case 6:
      starGoCenter = true;
      break;
    case 7:
      geoMoving = true;
      break;
    case 8:
      crashSide = true;
      break;    
    case 9:
      flyAway = true;
      break;  
    case 10:
      resetGeoLocation = true;
      textureOn=false;
      break;
    case 11:
      explosion = true;
      break;
    }
  } else if (theA==3) {
    switch (theB) {
    case 0:
      changeTerrainMode = true;
      moveStuff = true;
      break;
    case 1:
      juliaShowTrigger = true;
      break;
    case 2:
      terrainRandomTrigger = true;
      break;
    case 6:
      TerrainMode = 0;
      print("TerrainMode");
      print(TerrainMode);
      break;
    case 7:
      TerrainMode = 1;
      print("TerrainMode");
      print(TerrainMode);
      break;
    case 8:
      TerrainMode = 2;
      print("TerrainMode");
      print(TerrainMode);
      break;
    case 9:
      TerrainMode = 3;
      print("TerrainMode");
      print(TerrainMode);
      break; 
    case 10:
      TerrainRandom = true;
      break;
    }
  }
}

public void con(int theA, int theB, int theC) {
  println(theA, theB, theC);
  if (theA==3) {
    switch (theB) {
    case 3:
      phase3ShowBalls = returnOSC(theC);
      break;
    case 4:
      phase3ShowTerrain = returnOSC(theC);
      break;
    case 5:
      phase3ShowAttrator = returnOSC(theC);
      break;
    case 9:
      TerrainRandom = returnOSC(theC);
    case 10:
      cameraMovingX = returnOSC(theC);
      break;
    case 11:      
      cameraMovingY = returnOSC(theC);
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
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

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
  }
}
void soundCheck() {

  totalAmp = 0;

  rectMode(CORNERS);
  float centerFrequency = 0;
  fftLin.forward( in.mix );
  //fftLog.forward( in.mix );

  pushMatrix();
  translate(0, height/2);
  stroke(1);
  for (int i = 0; i < in.bufferSize() - 1; i++)
  {
    //line( i, 50 + in.left.get(i)*200, i+1, 50 + in.left.get(i+1)*200 );
    //line( i, 150 + in.right.get(i)*200, i+1, 150 + in.right.get(i+1)*200 );
    totalAmp += abs(in.mix.get(i)*100);
  }
  popMatrix();

  int w = int( width/fftLin.avgSize() );
  for (int i = 0; i < fftLin.avgSize(); i++)
  {
    centerFrequency    = fftLin.getAverageCenterFrequency(i);
    // how wide is this average in Hz?
    float averageWidth = fftLin.getAverageBandWidth(i);   
    // we calculate the lowest and highest frequencies
    // contained in this average using the center frequency
    // and bandwidth of this average.
    float lowFreq  = centerFrequency - averageWidth/2;
    float highFreq = centerFrequency + averageWidth/2;

    // freqToIndex converts a frequency in Hz to a spectrum band index
    // that can be passed to getBand. in this case, we simply use the 
    // index as coordinates for the rectangle we draw to represent
    // the average.
    int xl = (int)fftLin.freqToIndex(lowFreq);
    int xr = (int)fftLin.freqToIndex(highFreq);

    // if the mouse is inside of this average's rectangle
    // print the center frequency and set the fill color to red
    /*if ( mouseX >= xl && mouseX < xr )
     {
     fill(255, 0, 0, 255);
     textAlign(LEFT);
     textSize(25);
     text("Logarithmic Average Center Amplitude: " + totalAmp, 5, height-200 - 75);
     text("Logarithmic Average Center Index: " + i, 5, height-200 - 50);
     text("Logarithmic Average Center Frequency: " + centerFrequency, 5, height-200 - 25);
     
     fill(255, 0, 0);
     } else
     {
     fill(30);
     }
     // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
     stroke(50);
     rect( xl, height-200, xr, height-200 - fftLin.getAvg(i)*spectrumScale );
     textAlign(LEFT);
     textSize(15);
     text(nfc(fftLin.getAvg(i)*spectrumScale, 3), i*w, height-100);*/
  }



  //println(totalAmp);
}
