
class Mode {
  
  ModeAdd() {
  
  }

  void addCylinder() {
    pushMatrix();
    rotateX(PI/2);
    beginShape();
    texture(plane.plateImg);
    vertex(- plane.boardEdge/2, -plane.boardThick/2, -plane.boardEdge/2, 0, 0);
    vertex(- plane.boardEdge/2, -plane.boardThick/2, plane.boardEdge/2, 0, 450);
    vertex(plane.boardEdge/2, -plane.boardThick/2, plane.boardEdge/2, 450, 450);
    vertex(plane.boardEdge/2, -plane.boardThick/2, -plane.boardEdge/2, 450, 0);
    endShape(CLOSE);
    popMatrix();
  }
}