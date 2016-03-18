  
class Environment {

//_______________________________________________________________
//Attributes
    PImage backgroundImg;
    AudioPlayer player;
    PFont f;
    final float g;
    
//_______________________________________________________________
//Functions

  Environment() {
    backgroundImg = loadImage("StarWarsBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);
    player = minim.loadFile("StarWarsTheme.mp3");
    player.play();
    f = createFont("Starjedi.ttf", 16, true);
    g = 1.1;
  }

  void starWarsThemed() {
    background(backgroundImg);
    textFont(f, 20);
    fill(255, 255, 255);
    textAlign(LEFT);
    text("Rotation x : \t\t" + degrees(plane.angleX), 20, 20);
    text("Rotation z : \t\t" + degrees(plane.angleZ), 20, 40);
    text("Speed : \t\t" + plane.speed, 20, 60);
    textFont(f, 80);
    textAlign(CENTER);
    text("Jedi Mind Tricks", width/2, height - 50);
  }
}