import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import java.util.Collections; 
import java.util.List; 
import java.util.Random; 
import processing.video.*; 
import java.util.Collections; 
import java.util.Comparator; 
import java.util.List; 
import java.util.ArrayList; 
import java.util.List; 
import processing.core.PVector; 
import papaya.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TangibleGame extends PApplet {


//_______________________________________________________________
//Imports

//BONUS
//Those imports are for playing sounds.







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
Movie video;
Capture cam;
Boolean vidOn;
Boolean webOn;
PImage frameMovie;

//BONUS

//minim: object for loading playing sounds.
Minim minim;

//environment: for personalised background and theme.
Environment environment;
PImage mainBG;
PFont mainFont;
//_______________________________________________________________
//Functions

public void settings() {
  fullScreen(P3D);
}

public void setup() {
  noStroke();

  //Style setup
  mainBG = loadImage("MainBG.jpg");
  mainBG.resize(displayWidth, displayHeight);
  mainFont = createFont("spaceage.ttf", 16, true);

  //Video setup
  video = new Movie(this, "testvideo.mp4");

  //Camera setup
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i] +"   "+ i);
    }
    cam = new Capture(this, cameras[9]);
    cam.start();
  }

  //EdgeDetection
  ip = new ImageProcessing();
  
  currentMode = new MenuMode();

  //BONUS
  minim = new Minim(this);
  //environment = new Environment()
}

public void draw() {
  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);

  currentMode.display();
} 

public void movieEvent(Movie m) {
  m.read();
}

/*
 * Performs the mouse dragged action of the current mode. 
 */
public void mouseDragged() {
  currentMode.mouseDragged();
}

/*
 * Performs the mouse pressed action of the current mode. 
 */
public void mousePressed() {
  currentMode.mousePressed();
}

/*
 * Performs the mouse wheel action of the current mode. 
 */
public void mouseWheel(MouseEvent event) {
  currentMode.mouseWheel(event);
}

/*
 * Switches the current mode to edit mode if 'SHIFT' is pressed.
 */
public void keyPressed() {
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
public void keyReleased() {
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
/**
 *  This class modelizes the ball. It has attributes to keep track of its movement variables 
 *  and it's characteristics (dimentions, color, sounds, ...)
 *  
 *  @normalForce   normal force to the surface.
 *  @mu            friction coefficient.
 *  @friction      friction vector.
 *  @r             radius of the ball.
 *  @location      current position of the ball in the space, relative to the center of the plane.
 *  @velocity      current velocity of the ball.
 *  @gravity       gravity vector.
 */
class Ball {

  //_______________________________________________________________
  //Attributes  
  float normalForce;
  float mu;  
  PVector friction;
  float r;
  PVector location;
  PVector velocity;
  PVector gravity;
  int colour;

  //BONUS
  //The bouncing sound
  AudioSample boing;


  //_______________________________________________________________
  //Functions
  /**
   * Initializes all attributes of the ball.
   */
  Ball(float r) {
    this.location = new PVector(0, 0, 0);
    this.r = r;
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
    mu = 0.6f;
    normalForce = 1;

    //BONUS
    boing = minim.loadSample("LaserBlasts.mp3");
    colour = color(50, 100, 200);
  }

  /**
   * Updates the position and velocity.
   */
  public void update() {
    gravity.x = sin(plane.angleZ) * environment.g;
    gravity.z = -sin(plane.angleX) * environment.g;

    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(normalForce * mu);

    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);

    
    if (location.x > plane.boardEdge/2) {
      location.x = plane.boardEdge/2;
      velocity.x *= -1;
      //tappa 6
      scores.lastScore = - velocity.mag();
      scores.totalScore += scores.lastScore;
      
      //BONUS
      boing.trigger();
    } else if (location.x < -plane.boardEdge/2) {
      location.x = -plane.boardEdge/2;
      velocity.x *= -1;

      scores.lastScore = - velocity.mag();
      scores.totalScore += scores.lastScore;
      //BONUS
      boing.trigger();
    }
    if (location.z > plane.boardEdge/2) {
      location.z = plane.boardEdge/2;
      velocity.z *= -1; 

      scores.lastScore = - velocity.mag();
      scores.totalScore += scores.lastScore;
      
      //BONUS
      boing.trigger();
    } else if (location.z < -plane.boardEdge/2) {
      location.z = -plane.boardEdge/2;
      velocity.z *= -1; 
      
      scores.lastScore = - velocity.mag();
      scores.totalScore += scores.lastScore;
      //BONUS
      boing.trigger();
    }
    
    cylinderCollision();
  }

 /**
  * Checks the collision with all cylinders on the plane.
  */
  public void cylinderCollision() {
    PVector norm;
    for (int i = 0; i < cylinders.size(); ++i) {
      if ( dist(cylinders.get(i).x, cylinders.get(i).y, location.x, location.z) <= cylinder.c_radius + r) {        
        //tappa 6
        scores.lastScore = velocity.mag();
        scores.totalScore += scores.lastScore;
        
        norm = (new PVector(location.x - cylinders.get(i).x, 0, location.z - cylinders.get(i).y)).normalize();
       
        velocity = PVector.sub(velocity, PVector.mult(norm, velocity.dot(norm) * 2));

        PVector cylc = new PVector(cylinders.get(i).x, 0, cylinders.get(i).y);
        location = PVector.add(cylc, PVector.mult(norm, cylinder.c_radius + r));

        
        //BONUS
        boing.trigger();
      }
    }
  }

 /**
  * Displays the ball.
  */
  public void display() {
    pushMatrix();
    rotateX(plane.angleX);
    rotateZ(plane.angleZ);
    translate(location.x, -r - (plane.boardThick/2), location.z);
    fill(colour);
    sphere(r);
    popMatrix();
  }
}
/**
 *  Represents a cylinder
 *  
 *  @side      shape representing the side surface
 *  @top       shape representing the top surface
 *  @bot       shape representing the bot surface
 *  @c_radius  radius
 *  @c_height  height
 */
class Cylinder {

  PShape side;
  PShape top;
  PShape bot;

  float c_radius;
  float c_height;

  //BONUS
  int colour;

  /**
   * Constructs a cylinder with a given radius, height and resolution(number of edges).
   */
  Cylinder(float c_radius, float c_height, int resolution) {
    side = new PShape();
    top = new PShape();
    bot = new PShape();

    this.c_radius = c_radius;
    this.c_height = c_height;
    
    colour = color(50, 100, 200);

    float angle;
    float[] x = new float[resolution + 1];
    float[] y = new float[resolution + 1];

    //get the x and y position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * c_radius;
      y[i] = cos(angle) * c_radius;
    }

    side = createShape();
    side.beginShape(QUAD_STRIP);
    top = createShape();
    top.beginShape(TRIANGLE_FAN);
    bot = createShape();
    bot.beginShape(TRIANGLE_FAN);
    top.vertex(0, 0, 0);
    bot.vertex(0, 0, c_height);

    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      side.vertex(x[i], y[i], 0);
      side.vertex(x[i], y[i], c_height);
      top.vertex(x[i], y[i], 0);
      bot.vertex(x[i], y[i], c_height);
    }
    side.endShape();
    top.endShape();
    bot.endShape();
  }

  /**
   * Draws the cylinder.
   */
  public void draw() {
    shape(cylinder.side);
    shape(cylinder.top);
    shape(cylinder.bot);
  }
}
/**
 * Editing mode. Allows the user to add some cylinders on the plane.
 */
class EditMode extends Mode {

  //tappa 6
  
  EditMode(){
     isPaused = true;
     isPlayMode = true;
  }
  
  /*
   * If the mouse is pressed start the procedure to add a new cylinder.
   *
   * @see  addCylinder
   */
  public void mousePressed() {
    addCylinder();
  }

