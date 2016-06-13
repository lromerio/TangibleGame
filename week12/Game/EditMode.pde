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
  void mousePressed() {
    addCylinder();
  }

  /*
   * Draws the current state of the plane by calling highView,
   * and a cylinder centered at the current postion of the mouse.
   *
   * @see  highView
   */
  void display() {
    environment.display();
    pushMatrix();
    translate(width/2, height/2, 0);
    highView();

    //BONUS
    //Shows a cylinder centered at the current postion of the mouse, 
    //green if it's a valid position for a new cylinder, red if not.
    PVector mousePos = new PVector(mouseX - width/2, mouseY - height/2, plane.boardThick/2);
    color c;
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
  void highView() {
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
  void addCylinder() {

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
  boolean checkCylindersPosition(PVector center) { 
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
  void drawCylinders() {
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