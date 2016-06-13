/**
 * Represents a game mode.
 */
abstract class Mode {
  //tappa 6
  boolean isPaused;
    
  /*
   * Draws the plane and the ball.
   */
  abstract void display();
  
  /*
   * Implements the mouse dragged action for the mode.
   */
  void mouseDragged(){}
  
  /*
   * Implements the mouse pressed action for the mode.
   */
  void mousePressed(){}

  /*
   * Implements the mouse wheel action for the mode.
   */
  void mouseWheel(MouseEvent event){}

  /*
   * Draws the cylinders on the plane.
   */
  abstract void drawCylinders();
  
}