  /*
   * Draws the current state of the plane by calling highView,
   * and a cylinder centered at the current postion of the mouse.
   *
   * @see  highView
   */
  public void display() {
    environment.display();
    pushMatrix();
    translate(width/2, height/2, 0);
    highView();

    //BONUS
    //Shows a cylinder centered at the current postion of the mouse, 
    //green if it's a valid position for a new cylinder, red if not.
    PVector mousePos = new PVector(mouseX - width/2, mouseY - height/2, plane.boardThick/2);
    int c;
    if ( checkCylindersPosition(mousePos) &&
      (mousePos.x <= plane.boardEdge/2 - cylinder.c_radius) && (mousePos.x >= -plane.boardEdge/2 + cylinder.c_radius) &&
      (mousePos.y <= plane.boardEdge/2 - cylinder.c_radius) && (mousePos.y >= -plane.boardEdge/2 + cylinder.c_radius) ) {
      c = color(50, 200, 100);
    } else {
        c = color(255, 102, 102);
    }

    cylinder.side.setFill(c);
    cylinder.top.setFill(c);
    cylinder.bot.setFill(c);

    pushMatrix();      
    translate( mouseX - width/2, mouseY - height/2, plane.boardThick/2);
    cylinder.draw();
    popMatrix();
    
    drawCylinders();
    scores.drawScores();
    popMatrix();
  }

  /*
   * Displays an high view of the current state of the plane.
   */
  public void highView() {
    pushMatrix();
    rotateX(PI/2);

    shape(plane.upper);

    translate(ball.location.x, plane.boardThick/2 + ball.r, - ball.location.z);
    fill(ball.colour);
    sphere(ball.r);

    popMatrix();
  }

  /*
   * If checkCylindersPosition returns true add a new cylinder to the game.
   *
   * @see  checkCylindersPosition
   */
  public void addCylinder() {

    int x = mouseX - width/2;
    int y = mouseY - height/2;

    if ( (x <= plane.boardEdge/2 - cylinder.c_radius) && (x >= -plane.boardEdge/2 + cylinder.c_radius) &&
      (y <= plane.boardEdge/2 - cylinder.c_radius) && (y >= -plane.boardEdge/2 + cylinder.c_radius) ) {
      PVector cylCenter = new PVector(x, y, plane.boardThick/2);
      if (checkCylindersPosition(cylCenter)) {
        cylinders.add(cylCenter);
      }
    }
  }

  /*
   * Checks whether the given PVector is a valid center for a new cylinder or not.
   *
   * @param center  The PVector to check
   * @return        A boolean
   */
  public boolean checkCylindersPosition(PVector center) { 
    if ( dist(center.x, center.y, ball.location.x, ball.location.z) <= cylinder.c_radius + ball.r) {
      return false;
    }

    for ( int i = 0; i < cylinders.size(); ++i) {
      if ( dist(center.x, center.y, cylinders.get(i).x, cylinders.get(i).y) <= 2*cylinder.c_radius) {
        return false;
      }
    }
    return true;
  }

  /*
   * Draws the cylinders on the plane.
   */
  public void drawCylinders() {
    cylinder.side.setFill(cylinder.colour);
    cylinder.top.setFill(cylinder.colour);
    cylinder.bot.setFill(cylinder.colour);

    for (int j = 0; j < cylinders.size(); ++j) {
      pushMatrix();      
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
      cylinder.draw();
      popMatrix();
    }
  }
}

class EnterMode extends Mode {

  boolean resumeOver;
  boolean newOver;
  boolean helpOver;

  PImage backgroundImg;

  EnterMode() {
    isPaused = true;
    isPlayMode = false;

    textFont(mainFont);
  }


