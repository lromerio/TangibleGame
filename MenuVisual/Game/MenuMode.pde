

class MenuMode extends Mode {

  boolean classicOver;
  boolean swOver;
  boolean pkOver;
  boolean playOver;

  int env;

  // Non possiamo fare enumeration qui, per ora int...da valutare

  MenuMode() {
    isPaused = true;

    env = -1;
  }

  void display() {
    background(0);

    fill(255);
    textAlign(CENTER);
    textSize(80);
    text("Visual Programming Project", width/2, 120);

    textSize(30);
    text("Select Game Mode:", 250, height/4 + 50);


    isOver();    
    //Classic
    if (classicOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 100, 200, 40);
    //StarWars
    if (swOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 200, 200, 40);
    //ThirdOne
    if (pkOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 300, 200, 40);
    //Play
    if (playOver) fill(155); 
    else fill(255);
    rect(width-300, height-100, 200, 40);


    //inserire scritte nei rect? o immagine...
    fill(0);
    textSize(20);
    text("Classic", 240, height/4 + 127);

    drawPreview();
  }


  // Qui non serve...definiano vuoto nella super classe come dragged, etc.. ?
  void drawCylinders() {
  }

  void mousePressed() {
    if (classicOver) {
      env = 0;
    } else if (swOver) {
      env = 1;
    } else if (pkOver) {
      env = 2;
    } else if (playOver) {
      currentMode = new PlayMode();
    }
  }


  void isOver() {
    float x = mouseX;
    float y = mouseY;

    classicOver = false;
    swOver = false;
    pkOver = false;
    playOver = false;

    if (x > 140 && x < 340) {
      if (y > (height/4 + 100) && y < (height/4 + 140)) {
        classicOver = true;
      } else if (y > (height/4 + 200) && y < (height/4 + 240)) {
        swOver = true;
      } else if (y > (height/4 + 300) && y < (height/4 + 340)) {
        pkOver = true;
      }
    } else if (x > (width-300) && x < (width-100) && y > (height-100) && y < (height-60)) {
      playOver = true;
    }
  }

  void drawPreview() {

    //disegno immagine in base a valore corrente di env
    switch(env) {
    case -1:
      break;
    case 0: //classic
      fill(255, 0, 0);
      rect(width/2, height/4, width/2-100, height/2);
      break;
    case 1: //starwars
      fill(0, 255, 0);
      rect(width/2, height/4, width/2-100, height/2);
      break;
    case 2: //thirdone
      fill(0, 0, 255);
      rect(width/2, height/4, width/2-100, height/2);
      break;
    }
  }

  void startGame() {
    //inserire if per selezionare uno dei tre
    environment = new Environment();
    currentMode = new PlayMode();
  }

  /*
  //======================================================================== 
   //import the ControlP5 library
   //Define the new GUI
   
   void setup() {
   //set the window size
   size(200, 200);
   noStroke();
   //Create the new GUI
   gui = new ControlP5(this);
   //Add a Button
   gui.addButton("PressMe")
   //Set the position of the button : (X,Y)
   .setPosition(50, 50)
   //Set the size of the button : (X,Y)
   .setSize(100, 100)
   //Set the pre-defined Value of the button : (int)
   .setValue(0)
   //set the way it is activated : RELEASE the mouseboutton or PRESS it
   .activateBy(ControlP5.RELEASE);
   ;
   }
   
   public void PressMe(int value) {
   // This is the place for the code, that is activated by the buttonb
   println("Button pressed");
   }
   
   public void controlEvent(ControlEvent theEvent) {
   //Is called whenever a GUI Event happened
   }
   
   void draw() {
   //Do whatever you want
   }
   */
}