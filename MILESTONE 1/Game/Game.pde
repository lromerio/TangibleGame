//_______________________________________________________________
//Importation
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//_______________________________________________________________
//Objects
Ball ball;
Plane plane;
Cylinder cylinder;
ArrayList<PVector> cylinders;
Environment environment;
Minim minim;
Modes currentMode;
Mode modeManager;


//_______________________________________________________________
//Mode
enum Modes {
  PLAY, ADD_CYLINDER
};

//_______________________________________________________________
//Functions

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
  minim = new Minim(this);
  environment = new Environment();
  ball = new Ball(20);
  plane = new Plane(450, 20);
  cylinder = new Cylinder(30, 30, 40);
  modeManager = new Mode();
  currentMode = Modes.PLAY;
  cylinders = new ArrayList<PVector>();
}

void draw() {
  environment.starWarsThemed();
  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);
  translate(width/2, height/2, 0);

  switch(currentMode) {
    case PLAY:
      plane.display();
      ball.update();
      ball.display();
      break;
    case ADD_CYLINDER:   
      modeManager.highView();
   
      break;
  }
  
  modeManager.drawCylinders();
}

void mouseDragged() {
  if(currentMode == Modes.PLAY) {
    plane.mouseDraggedPlane();
  }
}

void mousePressed() {
  if(currentMode == Modes.ADD_CYLINDER) {
    modeManager.addCylinder();
  }
}

void mouseWheel(MouseEvent event) {
  if(currentMode == Modes.PLAY) {
    plane.mouseWheelPlane(event);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = Modes.ADD_CYLINDER;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = Modes.PLAY;
    }
  }
}