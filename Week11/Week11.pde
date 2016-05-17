import processing.video.*;
import java.util.Collections;    //for sorting
import java.util.List;
import java.util.Random;

Capture cam;
PImage img;
ArrayList<Integer> bestCandidates;
List<PVector> lines;
QuadGraph QGraph;
List<int[]> finalQuads;

void settings() {
  size(800, 600);
}

void setup() {
  /*
  // Use webcam
   String[] cameras = Capture.list();
   if (cameras.length == 0) {
   println("There are no cameras available for capture.");
   exit();
   } else {
   println("Available cameras:");
   for (int i = 0; i < cameras.length; i++) {
   println(cameras[i] +"   "+ i);
   }
   cam = new Capture(this, cameras[0]);
   cam.start();
   }
   */

  noLoop();

  img = loadImage("board4.jpg");

  QGraph = new QuadGraph();
}

void draw() {
  /*
  // Use webcam
   if (cam.available() == true) {
   cam.read();
   }
   img = cam.get();
   */

  // Draw image
  image(img, 0, 0);

  PImage result;
  result = hueThresholding(img, 50, 140);
  result = brightnessThresholding(result, 30, 220);
  result = saturationThresholding(result, 47, 255);
  result = convolute(result);
  result = intensityThresholding(result, 30, 220);    //lasciare?
  //result = sobel(result);
  image(result, 0, 0);

  //lines = hough(result, 200, 6);

  //QGraph.build(lines, width, height);

  //finalQuads = filterQuads(QGraph.findCycles());

  //drawQGraph(finalQuads, lines);
}

List<int[]> filterQuads(List<int[]> quads) {

  List<int[]> filtered = new ArrayList<int[]>();
  for (int[] quad : quads) {

    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);

    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);
    
    float A = width*height;

    if (  QGraph.isConvex(c12, c23, c34, c41)
      && QGraph.validArea(c12, c23, c34, c41, A, A/8)
      && QGraph.nonFlatQuad(c12, c23, c34, c41) ) {

      filtered.add(quad);
    }
  }

  return filtered;
}

void drawQGraph(List<int[]> quads, List<PVector> lines) {
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);

    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);

    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 50));
    quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
  }
}

ArrayList<PVector> hough(PImage edgeImg, int minVotes, int nLines) {

  bestCandidates = new ArrayList<Integer>();

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

  // pre-compute the sin and cos values
  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];
  float ang = 0;
  float inverseR = 1.f / discretizationStepsR;
  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {

    // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
    tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
    tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
  }

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
          int r = (int)(x*tabCos[phiC] + y*tabSin[phiC]);
          r += (rDim - 1) / 2;
          accumulator[(phiC+1)*(rDim + 2) + r] += 1;
        }
      }
    }
  }

  /*
  //Select bestCandidates
   for (int i = 0; i < accumulator.length; ++i) {            //(phiDim + 2) * (rDim + 2)
   if (accumulator[i] >= minVotes) {
   bestCandidates.add(i);
   }
   }
   */

  // size of the region we search for a local maximum
  int neighbourhood = 10;
  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          // check we are not outside the image
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            // check we are not outside the image
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }

  //Sort bestCandidates
  Collections.sort(bestCandidates, new HoughComparator(accumulator));

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

  // Array to return
  ArrayList<PVector> bestLines = new ArrayList<PVector>();

  for (int i = 0; i < min(nLines, bestCandidates.size()); ++i) {

    int idx = bestCandidates.get(i);

    // first, compute back the (r, phi) polar coordinates:
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;

    // Add line to bestLines
    bestLines.add(new PVector(r, phi));

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
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1>0) {
        if (y2>0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }

  return bestLines;
}

ArrayList<PVector> getIntersections(List<PVector> lines) {

  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);

      // compute the intersection and add it to ’intersections’
      float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
      float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y)) / d;
      float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y)) / d;

      // draw the intersection
      fill(255, 128, 0);
      ellipse(x, y, 10, 10);
    }
  }
  return intersections;
}

PVector intersection(PVector line1, PVector line2) {

  // compute the intersection and add it to ’intersections’
  float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
  float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y)) / d;
  float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y)) / d;

  return new PVector(x, y);
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