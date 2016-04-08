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
Environment environment;
Minim minim;
Mode currentMode;

//_______________________________________________________________
//Mode
enum Mode {
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
  currentMode = Mode.PLAY;
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
      //ModeAdd.addCylinder();
       pushMatrix();
      rotateX(PI/2);
      beginShape();
      texture(plane.plateImg);
      vertex(- plane.boardEdge/2, -plane.boardThick/2, -plane.boardEdge/2, 0, 0);
    vertex(- plane.boardEdge/2, -plane.boardThick/2, plane.boardEdge/2, 0, 450);
    vertex(plane.boardEdge/2, -plane.boardThick/2, plane.boardEdge/2, 450, 450);
    vertex(plane.boardEdge/2, -plane.boardThick/2, -plane.boardEdge/2, 450, 0);
    endShape(CLOSE);
    popMatrix();
      break;
  }
}

void mouseDragged() {
  plane.mouseDraggedPlane();
}

void mouseWheel(MouseEvent event) {
  plane.mouseWheelPlane(event);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = Mode.ADD_CYLINDER;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentMode = Mode.PLAY;
    }
  }
}