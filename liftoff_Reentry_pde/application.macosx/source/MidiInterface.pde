void midiContollerInit() {
  MidiBus.list();
  myBus = new MidiBus(this, "Launch Control XL", "Launch Control XL");
  midi = new Midi();
}
class Midi {
  int[] layerTint = new int[8];
  int[][] control = new int[8][3];
  boolean[] layerToggle = new boolean[8];
  Midi() {
    for (int channel=12; channel<=14; channel++) {
      for (int number=11; number<=18; number++) {
        int value = 0;
        myBus.sendControllerChange(channel, number, value); // Send a controllerChange
      }
    }
    for (int s=0; s<8; s++) {
      layerTint[s] = 0;
      layerToggle[s] = false;
      for (int i=0; i<3; i++) {
        control[s][i] = 0;
      }
    }
  }
  void update() {
  }
}
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange

  if (channel <= 7) {
    midi.control[channel][number-1] = value;
  }


  if (channel == 9) {
    midi.layerTint[number-1] = value*2;
    if (midi.layerTint[number-1] > 40)midi.layerToggle[number-1]=true;
    else midi.layerToggle[number-1]=false;
  }

  if (channel==13 && number ==11) {
    //soundReset = true;
  }

  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}
