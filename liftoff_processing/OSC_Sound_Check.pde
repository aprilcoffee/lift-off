public void mode(int theA) {
  transition = theA;
  transiting = true;
}
public void initVideo(int theA) {
  println("Hi");
  initVideoTrigger = true;
  initVideoPlaying = true;
}
public void test(int theA, int theB) {
  if (theA == 1) {
    if (theB==0) {
      photoTrigger = true;
    } else if (theB==1) {
      photoKill = true;
      //moveStuff=true;
    } else if (theB==2) {
      waterTrigger = true;
    } else if (theB==3) {
      ChangeObservationStar=true;
    }
  } else if (theA==2) {
    if (theB==0) {
      addStarTrigger=true;
    } else if (theB == 1) {
      showHalf = true;
      showHalfTrigger = true;
    } else if (theB == 2) {
      showAllgeo = true;
    } else if (theB == 3) {
      textureOn = true;
    } else if (theB == 4) {
      crashSide = true;
    } else if (theB == 5) {
      startMove = true;
    }
  } else if (theA==3) {
    if (theB==0) {
      if (bobbyTrigger==false)
        bobbyTrigger = true;
      else
        bobbyTrigger = false;
    } else if (theB==1) {
      juliaShowTrigger = true;
    }
  }
}
void soundCheck() {

  totalAmp = 0;

  rectMode(CORNERS);
  float centerFrequency = 0;
  fftLin.forward( in.mix );
  //fftLog.forward( in.mix );

  float height23=height-100;

  {
    // since linear averages group equal numbers of adjacent frequency bands
    // we can simply precalculate how many pixel wide each average's 
    // rectangle should be.
    int w = int( width/fftLin.avgSize() );
    for (int i = 0; i < fftLin.avgSize(); i++)
    {
      // if the mouse is inside the bounds of this average,
      // print the center frequency and fill in the rectangle with red
      if ( mouseX >= i*w && mouseX < i*w + w )
      {
        centerFrequency = fftLin.getAverageCenterFrequency(i);
        fill(255, 128);
        //text("Linear Average Center Frequency: " + i, 5, height23 - 25);
        fill(255, 0, 0);
      } else
      {
        fill(255);
      }
      // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
      //rect(i*w, height-100, i*w + w, height-100 - fftLin.getAvg(i)*spectrumScale);
    }
  }


  pushMatrix();
  translate(0, height/2);
  stroke(255);
  for (int i = 0; i < in.bufferSize() - 1; i++)
  {
    //line( i, 50 + in.left.get(i)*200, i+1, 50 + in.left.get(i+1)*200 );
    //line( i, 150 + in.right.get(i)*200, i+1, 150 + in.right.get(i+1)*200 );
    totalAmp += abs(in.mix.get(i)*100);
  }
  popMatrix();
  //println(totalAmp);
}
