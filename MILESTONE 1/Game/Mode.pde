
class Mode {

  void highView() {
    pushMatrix();
    rotateX(PI/2);
    beginShape();
    texture(plane.plateImg);
    vertex(- plane.boardEdge/2, -plane.boardThick/2, -plane.boardEdge/2, 0, 0);
    vertex(- plane.boardEdge/2, -plane.boardThick/2, plane.boardEdge/2, 0, 450);
    vertex(plane.boardEdge/2, -plane.boardThick/2, plane.boardEdge/2, 450, 450);
    vertex(plane.boardEdge/2, -plane.boardThick/2, -plane.boardEdge/2, 450, 0);
    endShape(CLOSE);
    translate(ball.location.x, plane.boardThick/2 + ball.r, - ball.location.z);
    fill(255, 102, 102);
    sphere(ball.r);

    popMatrix();
  }

  void addCylinder() {

    int x = mouseX - width/2;
    int y = mouseY - height/2;

    if ( (x <= plane.boardEdge/2 - cylinderBaseSize) && (x >= -plane.boardEdge/2 + cylinderBaseSize) &&
      (y <= plane.boardEdge/2 - cylinderBaseSize) && (y >= -plane.boardEdge/2 + cylinderBaseSize)) {
      PVector cylCenter = new PVector(x, y, plane.boardThick/2);
      if(checkCylindersPosition(cylCenter)) {
        cylinders.add(cylCenter);
      }
    }
  }
  
  boolean checkCylindersPosition(PVector center) { 
    if( dist(center.x, center.y, ball.location.x, ball.location.y) <= cylinderBaseSize + ball.r) {
      return false;
    }
    
    for( int i = 0; i < cylinders.size(); ++i) {
       if( dist(center.x, center.y, cylinders.get(i).x, cylinders.get(i).y) <= 2*cylinderBaseSize) {
         return false;
       }
    }
    return true;
  }

  void drawCylinders() {
    
    openCylinder.setFill(color(255, 102, 102));
    cylinderTop.setFill(color(255, 102, 102));
    cylinderBot.setFill(color(255, 102, 102));

    for (int j = 0; j < cylinders.size(); ++j) {
      pushMatrix();
      
      if(currentMode == Modes.PLAY) {
        rotateX(PI/2 + plane.angleX);
        rotateY(plane.angleZ);
      }
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
     
      
      shape(openCylinder);
      shape(cylinderTop);
      shape(cylinderBot);
      popMatrix();
    }
  }

  float cylinderBaseSize = 30;
  float cylinderHeight = 30;
  int cylinderResolution = 40;
  PShape openCylinder = new PShape();
  PShape cylinderTop = new PShape();
  PShape cylinderBot = new PShape();


  void createCylinder() {
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
      cylinderTop.vertex(x[i], y[i], 0);
      cylinderBot.vertex(x[i], y[i], cylinderHeight);
    }
    openCylinder.endShape();
    cylinderTop.endShape();
    cylinderBot.endShape();
  }
}