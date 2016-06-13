

class ScoreInterface {
  //tappa 6
  PGraphics dataVisualisation;
  PGraphics topView;
  PGraphics scoreboard;
  PGraphics barChart;

  float totalScore;
  float lastScore;

  ArrayList<Float> scoreChart;
  float scorePadding;
  float scoreBox;
  float scrollScale;
  int timeCounter;

  HScrollbar scrollbar;

  ScoreInterface() {
    dataVisualisation = createGraphics(width, 150, P2D);
    topView = createGraphics(140, 140, P2D);
    scoreboard = createGraphics(100, 140, P2D);
    barChart = createGraphics(width - topView.width - scoreboard.width - 20, 125, P2D);

    totalScore = 0;
    lastScore = 0;

    scoreChart = new ArrayList<Float>();
    scorePadding = 10;
    scoreBox = 5;
    scrollScale = 1;
    timeCounter = 30;

    scrollbar = new HScrollbar(15 + topView.width + scoreboard.width, height - 15, barChart.width, 10);
  }

  void drawScores() {
    drawData();
    image(dataVisualisation, -width/2, height/2 - dataVisualisation.height);

    drawTopView();
    image(topView, 5 - width/2, height/2 - dataVisualisation.height + 5);

    drawScoreboard();
    image(scoreboard, - width/2+ 10 + topView.width, height/2 - dataVisualisation.height + 5);

    drawBarChart();
    image(barChart, - width/2+ 15 + topView.width + scoreboard.width, height/2 - dataVisualisation.height + 5);

    scrollbar.update();
    scrollbar.display();
  }

  void drawData() {
    dataVisualisation.beginDraw();
    dataVisualisation.background(255);
    dataVisualisation.endDraw();
  }

  void drawTopView() {
    topView.beginDraw();
    topView.translate(topView.width/2, topView.height/2);
    topView.background(255, 204, 0);
    //Draw the Ball
    topView.fill(ball.colour);
    topView.ellipse(mapC(ball.location.x), mapC(ball.location.z), 2*mapC(ball.r), 2*mapC(ball.r));
    //Draw Cylinders
    topView.fill(cylinder.colour);
    for (int i = 0; i < cylinders.size(); ++i) {
      topView.ellipse(mapC(cylinders.get(i).x), mapC(cylinders.get(i).y), 2*mapC(cylinder.c_radius), 2*mapC(cylinder.c_radius));
    }
    topView.endDraw();
  }

  void drawScoreboard() {
    scoreboard.beginDraw();
    scoreboard.background(0);
    scoreboard.fill(255);
    scoreboard.text("Total Score:", 10, 20);
    scoreboard.text(totalScore, 15, 35);
    scoreboard.text("Velocity:", 10, 60);
    scoreboard.text(ball.velocity.mag(), 15, 75);
    scoreboard.text("Last Score:", 10, 100);
    scoreboard.text(lastScore, 15, 115);
    scoreboard.endDraw();
  }

  float mapC(float coord) {
    return map(coord, -plane.boardEdge/2, plane.boardEdge/2, -topView.width/2, topView.width/2);
  }

  void drawBarChart() {
    barChart.beginDraw();
    barChart.background(0);
    if (!currentMode.isPaused) {
      --timeCounter; 
      if (timeCounter == 0) {
        timeCounter = 10;
        scoreChart.add(totalScore);
      }
    }

    scrollScale = scrollbar.getPos() + 0.5;

    barChart.fill(0, 200, 0);
    for (int i = 0; i<scoreChart.size(); ++i) {
      for (int j = 0; j<scoreChart.get(i)/scorePadding; ++j) {
        barChart.rect(i*(scoreBox*scrollScale), barChart.height - j*scoreBox, scoreBox*scrollScale, scoreBox);
      }
    }

    barChart.endDraw();
  }
}