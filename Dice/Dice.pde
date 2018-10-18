Die diceRoll;
void setup() {
  //no loop means that draw is only called once
  //OR if you ever call redraw()
  size(700, 700);
  background(255);
  noLoop();
  diceRoll = new Die(5, 5);
}

void draw() {
  background(255);
  diceRoll.show();
}

void mousePressed() {
  //No real work for you to do here
  //calling redraw will do the necessary work 
  //to redraw your processing script
  redraw();
}


//Dice: Models a single 6 sided dice cube
//Each instance should randomly assign itself a value from 1 to 6
class Die {
  //variable declarations for your Die instances here
  int xPos;
  int yPos;
  //constructor
  Die(int x, int y) {
    //variable initializations here
  }

  //Simulate a roll of a die
  void roll() {
    //your code here, 
    //should randomly assign a value from 1 to 6
  }

  /*
	  Use the randomly assigned roll value to draw the face of a die
   	*/
  void show() {
    for (int j = 0; j < 5; j ++) {
      int yPos = 100 * j + 30;
      for (int i = 0; i < 5; i ++) {
        int xPos = 100 * i + 30;
        rect(xPos, yPos, 70s, 70);
      }
    }
    //your code here
  }
}
