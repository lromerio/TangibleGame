
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
import controlP5.*;

//_______________________________________________________________
//Objects
Ball ball;
Plane plane;
Cylinder cylinder;
ArrayList<PVector> cylinders;
Mode currentMode;
ScoreInterface scores;

//BONUS

//minim: object for loading playing sounds.
//Minim minim;
ControlP5 gui;    //for buttons
int env;


//environment: for personalised background and theme.
Environment environment;
//_______________________________________________________________
//Functions

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
  currentMode = new MenuMode();

  cylinders = new ArrayList<PVector>();
  ball = new Ball(20);
  plane = new Plane(450, 20);
  cylinder = new Cylinder(30, 30, 40);

  scores = new ScoreInterface();

  //BONUS
  //minim = new Minim(this);

  env = 0;
  gui = new ControlP5(this);

  // Add Buttons
  gui.addButton("Classic")
    .setValue(0)
    .setPosition(140, height/4 + 100)
    .setSize(200, 40)
    .activateBy(ControlP5.RELEASE);
    ;
  gui.addButton("StarWars")
    .setValue(0)
    .setPosition(140, height/4 + 200)
    .setSize(200, 40)
    .activateBy(ControlP5.RELEASE);
    ;
  gui.addButton("ThirdOne")
    .setValue(0)
    .setPosition(140, height/4 + 300)
    .setSize(200, 40)
    .activateBy(ControlP5.RELEASE);
    ;
  gui.addButton("Play")
    .setValue(0)
    .setPosition(width-300, height-100)
    .setSize(200, 40)
    .activateBy(ControlP5.RELEASE);
    ;
}

void draw() {
  //BONUS
  //environment.starWarsThemed();

  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);
  //pushMatrix();
  //translate(width/2, height/2, 0);


  currentMode.display();
  currentMode.drawCylinders();  

  //scores.drawScores();
} 

void Classic() {
  env = 0;
}
void StarWars() {
  env = 1;
}
void ThirdOne() {
  env = 2;
}

/*
void Play() {
  gui.hide();
  environment.starWarsThemed(); 
  currentMode = new PlayMode();
}
*/

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
      currentMode = new EditMode();
    }
  }
}

/*
 * Switches the current mode to play mode when 'SHIFT' is released.
 */
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = new PlayMode();
    }
  }
}