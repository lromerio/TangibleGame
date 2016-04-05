
abstract class Mode {
  
  abstract void display();
  
  void mouseDragged();
  
  void mousePressed();
  
  void mouseWheel(MouseEvent event);

  void drawCylinders() {    
    cylinder.side.setFill(color(255, 102, 102));
    cylinder.top.setFill(color(255, 102, 102));
    cylinder.bot.setFill(color(255, 102, 102));

    for (int j = 0; j < cylinders.size(); ++j) {
      pushMatrix();      
      if(currentMode == Modes.PLAY) {
        rotateX(PI/2 + plane.angleX);
        rotateY(plane.angleZ);
      }
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
      cylinder.draw();
      popMatrix();
    }
  }
}