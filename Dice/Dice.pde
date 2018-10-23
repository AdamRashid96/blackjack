import java.util.Arrays;
Die[] diceRoll;
int sum = 0;
int gameScreen = 0;
boolean autoroll = false;
float currMax;
float totalMax;
int[] faceFreq = new int[6];
int[] currFaceFreq = new int[6];
void setup() {
  //no loop means that draw is only called once
  //OR if you ever call redraw()
  size(700, 700);
  background(255);
  frameRate(10);
  diceRoll = new Die[25];
  for (int j = 0; j < 5; j ++) {
    int yPos = 100 * j + 30;
    for (int i = 0; i < 5; i ++) {
      int xPos = 100 * i + 30;
      diceRoll[j*5 + i] = new Die(xPos, yPos);
      sum += diceRoll[i].toggle;
    }
  }
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    drawGameScreen();
  } else if (gameScreen == 2) {
    diceSimulator();
  }
  println(gameScreen);
}

void mousePressed() {
  if (gameScreen == 2) {
    if ((mouseX >= 550 && mouseX <= 650)&& (mouseY >= 600 && mouseY <= 650)) { 
      if (!autoroll)
        sum = 0;
      autoroll = !autoroll;
    } else {
      if (!autoroll)
        sum = 0;
      reRollAll();
    }
  }
}

void initScreen() {
  background(80);
  textAlign(CENTER);
  fill(135, 206, 250);
  textSize(80);
  text("Dice", width/2, height/2);
  textSize(25); 
  text("Dice Simulator", width/2 - 150, height- 80);
  text("Blackjack", width/2 + 150, height-80);

  if (mouseX > 420 && mouseX < 600 && mouseY > 560 && mouseY < height -40) {
    if (mousePressed) {
      gameScreen = 1;
    } else {
      cursor(HAND);
    }
  } else {
    cursor(ARROW);
  }

  if (mouseX > 100 && mouseX < 300 && mouseY > 560 && mouseY < height - 40) {
    if (mousePressed) {
      gameScreen = 2;
    } else {
      cursor(HAND);
    }
  } else {
    cursor(ARROW);
  }
}

void diceSimulator() {
  textAlign(LEFT);
  background(255);
  autorollBox();
  if (autoroll)
    reRollAll();
  for (int i = 0; i < diceRoll.length; i++) {
    diceRoll[i].show();
  }
  totalDice();
  currentDice();
  currGraph();
  totalGraph();
  fill(0);
  textSize(15);
  text(sum, width -150, height - 150);
  textSize(12);
  text("Return to home >", 30, 15);
  if (mouseX > 0 && mouseX < 150 && mouseY > 0 && mouseY < 30) {
    if (mousePressed) {
      gameScreen = 0;
    } else {
      cursor(HAND);
    }
  } else {
    cursor(ARROW);
  }
  println(sum);
}

void drawGameScreen() {
  background(255);
  textAlign(LEFT);
  textSize(12);
  text("Return to home >", 30, 15);
  if (mouseX > 0 && mouseX < 150 && mouseY > 0 && mouseY < 30) {
    if (mousePressed) {
      gameScreen = 0;
    } else {
      cursor(HAND);
    }
  } else {
    cursor(ARROW);
  }
}

void autorollBox() {
  fill(200);
  rect(550, 600, 100, 50);
  fill(0);
  textSize(19);
  text("Auto Run", 555, 630);
}

void reRollAll() {
  Arrays.fill(currFaceFreq, 0);
  for (int i = 0; i < diceRoll.length; i++) {
    diceRoll[i].roll();
    sum += diceRoll[i].toggle;
  }
}

void totalDice() {
  fill (0);
  textSize(20);
  text("Total Faces:", 350, 530);

  for (int i = 1; i <= 6; i++) {
    text("Total " + i + "'s:   " + faceFreq[i-1], 350, 530 + (i*20));
  }
}

void currentDice() {
  fill (0);
  textSize(20);
  text("Current Faces:", 150, 530);

  for (int i = 1; i <= 6; i++) {
    text("Current " + i + "'s:   " + currFaceFreq[i-1], 150, 530 + (i*20));
  }
}

