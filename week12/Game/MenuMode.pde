

class MenuMode extends Mode {

  boolean classicOver;
  boolean swOver;
  boolean pkOver;
  boolean playOver;
  boolean helpOver;

  PImage PreviewSW;
  PImage PreviewC;
  PImage PreviewPK;
  PImage backgroundImg;

  int env;

  // Non possiamo fare enumeration qui, per ora int...da valutare

  MenuMode() {
    isPaused = true;
    isPlayMode = false;

    PreviewC = loadImage("PreviewC.JPG");
    PreviewSW = loadImage("PreviewSW.JPG");
    PreviewPK = loadImage("PreviewPK.JPG");
    backgroundImg = loadImage("MenuBack1.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    env = -1;
  }

  void display() {
    background(backgroundImg);

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
    //Pokémon
    if (pkOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 300, 200, 40);
    //Play
    if (env != -1) {
      if (playOver) fill(155); 
      else fill(255);
      rect(width-300, height-100, 200, 40);
    }

    //Help
    if (helpOver) fill(155); 
    else fill(255);
    rect(width-60, 20, 40, 40);

    //inserire scritte nei rect? o immagine...
    fill(0);
    textSize(20);
    text("Classic", 240, height/4 + 127);
    text("Star Wars", 240, height/4 + 227);    //inserire font rispettivi
    text("Pokémon", 240, height/4 + 327);
    text("Play", width-200, height-73);

    textSize(30);
    text("?", width-40, 50);



    drawPreview();

    //fill(0);
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
    } else if (playOver && env != -1) {
      startGame();
    } else if (helpOver) {
      currentMode = new HelpMode(currentMode);
    }
  }


  void isOver() {
    float x = mouseX;
    float y = mouseY;

    classicOver = false;
    swOver = false;
    pkOver = false;
    playOver = false;
    helpOver = false;

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
    } else if ( x > width-60 && x < width-20 && y > 20 && y < 60) {
      helpOver = true;
    }
  }

  void drawPreview() {

    //disegno immagine in base a valore corrente di env
    fill(255);
    switch(env) {
    case -1:
      break;
    case 0: //classic
      image(PreviewC, width/2, height/4, width/2-100, height/2);
      break;
    case 1: //starwars
      image(PreviewSW, width/2, height/4, width/2-100, height/2);
      break;
    case 2: //pokemon
      image(PreviewPK, width/2, height/4, width/2-100, height/2);
      break;
    }
  }

  void startGame() {
    environment = new Environment(env);
    cylinders = new ArrayList<PVector>();
    scores = new ScoreInterface();
    ball = new Ball(20);
    plane = new Plane(450, 20);
    cylinder = new Cylinder(30, 30, 40);
    currentMode = new PlayMode();
    cam.loop();
  }
}