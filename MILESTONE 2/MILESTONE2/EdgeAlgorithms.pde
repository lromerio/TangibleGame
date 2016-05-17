

class EdgeAlgorithms {

  PImage gaussianBlur(PImage img) {

    // Convolution Kernel
    float[][] kernel = 
      { { 9, 12, 9 }, 
      { 12, 15, 12 }, 
      { 9, 12, 9 }};
    float weight = 99.f;

    // Create a greyscale image (type: ALPHA) for output
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

  PImage sobel(PImage img) {

    // Convolution kernels
    float[][] hKernel = 
      { { 0, 1, 0 }, 
      { 0, 0, 0 }, 
      { 0, -1, 0 } };
    float[][] vKernel = 
      { { 0, 0, 0 }, 
      { 1, 0, -1 }, 
      { 0, 0, 0 } };
    PImage result = createImage(img.width, img.height, ALPHA);

    // Clear the image
    for (int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(0);
    }
    float max=0;
    float[] buffer = new float[img.width * img.height];
    float sum_h = 0;
    float sum_v = 0;
    float sum = 0;

    // Double convolution
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
        if (sum > max) {
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
}