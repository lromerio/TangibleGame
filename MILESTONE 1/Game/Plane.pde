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
    PShape upper;
    PShape bottom;
    PShape side1;
    PShape side2;
    PShape side3;
    PShape side4;

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
    
    upper = createShape();
      upper.beginShape();
      upper.texture(plateImg);
      upper.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 0);
      upper.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 450);
      upper.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 450);
      upper.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 0);
      upper.endShape();
    
     bottom = createShape();
      bottom.beginShape();
      bottom.texture(plateImg);
      bottom.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      bottom.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 450);
      bottom.vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 450);
      bottom.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      bottom.endShape();

      side1 = createShape();
      side1.beginShape();
      side1.texture(sideImg);
      side1.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      side1.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
      side1.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      side1.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      side1.endShape();

      side2 = createShape();
      side2.beginShape();
      side2.texture(sideImg);
      side2.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      side2.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
      side2.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      side2.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      side2.endShape();
      
      side3 = createShape();
      side3.beginShape();
      side3.texture(sideImg);
      side3.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
      side3.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
      side3.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      side3.vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      side3.endShape();
      
      side4 = createShape();
      side4.beginShape();
      side4.texture(sideImg);
      side4.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      side4.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
      side4.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
      side4.vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
      side4.endShape();

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
      shape(upper);
      shape(bottom);
      shape(side1);
      shape(side2);
      shape(side3);
      shape(side4);
  }
}