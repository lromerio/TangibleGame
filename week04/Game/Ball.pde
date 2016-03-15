class Ball {
  float r;
  PVector location;
  PVector velocity;
  PVector gravity;

  final float g = 0.1;

  Ball(float r) {
    this.location = new PVector(0, 0, 0);
    this.r = r;
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
  }


  void update() {
    gravity.x = sin(angleZ) * g;
    gravity.z = sin(angleX) * g;
    
    velocity.add(gravity);
    location.add(velocity);
  }


  void display() {
    pushMatrix();
    translate(location.x, location.y, location.z);
    sphere(r);
    popMatrix();
  }
}