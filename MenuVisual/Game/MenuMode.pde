

class MenuMode extends Mode {


  // Non possiamo fare enumeration qui, per ora int...da valutare

  MenuMode() {
    isPaused = true;
  }

  void display() {
    background(0);

    fill(255);
    textAlign(CENTER);
    textSize(80);
    text("Visual Programming Project", width/2, 120);

    textSize(30);
    text("Select Game Mode:", 250, height/4 + 50);

    drawPreview();
  }


  // Qui non serve...definiano vuoto nella super classe come dragged, etc.. ?
  void drawCylinders() {
  }

  void drawPreview() {

    //disegno immagine in base a valore corrente di env
    switch(env) {
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