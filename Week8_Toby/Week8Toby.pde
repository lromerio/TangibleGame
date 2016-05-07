PImage img;
HScrollbar scrollbar1;
HScrollbar scrollbar2;

void settings() {
  size(800, 600);
}

void setup() {
  img = loadImage("board1.jpg");
  scrollbar1 = new HScrollbar(5, height - 40, width - 10, 30);
  scrollbar2 = new HScrollbar(5, height - 80, width - 10, 30);

  //For convolute e thresholding normale
  noLoop();
}

void draw() {
  PImage result = hueThresholding(img, 115, 140);
  result = saturationThresholding(result, 70, 255);
  result = brightnessThresholding(result, 20, 230);
  image(sobel(result), 0, 0);
}

PImage sobel(PImage img) {
  float[][] hKernel = 
  { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = 
  { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  float sum_h = 0;
  float sum_v = 0;
  float sum = 0;
  
  // *************************************
  // Implement here the double convolution
  // *************************************
  for (int y = 1; y < img.height - 1; ++y) {
    for (int x = 1; x < img.width - 1; ++x) {
      sum_h = 0;
      sum_v = 0;
      sum = 0;
      for (int i = -1; i < 2; ++i) {
        for (int j = -1; j < 2; ++j) {
          sum_h += brightness(img.pixels[(y+i)*img.width + (x+j)])*hKernel[j+1][i+1];
          sum_v += brightness(img.pixels[(y+i)*img.width + (x+j)])*vKernel[j+1][i+1];
        }
      }
      sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      buffer[x + y*img.width] = sum;
      if(sum > max) {
        max = sum;
      }
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

PImage convolute(PImage img) {
  float[][] kernel = 
    { { 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};
  float weight = 99.f;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  int sum = 0;
  for (int y = 1; y < img.height - 1; ++y) {
    for (int x = 1; x < img.width - 1; ++x) {
      sum = 0;
      for (int i = -1; i < 2; ++i) {
        for (int j = -1; j < 2; ++j) {
          sum += brightness(img.pixels[(y+i)*img.width + (x+j)])*kernel[j+1][i+1];
        }
      }
      result.pixels[x + y*img.width] = color((int)(sum/weight));
    }
  }
  return result;
}

PImage brightnessThresholding(PImage img, int lowerBound, int upperBound) {
  PImage result = createImage(width, height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) <= upperBound &&
        brightness(img.pixels[i]) >= lowerBound) {
        result.pixels[i] = img.pixels[i];
    } else {
       result.pixels[i] = color(0);
    }
  }
 return result;
}

PImage saturationThresholding(PImage img, int lowerBound, int upperBound) {
  PImage result = createImage(width, height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (saturation(img.pixels[i]) <= upperBound &&
        saturation(img.pixels[i]) >= lowerBound) {
        result.pixels[i] = img.pixels[i];
    } else {
       result.pixels[i] = color(0);
    }
  }
 return result;
}

PImage hueThresholding(PImage img, int lowerBound, int upperBound) {
  PImage result = createImage(width, height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (  hue(img.pixels[i]) < lowerBound ||
          hue(img.pixels[i]) > upperBound) {
      result.pixels[i] = color(0);
    } else {
      result.pixels[i] =  img.pixels[i];
    }
  }
  
  return result;
}