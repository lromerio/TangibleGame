/**
 *  This class modelizes the ball. It has attributes to keep track of its movement variables 
 *  and it's characteristics (dimentions, color, sounds, ...)
 *  
 *  @normalForce   normal force to the surface.
 *  @mu            friction coefficient.
 *  @friction      friction vector.
 *  @r             radius of the ball.
 *  @location      current position of the ball in the space, relative to the center of the plane.
 *  @velocity      current velocity of the ball.
 *  @gravity       gravity vector.
 */
class Ball {

  //_______________________________________________________________
  //Attributes  
  float normalForce;
  float mu;  
  PVector friction;
  float r;
  PVector location;
  PVector velocity;
  PVector gravity;

  //BONUS
  //The bouncing sound
  //AudioSample boing;


  //_______________________________________________________________
  //Functions
  Ball(float r) {
    this.location = new PVector(0, 0, 0);
    this.r = r;
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    mu = 0.6;
    normalForce = 1;

    //BONUS
    //boing = minim.loadSample("LaserBlasts.mp3");
  }

  void update() {
    gravity.x = sin(plane.angleZ) * environment.g;
    gravity.z = -sin(plane.angleX) * environment.g;

    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(normalForce * mu);

    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);

    cylinderCollision();
    
    float alpha;

    if (location.x > plane.boardEdge/2) {
      alpha = Math.abs(location.x - plane.boardEdge/2)*velocity.x/velocity.z;
      location.z = location.z - alpha;
      location.x = plane.boardEdge/2;
      
      velocity.x *= -1; 
      //BONUS
      //boing.trigger();
    } else if (location.x < -plane.boardEdge/2) {
      alpha = Math.abs(location.x - plane.boardEdge/2)*velocity.x/velocity.z;
      location.z = location.z + alpha;
      location.x = -plane.boardEdge/2;
      velocity.x *= -1; 
      //BONUS
      //boing.trigger();
    }
    if (location.z > plane.boardEdge/2) {
      alpha = Math.abs(location.z - plane.boardEdge/2)*velocity.z/velocity.x;
      location.x = location.x - alpha;
      location.z = plane.boardEdge/2;
      velocity.z *= -1; 
      //BONUS
      //boing.trigger();
    } else if (location.z < -plane.boardEdge/2) {
      alpha = Math.abs(location.z - plane.boardEdge/2)*velocity.z/velocity.x;
      location.x = location.x + alpha;
      location.z = -plane.boardEdge/2;
      velocity.z *= -1; 
      //BONUS
      //boing.trigger();
    }
  }

  void cylinderCollision() {
    PVector norm;
    for (int i = 0; i < cylinders.size(); ++i) {
      if ( dist(cylinders.get(i).x, cylinders.get(i).y, location.x, location.z) <= cylinder.c_radius + ball.r) {
        norm = (new PVector(location.x - cylinders.get(i).x, 0, location.z - cylinders.get(i).y)).normalize();

        //dobbiamo considerare anche il fatto che sopra addiamo pure la friction!!!
        location.sub( velocity.normalize().mult(-1*(cylinder.c_radius - dist(cylinders.get(i).x, cylinders.get(i).y, location.x, location.z)) ) );

        velocity.sub(norm.mult(velocity.dot(norm) * 2));
        //PVector v = new PVector(cylinders.get(i).x, cylinders.get(i).z ,cylinders.get(i).y);
        //location = v.add(norm.mult(modeManager.cylinderBaseSize + r));
        
        //BONUS
        //boing.trigger();
      }
    }
  }

  void display() {
    pushMatrix();
    rotateX(plane.angleX);
    rotateZ(plane.angleZ);
    translate(location.x, -r - (plane.boardThick/2), location.z);
    fill(255, 102, 102);
    sphere(r);
    popMatrix();
  }
}