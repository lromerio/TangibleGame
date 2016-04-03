void settings() {
  size (1000, 1000, P2D);
}

void setup() {
}

void draw() {

  background(255, 255, 255);

  //Setting up the perspective and a cuboid
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);

  //Rotating the cube around X axis
  float[][] transform1 = rotateXMatrix(PI/8);
  input3DBox = transformBox(input3DBox, transform1);
  projectBox(eye, input3DBox).render();

  //Translating the rotated cube
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();

  //Scaling the rotated and translated cube
  float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
}

//Class to represent 2D positions
class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

//Class to represent 3D positions
class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

//Project a 3D position into a 2D one seen by the eye coordinates
My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  return new My2DPoint((p.x - eye.x)/((eye.z - p.z)/eye.z), 
                       (p.y - eye.y)/((eye.z - p.z)/eye.z));
}

//A cuboid represented in 2D
class My2DBox {
  My2DPoint[] s;
  
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  
  //draws the 12 edges
  void render() {
   for (int i = 0; i <= 3; i++) {
      line(s[i].x, s[i].y, s[(i+1) % 4].x, s[(i+1) % 4].y);
      line(s[i + 4].x, s[i + 4].y, s[(i+1)%4 + 4].x, s[(i+1)%4 + 4].y);
      line(s[i].x, s[i].y, s[i + 4].x, s[i + 4].y);
    }
  }
}

//A cuboid represented in 3D
class My3DBox {
  My3DPoint[] p;
  
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{  new My3DPoint(x, y+dimY, z+dimZ), 
                               new My3DPoint(x, y, z+dimZ), 
                               new My3DPoint(x+dimX, y, z+dimZ), 
                               new My3DPoint(x+dimX, y+dimY, z+dimZ), 
                               new My3DPoint(x, y+dimY, z), 
                               origin, 
                               new My3DPoint(x+dimX, y, z), 
                               new My3DPoint(x+dimX, y+dimY, z)
                            };
  }
  
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

//Projects a 3D cuboid in the 2D plane seen by the eye coordinates
My2DBox projectBox (My3DPoint eye, My3DBox box) {
  
  My2DPoint[] projected = new My2DPoint[8];

  for (int i=0; i<8; i++) {
    projected[i] = projectPoint(eye, box.p[i]);
  }

  return new My2DBox(projected);
}

//Adds a fourth coordinate for the homogeneous representation
float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

//Returns a rotation matrix of "angle" radians around the X axis
float[][] rotateXMatrix(float angle) {
  return(new float[][] {
    {1, 0, 0, 0}, 
    {0, cos(angle), sin(angle), 0}, 
    {0, -sin(angle), cos(angle), 0}, 
    {0, 0, 0, 1}});
}

//Returns a rotation matrix of "angle" radians around the Y axis
float[][] rotateYMatrix(float angle) {
  return(new float[][] {
    {cos(angle), 0, sin(angle), 0}, 
    {0, 1, 0, 0}, 
    {-sin(angle), 0, cos(angle), 0}, 
    {0, 0, 0, 1}});
}

//Returns a rotation matrix of "angle" radians around the Z axis
float[][] rotateZMatrix(float angle) {
  return(new float[][] {
    {cos(angle), -sin(angle), 0, 0}, 
    {sin(angle), cos(angle), 0, 0}, 
    {0, 0, 1, 0}, 
    {0, 0, 0, 1}});
}

//Returns a matrix that scales each dimension of x, y, z factors, respectively
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {
    {x, 0, 0, 0}, 
    {0, y, 0, 0}, 
    {0, 0, z, 0}, 
    {0, 0, 0, 1}});
}

//Returns a matrix that translates of x, y, z in the respective direction
float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {
    {1, 0, 0, x}, 
    {0, 1, 0, y}, 
    {0, 0, 1, z}, 
    {0, 0, 0, 1}});
}

//Computes the dot product between matrix a and vector b
float[] matrixProduct(float[][] a, float[] b) {
  
  float[] result = new float[b.length];

  for (int i=0; i < a.length; i++) {
    for (int j=0; j < a[i].length; j++) {
      result[i] += a[i][j]*b[j];
    }
  }

  return result;
}

//Removes the homogeneous coordinate and goes back to a euclidean coordinate system
My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

//Returns the transformed box, given a transformMatrix
My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  
  My3DPoint[] transformed = new My3DPoint[box.p.length];
  for (int i=0; i < box.p.length; i++) {
    transformed[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  }

  return new My3DBox(transformed);
}