
import java.util.Collections;    //for sorting
import java.util.List;
import java.util.Random;

PImage imgStart;
PImage imgSobel;
PImage imgHoughAccumulator;
PImage imgQuad;

List<PVector> bestLines;
ArrayList<Integer> bestCandidates;

QuadGraph QGraph;
List<int[]> finalQuads;
PVector areaBounds;

void settings() {
  size(2200, 600);
}

void setup() {

  // Image to print
  imgStart = loadImage("board4.jpg");

  QGraph = new QuadGraph();
  noLoop();
}

void draw() {
  // Draw image
  image(imgStart, 0, 0);

  // Thresholding pipeline
  imgSobel = hueThresholding(imgStart, 50, 140);
  imgSobel = brightnessThresholding(imgSobel, 30, 200);
  imgSobel = saturationThresholding(imgSobel, 90, 255);
  imgSobel = gaussianBlur(imgSobel);
  imgSobel = intensityThresholding(imgSobel, 30, 200);

  // Calculate area bounds from pre-sobel image
  areaBounds = areaThresholding(imgSobel);

  // Calculate Sobel image
  imgSobel = sobel(imgSobel);

  // Do Hough algorithm and print accumulator
  bestLines = hough(imgSobel, 178, 6);

  // Quad detection
  QGraph.build(bestLines, width, height);
  finalQuads = filterQuads(QGraph.findCycles());

  // Print images
  drawBestQuad(finalQuads.get(0), imgStart);
  image(imgHoughAccumulator, 800, 0);
  image(imgSobel, 1400, 0);
}

List<int[]> filterQuads(List<int[]> quads) {

  List<int[]> filtered = new ArrayList<int[]>();
  for (int[] quad : quads) {

    PVector l1 = bestLines.get(quad[0]);
    PVector l2 = bestLines.get(quad[1]);
    PVector l3 = bestLines.get(quad[2]);
    PVector l4 = bestLines.get(quad[3]);

    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);

    float A = width*height;

    if (  QGraph.isConvex(c12, c23, c34, c41)
      &&  QGraph.validArea(c12, c23, c34, c41, A, 0)
      &&  QGraph.nonFlatQuad(c12, c23, c34, c41) ) {

      filtered.add(quad);
    }
  }

  return filtered;
}

void drawBestQuad(int[] quad, PImage imgStart) {

  for (int i = 0; i < 4; ++i) {

    PVector l = bestLines.get(quad[i]); 

    // Compute the intersection of this line with the 4 borders of the image
    int x0 = 0;
    int y0 = (int) (l.x / sin(l.y));
    int x1 = (int) (l.x / cos(l.y));
    int y1 = 0;
    int x2 = imgStart.width;
    int y2 = (int) (-cos(l.y) / sin(l.y) * x2 + l.x / sin(l.y));
    int y3 = imgStart.width;
    int x3 = (int) (-(y3 - l.x / sin(l.y)) * (sin(l.y) / cos(l.y)));

    //Plot the lines
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

  PVector l1 = bestLines.get(quad[0]);
  PVector l2 = bestLines.get(quad[1]);
  PVector l3 = bestLines.get(quad[2]);
  PVector l4 = bestLines.get(quad[3]);

  // (intersection() is a simplified version of the
  // intersections() method you wrote last week, that simply
  // return the coordinates of the intersection between 2 lines)
  PVector c12 = intersection(l1, l2);
  PVector c23 = intersection(l2, l3);
  PVector c34 = intersection(l3, l4);
  PVector c41 = intersection(l4, l1);

  // Draw quad corners
  fill(255, 128, 0);
  ellipse(c12.x, c12.y, 10, 10);
  ellipse(c23.x, c23.y, 10, 10);
  ellipse(c34.x, c34.y, 10, 10);
  ellipse(c41.x, c41.y, 10, 10);
}

void drawQGraph(List<int[]> quads, List<PVector> lines) {
  for (int[] quad : quads) {
    PVector l1 = bestLines.get(quad[0]);
    PVector l2 = bestLines.get(quad[1]);
    PVector l3 = bestLines.get(quad[2]);
    PVector l4 = bestLines.get(quad[3]);

    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);

    // Draw quad corners
    fill(255, 128, 0);
    ellipse(c12.x, c12.y, 10, 10);
    ellipse(c23.x, c23.y, 10, 10);
    ellipse(c34.x, c34.y, 10, 10);
    ellipse(c41.x, c41.y, 10, 10);

    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 50));
    quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
  }
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

// Takes the accumulator and its dimensions and returns the image
PImage displayHoughAcc(int[] accumulator, int rDim, int phiDim) {

  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }

  houghImg.resize(600, 600);
  houghImg.updatePixels();
  return houghImg;
}

ArrayList<PVector> hough(PImage edgeImg, int minVotes, int nLines) {

  bestCandidates = new ArrayList<Integer>();

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  // Accumulator and dimensions
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

  // Pre-compute the sin and cos values
  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];
  float ang = 0;
  float inverseR = 1.f / discretizationStepsR;
  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
    tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
    tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
  }

  // Fill the accumulator
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {

      // If on an edge
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {

        // Determine all lines
        for (int phiC = 0; phiC < phiDim; ++phiC) {
          int r = (int)(x*tabCos[phiC] + y*tabSin[phiC]);
          r += (rDim - 1) / 2;
          accumulator[(phiC+1)*(rDim + 2) + r] += 1;
        }
      }
    }
  }

  // Local maxima
  int neighbourhood = 10;
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          bestCandidates.add(idx);
        }
      }
    }
  }

  // Save accumulator image
  imgHoughAccumulator = displayHoughAcc(accumulator, rDim, phiDim);

  // Sort bestCandidates
  Collections.sort(bestCandidates, new HoughComparator(accumulator));

  // Lines array to return
  ArrayList<PVector> bestLines = new ArrayList<PVector>();

  for (int i = 0; i < min(nLines, bestCandidates.size()); ++i) {

    int idx = bestCandidates.get(i);

    //Compute back the (r, phi) polar coordinates:
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;

    // Add line to bestLines
    bestLines.add(new PVector(r, phi));
  }

  return bestLines;
}

// Area thresholding
PVector areaThresholding(PImage img) {

  int whitePixels = 0;

  for (int i = 0; i < img.width * img.height; i++) {
    if (img.pixels[i] == color(255) ) {
      ++whitePixels;
    }
  }

  float minArea = whitePixels - (img.width * img.height*10)/100.f;
  float maxArea = whitePixels + (img.width * img.height*10)/100.f;

  return new PVector(maxArea, minArea);
}

// Implement Sobel algorithm
PImage sobel(PImage img) {

  // Kernels and image initialisation
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

PImage gaussianBlur(PImage img) {

  // Kernel initialisation
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

// Threshold brightness
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

// Threshold saturation
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

// Threshold hue
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

// Threshold brightness and output a blck and white image
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