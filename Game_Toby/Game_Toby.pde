
void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
}

//***VARIABLES DECLARATION***//
float depth = 200;
float rx = 0;
float rz = 0;
float speed = 1;
//***************************//

void draw() {
  background(96, 96, 96);
  directionalLight(229, 255, 204, 0, 0, -1);
  ambientLight(102, 102, 102);
  translate(width/2, height/2, 0);
  rotateX(rx);
  rotateZ(rz);
  fill(0, 255, 0);
  box(500, 20, 500);
}

void mouseWheel(MouseEvent wheel) {
  if (speed - wheel.getCount()/10.0 >= 0.2 && speed - wheel.getCount()/10.0 <= 1.5) {
    speed -= wheel.getCount()/10.0;
  } else {
    if (speed - wheel.getCount()/10.0 < 0.2) {
      speed = 0.2;
    }
    if (speed - wheel.getCount()/10.0 > 1.5) {
      speed = 1.5;
    }
  }
}

//DUBBIO: pmouseX e pmouseY magari non fanno esattamente quello che ci serve! per quello il mio si muove di merda

void mouseDragged() {

  if (pmouseY < mouseY) {
    if (rx - PI*speed/180 > -PI/3) rx -= PI*speed/180;
    else rx = -PI/3;
  } else {
    if (rx + PI*speed/180 < PI/3)  rx += PI*speed/180;
    else rx = PI/3;
  }

  if (pmouseX < mouseX) {
    if (rz + PI*speed/180 < PI/3) rz += PI*speed/180;
    else rz = PI/3;
  } else {
    if (rz - PI*speed/180 > -PI/3) rz -= PI*speed/180;
    else rz = -PI/3;
  }
}

//Vostra versione nel mio ---> worka meglio, quindi magri meglio non usare pmouse

/*void mouseDragged() 
{
  if (pmouseX > mouseX && rz >= -PI/3) {
    rz -= max((PI/60)*speed, -PI/3);               //scrivendo così, sottraggo il max tra i due dal valore dell'angolo?
  } else if (pmouseX < mouseX && rz <= PI/3) {     //perché dovrei voler sottrarre -PI/3?
    rz += min((PI/60)*speed, PI/3);
  }
  //previousX = mouseX;

  if (pmouseY < mouseY && rx >= -PI/3) {
    rx -= max((PI/60)*speed, -PI/3);
  } else if (pmouseY > mouseY && rx <= PI/3) {
    rx += min((PI/60)*speed, PI/3);
  }
  //previousY = mouseY;
}*/