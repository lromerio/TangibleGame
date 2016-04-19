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

PGraphics dataVisualisation;
PGraphics topView;
PGraphics scoreboard;


//BONUS

//minim: object for loading playing sounds.
//Minim minim;

//environment: for personalised background and theme.
Environment environment;
//_______________________________________________________________
//Functions

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
  currentMode = new PlayMode();
  cylinders = new ArrayList<PVector>();
  
  dataVisualisation = createGraphics(width, 150, P2D);
  topView = createGraphics(140, 140, P2D);
  scoreboard = createGraphics(100, 140, P2D);

  ball = new Ball(20);
  plane = new Plane(450, 20);
  cylinder = new Cylinder(30, 30, 40);

  //BONUS
  //minim = new Minim(this);
  environment = new Environment();
}

void draw() {
  //BONUS
  environment.starWarsThemed();

  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);
  translate(width/2, height/2, 0);

  currentMode.display();
  currentMode.drawCylinders();
  
  drawData();
  image(dataVisualisation, -width/2, height/2 - dataVisualisation.height);
  
  drawTopView();
  image(topView, 5 - width/2, height/2 - dataVisualisation.height + 5);
  
  drawScoreboard();
  image(scoreboard, - width/2+ 10 + topView.width, height/2 - dataVisualisation.height + 5);
}

void drawData() {
  dataVisualisation.beginDraw();
  dataVisualisation.background(255);
  dataVisualisation.endDraw();
}

void drawTopView() {
  topView.beginDraw();
  topView.translate(topView.width/2, topView.height/2);
  topView.background(255, 204, 0);
  //Draw the Ball
  topView.fill(ball.colour);
  topView.ellipse(mapC(ball.location.x), mapC(ball.location.z), 2*mapC(ball.r), 2*mapC(ball.r));
  //Draw Cylinders
  topView.fill(cylinder.colour);
  for(int i = 0; i < cylinders.size(); ++i) {
    topView.ellipse(mapC(cylinders.get(i).x), mapC(cylinders.get(i).y), 2*mapC(cylinder.c_radius), 2*mapC(cylinder.c_radius));
  }
  topView.endDraw();
}

void drawScoreboard() {
  scoreboard.beginDraw();
  scoreboard.background(0);
  scoreboard.fill(255);
  scoreboard.text("Total Score:", 10, 20);
  scoreboard.text(720000, 15, 35);
  scoreboard.text("Velocity:", 10, 60);
  scoreboard.text(ball.velocity.mag(), 15, 75);
  scoreboard.text("Last Score:", 10, 100);
  scoreboard.text(719999, 15, 115);
  scoreboard.endDraw();  
}

float mapC(float coord) {
  return map(coord, -plane.boardEdge/2, plane.boardEdge/2, -topView.width/2, topView.width/2);
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