  public void display() {
    background(mainBG);

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

    //TODO eventualmente inserie la possibilit\u00e0 di uscire dal gioco

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

  public void mousePressed() {
    if (resumeOver) {
      currentMode = new PlayMode();
    } else if (newOver) {
      currentMode = new MenuMode();
    } else if (helpOver) {
      currentMode = new HelpMode(currentMode);
    }
  }


  public void isOver() {
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
  public void drawCylinders() {
  };
}
/**
 *  All this class is a BONUS,except for the gravity coefficient. Represents the environment of the game,
 *  containing the background, the plane texture, and sounds.
 *
 *  @backgroundImg background of the game.
 *  @f             font for the stats.
 *  @g             gravity coefficient
 */
class Environment {

  //_______________________________________________________________
  //Attributes
  PImage backgroundImg;
  PImage plateImg;
  PImage sideImg;
 

  PFont gameFont;
  //int env;

  final float g;

  //BONUS
  //PLayer for the background music
  AudioPlayer player;

  //_______________________________________________________________
  //Functions

  /**
   * Creates an environment, loading images and sounds, and initialising the attributes
   */
  Environment(int env) {    
    g = 1.1f;

    //this.env = env;

    switch(env) {
    case 0: //classic
      classicThemed();
      break;
    case 1: //starwars
      starWarsThemed();
      break;
    case 2: //thirdone
      pokemonThemed();
      break;
    }
  }

  public void classicThemed() {
    backgroundImg = mainBG;

    plateImg = loadImage("PlateTextureClassic.jpg");
    sideImg = loadImage("PlateTextureClassic.jpg");

    gameFont = mainFont;
  }

  public void starWarsThemed() {
    //BONUS
    //Star Wars themed background (source: http://imgur.com/gallery/gXpIT), resized to match the display window.
    backgroundImg = loadImage("StarWarsBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    plateImg = loadImage("PlateTexture2.jpg");
    sideImg = loadImage("SideTxt2.jpg");      

    //BONUS
    //Plays the Star Wars theme in backgound when the Environment is created.
    player = minim.loadFile("StarWarsTheme.mp3");
    player.play();

    //BONUS
    //Star Wars themed font to display on the screen (source: http://www.fontspace.com/category/star%20wars)
    gameFont = createFont("Starjedi.ttf", 16, true);
  }

  public void pokemonThemed() {
    //BONUS
    //Star Wars themed background (source: http://imgur.com/gallery/gXpIT), resized to match the display window.
    backgroundImg = loadImage("pok1.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    plateImg = loadImage("PlateTexturePokemon2.jpg");
    sideImg = loadImage("PlateTexturePokemon2.jpg");

    //BONUS
    //Plays the Star Wars theme in backgound when the Environment is created.
    //player = minim.loadFile("StarWarsTheme.mp3");
    //player.play();

    //BONUS
    //Star Wars themed font to display on the screen (source: http://www.fontspace.com/category/star%20wars)
    gameFont = createFont("PokemonSolid.ttf", 16, true);
  }

  /**
   * Displays a Star Wars themed background and writes on the top left of the screen the tilting angle and speed
   */
  public void display() {
    background(backgroundImg);
    //Display some of the attributes of the plane
    //textFont(f, 20);
    textSize(20);
    fill(255, 255, 255);
    textAlign(LEFT);
    text("Rotation x : \t\t" + degrees(plane.angleX), 20, 20);
    text("Rotation z : \t\t" + degrees(plane.angleZ), 20, 40);
    text("Speed : \t\t" + plane.speed, 20, 60);
  }
}
class HScrollbar {
  float barWidth;  //Bar's width in pixels
  float barHeight; //Bar's height in pixels
  float xPosition;  //Bar's x position in pixels
  float yPosition;  //Bar's y position in pixels
  
  float sliderPosition, newSliderPosition;    //Position of slider
  float sliderPositionMin, sliderPositionMax; //Max and min values of slider
  
  boolean mouseOver;  //Is the mouse over the slider?
  boolean locked;     //Is the mouse clicking and dragging the slider now?

  /**
   * @brief Creates a new horizontal scrollbar
   * 
   * @param x The x position of the top left corner of the bar in pixels
   * @param y The y position of the top left corner of the bar in pixels
   * @param w The width of the bar in pixels
   * @param h The height of the bar in pixels
   */
  HScrollbar (float x, float y, float w, float h) {
    barWidth = w;
    barHeight = h;
    xPosition = x;
    yPosition = y;
    
    sliderPosition = xPosition + barWidth/2 - barHeight/2;
    newSliderPosition = sliderPosition;
    
    sliderPositionMin = xPosition;
    sliderPositionMax = xPosition + barWidth - barHeight;
  }

  /**
   * @brief Updates the state of the scrollbar according to the mouse movement
   */
  public void update() {
    if (isMouseOver()) {
      mouseOver = true;
    }
    else {
      mouseOver = false;
    }
    if (mousePressed && mouseOver) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderPosition = constrain(mouseX - barHeight/2, sliderPositionMin, sliderPositionMax);
    }
    if (abs(newSliderPosition - sliderPosition) > 1) {
      sliderPosition = sliderPosition + (newSliderPosition - sliderPosition);
    }
  }

  /**
   * @brief Clamps the value into the interval
   * 
   * @param val The value to be clamped
   * @param minVal Smallest value possible
   * @param maxVal Largest value possible
   * 
   * @return val clamped into the interval [minVal, maxVal]
   */
  public float constrain(float val, float minVal, float maxVal) {
    return min(max(val, minVal), maxVal);
  }

  /**
   * @brief Gets whether the mouse is hovering the scrollbar
   *
   * @return Whether the mouse is hovering the scrollbar
   */
  public boolean isMouseOver() {
    if (mouseX > xPosition && mouseX < xPosition+barWidth &&
      mouseY > yPosition && mouseY < yPosition+barHeight) {
      return true;
    }
    else {
      return false;
    }
  }

  /**
   * @brief Draws the scrollbar in its current state
   */ 
  public void display() {
    noStroke();
    fill(204);
    rect(xPosition, yPosition, barWidth, barHeight);
    if (mouseOver || locked) {
      fill(0, 0, 0);
    }
    else {
      fill(102, 102, 102);
    }
    rect(sliderPosition, yPosition, barHeight, barHeight);
  }

  /**
   * @brief Gets the slider position
   * 
   * @return The slider position in the interval [0,1] corresponding to [leftmost position, rightmost position]
   */
  public float getPos() {
    return (sliderPosition - xPosition)/(barWidth - barHeight);
  }
}

class HelpMode extends Mode {

  boolean backOver;
  Mode prevMode;

  PImage backgroundImg;

  HelpMode(Mode currentMode) {
    isPaused = true;
    isPlayMode = false;
    prevMode = currentMode;
    textFont(mainFont);
  }

  public void display() {
    background(mainBG);

    fill(255);
    textAlign(CENTER);
    textSize(50);
    text("HELP", width/2, 120);
    textSize(20);
    text("The goal of this simple game is to hit cylinders on a plane with a ball.", width/2, height/4 + 50);
    text("This is done by tilting the plane either with the mouse (click and drag on the playing area)", width/2, height/4 + 150);
    text("or with a real lego board and a webcam to capture its movements.", width/2, height/4 + 200);
    text("You gain points by hitting cylinders and lose them if you hit the edges of the board.", width/2, height/4 + 300);
    text("Cylinders can be added by holding the SHIFT key and clicking on the board.", width/2, height/4 + 400);
    text("Pressing ENTER will pause the game.", width/2, height/4 + 450);
    text("In this MILESTONE version you can also click \"Play with Video\"", width/2, height/4 + 550);
    text("to let the board follow a prerecorded video", width/2, height/4 + 600);

    isOver();

    //Back
    if (backOver) fill(155); 
    else fill(255);
    rect(width-300, height-100, 200, 40);

    fill(0);        //modificare font (di base)
    textSize(20);
    text("Back", width-200, height-73);
  }

  public void mousePressed() {
    if (backOver) {
      currentMode = prevMode;
    }
  }

  public void isOver() {
    float x = mouseX;
    float y = mouseY;

    if (x > (width-300) && x < (width-100) && y > (height-100) && y < (height-60)) {
      backOver = true;
    } else {
      backOver = false;
    }
  }

  //anche qui non usato
  public void drawCylinders() {
  };
}
class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}
// Imports
    //for sorting




class ImageProcessing {

  // Camera
  //Capture cam;
  //Movie cam;

  // Images
  PImage imgStart;
  PImage imgSobel;
  PImage imgHoughAccumulator;
  PImage imgQuad;

  // Detection structures
  List<PVector> bestLines;
  ArrayList<Integer> bestCandidates;
  QuadGraph QGraph;
  List<int[]> finalQuads;
  PVector areaBounds;

  // Week 12
  TwoDThreeD tdtd;


   ImageProcessing() {

    QGraph = new QuadGraph();

    tdtd = new TwoDThreeD(width, height);
  }

  public void update(PImage cam) {  

    // Thresholding pipeline
    imgSobel = hueThresholding(cam.get(), 50, 140);
    imgSobel = brightnessThresholding(imgSobel, 30, 200);
    imgSobel = saturationThresholding(imgSobel, 90, 255);
    imgSobel = gaussianBlur(imgSobel);
    imgSobel = intensityThresholding(imgSobel, 30, 200);

    // Calculate Sobel image
    imgSobel = sobel(imgSobel);
    
    
    // Do Hough algorithm and print accumulator
    bestLines = hough(imgSobel, 178, 6);

    // Quad detection
    QGraph.build(bestLines, width, height);
    finalQuads = filterQuads(QGraph.findCycles());

    if (!finalQuads.isEmpty()) {

      List<PVector> sortedC = QGraph.sortCorners(quadCoord(finalQuads));

      PVector rot = tdtd.get3DRotations(sortedC);

      println("Rot x: " + degrees(rot.x) );
      println("Rot y: " + degrees(rot.y) );
      println("Rot z: " + degrees(rot.z) );

      // Update plane angles
      plane.angleX = rot.x;
      plane.angleZ = rot.z;      
    }
    
    
  }
  
 
  //____________________________________________________________________________________
  //     WEEK 12
  //____________________________________________________________________________________

  public List<PVector> quadCoord(List<int[]> quad) {

    PVector l1 = bestLines.get(quad.get(0)[0]);
    PVector l2 = bestLines.get(quad.get(0)[1]);
    PVector l3 = bestLines.get(quad.get(0)[2]);
    PVector l4 = bestLines.get(quad.get(0)[3]);

    List<PVector> corners = new ArrayList<PVector>();

    corners.add(intersection(l1, l2));
    corners.add(intersection(l2, l3));
    corners.add(intersection(l3, l4));
    corners.add(intersection(l4, l1));

    return corners;
  }


  //____________________________________________________________________________________
  //    MILESTONE II
  //____________________________________________________________________________________

  // Implements convexity, area and non-flat filters
  public List<int[]> filterQuads(List<int[]> quads) {

    List<int[]> filtered = new ArrayList<int[]>();
    for (int[] quad : quads) {

      PVector l1 = bestLines.get(quad[0]);
      PVector l2 = bestLines.get(quad[1]);
      PVector l3 = bestLines.get(quad[2]);
      PVector l4 = bestLines.get(quad[3]);

      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      float A = width*height;

      if (  QGraph.isConvex(c12, c23, c34, c41)
        &&  QGraph.validArea(c12, c23, c34, c41, A, 0)
        &&  QGraph.nonFlatQuad(c12, c23, c34, c41) ) {

        filtered.add(quad);
      }
    }

    return filtered;
  }

  // Draw a collection of quads by displaying their corners
  public void drawQGraph(List<int[]> quads) {
    for (int[] quad : quads) {
      for (int i = 0; i < 4; ++i) {

        PVector l = bestLines.get(quad[i]); 

        // Compute the intersection of this line with the 4 borders of the image
        int x0 = 0;
        int y0 = (int) (l.x / sin(l.y));
        int x1 = (int) (l.x / cos(l.y));
        int y1 = 0;
        int x2 = imgStart.width;
        int y2 = (int) (-cos(l.y) / sin(l.y) * x2 + l.x / sin(l.y));
        int y3 = imgStart.width;
        int x3 = (int) (-(y3 - l.x / sin(l.y)) * (sin(l.y) / cos(l.y)));

        //Plot the lines
        stroke(204, 102, 0);
        if (y0 > 0) {
          if (x1 > 0)
            line(x0, y0, x1, y1);
          else if (y2 > 0)
            line(x0, y0, x2, y2);
          else
            line(x0, y0, x3, y3);
        } else {
          if (x1>0) {
            if (y2>0)
              line(x1, y1, x2, y2);
            else
              line(x1, y1, x3, y3);
          } else
            line(x2, y2, x3, y3);
        }
      }

      PVector l1 = bestLines.get(quad[0]);
      PVector l2 = bestLines.get(quad[1]);
      PVector l3 = bestLines.get(quad[2]);
      PVector l4 = bestLines.get(quad[3]);

      // (intersection() is a simplified version of the
      // intersections() method you wrote last week, that simply
      // return the coordinates of the intersection between 2 lines)
      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      // Draw quad corners
      fill(255, 128, 0);
      ellipse(c12.x, c12.y, 10, 10);
      ellipse(c23.x, c23.y, 10, 10);
      ellipse(c34.x, c34.y, 10, 10);
      ellipse(c41.x, c41.y, 10, 10);
    }
  }

  public ArrayList<PVector> getIntersections(List<PVector> lines) {

    ArrayList<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < lines.size() - 1; i++) {
      PVector line1 = lines.get(i);
      for (int j = i + 1; j < lines.size(); j++) {
        PVector line2 = lines.get(j);

        // compute the intersection and add it to \u2019intersections\u2019
        float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
        float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y)) / d;
        float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y)) / d;

