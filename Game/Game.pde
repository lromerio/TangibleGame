void settings() {
size(800, 800, P3D);
}
void setup() {
noStroke();
}

float angleX = 0;
float angleZ = 0;

float previousY = mouseY;
float previousX = mouseX;

float speed = 1;

void draw() {
background(0, 255, 255);
lights();

translate(width/2, height/2, 0);
rotateX(angleX);
rotateZ(angleZ);
box(200, 10, 200);
translate(100, 0, 0);
}


void mouseDragged() 
{
  if (previousX > mouseX && angleZ >= -PI/3){
    angleZ -= max((PI/60)*speed, -PI/3);
  }
  else if (previousX < mouseX && angleZ <= PI/3){
    angleZ += min((PI/60)*speed, PI/3);
  }
  previousX = mouseX;
 
    if (previousY < mouseY && angleX >= -PI/3){
    angleX -= max((PI/60)*speed, -PI/3);
  }
  else if (previousY > mouseY && angleX <= PI/3){
    angleX += min((PI/60)*speed, PI/3);
  }
  previousY = mouseY;
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  print(e);
  speed = (e>0)? speed*1.1 : speed*0.9;  
}