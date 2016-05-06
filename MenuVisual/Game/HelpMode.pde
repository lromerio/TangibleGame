
class HelpMode extends Mode {

    boolean backOver;
    Mode prevMode;

  HelpMode(Mode currentMode) {
    isPaused = true;
    isPlayMode = false;
    prevMode = currentMode;
  }

  void display() {
    background(0);
    
    fill(255);
    textAlign(CENTER);
    textSize(80);
    text("HELP", width/2, 120);
    textSize(50);
    text("Schiaccia un po' di tasti a caso", width/2, 200);
    
    isOver();
    
    //Play
    if (backOver) fill(155); 
    else fill(255);
    rect(width-300, height-100, 200, 40);
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