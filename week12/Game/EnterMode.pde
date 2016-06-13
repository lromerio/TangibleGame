
class EnterMode extends Mode {

  boolean resumeOver;
  boolean newOver;
  boolean helpOver;

  EnterMode() {
    isPaused = true;
    isPlayMode = false;
  }


  void display() {
    background(0);

    fill(255);
    textAlign(CENTER);
    textSize(50);
    text("Visual Programming Project", width/2, 120);

    isOver();    
    //Resume
    if (resumeOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 100, 200, 40);
    //New Game
    if (newOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 200, 200, 40);

    //TODO eventualmente inserie la possibilità di uscire dal gioco

    //Help
    if (helpOver) fill(155); 
    else fill(255);
    rect(width-60, 20, 40, 40);

    fill(0);
    textSize(20);
    text("Resume", 240, height/4 + 127);
    text("New Game", 240, height/4 + 227);    //inserire font rispettivi
    
    textSize(30);
    text("?", width-40, 50);


    pushMatrix();
    translate(width/2, height/2, 0);
    scores.drawScores();
    popMatrix();
  }

  void mousePressed() {
    if (resumeOver) {
      currentMode = new PlayMode();
    } else if (newOver) {
      currentMode = new MenuMode();
    } else if (helpOver) {
      currentMode = new HelpMode(currentMode);
    }
  }


  void isOver() {
    float x = mouseX;
    float y = mouseY;

    resumeOver = false;
    newOver = false;
    helpOver = false;

    if (x > 140 && x < 340) {
      if (y > (height/4 + 100) && y < (height/4 + 140)) {
        resumeOver = true;
      } else if (y > (height/4 + 200) && y < (height/4 + 240)) {
        newOver = true;
      }
    } else if ( x > width-60 && x < width-20 && y > 20 && y < 60) {
      helpOver = true;
    }
  }

  //anche qui non usato
  void drawCylinders() {
  };
}