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
Mode currentMode;

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
  currentMode = new PlayMode();
  cylinders = new ArrayList<PVector>();
}

void draw() {
  environment.starWarsThemed();
  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);
  translate(width/2, height/2, 0);
  currentMode.display();
  currentMode.drawCylinders();
}

void mouseDragged() {
  currentMode.mouseDragged();
}

void mousePressed() {
  currentMode.mousePressed();
}

void mouseWheel(MouseEvent event) {
  currentMode.mouseWheel();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = new EditMode();
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = new PlayMode();
    }
  }
}