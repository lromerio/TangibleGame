
class HelpMode extends Mode {

  boolean backOver;
  Mode prevMode;

  PImage backgroundImg;

  HelpMode(Mode currentMode) {
    isPaused = true;
    isPlayMode = false;
    prevMode = currentMode;
    textFont(mainFont);
  }

  void display() {
    background(mainBG);

    fill(255);
    textAlign(CENTER);
    textSize(50);
    text("HELP", width/2, 120);
    textSize(20);
    text("The goal of this simple game is to hit cylinders on a plane with a ball.", width/2, height/4 + 50);
    text("This is done by tilting the plane either with the mouse (click and drag on the playing area)", width/2, height/4 + 150);
    text("or with a real lego board and a webcam to capture its movements.", width/2, height/4 + 200);
    text("You gain points by hitting cylinders and lose them if you hit the edges of the board.", width/2, height/4 + 300);
    text("Cylinders can be added by holding the SHIFT key and clicking on the board.", width/2, height/4 + 400);
    text("Pressing ENTER will pause the game.", width/2, height/4 + 450);
    text("In this MILESTONE version you can also click \"Play with Video\"", width/2, height/4 + 550);
    text("to let the board follow a prerecorded video", width/2, height/4 + 600);

    isOver();

    //Back
    if (backOver) fill(155); 
    else fill(255);
    rect(width-300, height-100, 200, 40);

    fill(0);        //modificare font (di base)
    textSize(20);
    text("Back", width-200, height-73);
  }

  void mousePressed() {
    if (backOver) {
      currentMode = prevMode;
    }
  }

  void isOver() {
    float x = mouseX;
    float y = mouseY;

    if (x > (width-300) && x < (width-100) && y > (height-100) && y < (height-60)) {
      backOver = true;
    } else {
      backOver = false;
    }
  }

  //anche qui non usato
  void drawCylinders() {
  };
}