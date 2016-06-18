/**
 * Playing mode. The user tilts the plane dragging the mouse.
 */
class PlayMode extends Mode {

  //tappa 6
  PlayMode() {
    isPaused = false;
    isPlayMode = true;

    textFont(environment.gameFont);
  } 
  /*
   * Performs the mouse dragged action of the plane.
   *
   * @see  plane.mouseDraggedPlane
   */
  void mouseDragged() {
    if (!vidOn && !webOn && mouseY < height-scores.dataVisualisation.height) {
      plane.mouseDraggedPlane();
    }
  }

  /*
   * Performs the mouse wheel action of the plane.
   *
   * @see  plane.mouseWheelPlane
   */
  void mouseWheel(MouseEvent event) {
    plane.mouseWheelPlane(event);
  }

  /*
   * Updates and displays the plane and the ball.
   */
  void display() {
    environment.display();

    if (vidOn) {
      ip.update(video);
    } else if (webOn) {
      // Get camera image
      if (cam.available() == true) {
        cam.read();
      }
      ip.update(cam.get());
    }

    pushMatrix();
    translate(width/2, height/2, 0);
    plane.display();
    ball.update();
    ball.display();
    drawCylinders();
    scores.drawScores();
    popMatrix(); 


    if (vidOn || webOn) {
      PImage toPrintSobel = ip.imgSobel;
      toPrintSobel.resize(200, 200);
      
      PImage toPrintCam;
      if (vidOn) {
        toPrintCam = video.get();
      } else {
        toPrintCam = cam.get();
      }
      toPrintCam.resize(200, 200);

      fill(0);
      rect(width-toPrintCam.width - 10, 0, toPrintCam.width + 10, toPrintCam.height + toPrintSobel.height + 10);

      image(toPrintCam, width-toPrintCam.width - 5, 5);
      image(toPrintSobel, width-toPrintSobel.width - 5, toPrintCam.height + 5);
    }
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
      rotateX(PI/2 + plane.angleX);
      rotateY(plane.angleZ);
      translate(cylinders.get(j).x, cylinders.get(j).y, cylinders.get(j).z);
      cylinder.draw();
      popMatrix();
    }
  }
}