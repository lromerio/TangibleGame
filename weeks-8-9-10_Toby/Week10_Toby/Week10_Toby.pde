import processing.video.*;
Capture cam;
PImage img;
ArrayList<Integer> bestCandidates;

void settings() {
  size(640, 480);
}

void setup() {
  bestCandidates = new ArrayList<Integer>();
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i] +"   "+ i);
    }
    cam = new Capture(this, cameras[58]);
    cam.start();
  }
}

void draw() {
   if (cam.available() == true) {
    cam.read();
  }
  img = cam.get();
  image(img, 0, 0);
  PImage result = hueThresholding(img, 50, 140);
  result = saturationThresholding(result, 70, 255);
  result = brightnessThresholding(result, 30, 220);
  result = sobel(result);
  //image(result, 0, 0);
  hough(result);
}

void hough(PImage edgeImg, int minVotes) {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
        for (int phiC = 0; phiC < phiDim; ++phiC) {
          int r = (int)((x*cos(phiC*discretizationStepsPhi) + y*sin(phiC*discretizationStepsPhi))/discretizationStepsR);
          r += (rDim - 1) / 2;
          accumulator[(phiC+1)*(rDim + 2) + r] += 1;
        }
      }
    }
  }
  
  for(int i = 0; i < (phiDim + 2) * (rDim + 2); ++i) {
    if(
  }

  /*
  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  houghImg.resize(400, 400);
  houghImg.updatePixels();
  return houghImg;
  */
  
  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > 200) {
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim + 2)) - 1;
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;

      //Cartesian equation of a line: y = ax + b
      //in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      //=> y = 0 : x = r / cos(phi)
      //=> x = 0 : y = r / sin(phi)

      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      
      //Finally, plot the lines
      stroke(204, 102, 0);
      if(y0 > 0) {
        if(x1 > 0)
          line(x0, y0, x1, y1);
        else if(y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      }
      else {
        if(x1>0) {
          if(y2>0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        }
        else
          line(x2, y2, x3, y3);
      }
    }
  }
  
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