        // draw the intersection
        fill(255, 128, 0);
        ellipse(x, y, 10, 10);
      }
    }
    return intersections;
  }

  // Computes the intersection between two polar lines
  public PVector intersection(PVector line1, PVector line2) {

    // compute the intersection and add it to \u2019intersections\u2019
    float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
    float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y)) / d;
    float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y)) / d;

    return new PVector(x, y);
  }

  // Takes the accumulator and its dimensions and returns the image
  public PImage displayHoughAcc(int[] accumulator, int rDim, int phiDim) {

    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }

    houghImg.resize(600, 600);
    houghImg.updatePixels();
    return houghImg;
  }

  // Implements the Hough algorithm for edge detection
  public ArrayList<PVector> hough(PImage edgeImg, int minVotes, int nLines) {

    bestCandidates = new ArrayList<Integer>();

    float discretizationStepsPhi = 0.06f;
    float discretizationStepsR = 2.5f;

    // Accumulator and dimensions
    int phiDim = (int) (Math.PI / discretizationStepsPhi);
    int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
    int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

    // Pre-compute the sin and cos values
    float[] tabSin = new float[phiDim];
    float[] tabCos = new float[phiDim];
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }

    // Fill the accumulator
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {

        // If on an edge
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {

          // Determine all lines
          for (int phiC = 0; phiC < phiDim; ++phiC) {
            int r = (int)(x*tabCos[phiC] + y*tabSin[phiC]);
            r += (rDim - 1) / 2;
            accumulator[(phiC+1)*(rDim + 2) + r] += 1;
          }
        }
      }
    }

    // Local maxima
    int neighbourhood = 20;
    for (int accR = 0; accR < rDim; accR++) {
      for (int accPhi = 0; accPhi < phiDim; accPhi++) {
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
        if (accumulator[idx] > minVotes) {
          boolean bestCandidate=true;
          for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
            if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
            for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
              if (accR+dR < 0 || accR+dR >= rDim) continue;
              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
              if (accumulator[idx] < accumulator[neighbourIdx]) {
                bestCandidate=false;
                break;
              }
            }
            if (!bestCandidate) break;
          }
          if (bestCandidate) {
            bestCandidates.add(idx);
          }
        }
      }
    }

    // Save accumulator image
    imgHoughAccumulator = displayHoughAcc(accumulator, rDim, phiDim);

    // Sort bestCandidates
    Collections.sort(bestCandidates, new HoughComparator(accumulator));

    // Lines array to return
    ArrayList<PVector> bestLines = new ArrayList<PVector>();

    for (int i = 0; i < min(nLines, bestCandidates.size()); ++i) {

      int idx = bestCandidates.get(i);

      //Compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim + 2)) - 1;
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;

      // Add line to bestLines
      bestLines.add(new PVector(r, phi));
    }

    return bestLines;
  }

  // Area thresholding
  public PVector areaThresholding(PImage img) {

    int whitePixels = 0;

    for (int i = 0; i < img.width * img.height; i++) {
      if (img.pixels[i] == color(255) ) {
        ++whitePixels;
      }
    }

    float minArea = whitePixels - (img.width * img.height*10)/100.f;
    float maxArea = whitePixels + (img.width * img.height*10)/100.f;

    return new PVector(maxArea, minArea);
  }

  // Implement Sobel algorithm
  public PImage sobel(PImage img) {

    // Kernels and image initialisation
    float[][] hKernel = 
      { { 0, 1, 0 }, 
      { 0, 0, 0 }, 
      { 0, -1, 0 } };
    float[][] vKernel = 
      { { 0, 0, 0 }, 
      { 1, 0, -1 }, 
      { 0, 0, 0 } };
    PImage result = createImage(img.width, img.height, ALPHA);


    // Clear the image
    for (int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(0);
    }
    float max=0;
    float[] buffer = new float[img.width * img.height];
    float sum_h = 0;
    float sum_v = 0;
    float sum = 0;

    // Double convolution
    for (int y = 1; y < img.height - 1; ++y) {
      for (int x = 1; x < img.width - 1; ++x) {
        sum_h = 0;
        sum_v = 0;
        sum = 0;
        for (int i = -1; i < 2; ++i) {
          for (int j = -1; j < 2; ++j) {
            sum_h += brightness(img.pixels[(y+i)*img.width + (x+j)])*hKernel[j+1][i+1];
            sum_v += brightness(img.pixels[(y+i)*img.width + (x+j)])*vKernel[j+1][i+1];
          }
        }
        sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
        buffer[x + y*img.width] = sum;
        if (sum > max) {
          max = sum;
        }
      }
    }

    for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
      for (int x = 2; x < img.width - 2; x++) { // Skip left and right
        if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
          result.pixels[y * img.width + x] = color(255);
        } else {
          result.pixels[y * img.width + x] = color(0);
        }
      }
    }
    return result;
  }

  // Implements the Gaussian Blur on an image
  public PImage gaussianBlur(PImage img) {

    // Kernel initialisation
    float[][] kernel = 
      { { 9, 12, 9 }, 
      { 12, 15, 12 }, 
      { 9, 12, 9 }};
    float weight = 99.f;

    // Create a greyscale image (type: ALPHA) for output
    PImage result = createImage(img.width, img.height, ALPHA);
    int sum = 0;
    for (int y = 1; y < img.height - 1; ++y) {
      for (int x = 1; x < img.width - 1; ++x) {
        sum = 0;
        for (int i = -1; i < 2; ++i) {
          for (int j = -1; j < 2; ++j) {
            sum += brightness(img.pixels[(y+i)*img.width + (x+j)])*kernel[j+1][i+1];
          }
        }
        result.pixels[x + y*img.width] = color((int)(sum/weight));
      }
    }
    return result;
  }

  // Threshold brightness
  public PImage brightnessThresholding(PImage img, int lowerBound, int upperBound) {
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
      if (brightness(img.pixels[i]) <= upperBound &&
        brightness(img.pixels[i]) >= lowerBound) {
        result.pixels[i] = img.pixels[i];
      } else {
        result.pixels[i] = color(0);
      }
    }
    return result;
  }

  // Threshold saturation
  public PImage saturationThresholding(PImage img, int lowerBound, int upperBound) {
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
      if (saturation(img.pixels[i]) <= upperBound &&
        saturation(img.pixels[i]) >= lowerBound) {
        result.pixels[i] = img.pixels[i];
      } else {
        result.pixels[i] = color(0);
      }
    }
    return result;
  }

  // Threshold hue
  public PImage hueThresholding(PImage img, int lowerBound, int upperBound) {
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
      if (  hue(img.pixels[i]) < lowerBound ||
        hue(img.pixels[i]) > upperBound) {
        result.pixels[i] = color(0);
      } else {
        result.pixels[i] =  img.pixels[i];
      }
    }

    return result;
  }

  // Threshold brightness and output a blck and white image
  public PImage intensityThresholding(PImage img, int lowerBound, int upperBound) {
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
      if ( brightness(img.pixels[i]) < lowerBound ||
        brightness(img.pixels[i]) > upperBound) {
        result.pixels[i] = color(0);
      } else {
        result.pixels[i] =  color(255);
      }
    }

    return result;
  }
}


