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
  }

  void draw() {
    environment.starWarsThemed();
    directionalLight(229, 255, 204, 0, 1, -1);
    ambientLight(102, 102, 102);
    translate(width/2, height/2, 0);
    
    //plane.update();
    plane.display();
    
    ball.update();
    ball.display();
  }

  void mouseDragged() {
    plane.mouseDraggedPlane();
  }

  void mouseWheel(MouseEvent event) {
    plane.mouseWheelPlane(event);
  }