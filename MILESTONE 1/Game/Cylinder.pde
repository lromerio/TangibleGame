/**
 *  Represents a cylinder
 *  
 *  @side      shape representing the side surface
 *  @top       shape representing the top surface
 *  @bot       shape representing the bot surface
 *  @c_radius  radius
 *  @c_height  height
 */
class Cylinder {

  PShape side;
  PShape top;
  PShape bot;

  float c_radius;
  float c_height;

  //BONUS
  color colour;

  /**
   * Constructs a cylinder with a given radius, height and resolution(number of edges).
   */
  Cylinder(float c_radius, float c_height, int resolution) {
    side = new PShape();
    top = new PShape();
    bot = new PShape();

    this.c_radius = c_radius;
    this.c_height = c_height;
    
    colour = color(50, 100, 200);

    float angle;
    float[] x = new float[resolution + 1];
    float[] y = new float[resolution + 1];

    //get the x and y position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * c_radius;
      y[i] = cos(angle) * c_radius;
    }

    side = createShape();
    side.beginShape(QUAD_STRIP);
    top = createShape();
    top.beginShape(TRIANGLE_FAN);
    bot = createShape();
    bot.beginShape(TRIANGLE_FAN);
    top.vertex(0, 0, 0);
    bot.vertex(0, 0, c_height);

    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      side.vertex(x[i], y[i], 0);
      side.vertex(x[i], y[i], c_height);
      top.vertex(x[i], y[i], 0);
      bot.vertex(x[i], y[i], c_height);
    }
    side.endShape();
    top.endShape();
    bot.endShape();
  }

  /**
   * Draws the cylinder.
   */
  void draw() {
    shape(cylinder.side);
    shape(cylinder.top);
    shape(cylinder.bot);
  }
}