class MenuMode extends Mode {

  boolean classicOver;
  boolean swOver;
  boolean pkOver;
  boolean playOver;
  boolean helpOver;
  boolean playVidOver;
  boolean playCamOver;


  PImage PreviewSW;
  PImage PreviewC;
  PImage PreviewPK;

  int env;

  // Non possiamo fare enumeration qui, per ora int...da valutare

  MenuMode() {
    isPaused = true;
    isPlayMode = false;

    PreviewC = loadImage("PreviewC.JPG");
    PreviewSW = loadImage("PreviewSW.JPG");
    PreviewPK = loadImage("PreviewPK.JPG");

    textFont(mainFont);

    env = -1;
  }

  public void display() {
    background(mainBG);

    fill(255);
    textAlign(CENTER);
    textSize(50);
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
    //Pok\u00e9mon
    if (pkOver) fill(155); 
    else fill(255);
    rect(140, height/4 + 300, 200, 40);
    //Play
    if (env != -1) {
      //Normal
      if (playOver) fill(155); 
      else fill(255);
      rect(width-300, height-100, 200, 40);
      //Video
      if (playVidOver) fill(155); 
      else fill(255);
      rect(width-650, height-100, 300, 40);
      //Webcam
      if (playCamOver) fill(155); 
      else fill(255);
      rect(width-1000, height-100, 300, 40);
    }

    //Help
    if (helpOver) fill(155); 
    else fill(255);
    rect(width-60, 20, 40, 40);

    //inserire scritte nei rect? o immagine...
    fill(0);
    textSize(20);
    text("Classic", 240, height/4 + 127);
    text("Star Wars", 240, height/4 + 227);
    text("Pok\u00e9mon", 240, height/4 + 327);
    if (env != -1) {
      text("Play", width-200, height-73);
      text("Play with Video", width-500, height-73);
      text("Play with Webcam", width-850, height-73);
    }

    textSize(30);
    text("?", width-40, 50);



    drawPreview();

    //fill(0);
  }


  // Qui non serve...definiano vuoto nella super classe come dragged, etc.. ?
  public void drawCylinders() {
  }

  public void mousePressed() {
    if (classicOver) {
      env = 0;
    } else if (swOver) {
      env = 1;
    } else if (pkOver) {
      env = 2;
    } else if (playOver && env != -1) {
      vidOn = false;
      webOn = false;
      startGame();
    } else if (playVidOver && env != -1) {
      vidOn = true;
      webOn = false;
      startGame();
    } else if (playCamOver && env != -1) {
      vidOn = false;
      webOn = true;
      startGame();
    } else if (helpOver) {
      currentMode = new HelpMode(currentMode);
    }
  }


  public void isOver() {
    float x = mouseX;
    float y = mouseY;

    classicOver = false;
    swOver = false;
    pkOver = false;
    playOver = false;
    helpOver = false;
    playVidOver = false;
    playCamOver = false;


    if (x > 140 && x < 340) {
      if (y > (height/4 + 100) && y < (height/4 + 140)) {
        classicOver = true;
      } else if (y > (height/4 + 200) && y < (height/4 + 240)) {
        swOver = true;
      } else if (y > (height/4 + 300) && y < (height/4 + 340)) {
        pkOver = true;
      }
    } else if ( y > (height-100) && y < (height-60)) {
      if (x > (width-300) && x < (width-100)) {
        playOver = true;
      } else if ( x > width-650 && x < width-350) {
        playVidOver = true;
      } else if ( x > width-1000 && x < width-700) {
        playCamOver = true;
      }
    } else if ( x > width-60 && x < width-20 && y > 20 && y < 60) {
      helpOver = true;
    }
  }

  public void drawPreview() {

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

  public void startGame() {
    environment = new Environment(env);
    cylinders = new ArrayList<PVector>();
    scores = new ScoreInterface();
    ball = new Ball(20);
    plane = new Plane(450, 20);
    cylinder = new Cylinder(30, 30, 40);
    currentMode = new PlayMode();
    if (vidOn) {
      video.loop();
    }
  }
}
/**
 * Represents a game mode.
 */
abstract class Mode {
  //tappa 6
  boolean isPaused;
  boolean isPlayMode;
    
  /*
   * Draws the plane and the ball.
   */
  public abstract void display();
  
  /*
   * Implements the mouse dragged action for the mode.
   */
  public void mouseDragged(){}
  
  /*
   * Implements the mouse pressed action for the mode.
   */
  public void mousePressed(){}

  /*
   * Implements the mouse wheel action for the mode.
   */
  public void mouseWheel(MouseEvent event){}

  /*
   * Draws the cylinders on the plane.
   */
  public abstract void drawCylinders();
  
}
/**
 *  Represents the plane keeping track of the dimensions, its angles and speed of tilting and additionally some textures
 *  
 *  @previousX   last x coordinate of the mouse.
 *  @previousY   last y coordinate of the mouse.
 *  @angleX      x angle of the inclination.
 *  @angleZ      z angle of the inclination.
 *  @speed       speed of the tilting movement.
 *  @boardEdge   lenght of the edge.
 *  @boardThick  thickness of the plane.
 *  @plateImg    image on top/bot.
 *  @upper       the top of the plane, where the game actually takes place
 *  @bottom      the bottom of the plane
 *  @side1       the left side of the plane
 *  @side2       the back side of the plane
 *  @side3       the front side of the plane
 *  @side4       the right side of the plane
 */
class Plane {

  //_______________________________________________________________
  //Attributes
  float previousX;
  float previousY;
  float angleX;
  float angleZ;
  float speed;
  float boardEdge;
  float boardThick;

  //the plane is not implemented by a single box but rather with 6 PShapes, so that it's possible to add different textures to each side
  PShape upper;
  PShape bottom;
  PShape side1;
  PShape side2;
  PShape side3;
  PShape side4;

  //_______________________________________________________________
  //Basic Function

