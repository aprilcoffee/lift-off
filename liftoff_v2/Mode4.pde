void mode4() {
  pushMatrix();
  background(0);
  
  
  modeFrameCount[4]++;
  camera(300, 400, 1000, 0, 0, 0, 0, 1, 0);
  if (SG[4][0]) {

    flag = floor(random(3));
    newLonMinHalf = (int)random(total);  
    int tempLonMax= floor(random(3, 35));
    //if (random(2)<1) {
    //  tempMax = int(phase2Counter*0.01);
    //} else tempMax = -int(phase2Counter*0.01);
    newLonMaxHalf = newLonMinHalf + tempLonMax;    
    if (newLonMaxHalf > total)newLonMaxHalf=total-1;
    if (newLonMaxHalf < 0)newLonMaxHalf=0;

    //if (phase2Counter*0.001 < 3) {
    //  shabaMode2 = int(random(phase2Counter*0.001));
    //} else {
    //  shabaMode2 = int(random(3));
    //}

    if (newLonMinHalf > newLonMaxHalf) {
      int temp = newLonMinHalf;
      newLonMinHalf = newLonMaxHalf;
      newLonMaxHalf = temp;
    }

    newLatMinHalf = (int)random(total);    
    //newLatMaxHalf = (int)random(total);
    int tempLatMax= floor(random(3, 35));
    newLatMaxHalf = newLatMinHalf + tempLatMax;    
    if (newLatMaxHalf > total)newLatMaxHalf=total-1;
    if (newLatMaxHalf < 0)newLatMaxHalf=0;

    if (newLatMinHalf > newLatMaxHalf) {
      int temp = newLatMinHalf;
      newLatMinHalf = newLatMaxHalf;
      newLatMaxHalf = temp;
    }
    //showHalfTrigger=false;
  }

  for (int i=newLatMinHalf; i<newLatMaxHalf; i++) {
    for (int j=newLonMinHalf; j<newLonMaxHalf; j++) {
      //for (int i=0; i<total; i++) {
      //  for (int j=0; j<total; j++) {
      Geometry G = geometry.get(i*(total+1) + j);
      Geometry Gup = geometry.get((i+1)*(total+1) + j);
      Geometry Gright = geometry.get((i)*(total+1) + j+1);
      Geometry Gnext = geometry.get((i+1)*(total+1) + j+1);
      //        println(i, j, G.ii, G.jj);
      //if (i!=G.ii || j!=G.jj)println(i, j);
      //if((i+1)!=Gnext.ii || (j+1)!=Gnext.jj)println(i,j);
      G.update();
      G.show(
        Gup.globeTexture, 
        Gright.globeTexture, 
        Gnext.globeTexture, 
        flag//shaba mode
        );
    }
  }
  SG[4][0] = false;

  blackHole();
  if (volume<0.5)
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

  popMatrix();
}
