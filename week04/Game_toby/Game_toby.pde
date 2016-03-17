import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

void settings() {
  fullScreen(P3D);
}
void setup() {
  minim = new Minim(this);
  player = minim.loadFile("StarWarsTheme.mp3");
  player.play();
  backgroundImg = loadImage("StarWarsBg.jpg");
  backgroundImg.resize(displayWidth, displayHeight);
  plateImg = loadImage("PlateTexture2.jpg");
  sideImg = loadImage("SideTxt2.jpg");
  f = createFont("Starjedi.ttf", 16, true);
  noStroke();
  //center = new PVector(width/2, height/2, 0);
  ball = new Ball(20);
}

//Variables
float angleX = 0;
float angleZ = 0;
float speed = 1;

PImage backgroundImg;
PImage plateImg;
PImage sideImg;
Minim minim;
AudioPlayer player;
PFont f;
//Mouse coordinates
float previousY = mouseY;
float previousX = mouseX;

float boardEdge = 450;
float boardThick = 20;

Ball ball;
PVector center;



void draw() {
  starWarsThemed();
  directionalLight(229, 255, 204, 0, 1, -1);
  ambientLight(102, 102, 102);
  translate(width/2, height/2, 0);
  rotateX(angleX);
  rotateZ(angleZ);
  fill(64, 64, 64);
  box(boardEdge, boardThick, boardEdge);
  drawTextures();

  ball.update();
  ball.display();
}

void drawTextures() {
  fill(255, 255, 255);
  textureMode(IMAGE);
//upper
  beginShape();
  texture(plateImg);
  vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 0);
  vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 450);
  vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 450);
  vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 0);
  endShape(CLOSE);
  
//bottom
  textureMode(IMAGE);
  beginShape();
  texture(plateImg);
  vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 450);
  vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 450);
  vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 450);
  vertex(boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
  endShape(CLOSE);
  
//sides
  textureMode(IMAGE);
  beginShape();
  texture(sideImg);
  vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
  vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
  vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
  vertex(boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
  endShape(CLOSE);
  
  beginShape();
  textureMode(IMAGE);
  texture(sideImg);
  vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
  vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
  vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
  vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
  endShape(CLOSE);
  
  textureMode(IMAGE);
  beginShape();
  texture(sideImg);
  vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
  vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
  vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
  vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
  endShape(CLOSE);
  
  textureMode(IMAGE);
  beginShape();
  texture(sideImg);
  vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
  vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
  vertex(boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
  vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
  endShape(CLOSE);
}

void starWarsThemed() {
  background(backgroundImg);
  textFont(f,20);
  fill(255, 255, 255);
  textAlign(LEFT);
  text("Rotation x : \t\t" + degrees(angleX), 20, 20);
  text("Rotation z : \t\t" + degrees(angleZ), 20, 40);
  text("Speed : \t\t" + speed, 20, 60);
  textFont(f, 80);
  textAlign(CENTER);
  text("Jedi Mind Tricks", width/2, height - 50);
}

void mouseDragged() 
{
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

float bound(float val) {
  if (val<0.2) {
    return 0.2;
  } else if (val>1.5) {
    return 1.5;
  } else return val;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speed = (e>0)? bound(speed+0.1) : bound(speed-0.1);
}