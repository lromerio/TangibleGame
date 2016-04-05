
class PlayMode extends Mode {

  void mouseDragged() {
    plane.mouseDraggedPlane();
  }


  void mouseWheel(MouseEvent event) {
    plane.mouseWheelPlane(event);
  }

  void display() {
    plane.display();
    ball.update();
    ball.display();
  }

  void drawCylinders() {    
    cylinder.side.setFill(color(255, 102, 102));
    cylinder.top.setFill(color(255, 102, 102));
    cylinder.bot.setFill(color(255, 102, 102));

    for (int j = 0; j < cylinders.size(); ++j) {
      pushMatrix();      
      rotateX(PI/2 + plane.angleX);
      rotateY(plane.angleZ);
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
      cylinder.draw();
      popMatrix();
    }
  }
}