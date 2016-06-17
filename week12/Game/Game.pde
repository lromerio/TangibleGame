
//_______________________________________________________________
//Imports

//BONUS
//Those imports are for playing sounds.
//import ddf.minim.*;
//import ddf.minim.analysis.*;
//import ddf.minim.effects.*;
//import ddf.minim.signals.*;
//import ddf.minim.spi.*;
//import ddf.minim.ugens.*;

//_______________________________________________________________
//Objects
Ball ball;
Plane plane;
Cylinder cylinder;
ArrayList<PVector> cylinders;
Mode currentMode;
Mode prevMode;
ScoreInterface scores;

//EdgeDetection
ImageProcessing ip;
Movie cam;
Boolean camOn;
PImage frameMovie;

//BONUS

//minim: object for loading playing sounds.
//Minim minim;

//environment: for personalised background and theme.
Environment environment;
PImage mainBG;
PFont mainFont;
//_______________________________________________________________
//Functions

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();

  // Standard Background
  mainBG = loadImage("MainBG.jpg");
  mainBG.resize(displayWidth, displayHeight);

  // Font
  mainFont = createFont("spaceage.ttf", 16, true);

  currentMode = new MenuMode();


  cam = new Movie(this, "testvideo.mp4"); //Put the video in the same directory
  //cam.loop();

  //EdgeDetection
  ip = new ImageProcessing();
  //String []args = {"Image processing window"};
  //PApplet.runSketch(args, ip);



  //cylinders = new ArrayList<PVector>();
  //ball = new Ball(20);
  //plane = new Plane(450, 20);
  //cylinder = new Cylinder(30, 30, 40);

  //scores = new ScoreInterface();

  //BONUS
  //minim = new Minim(this);
  //environment = new Environment()
}

void draw() {
  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);

  //ip.update(cam);

  currentMode.display();
} 

void movieEvent(Movie m) {
  m.read();
}

/*
 * Performs the mouse dragged action of the current mode. 
 */
void mouseDragged() {
  currentMode.mouseDragged();
}

/*
 * Performs the mouse pressed action of the current mode. 
 */
void mousePressed() {
  currentMode.mousePressed();
}

/*
 * Performs the mouse wheel action of the current mode. 
 */
void mouseWheel(MouseEvent event) {
  currentMode.mouseWheel(event);
}

/*
 * Switches the current mode to edit mode if 'SHIFT' is pressed.
 */
void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      if (currentMode.isPlayMode) {
        currentMode = new EditMode();
      }
    }
  }
}

/*
 * Switches the current mode to play mode when 'SHIFT' is released.
 */
void keyReleased() {
  if (currentMode.isPlayMode) {
    if (key == CODED) {
      if (keyCode == SHIFT) {
        currentMode = new PlayMode();
      }
    } else if (key == ENTER) {
      currentMode = new EnterMode();
    }
  }
}