  /**
   * Initializes all attributes of the plane, loads textures and creates the shapes of each face.
   *
   * @param  boardEdge    the desired length of the sides
   * @param  boardThick   the desired thickness of the plane
   */
  Plane(float boardEdge, float boardThick) {

    //For tilting the plane
    previousX = mouseX;
    previousY = mouseY;
    angleX = 0;
    angleZ = 0;
    speed = 1;

    //Dimensions
    this.boardEdge = boardEdge;
    this.boardThick = boardThick;

    //Top side
    upper = createShape();
    upper.beginShape();
    upper.texture(environment.plateImg);
    upper.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 0);
    upper.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 450);
    upper.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 450);
    upper.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 0);
    upper.endShape();

    //Bottom side
    bottom = createShape();
    bottom.beginShape();
    //BONUS
    //texture
    bottom.texture(environment.plateImg);
    bottom.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
    bottom.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 450);
    bottom.vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 450);
    bottom.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
    bottom.endShape();

    //Left side
    side1 = createShape();
    side1.beginShape();
    //BONUS
    //texture
    side1.texture(environment.sideImg);
    side1.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
    side1.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
    side1.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
    side1.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
    side1.endShape();

    //Back side
    side2 = createShape();
    side2.beginShape();
    //BONUS
    //texture
    side2.texture(environment.sideImg);
    side2.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
    side2.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
    side2.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
    side2.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
    side2.endShape();

    //Front side
    side3 = createShape();
    side3.beginShape();
    //BONUS
    //texture
    side3.texture(environment.sideImg);
    side3.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
    side3.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
    side3.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
    side3.vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
    side3.endShape();

    //Right side
    side4 = createShape();
    side4.beginShape();
    //BONUS
    //texture
    side4.texture(environment.sideImg);
    side4.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
    side4.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
    side4.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
    side4.vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
    side4.endShape();
  }

  /**
   * Displays the plane
   */
  public void display() {
    pushMatrix();
    rotateX(angleX);
    rotateZ(angleZ);
    shape(upper);
    shape(bottom);
    shape(side1);
    shape(side2);
    shape(side3);
    shape(side4);
    popMatrix();
  }

  //_______________________________________________________________
  //Control

  /**
   * Implements the mouse dragged action for the plane, tilting it.
   */
  public void mouseDraggedPlane() {
    if (previousX > mouseX && angleZ >= -PI/3) {
      angleZ -= max((PI/60)*speed, -PI/3);
    } else if (previousX < mouseX && angleZ <= PI/3) {
      angleZ += min((PI/60)*speed, PI/3);
    }
    previousX = mouseX;

    if (previousY < mouseY && angleX >= -PI/3) {
      angleX -= max((PI/60)*speed, -PI/3);
    } else if (previousY > mouseY && angleX <= PI/3) {
      angleX += min((PI/60)*speed, PI/3);
    }
    previousY = mouseY;
  }

  /**
   * Utility function for cheching the tilting speed bounds [0.2, 1.5]
   *
   * @return  the bounded tilting speed
   */
  public float bound(float val) {
    if (val<0.2f) {
      return 0.2f;
    } else if (val>1.5f) {
      return 1.5f;
    } else return val;
  }

  /**
   * Implements the mouse wheel action for the plane, changing the tilting speed.
   */
  public void mouseWheelPlane(MouseEvent event) {
    float e = event.getCount();
    speed = (e>0)? bound(speed+0.1f) : bound(speed-0.1f);
  }
}
/**
 * Playing mode. The user tilts the plane dragging the mouse.
 */
class PlayMode extends Mode {

  //tappa 6
  PlayMode() {
    isPaused = false;
    isPlayMode = true;

    textFont(environment.gameFont);
  } 
  /*
   * Performs the mouse dragged action of the plane.
   *
   * @see  plane.mouseDraggedPlane
   */
  public void mouseDragged() {
    if (!vidOn && !webOn && mouseY < height-scores.dataVisualisation.height) {
      plane.mouseDraggedPlane();
    }
  }

  /*
   * Performs the mouse wheel action of the plane.
   *
   * @see  plane.mouseWheelPlane
   */
  public void mouseWheel(MouseEvent event) {
    plane.mouseWheelPlane(event);
  }

  /*
   * Updates and displays the plane and the ball.
   */
  public void display() {
    environment.display();

    if (vidOn) {
      ip.update(video);
    } else if (webOn) {
      // Get camera image
      if (cam.available() == true) {
        cam.read();
      }
      PImage toUp = cam.get();
      ip.update(toUp);
    }

    pushMatrix();
    translate(width/2, height/2, 0);
    plane.display();
    ball.update();
    ball.display();
    drawCylinders();
    scores.drawScores();
    popMatrix(); 


    if (vidOn || webOn) {
      PImage toPrintSobel = ip.imgSobel;
      toPrintSobel.resize(200, 200);
      
      PImage toPrintCam;
      if (vidOn) {
        toPrintCam = video.get();
      } else {
        toPrintCam = cam.get();
      }
      toPrintCam.resize(200, 200);

      fill(0);
      rect(width-toPrintCam.width - 10, 0, toPrintCam.width + 10, toPrintCam.height + toPrintSobel.height + 10);

      image(toPrintCam, width-toPrintCam.width - 5, 5);
      image(toPrintSobel, width-toPrintSobel.width - 5, toPrintCam.height + 5);
    }
  }

  /*
   * Draws the cylinders on the plane.
   */
  public void drawCylinders() {    
    cylinder.side.setFill(cylinder.colour);
    cylinder.top.setFill(cylinder.colour);
    cylinder.bot.setFill(cylinder.colour);

    for (int j = 0; j < cylinders.size(); ++j) {
      pushMatrix();      
      rotateX(PI/2 + plane.angleX);
      rotateY(plane.angleZ);
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
      cylinder.draw();
      popMatrix();
    }
  }
}





class QuadGraph {


  List<int[]> cycles = new ArrayList<int[]>();
  int[][] graph;

  public void build(List<PVector> lines, int width, int height) {

    int n = lines.size();

    // The maximum possible number of edges is n * (n - 1)/2
    graph = new int[n * (n - 1)/2][2];

    int idx =0;

    for (int i = 0; i < lines.size(); i++) {
      for (int j = i + 1; j < lines.size(); j++) {
        if (intersect(lines.get(i), lines.get(j), width, height)) {

          // TODO
          // fill the graph using intersect() to check if two lines are
          // connected in the graph.
          graph[idx][0] = i;
          graph[idx][1] = j;

          idx++;
        }
      }
    }
  }

  /** Returns true if polar lines 1 and 2 intersect 
   * inside an area of size (width, height)
   */
  public boolean intersect(PVector line1, PVector line2, int width, int height) {

    double sin_t1 = Math.sin(line1.y);
    double sin_t2 = Math.sin(line2.y);
    double cos_t1 = Math.cos(line1.y);
    double cos_t2 = Math.cos(line2.y);
    float r1 = line1.x;
    float r2 = line2.x;

    double denom = cos_t2 * sin_t1 - cos_t1 * sin_t2;

    int x = (int) ((r2 * sin_t1 - r1 * sin_t2) / denom);
    int y = (int) ((-r2 * cos_t1 + r1 * cos_t2) / denom);

    if (0 <= x && 0 <= y && width >= x && height >= y)
      return true;
    else
      return false;
  }

  public List<int[]> findCycles() {

    cycles.clear();
    for (int i = 0; i < graph.length; i++) {
      for (int j = 0; j < graph[i].length; j++) {
        findNewCycles(new int[] {graph[i][j]});
      }
    }
    for (int[] cy : cycles) {
      String s = "" + cy[0];
      for (int i = 1; i < cy.length; i++) {
        s += "," + cy[i];
      }
      System.out.println(s);
    }
    return cycles;
  }

  public void findNewCycles(int[] path)
  {
    int n = path[0];
    int x;
    int[] sub = new int[path.length + 1];

    for (int i = 0; i < graph.length; i++)
      for (int y = 0; y <= 1; y++)
        if (graph[i][y] == n)
          //  edge refers to our current node
        {
          x = graph[i][(y + 1) % 2];
          if (!visited(x, path))
            //  neighbor node not on path yet
          {
            sub[0] = x;
            System.arraycopy(path, 0, sub, 1, path.length);
            //  explore extended path
            findNewCycles(sub);
          } else if ((path.length == 4) && (x == path[path.length - 1]))
            //  cycle found
          {
            int[] p = normalize(path);
            int[] inv = invert(p);
            if (isNew(p) && isNew(inv))
            {
              cycles.add(p);
            }
          }
        }
  }

