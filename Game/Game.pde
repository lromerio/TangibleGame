void settings() {
  size(700, 700, P3D);
}

void setup() {
  noStroke();
}

float rotX = 0;
float rotZ = 0;
float previousX = mouseX;
float previousY = mouseY;

void draw() {
  background(0, 0, 200);
  lights();
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateZ(rotZ);
  box(250, 15, 250);
  //translate(100, 0, 0);
}

void mouseDragged() 
{
  if (previousX > mouseX && rotZ >= -PI/3){
    rotZ -= PI/60;
  }
  else if (previousX < mouseX && rotZ <= PI/3){
    rotZ += PI/60;
  }
  previousX = mouseX;
  
    if (previousY < mouseY && rotX >= -PI/3){
    rotX -= PI/60;
  }
  else if (previousY > mouseY && rotX <= PI/3){
    rotX += PI/60;
  }
  previousY = mouseY;
}