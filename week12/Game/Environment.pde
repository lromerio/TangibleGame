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
  PImage plateImg;
  PImage sideImg;
 

  PFont gameFont;
  //int env;

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

    //this.env = env;

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
    backgroundImg = mainBG;

    plateImg = loadImage("PlateTextureClassic.jpg");
    sideImg = loadImage("PlateTextureClassic.jpg");

    gameFont = mainFont;
  }

  void starWarsThemed() {
    //BONUS
    //Star Wars themed background (source: http://imgur.com/gallery/gXpIT), resized to match the display window.
    backgroundImg = loadImage("StarWarsBg.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    plateImg = loadImage("PlateTexture2.jpg");
    sideImg = loadImage("SideTxt2.jpg");      

    //BONUS
    //Plays the Star Wars theme in backgound when the Environment is created.
    //player = minim.loadFile("StarWarsTheme.mp3");
    //player.play();

    //BONUS
    //Star Wars themed font to display on the screen (source: http://www.fontspace.com/category/star%20wars)
    gameFont = createFont("Starjedi.ttf", 16, true);
  }

  void pokemonThemed() {
    //BONUS
    //Star Wars themed background (source: http://imgur.com/gallery/gXpIT), resized to match the display window.
    backgroundImg = loadImage("pok1.jpg");
    backgroundImg.resize(displayWidth, displayHeight);

    plateImg = loadImage("PlateTexturePokemon2.jpg");
    sideImg = loadImage("PlateTexturePokemon2.jpg");

    //BONUS
    //Plays the Star Wars theme in backgound when the Environment is created.
    //player = minim.loadFile("StarWarsTheme.mp3");
    //player.play();

    //BONUS
    //Star Wars themed font to display on the screen (source: http://www.fontspace.com/category/star%20wars)
    gameFont = createFont("PokemonSolid.ttf", 16, true);
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