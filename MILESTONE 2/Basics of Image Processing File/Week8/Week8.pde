PImage img;
HScrollbar scrollbar1;
HScrollbar scrollbar2;

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("board1.jpg");
  //noLoop(); // no interactive behaviour: draw() will be called only once.
  scrollbar1 = new HScrollbar(0, height - 20, width, 20);
  scrollbar2 = new HScrollbar(0, height - 40, width, 20);
}
void draw() {

  image(sobel(convolute(threshold(img))), 0, 0);
  scrollbar1.update();
  scrollbar1.display();
  scrollbar2.update();
  scrollbar2.display();
}



PImage threshold(PImage img) {
  PImage result = createImage(width, height, RGB); 
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(hue(img.pixels[i]));

    if (hue(img.pixels[i]) > 255*scrollbar1.getPos() && hue(img.pixels[i]) < 255*scrollbar2.getPos()) { 
      result.pixels[i] = img.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}



PImage convolute(PImage img) {
  /*  float[][] kernel = { { 0, 0, 0 }, 
   { 0, 2, 0 }, 
   { 0, 0, 0 }};   
   */
  float[][] gaussianKernel = { { 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};


  float weight = 99.f;
  
  PImage result = createImage(img.width, img.height, ALPHA);
  int sum = 0;

  for (int x=1; x<img.width -1; ++x) {
    for (int y=1; y<img.height-1; ++y) {

      for (int i=-1; i<2; ++i) {
        for (int j=-1; j<2; ++j) {
          sum += brightness(img.pixels[x+i + (y+j) * img.width])*gaussianKernel[i+1][j+1];
        }
      }
      result.pixels[y * img.width + x] = color((sum/weight));
      sum = 0;
    }
  }

  return result;
}



PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];

  for (int x=1; x<img.width -1; ++x) {
    for (int y=1; y<img.height-1; ++y) {
      float sum_h = 0;
      float sum_v = 0;

      for (int i=-1; i<2; ++i) {
        for (int j=-1; j<2; ++j) {
          sum_h += brightness(img.pixels[x+i + (y+j) * img.width])*hKernel[i+1][j+1];
          sum_v += brightness(img.pixels[x+i + (y+j) * img.width])*vKernel[i+1][j+1];
        }
      }

      float sum=sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      max = max(max, sum);

      buffer[y * img.width + x] = sum;
      sum = 0;
    }
  }

  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}