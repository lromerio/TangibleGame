
// Imports
import java.util.Collections;    //for sorting
import java.util.List;
import java.util.Random;

// Images
PImage imgStart;
PImage imgSobel;
PImage imgHoughAccumulator;
PImage imgQuad;


Thresholding thresholds;
Hough hough;
EdgeAlgorithms algos;
QuadGraph QGraph;

List<int[]> finalQuads;
PVector areaBounds;

void settings() {
  size(1200, 600);
}

void setup() {

  // Image to be printed
  imgStart = loadImage("board1.jpg");
  
  thresholds = new Thresholding();
  hough = new Hough(imgStart, 200, 6);
  algos = new EdgeAlgorithms();

  QGraph = new QuadGraph();
  noLoop();
}

void draw() {
  
  imgSobel = thresholds.hueThresholding(imgStart, 50, 140);
  imgSobel = thresholds.brightnessThresholding(imgSobel, 30, 220);
  imgSobel = thresholds.saturationThresholding(imgSobel, 47, 255);
  imgSobel = algos.gaussianBlur(imgSobel);
  imgSobel = thresholds.intensityThresholding(imgSobel, 30, 220);
  imgSobel = algos.sobel(imgSobel);
  
  imgHoughAccumulator = hough.calculateAccumulator();
  
  image(imgSobel, 0, 0);
  image(imgHoughAccumulator, 800, 0);
}

List<int[]> filterQuads(List<int[]> quads) {

  List<int[]> filtered = new ArrayList<int[]>();
  for (int[] quad : quads) {

    PVector l1 = hough.bestLines.get(quad[0]);
    PVector l2 = hough.bestLines.get(quad[1]);
    PVector l3 = hough.bestLines.get(quad[2]);
    PVector l4 = hough.bestLines.get(quad[3]);

    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);
    
    float A = width*height;

    if (  QGraph.isConvex(c12, c23, c34, c41)
      && QGraph.validArea(c12, c23, c34, c41, A, areaBounds.y)
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