  //  check of both arrays have same lengths and contents
  public Boolean equals(int[] a, int[] b)
  {
    Boolean ret = (a[0] == b[0]) && (a.length == b.length);

    for (int i = 1; ret && (i < a.length); i++)
    {
      if (a[i] != b[i])
      {
        ret = false;
      }
    }

    return ret;
  }

  //  create a path array with reversed order
  public int[] invert(int[] path)
  {
    int[] p = new int[path.length];

    for (int i = 0; i < path.length; i++)
    {
      p[i] = path[path.length - 1 - i];
    }

    return normalize(p);
  }

  //  rotate cycle path such that it begins with the smallest node
  public int[] normalize(int[] path)
  {
    int[] p = new int[path.length];
    int x = smallest(path);
    int n;

    System.arraycopy(path, 0, p, 0, path.length);

    while (p[0] != x)
    {
      n = p[0];
      System.arraycopy(p, 1, p, 0, p.length - 1);
      p[p.length - 1] = n;
    }

    return p;
  }

  //  compare path against known cycles
  //  return true, iff path is not a known cycle
  public Boolean isNew(int[] path)
  {
    Boolean ret = true;

    for (int[] p : cycles)
    {
      if (equals(p, path))
      {
        ret = false;
        break;
      }
    }

    return ret;
  }

  //  return the int of the array which is the smallest
  public int smallest(int[] path)
  {
    int min = path[0];

    for (int p : path)
    {
      if (p < min)
      {
        min = p;
      }
    }

    return min;
  }

  //  check if vertex n is contained in path
  public Boolean visited(int n, int[] path)
  {
    Boolean ret = false;

    for (int p : path)
    {
      if (p == n)
      {
        ret = true;
        break;
      }
    }

    return ret;
  }



  /** Check if a quad is convex or not.
   * 
   * Algo: take two adjacent edges and compute their cross-product. 
   * The sign of the z-component of all the cross-products is the 
   * same for a convex polygon.
   * 
   * See http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
   * for justification.
   * 
   * @param c1
   */
  public boolean isConvex(PVector c1, PVector c2, PVector c3, PVector c4) {

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float i1=v21.cross(v32).z;
    float i2=v32.cross(v43).z;
    float i3=v43.cross(v14).z;
    float i4=v14.cross(v21).z;

    if (   (i1>0 && i2>0 && i3>0 && i4>0) 
      || (i1<0 && i2<0 && i3<0 && i4<0))
      return true;
    else 
    System.out.println("Eliminating non-convex quad");
    return false;
  }

  /** Compute the area of a quad, and check it lays within a specific range
   */
  public boolean validArea(PVector c1, PVector c2, PVector c3, PVector c4, float max_area, float min_area) {

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float i1=v21.cross(v32).z;
    float i2=v32.cross(v43).z;
    float i3=v43.cross(v14).z;
    float i4=v14.cross(v21).z;

    float area = Math.abs(0.5f * (i1 + i2 + i3 + i4));

    //System.out.println(area);

    boolean valid = (area < max_area && area > min_area);

    if (!valid) System.out.println("Area out of range");

    return valid;
  }

  /** Compute the (cosine) of the four angles of the quad, and check they are all large enough
   * (the quad representing our board should be close to a rectangle)
   */
  public boolean nonFlatQuad(PVector c1, PVector c2, PVector c3, PVector c4) {

    // cos(70deg) ~= 0.3
    float min_cos = 0.5f;

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float cos1=Math.abs(v21.dot(v32) / (v21.mag() * v32.mag()));
    float cos2=Math.abs(v32.dot(v43) / (v32.mag() * v43.mag()));
    float cos3=Math.abs(v43.dot(v14) / (v43.mag() * v14.mag()));
    float cos4=Math.abs(v14.dot(v21) / (v14.mag() * v21.mag()));

    if (cos1 < min_cos && cos2 < min_cos && cos3 < min_cos && cos4 < min_cos)
      return true;
    else {
      System.out.println("Flat quad");
      return false;
    }
  }


  public List<PVector> sortCorners(List<PVector> quad) {

    // 1 - Sort corners so that they are ordered clockwise
    PVector a = quad.get(0);
    PVector b = quad.get(2);

    PVector center = new PVector((a.x+b.x)/2, (a.y+b.y)/2);

    Collections.sort(quad, new CWComparator(center));



    // 2 - Sort by upper left most corner
    PVector origin = new PVector(0, 0);
    float distToOrigin = 1000;

    for (PVector p : quad) {
      if (p.dist(origin) < distToOrigin) distToOrigin = p.dist(origin);
    }

    while (quad.get(0).dist(origin) != distToOrigin)
      Collections.rotate(quad, 1);


    return quad;
  }
}


class CWComparator implements Comparator<PVector> {
  PVector center;
  public CWComparator(PVector center) {
    this.center = center;
  }

  @Override
    public int compare(PVector b, PVector d) {
    if (Math.atan2(b.y-center.y, b.x-center.x)<Math.atan2(d.y-center.y, d.x-center.x))
      return -1;
    else return 1;
  }
}


class ScoreInterface {
  //tappa 6
  PGraphics dataVisualisation;
  PGraphics topView;
  PGraphics scoreboard;
  PGraphics barChart;

  float totalScore;
  float lastScore;

  ArrayList<Float> scoreChart;
  float scorePadding;
  float scoreBox;
  float scrollScale;
  int timeCounter;

  HScrollbar scrollbar;

  ScoreInterface() {
    dataVisualisation = createGraphics(width, 150, P2D);
    topView = createGraphics(140, 140, P2D);
    scoreboard = createGraphics(100, 140, P2D);
    barChart = createGraphics(width - topView.width - scoreboard.width - 20, 125, P2D);

    totalScore = 0;
    lastScore = 0;

    scoreChart = new ArrayList<Float>();
    scorePadding = 10;
    scoreBox = 5;
    scrollScale = 1;
    timeCounter = 30;

    scrollbar = new HScrollbar(15 + topView.width + scoreboard.width, height - 15, barChart.width, 10);
  }

  public void drawScores() {
    drawData();
    image(dataVisualisation, -width/2, height/2 - dataVisualisation.height);

    drawTopView();
    image(topView, 5 - width/2, height/2 - dataVisualisation.height + 5);

    drawScoreboard();
    image(scoreboard, - width/2+ 10 + topView.width, height/2 - dataVisualisation.height + 5);

    drawBarChart();
    image(barChart, - width/2+ 15 + topView.width + scoreboard.width, height/2 - dataVisualisation.height + 5);

    scrollbar.update();
    scrollbar.display();
  }

  public void drawData() {
    dataVisualisation.beginDraw();
    dataVisualisation.background(255);
    dataVisualisation.endDraw();
  }

  public void drawTopView() {
    topView.beginDraw();
    topView.translate(topView.width/2, topView.height/2);
    topView.background(0, 153, 0);
    //Draw the Ball
    topView.fill(ball.colour);
    topView.ellipse(mapC(ball.location.x), mapC(ball.location.z), 2*mapC(ball.r), 2*mapC(ball.r));
    //Draw Cylinders
    topView.fill(cylinder.colour);
    for (int i = 0; i < cylinders.size(); ++i) {
      topView.ellipse(mapC(cylinders.get(i).x), mapC(cylinders.get(i).y), 2*mapC(cylinder.c_radius), 2*mapC(cylinder.c_radius));
    }
    topView.endDraw();
  }

  public void drawScoreboard() {
    scoreboard.beginDraw();
    scoreboard.background(0);
    scoreboard.fill(255);
    scoreboard.text("Total Score:", 10, 20);
    scoreboard.text(totalScore, 15, 35);
    scoreboard.text("Velocity:", 10, 60);
    scoreboard.text(ball.velocity.mag(), 15, 75);
    scoreboard.text("Last Score:", 10, 100);
    scoreboard.text(lastScore, 15, 115);
    scoreboard.endDraw();
  }

