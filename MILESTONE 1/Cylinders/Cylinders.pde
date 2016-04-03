float cylinderBaseSize = 50;
float cylinderHeight = 50;
int cylinderResolution = 40;
PShape openCylinder = new PShape();
PShape cylinderTop = new PShape();
PShape cylinderBot = new PShape();
void settings() {
  size(400, 400, P3D);
}
void setup() {
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  cylinderTop = createShape();
  cylinderTop.beginShape(TRIANGLE_FAN);
  cylinderBot = createShape();
  cylinderBot.beginShape(TRIANGLE_FAN);
  cylinderTop.vertex(0, 0, 0);
  cylinderBot.vertex(0, 0, cylinderHeight);
  //draw the border of the cylinder
  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
    cylinderTop.vertex(x[i], y[i], 0)
    cylinderBot.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();
  cylinderTop.endShape();
  cylinderBot.endShape();
}
void draw() {
  background(255);
  translate(mouseX, mouseY, 0);
  shape(openCylinder);
  shape(cylinderTop);
  shape(cylinderBot);
}