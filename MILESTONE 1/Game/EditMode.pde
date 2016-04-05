

class EditMode extends Mode {
  
  void mousePressed() {
    addCylinder();
  }
  
 void display() {
  highView();
 }
  
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

    if ( (x <= plane.boardEdge/2 - cylinder.c_radius) && (x >= -plane.boardEdge/2 + cylinder.c_radius) &&
      (y <= plane.boardEdge/2 - cylinder.c_radius) && (y >= -plane.boardEdge/2 + cylinder.c_radius)) {
      PVector cylCenter = new PVector(x, y, plane.boardThick/2);
      if(checkCylindersPosition(cylCenter)) {
        cylinders.add(cylCenter);
      }
    }
  }
  
  boolean checkCylindersPosition(PVector center) { 
    if( dist(center.x, center.y, ball.location.x, ball.location.y) <= cylinder.c_radius + ball.r) {
      return false;
    }
    
    for( int i = 0; i < cylinders.size(); ++i) {
       if( dist(center.x, center.y, cylinders.get(i).x, cylinders.get(i).y) <= 2*cylinder.c_radius) {
         return false;
       }
    }
    return true;
  }
  
    void drawCylinders() {    
    cylinder.side.setFill(color(255, 102, 102));
    cylinder.top.setFill(color(255, 102, 102));
    cylinder.bot.setFill(color(255, 102, 102));

    for (int j = 0; j < cylinders.size(); ++j) {
      pushMatrix();      
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
      cylinder.draw();
      popMatrix();
    }
  }
  
}