  public float mapC(float coord) {
    return map(coord, -plane.boardEdge/2, plane.boardEdge/2, -topView.width/2, topView.width/2);
  }

  public void drawBarChart() {
    barChart.beginDraw();
    barChart.background(0);
    if (!currentMode.isPaused) {
      --timeCounter; 
      if (timeCounter == 0) {
        timeCounter = 10;
        scoreChart.add(totalScore);
      }
    }

    scrollScale = scrollbar.getPos() + 0.5f;

    barChart.fill(0, 200, 0);
    for (int i = 0; i<scoreChart.size(); ++i) {
      for (int j = 0; j<scoreChart.get(i)/scorePadding; ++j) {
        barChart.rect(i*(scoreBox*scrollScale), barChart.height - j*scoreBox, scoreBox*scrollScale, scoreBox);
      }
    }

    barChart.endDraw();
  }
}





class TwoDThreeD {

  // default focal length, well suited for most webcams
  float f = 700;

  // intrisic camera matrix
  float [][] K = {{f, 0, 0}, 
    {0, f, 0}, 
    {0, 0, 1}};

  // Real physical coordinates of the Lego board in mm
  float boardSize = 380.f; // large Duplo board
  //float boardSize = 255.f; // smaller Lego board

  // the 3D coordinates of the physical board corners, clockwise
  float [][] physicalCorners = {
    // TODO:
    // Store here the 3D coordinates of the corners of
    // the real Lego board, in homogenous coordinates
    // and clockwise.
    {-boardSize/2, -boardSize/2, 0, 1}, 
    {boardSize/2, -boardSize/2, 0, 1}, 
    {boardSize/2, boardSize/2, 0, 1}, 
    {-boardSize/2, boardSize/2, 0, 1}
  };

  public TwoDThreeD(int width, int height) {

    // set the offset to the center of the webcam image
    K[0][2] = 0.5f * width;
    K[1][2] = 0.5f * height;
  }

  public PVector get3DRotations(List<PVector> points2D) {

    // 1- Solve the extrinsic matrix from the projected 2D points
    double[][] E = solveExtrinsicMatrix(points2D);


    // 2 - Re-build a proper 3x3 rotation matrix from the camera's 
    //     extrinsic matrix E
    float[] firstColumn = {(float)E[0][0], 
      (float)E[1][0], 
      (float)E[2][0]};
    firstColumn = Mat.multiply(firstColumn, 1/Mat.norm2(firstColumn)); // normalize

    float[] secondColumn={(float)E[0][1], 
      (float)E[1][1], 
      (float)E[2][1]};
    secondColumn = Mat.multiply(secondColumn, 1/Mat.norm2(secondColumn)); // normalize

    float[] thirdColumn = Mat.cross(firstColumn, secondColumn);

    float[][] rotationMatrix = {
      {firstColumn[0], secondColumn[0], thirdColumn[0]}, 
      {firstColumn[1], secondColumn[1], thirdColumn[1]}, 
      {firstColumn[2], secondColumn[2], thirdColumn[2]}
    };

    // 3 - Computes and returns Euler angles (rx, ry, rz) from this matrix
    return rotationFromMatrix(rotationMatrix);
  }


  public double[][] solveExtrinsicMatrix(List<PVector> points2D) {

    // p ~= K \u00b7 [R|t] \u00b7 P
    // with P the (3D) corners of the physical board, p the (2D) 
    // projected points onto the webcam image, K the intrinsic 
    // matrix and R and t the rotation and translation we want to 
    // compute.
    //
    // => We want to solve: (K^(-1) \u00b7 p) X ([R|t] \u00b7 P) = 0

    float [][] invK = Mat.inverse(K);

    float[][] projectedCorners = new float[4][3];

    for (int i=0; i<4; i++) {
      // TODO:
      // store in projectedCorners the result of (K^(-1) \u00b7 p), for each 
      // corner p found in the webcam image.
      // You can use Mat.multiply to multiply a matrix with a vector.
      
      float[] p = { points2D.get(i).x, points2D.get(i).y, 1 };
      projectedCorners[i] = Mat.multiply(invK, p);
    }

    // 'A' contains the cross-product (K^(-1) \u00b7 p) X P
    float[][] A= new float[12][9];

    for (int i=0; i<4; i++) {
      A[i*3][0]=0;
      A[i*3][1]=0;
      A[i*3][2]=0;

      // note that we take physicalCorners[0,1,*3*]: we drop the Z
      // coordinate and use the 2D homogenous coordinates of the physical
      // corners
      A[i*3][3]=-projectedCorners[i][2] * physicalCorners[i][0];
      A[i*3][4]=-projectedCorners[i][2] * physicalCorners[i][1];
      A[i*3][5]=-projectedCorners[i][2] * physicalCorners[i][3];

      A[i*3][6]= projectedCorners[i][1] * physicalCorners[i][0];
      A[i*3][7]= projectedCorners[i][1] * physicalCorners[i][1];
      A[i*3][8]= projectedCorners[i][1] * physicalCorners[i][3];

      A[i*3+1][0]= projectedCorners[i][2] * physicalCorners[i][0];
      A[i*3+1][1]= projectedCorners[i][2] * physicalCorners[i][1];
      A[i*3+1][2]= projectedCorners[i][2] * physicalCorners[i][3];

      A[i*3+1][3]=0;
      A[i*3+1][4]=0;
      A[i*3+1][5]=0;

      A[i*3+1][6]=-projectedCorners[i][0] * physicalCorners[i][0];
      A[i*3+1][7]=-projectedCorners[i][0] * physicalCorners[i][1];
      A[i*3+1][8]=-projectedCorners[i][0] * physicalCorners[i][3];

      A[i*3+2][0]=-projectedCorners[i][1] * physicalCorners[i][0];
      A[i*3+2][1]=-projectedCorners[i][1] * physicalCorners[i][1];
      A[i*3+2][2]=-projectedCorners[i][1] * physicalCorners[i][3];

      A[i*3+2][3]= projectedCorners[i][0] * physicalCorners[i][0];
      A[i*3+2][4]= projectedCorners[i][0] * physicalCorners[i][1];
      A[i*3+2][5]= projectedCorners[i][0] * physicalCorners[i][3];

      A[i*3+2][6]=0;
      A[i*3+2][7]=0;
      A[i*3+2][8]=0;
    }

    SVD svd=new SVD(A);

    double[][] V = svd.getV();

    double[][] E = new double[3][3];

    //E is the last column of V
    for (int i=0; i<9; i++) {
      E[i/3][i%3] = V[i][V.length-1] / V[8][V.length-1];
    }

    return E;
  }

  public PVector rotationFromMatrix(float[][]  mat) {

    // Assuming rotation order is around x,y,z
    PVector rot = new PVector();

    if (mat[1][0] > 0.998f) { // singularity at north pole
      rot.z = 0;
      float delta = (float) Math.atan2(mat[0][1], mat[0][2]);
      rot.y = -(float) Math.PI/2;
      rot.x = -rot.z + delta;
      return rot;
    }

    if (mat[1][0] < -0.998f) { // singularity at south pole
      rot.z = 0;
      float delta = (float) Math.atan2(mat[0][1], mat[0][2]);
      rot.y = (float) Math.PI/2;
      rot.x = rot.z + delta;
      return rot;
    }

    rot.y =-(float)Math.asin(mat[2][0]);
    rot.x = (float)Math.atan2(mat[2][1]/Math.cos(rot.y), mat[2][2]/Math.cos(rot.y));
    rot.z = (float)Math.atan2(mat[1][0]/Math.cos(rot.y), mat[0][0]/Math.cos(rot.y));

    return rot;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TangibleGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
