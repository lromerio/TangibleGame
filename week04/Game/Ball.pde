//import ddf.minim.*;

class Ball {

  //Minim minim = new Minim(this);
  //AudioSample boing = minim.loadSample("boing.mp3", 2048);

  float r;
  PVector location;
  PVector velocity;
  PVector gravity;

  float normalForce = 0.5;
  float mu = 1;
  float frictionMagnitude;
  PVector friction;




  final float g = 1.1;

  Ball(float r) {
    this.location = new PVector(0, 0, 0);
    this.r = r;
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
  }


  void update() {
    gravity.x = sin(angleZ) * g;
    gravity.z = -sin(angleX) * g;

    frictionMagnitude = normalForce * mu;
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravity);
    velocity.add(friction);


    if (location.x > boardEdge/2 || location.x < -boardEdge/2) {
      velocity.x *=-1; 
      //boing.trigger();
    }
    if (location.z > boardEdge/2 || location.z < -boardEdge/2) {
      velocity.z *=-1; 
      //boing.trigger();
    }



    location.add(velocity);
  }


  void display() {
    pushMatrix();
    translate(location.x, -r -10, location.z);
    fill(255, 0, 0);
    sphere(r);
    popMatrix();
  }
}