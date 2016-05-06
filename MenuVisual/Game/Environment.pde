/**
 *  All this class is a BONUS,except for the gravity coefficient. Represents the environment of the game,
 *  containing the background, the plane texture, and sounds.
 *
 *  @backgroundImg background of the game.
 *  @f             font for the stats.
 *  @g             gravity coefficient
 */
class Environment {

  //_______________________________________________________________
  //Attributes
  PImage backgroundImg;
  PFont f;
  int env;
  
  final float g;

  //BONUS
  //PLayer for the background music
  //AudioPlayer player;

  //_______________________________________________________________
  //Functions

  /**
   * Creates an environment, loading images and sounds, and initialising the attributes
   */
  Environment(int env) {    
    g = 1.1;
    
    this.env = env;

    switch(env) {
    case 0: //classic
      classicThemed();
      break;
    case 1: //starwars
      starWarsThemed();
      break;
    case 2: //thirdone
      pokemonThemed();
      break;
    }
  }

  void classicThemed() {
    backgroundImg = loadImage("classicBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);
    
    //TODO stabilire font classic-->da rimettere anche prima di tornare al menu principale ("NewGame")
  }

  void starWarsThemed() {
    //BONUS
    //Star Wars themed background (source: http://imgur.com/gallery/gXpIT), resized to match the display window.
    backgroundImg = loadImage("StarWarsBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    //BONUS
    //Plays the Star Wars theme in backgound when the Environment is created.
    //player = minim.loadFile("StarWarsTheme.mp3");
    //player.play();

    //BONUS
    //Star Wars themed font to display on the screen (source: http://www.fontspace.com/category/star%20wars)
    f = createFont("Starjedi.ttf", 16, true);
    textFont(f);
  }

  void pokemonThemed() {
    //BONUS
    //Star Wars themed background (source: http://imgur.com/gallery/gXpIT), resized to match the display window.
    backgroundImg = loadImage("pokemonBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    //BONUS
    //Plays the Star Wars theme in backgound when the Environment is created.
    //player = minim.loadFile("StarWarsTheme.mp3");
    //player.play();

    //BONUS
    //Star Wars themed font to display on the screen (source: http://www.fontspace.com/category/star%20wars)
    f = createFont("PokemonSolid.ttf", 16, true);
    textFont(f);
  }

  /**
   * Displays a Star Wars themed background and writes on the top left of the screen the tilting angle and speed
   */
  void display() {
    background(backgroundImg);
    //Display some of the attributes of the plane
    //textFont(f, 20);
    textSize(20);
    fill(255, 255, 255);
    textAlign(LEFT);
    text("Rotation x : \t\t" + degrees(plane.angleX), 20, 20);
    text("Rotation z : \t\t" + degrees(plane.angleZ), 20, 40);
    text("Speed : \t\t" + plane.speed, 20, 60);
  }
}