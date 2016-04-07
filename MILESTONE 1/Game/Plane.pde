/**
 *  Represents the plane.
 *  
 *  @previousX   last x coordinate of the mouse.
 *  @previousY   last y coordinate of the mouse.
 *  @angleX      x angle of the inclination.
 *  @angleZ      z angle of the inclination.
 *  @speed       speed of the tilting movement.
 *  @boardEdge   lenght of the edge.
 *  @boardThick  thickness of the plane.
 *  @plateImg    image on top/bot.
 *  @sideImg     image on the side.
 */
class Plane {
  
//_______________________________________________________________
//Attributes
    float previousX;
    float previousY;
    float angleX;
    float angleZ;
    float speed;
    float boardEdge;
    float boardThick;
    PImage plateImg;
    PImage sideImg;

//_______________________________________________________________
//Basic Function
  Plane(float boardEdge, float boardThick) {
    previousX = mouseX;
    previousY = mouseY;
    angleX = 0;
    angleZ = 0;
    speed = 1;
    this.boardEdge = boardEdge;
    this.boardThick = boardThick;
    plateImg = loadImage("PlateTexture2.jpg");
    sideImg = loadImage("SideTxt2.jpg");
  }
  
  void display() {
    pushMatrix();
    rotateX(angleX);
    rotateZ(angleZ);
    drawTextures();
    popMatrix();
  }

//_______________________________________________________________
//Control
  void mouseDraggedPlane() {
    if (previousX > mouseX && angleZ >= -PI/3) {
      angleZ -= max((PI/60)*speed, -PI/3);
    } else if (previousX < mouseX && angleZ <= PI/3) {
      angleZ += min((PI/60)*speed, PI/3);
    }
    previousX = mouseX;

    if (previousY < mouseY && angleX >= -PI/3) {
      angleX -= max((PI/60)*speed, -PI/3);
    } else if (previousY > mouseY && angleX <= PI/3) {
      angleX += min((PI/60)*speed, PI/3);
    }
    previousY = mouseY;
  }

  float bound(float val) {
    if (val<0.2) {
      return 0.2;
    } else if (val>1.5) {
      return 1.5;
    } else return val;
  }

  void mouseWheelPlane(MouseEvent event) {
    float e = event.getCount();
    speed = (e>0)? bound(speed+0.1) : bound(speed-0.1);
  }

//_______________________________________________________________
//Gaphic
  void drawTextures() {
      fill(255, 255, 255);
      textureMode(IMAGE);
      
    //upper
      beginShape();
      texture(plateImg);
      vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 0);
      vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 450);
      vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 450);
      vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 0);
      endShape(CLOSE);

    //bottom
      textureMode(IMAGE);
      beginShape();
      texture(plateImg);
      vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 450);
      vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 450);
      vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 450);
      vertex(boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      endShape(CLOSE);

    //sides
      textureMode(IMAGE);
      beginShape();
      texture(sideImg);
      vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
      vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
      vertex(boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      endShape(CLOSE);

      beginShape();
      textureMode(IMAGE);
      texture(sideImg);
      vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
      vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      endShape(CLOSE);

      textureMode(IMAGE);
      beginShape();
      texture(sideImg);
      vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
      vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
      vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      endShape(CLOSE);

      textureMode(IMAGE);
      beginShape();
      texture(sideImg);
      vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
      vertex(boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
      vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
      endShape(CLOSE);
  }
}