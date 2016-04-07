/**
 *  All this class is a BONUS. Represents the environment of the game,
 *  containing the background, the plane skin, and sounds.
 *
 *  @backgroundImg background of the game.
 *  @f             font for the stats.
 *
 *
 *  @g             DUNNO
 */
class Environment {

//_______________________________________________________________
//Attributes
    PImage backgroundImg;
    PFont f;
    final float g;
    
    //AudioPlayer player;
    
//_______________________________________________________________
//Functions

  Environment() {
    backgroundImg = loadImage("StarWarsBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);
    //player = minim.loadFile("StarWarsTheme.mp3");
    //player.play();
    f = createFont("Starjedi.ttf", 16, true);
    
    
    g = 1.1; //NOT USED???
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
    //text("Jedi Mind Tricks", width/2, height - 50);
  }
}