void currGraph() {
  currMax = currFaceFreq[0];
  for (int i = 0; i < 6; i++) {
    if (currFaceFreq[i] > currMax)
      currMax = currFaceFreq[i];
  }
  fill(0);
  textSize(20);
  text("Current Faces", 520, 30);
  //rect 1
  fill(255, 0, 0);
  rect(520, 170 -(130*(currFaceFreq[0]/currMax)), 30, 130*(currFaceFreq[0]/currMax));
  //rect 2
  fill(0, 255, 0);
  rect(550, 170 -(130*(currFaceFreq[1]/currMax)), 30, 130*(currFaceFreq[1]/currMax));
  //rect 3
  fill(0, 0, 255);
  rect(580, 170 -(130*(currFaceFreq[2]/currMax)), 30, 130*(currFaceFreq[2]/currMax));
  //rect 4
  fill(255, 255, 0);
  rect(610, 170 -(130*(currFaceFreq[3]/currMax)), 30, 130*(currFaceFreq[3]/currMax));
  //rect 5
  fill(255, 0, 255);
  rect(640, 170 -(130*(currFaceFreq[4]/currMax)), 30, 130*(currFaceFreq[4]/currMax));
  //rect 6
  fill(0, 255, 255);
  rect(670, 170 -(130*(currFaceFreq[5]/currMax)), 30, 130*(currFaceFreq[5]/currMax));
}

void totalGraph() {
  totalMax = faceFreq[0];
  for (int i = 0; i < 6; i++) {
    if (faceFreq[i] > totalMax)
      totalMax = faceFreq[i];
  }
  fill(0);
  textSize(20);
  text("Total  Faces", 520, 210);
  //rect 1
  fill(255, 0, 0);
  rect(520, 370 -(130*(faceFreq[0]/totalMax)), 30, 130*(faceFreq[0]/totalMax));
  //rect 2
  fill(0, 255, 0);
  rect(550, 370 -(130*(faceFreq[1]/totalMax)), 30, 130*(faceFreq[1]/totalMax));
  //rect 3
  fill(0, 0, 255);
  rect(580, 370 -(130*(faceFreq[2]/totalMax)), 30, 130*(faceFreq[2]/totalMax));
  //rect 4
  fill(255, 255, 0);
  rect(610, 370 -(130*(faceFreq[3]/totalMax)), 30, 130*(faceFreq[3]/totalMax));
  //rect 5
  fill(255, 0, 255);
  rect(640, 370 -(130*(faceFreq[4]/totalMax)), 30, 130*(faceFreq[4]/totalMax));
  //rect 6
  fill(0, 255, 255);
  rect(670, 370 -(130*(faceFreq[5]/totalMax)), 30, 130*(faceFreq[5]/totalMax));
}






//Dice: Models a single 6 sided dice cube
//Each instance should randomly assign itself a value from 1 to 6
class Die {
  //variable declarations for your Die instances here
  int xPos;
  int yPos;
  int toggle;
  //constructor
  Die(int x, int y) {
    //variable initializations here
    xPos = x;
    yPos = y;
    roll();
  }

  //Simulate a roll of a die
  void roll() {
    toggle = (int)random(1, 7);
    faceFreq[toggle - 1]++;
    currFaceFreq[toggle - 1]++;
  } 

  void show_rect() { 
    //Dice
    fill(255);
    rect(xPos, yPos, 70, 70, 8);
  }

  void show_ellipse() {
    fill(0);
    //Face 1
    switch(toggle) {
    case 1: 
      ellipse(xPos + 35, yPos + 35, 10, 10);
      break;
    case 5: 
      ellipse(xPos + 10, yPos + 10, 10, 10);
      ellipse(xPos + 60, yPos + 60, 10, 10);
    case 3: 
      ellipse(xPos + 35, yPos + 35, 10, 10);
      ellipse(xPos + 60, yPos + 10, 10, 10);
      ellipse(xPos + 10, yPos + 60, 10, 10);
      break;
    case 6: 
      ellipse(xPos + 10, yPos + 35, 10, 10);
      ellipse(xPos + 60, yPos + 35, 10, 10);
    case 4:
      //ellipse(xPos + 60, yPos + 10, 10, 10);
      //ellipse(xPos + 10, yPos + 60, 10, 10);
      ellipse(xPos + 10, yPos + 10, 10, 10);
      ellipse(xPos + 60, yPos + 60, 10, 10);
      //break;
    case 2: 
      ellipse(xPos + 60, yPos + 10, 10, 10);
      ellipse(xPos + 10, yPos + 60, 10, 10);
      break;
    }
  }

  void show() {
    show_rect();
    show_ellipse();
    println(toggle);
  }
}
