/* @pjs preload="heart.png","spade.png","clubs.png","diamonds.png"; */
import java.util.Arrays;
Die[] diceRoll;
Card[] dealCards;
int NUM_OF_CARDS = 52;
int sum = 0;
int gameScreen = 0;
int handSize = 2;
int totalOfHand = 0;
int totalOfDealer = 0;
int gameSenario = 0; //0 is Lose, 1 is win
int[] cardIndex = new int[52];
boolean dealerTurn = false;
boolean handTotalToggle = true;
boolean autoroll = false;
boolean hitToggle = true;
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
  shuffleDeck();
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    drawGameScreen();
  } else if (gameScreen == 2) {
    diceSimulator();
  } else if (gameScreen == 3) {
    endScreen();
  }
}

void mousePressed() {
  if (gameScreen == 2) {
    //Toggle Auto Roll On and Off
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

void mouseReleased() {
  hitToggle = true;
}

//Home Screen
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

//Dice Simulator
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

//BlackJack
void drawGameScreen() {
  background(255);
  textAlign(LEFT); 
  hand();
  dealer();
  handTotal();
  hitBox();
  println("Hand Size: " + handSize);
  if (!dealerTurn) {
    if (mouseX > 540 && mouseX < 660 && mouseY > 490 && mouseY < 555) {
      if (mousePressed && hitToggle) {
        handSize++;
        totalOfHand = 0;
        handTotalToggle = true;
        hitToggle = false;
      }
    }

    if (mouseX > 540 && mouseX < 660 && mouseY > 560 && mouseY < 625) {
      if (mousePressed) {
        dealerTurn = true;
      }
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

//Creates the endscreen if they won or lost
void endScreen() {
  if (gameSenario == 0) {
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text("Busted!", width/2, height/2);
  } else if (gameSenario == 1) {
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text("Blackjack!", width/2, height/2);
  }
}

//Makes the object Array into an ordered deck of cards
void buildDeck() {
  for (int i = 1; i <=4; i++) {
    for (int j = 1; j <= 13; j++) {
      dealCards[((i-1) * 13) + (j - 1)].toggleSuit = i;
      dealCards[((i-1) * 13) + (j - 1)].toggleNumber = j;
    }
  }
}

void shuffleDeck() {
  for (int i = 0; i < dealCards.length; i++) {
    int j = (int)(Math.random()*52);
    Card c = dealCards[j];
    dealCards[j] = dealCards[i];
    dealCards[i] = c;
  }
}

//Makes the dealers Hand and Turn
void dealer() {
  dealCards[8].show_card(250, 10);
  if (dealerTurn) {
    dealCards[9].show_card(350, 10);
    if(dealCards[8].toggleNumber + dealCards[9].toggleNumber < 17){
      dealCards[10].show_card(350, 10);
    }
  }
}

//This Draws the two cards
void hand() {
  switch(handSize) { //Checks Hand Size every time hit is clicked and draws a card
  case 8:
    dealCards[7].show_card(250, 350);
  case 7:
    dealCards[6].show_card(150, 350);
  case 6:
    dealCards[5].show_card(50, 350);
  case 5:
    dealCards[4].show_card(450, 500);
  case 4:
    dealCards[3].show_card(350, 500);
  case 3:
    dealCards[0].show_card(50, 500);
    dealCards[1].show_card(150, 500);
    dealCards[2].show_card(250, 500);
    break;
  default:
    dealCards[0].show_card(50, 500);
    dealCards[1].show_card(150, 500);
    break;
  }
}

//Creates The box for hit and Stand
void hitBox() {
  fill(200);
  rect(550, 500, 100, 50);
  rect(550, 560, 100, 50);
  fill(0);
  textSize(19);
  text("Hit", 570, 530);
  text("Stand", 570, 590);
}

void handTotal() {
  if (handTotalToggle) {
    switch(handSize) { //Checks Hand Size every time hit is clicked and draws a card
    case 8:
      if (dealCards[7].toggleNumber == 11 || dealCards[7].toggleNumber == 12 || dealCards[7].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[7].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[7].toggleNumber;
      }
    case 7:
      if (dealCards[6].toggleNumber == 11 || dealCards[6].toggleNumber == 12 || dealCards[6].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[6].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[6].toggleNumber;
      }
    case 6:
      if (dealCards[5].toggleNumber == 11 || dealCards[5].toggleNumber == 12 || dealCards[5].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[5].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[5].toggleNumber;
      }

    case 5:
      if (dealCards[4].toggleNumber == 11 || dealCards[4].toggleNumber == 12 || dealCards[4].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[4].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[4].toggleNumber;
      }
    case 4:
      if (dealCards[3].toggleNumber == 11 || dealCards[3].toggleNumber == 12 || dealCards[3].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[3].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[3].toggleNumber;
      }
    case 3:
      if (dealCards[2].toggleNumber == 11 || dealCards[2].toggleNumber == 12 || dealCards[2].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[2].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[2].toggleNumber;
      }
    default:
      if (dealCards[0].toggleNumber == 11 || dealCards[0].toggleNumber == 12 || dealCards[0].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[0].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[0].toggleNumber;
      }

      if (dealCards[1].toggleNumber == 11 || dealCards[1].toggleNumber == 12 || dealCards[1].toggleNumber == 13) {
        totalOfHand += 10;
      } else if (dealCards[1].toggleNumber == 1) {
        totalOfHand += 11;
      } else {
        totalOfHand += dealCards[1].toggleNumber;
      }
      handTotalToggle = false;
      break;
    }
  }
  switch(handSize) {
  case 8:
    if (dealCards[7].toggleNumber == 1 && totalOfHand > 21) {
      totalOfHand -= 10;
    }

    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
  case 7:
    if (dealCards[6].toggleNumber == 1 && totalOfHand > 21) {
      totalOfHand -= 10;
    }
    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
  case 6:
    if (dealCards[5].toggleNumber == 1 && totalOfHand > 21) {
      totalOfHand -= 10;
    }

    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
  case 5:
    if (dealCards[4].toggleNumber == 1 && totalOfHand > 21) {
      totalOfHand -= 10;
    }

    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
  case 4:
    if (dealCards[3].toggleNumber == 1 && totalOfHand > 21) {
      totalOfHand -= 10;
    }

    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
  case 3:
    if ((dealCards[0].toggleNumber == 1 || dealCards[1].toggleNumber == 1 || dealCards[2].toggleNumber == 1) && totalOfHand > 21) {
      totalOfHand -= 10;
    }

    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
    break;
  case 2:
    if ((dealCards[0].toggleNumber == 1 || dealCards[1].toggleNumber == 1) && totalOfHand > 21) {
      totalOfHand -= 10;
    }

    if (totalOfHand == 21) {
      gameSenario = 1;
      gameScreen = 3;
      println("Blackjack");
    }

    if (totalOfHand > 21) {
      gameSenario = 0;
      gameScreen = 3;
      println("Busted");
    }
    break;
  }
  println("Hand total: " + totalOfHand);
}

//Creates The box for Auto Roll
void autorollBox() {
  fill(200);
  rect(550, 600, 100, 50);
  fill(0);
  textSize(19);
  text("Auto Run", 555, 630);
}

//Refills the array with new values and increments the sum
void reRollAll() {
  Arrays.fill(currFaceFreq, 0);
  for (int i = 0; i < diceRoll.length; i++) {
    diceRoll[i].roll();
    sum += diceRoll[i].toggle;
  }
}

//Makes the list of the total dice and faces
void totalDice() {
  fill (0);
  textSize(20);
  text("Total Faces:", 350, 530);

  for (int i = 1; i <= 6; i++) {
    text("Total " + i + "'s:   " + faceFreq[i-1], 350, 530 + (i*20));
  }
}

//Makes the list of the current dice and faces
void currentDice() {
  fill (0);
  textSize(20);
  text("Current Faces:", 150, 530);

  for (int i = 1; i <= 6; i++) {
    text("Current " + i + "'s:   " + currFaceFreq[i-1], 150, 530 + (i*20));
  }
}

//Builds the graph of current faces by dividing them by the max
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

//Builds the graph of total faces by dividing them by the max
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
