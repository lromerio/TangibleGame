
class PlayMode extends Mode {

  void mouseDragged() {
    plane.mouseDraggedPlane();
  }

  void mousePressed() {
     modeManager.addCylinder();
  }

  void mouseWheel(MouseEvent event) {
     plane.mouseWheelPlane(event);
  }

  void display() {
    plane.display();
    ball.update();
    ball.display();
  }
}