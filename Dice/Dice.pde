/* @pjs preload="heart.png","spade.png","clubs.png","diamonds.png"; */
import java.util.Arrays;
Die[] diceRoll;
Card[] dealCards;
int NUM_OF_CARDS = 52;
int sum = 0;
int gameScreen = 0;
int handSize = 2;
int[] currentHand = {(int) random(0, 52), (int) random(0, 52), (int) random(0, 52), (int) random(0, 52), (int) random(0, 52)};
int[] cardIndex = new int[52];
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
  dealCards = new Card[NUM_OF_CARDS];
  for (int j = 0; j < 5; j ++) {
    int yPos = 100 * j + 30;
    for (int i = 0; i < 5; i ++) {
      int xPos = 100 * i + 30;
      diceRoll[j*5 + i] = new Die(xPos, yPos);
      sum += diceRoll[i].toggle;
    }
  }

  for (int i = 0; i < NUM_OF_CARDS; i++) {
    dealCards[i] = new Card();
  }
  buildDeck();
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    drawGameScreen();
  } else if (gameScreen == 2) {
    diceSimulator();
  }
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
  /*
  if (gameScreen == 1) {
   for (int i = 0; i < currentHand.length; i++) {
   currentHand[i] = (int) random(0, 52);
   }
   }
   */
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
  hand();
  hitBox();
  println("Hand Size: " + handSize);
  if (mouseX > 540 && mouseX < 660 && mouseY > 490 && mouseY < 560) {
    if (mousePressed) {
      handSize++;
    }
  }

  fill(0);
  textSize(15);
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

void buildDeck() {
  for (int i = 1; i <=4; i++) {
    for (int j = 1; j <= 13; j++) {
      dealCards[((i-1) * 13) + (j - 1)].toggleSuit = i;
      dealCards[((i-1) * 13) + (j - 1)].toggleNumber = j;
    }
  }
}

void hand() {
  dealCards[currentHand[0]].show_card(100, 500);
  dealCards[currentHand[1]].show_card(200, 500);
  if (handSize == 3)
    dealCards[currentHand[2]].show_card(300, 500);

  if (handSize == 4) {
    dealCards[currentHand[2]].show_card(300, 500);
    dealCards[currentHand[3]].show_card(400, 500);
  }
  if (handSize == 5) {
    dealCards[currentHand[2]].show_card(300, 500);
    dealCards[currentHand[3]].show_card(400, 500);
    dealCards[currentHand[4]].show_card(500, 500);
  }
}

void hitBox() {
  fill(200);
  rect(550, 500, 100, 50);
  rect(550, 560, 100, 50);
  fill(0);
  textSize(19);
  text("Hit", 570, 530);
  text("Stand", 570, 590);
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
//End of Dice


class Card {
  PImage heart;
  PImage spade;
  PImage clubs;
  PImage diamonds;
  int xPos;
  int yPos;
  int toggleNumber;
  int toggleSuit;

  Card() {
    //xPos = x;
    //yPos = y;
    heart = loadImage("heart.png");
    diamonds = loadImage("diamonds.png");
    spade = loadImage("spade.png");
    clubs = loadImage("clubs.png");
    //shuffle();
  }
  void shuffle() {
    toggleNumber = (int)random(1, 14);
    toggleSuit = (int)random(1, 5);
  }

  void show_card(int x, int y) { 
    //Dice
    xPos = x;
    yPos = y;
    fill(255);
    rect(xPos, yPos, 100, 150, 2);
    show_suit();
    show_face();
  }

  void show_face() {
    if (toggleSuit == 1 || toggleSuit == 2)
      fill(255, 0, 0);

    if (toggleSuit == 3 || toggleSuit == 4)
      fill(0);
    textSize(20);
    switch(toggleNumber) {
    case 1:
      text("A", xPos +  10, yPos + 30);
      text("A", xPos +  80, yPos + 140);
      break;
    case 2:
      text("2", xPos +  10, yPos + 30);
      text("2", xPos +  80, yPos + 140);
      break;
    case 3:
      text("3", xPos +  10, yPos + 30);
      text("3", xPos +  80, yPos + 140);
      break;
    case 4:
      text("4", xPos +  10, yPos + 30);
      text("4", xPos +  80, yPos + 140);
      break;
    case 5:
      text("5", xPos +  10, yPos + 30);
      text("5", xPos +  80, yPos + 140);
      break;
    case 6:
      text("6", xPos +  10, yPos + 30);
      text("6", xPos +  80, yPos + 140);
      break;
    case 7:
      text("7", xPos +  10, yPos + 30);
      text("7", xPos +  80, yPos + 140);
      break;
    case 8:
      text("8", xPos +  10, yPos + 30);
      text("8", xPos +  80, yPos + 140);
      break;
    case 9:
      text("9", xPos +  10, yPos + 30);
      text("9", xPos +  80, yPos + 140);
      break;
    case 10:
      text("10", xPos +  10, yPos + 30);
      text("10", xPos +  70, yPos + 140);
      break;
    case 11:
      text("J", xPos +  10, yPos + 30);
      text("J", xPos +  80, yPos + 140);
      break;
    case 12:
      text("Q", xPos +  10, yPos + 30);
      text("Q", xPos +  80, yPos + 140);
      break;
    case 13:
      text("K", xPos +  10, yPos + 30);
      text("K", xPos +  80, yPos + 140);
      break;
    }
  }

  void show_suit() {
    switch(toggleSuit) {
    case 1:
      image(heart, xPos + 30, yPos + 55, 40, 40);
      break;
    case 2:
      image(diamonds, xPos + 30, yPos + 55, 40, 40);
      break;
    case 3:
      image(spade, xPos + 3, yPos + 25, 90, 90);
      break;
    case 4:
      image(clubs, xPos + 20, yPos + 40, 60, 60);
      break;
    }
  }
}
