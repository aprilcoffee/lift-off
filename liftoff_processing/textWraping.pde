class textGenerator {
  char[] title;
  float[] titleFloat;
  float[] titleTargetFloat;

  int textLength;
  textGenerator(String S) {

    title = new char[20];
    titleFloat = new float[20];
    titleTargetFloat = new float[20];

    char[] temp = S.toCharArray();
    textLength = temp.length;
    for (int s=0; s<temp.length; s++) {
      titleTargetFloat[s] = int(temp[s]);
    }
  }
  void show(float x, float y, int textSize) {
    for (int s=0; s<textLength; s++) {
      titleFloat[s] += (titleTargetFloat[s] - titleFloat[s])*0.3;
      if ((titleTargetFloat[s] - titleFloat[s]) < 0.1 && (titleTargetFloat[s] - titleFloat[s])>0) {
        titleFloat[s]+=1;
      }
    }
    for (int s=0; s<textLength; s++) {
      title[s] = char(floor(titleFloat[s]));
    }
    int catchLength=0;
    for (catchLength=0; catchLength<textLength; catchLength++) {
      if (char(floor(titleFloat[catchLength])) == ' ')break;
    }
    char[] tempShow = new char[catchLength];
    for (int s=0; s<catchLength; s++) {
      tempShow[s]=char(floor(titleFloat[s]));
    }
    pushMatrix();
    translate(x, y);
    textAlign(LEFT);
    textSize(textSize);
    textMode(SHAPE);
    fill(255);
    text(new String(tempShow), 0, 0);
    popMatrix();
  }
  void showOnGraphics(float x, float y, int textSize,PGraphics P) {
    for (int s=0; s<textLength; s++) {
      titleFloat[s] += (titleTargetFloat[s] - titleFloat[s])*0.3;
      if ((titleTargetFloat[s] - titleFloat[s]) < 0.1 && (titleTargetFloat[s] - titleFloat[s])>0) {
        titleFloat[s]+=1;
      }
    }
    for (int s=0; s<textLength; s++) {
      title[s] = char(floor(titleFloat[s]));
    }
    int catchLength=0;
    for (catchLength=0; catchLength<textLength; catchLength++) {
      if (char(floor(titleFloat[catchLength])) == ' ')break;
    }
    char[] tempShow = new char[catchLength];
    for (int s=0; s<catchLength; s++) {
      tempShow[s]=char(floor(titleFloat[s]));
    }
    P.pushMatrix();
    P.translate(x, y);
    P.textAlign(LEFT);
    P.textSize(textSize);
    P.textMode(SHAPE);
    P.fill(255);
    P.text(new String(tempShow), 0, 0);
    P.popMatrix();
  }
  void update(String S) { 
    char[] temp = S.toCharArray();
    int newTextLength = temp.length;
    if (newTextLength < textLength) {
      for (int i=newTextLength; i<textLength; i++) {
        titleTargetFloat[i] = int(' ');
      }
    } else {
      textLength = newTextLength;
    }
    for (int s=0; s<temp.length; s++) {
      titleTargetFloat[s] = int(temp[s]);
    }
  }
}
