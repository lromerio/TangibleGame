/**
 *  Represents the plane keeping track of the dimensions, its angles and speed of tilting and additionally some textures
 *  
 *  @previousX   last x coordinate of the mouse.
 *  @previousY   last y coordinate of the mouse.
 *  @angleX      x angle of the inclination.
 *  @angleZ      z angle of the inclination.
 *  @speed       speed of the tilting movement.
 *  @boardEdge   lenght of the edge.
 *  @boardThick  thickness of the plane.
 *  @plateImg    image on top/bot.
 *  @upper       the top of the plane, where the game actually takes place
 *  @bottom      the bottom of the plane
 *  @side1       the left side of the plane
 *  @side2       the back side of the plane
 *  @side3       the front side of the plane
 *  @side4       the right side of the plane
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
    
    //the plane is not implemented by a single box but rather with 6 PShapes, so that it's possible to add different textures to each side
    PShape upper;
    PShape bottom;
    PShape side1;
    PShape side2;
    PShape side3;
    PShape side4;

//_______________________________________________________________
//Basic Function

  /**
   * Initializes all attributes of the plane, loads textures and creates the shapes of each face.
   *
   * @param  boardEdge    the desired length of the sides
   * @param  boardThick   the desired thickness of the plane
   */
  Plane(float boardEdge, float boardThick) {
    
    //For tilting the plane
    previousX = mouseX;
    previousY = mouseY;
    angleX = 0;
    angleZ = 0;
    speed = 1;
    
    //Dimensions
    this.boardEdge = boardEdge;
    this.boardThick = boardThick;
    
    //BONUS
    //Star Wars themed textures (http://www.moddb.com/games/star-wars-jedi-knight-ii respectively)
    plateImg = loadImage("PlateTexture2.jpg");
    sideImg = loadImage("SideTxt2.jpg");
    
    //Top side
    upper = createShape();
      upper.beginShape();
      upper.texture(plateImg);
      upper.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 0);
      upper.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 450);
      upper.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 450);
      upper.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 0);
      upper.endShape();
    
    //Bottom side
    bottom = createShape();
      bottom.beginShape();
      //BONUS
      //texture
      bottom.texture(plateImg);
      bottom.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      bottom.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 450);
      bottom.vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 450);
      bottom.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      bottom.endShape();

      //Left side
      side1 = createShape();
      side1.beginShape();
      //BONUS
      //texture
      side1.texture(sideImg);
      side1.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      side1.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
      side1.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      side1.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      side1.endShape();

      //Back side
      side2 = createShape();
      side2.beginShape();
      //BONUS
      //texture
      side2.texture(sideImg);
      side2.vertex(- boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      side2.vertex(- boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
      side2.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 0, 20);
      side2.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 0, 0);
      side2.endShape();
      
      //Front side
      side3 = createShape();
      side3.beginShape();
      //BONUS
      //texture
      side3.texture(sideImg);
      side3.vertex(- boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
      side3.vertex(- boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
      side3.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 450, 20);
      side3.vertex(boardEdge/2, boardThick/2, boardEdge/2, 450, 0);
      side3.endShape();
      
      //Right side
      side4 = createShape();
      side4.beginShape();
      //BONUS
      //texture
      side4.texture(sideImg);
      side4.vertex(boardEdge/2, boardThick/2, -boardEdge/2, 450, 0);
      side4.vertex(boardEdge/2, -boardThick/2, -boardEdge/2, 450, 20);
      side4.vertex(boardEdge/2, -boardThick/2, boardEdge/2, 0, 20);
      side4.vertex(boardEdge/2, boardThick/2, boardEdge/2, 0, 0);
      side4.endShape();

  }
  
  /**
   * Displays the plane
   */
  void display() {
    pushMatrix();
    rotateX(angleX);
    rotateZ(angleZ);
    shape(upper);
    shape(bottom);
    shape(side1);
    shape(side2);
    shape(side3);
    shape(side4);
    popMatrix();
  }

//_______________________________________________________________
//Control

  /**
   * Implements the mouse dragged action for the plane, tilting it.
   */
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

  /**
   * Utility function for cheching the tilting speed bounds [0.2, 1.5]
   *
   * @return  the bounded tilting speed
   */
  float bound(float val) {
    if (val<0.2) {
      return 0.2;
    } else if (val>1.5) {
      return 1.5;
    } else return val;
  }

  /**
   * Implements the mouse wheel action for the plane, changing the tilting speed.
   */
  void mouseWheelPlane(MouseEvent event) {
    float e = event.getCount();
    speed = (e>0)? bound(speed+0.1) : bound(speed-0.1);
  }

}