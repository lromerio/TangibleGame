

class Thresholding {


  PImage brightnessThresholding(PImage img, int lowerBound, int upperBound) {
    
    PImage result = createImage(img.width, img.height, RGB);
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


  PImage hueThresholding(PImage img, int lowerBound, int upperBound) {

    PImage result = createImage(img.width, img.height, RGB);
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

  PImage intensityThresholding(PImage img, int lowerBound, int upperBound) {

    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
      if ( brightness(img.pixels[i]) < lowerBound ||
        brightness(img.pixels[i]) > upperBound) {
        result.pixels[i] = color(0);
      } else {
        result.pixels[i] =  color(255);
      }
    }

    return result;
  }

  PImage saturationThresholding(PImage img, int lowerBound, int upperBound) {

    PImage result = createImage(img.width, img.height, RGB);
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

  PVector areaThresholding(PImage img) {

    int whitePixels = 0;

    for (int i = 0; i < img.width * img.height; i++) {
      if (img.pixels[i] == color(255) ) {
        ++whitePixels;
      }
    }

    float minArea = whitePixels - (img.width * img.height*20)/100.f;
    float maxArea = whitePixels + (img.width * img.height*20)/100.f;

    println("White :" + whitePixels);
    println("Total :" + (img.width * img.height));
    println("Min :" + minArea);
    println("Max :" + maxArea);

    return new PVector(maxArea, minArea);
  }
}