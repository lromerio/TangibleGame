/**
 * Represents a game mode.
 */
abstract class Mode {
  
  abstract void display();
  
  void mouseDragged(){}
  
  void mousePressed(){}
  
  void mouseWheel(MouseEvent event){}

  abstract void drawCylinders();
  
}