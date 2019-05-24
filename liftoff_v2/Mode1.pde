void mode1() {
  camera(width/2.0 + camShakeX, 
    height/2.0 + camShakeY, 
    (height/2.0) / tan(PI*30.0 / 180.0)+camShakeZ, 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
  if (signalChange[1][0]==true//&& 
    //abs(camShakeXX-camShakeX)<10 &&
    //abs(camShakeYY-camShakeY)<10 &&
    //abs(camShakeZZ-camShakeZ)<10
    ) 
  {

    camShakeXX = random(-200, 200);
    camShakeYY = random(-200, 200);
    camShakeZZ = random(-500, 500);
    //camShakeZZ = random(-(height/2.0) / tan(PI*30.0 / 180.0)
    //, (height/2.0) / tan(PI*30.0 / 180.0));
    // camShakeZZ -= 500;
  }
  camShakeX += (camShakeXX-camShakeX)*0.4;
  camShakeY += (camShakeYY-camShakeY)*0.4;
  camShakeZ += (camShakeZZ-camShakeZ)*0.4;


  if (signalChange[1][1]==true) {
    for (int s=0; s<6; s++) {
      constellation[s] = floor(random(particle.size()));
    }
  }

  for (int s=0; s<particle.size(); s++) {
    Particle P = particle.get(s);
    P.update();
    if (random(10)>8) {
      strokeWeight(random(1));
    } else {      
      strokeWeight(1);
    }
    P.show();
  }
  for (int s=0; s<5-1; s++) {
    Particle P = particle.get(constellation[s]);
    Particle PP = particle.get(constellation[s+1]);
    stroke(255);
    strokeWeight(1);
    line(P.pos.x, P.pos.y, P.pos.z, 
      PP.pos.x, PP.pos.y, PP.pos.z
      );

    vertex(P.pos.x, P.pos.y, P.pos.z);
  }

  stroke(135, 0);
  beginShape(TRIANGLE_STRIP);
  for (int s=0; s<particle.size(); s++) {
    Particle P = particle.get(s);
    vertex(P.pos.x, P.pos.y, P.pos.z);
  }
  endShape();


  if (signalChange[1][2]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      //P.returnToGrid();
      P.randomlize();
      //P.randomSphere();
    }
  }


  if (volume>0.5)
    fx.render()
      .sobel()
      //.bloom(0.1, 20, 30)
      //.blur(10, 0.5)
      //.toon()
      .brightPass(0.1)
      .blur(20, 30)
      .compose();

  else
    fx.render()
      //.sobel()
      //.bloom(0.2, 20, 30)
      //.toon()
      //.brightPass(1)
      .blur(20, 30)
      //.blur(1, 0.001)
      .compose();
}
