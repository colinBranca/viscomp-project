class ModeInformations extends Mode {
  ModeTopView topView;
  ModeScoreBoard scoreBoard;
  ModeScoreChart scoreChart;
  ModeScrollBar scrollBar;

  ModeInformations(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P2D);

    int margin = height / 20;
    int innerHeight = height - 2 * margin;
    int scrollBarHeight = height / 8;

    topView = new ModeTopView(env, innerHeight, innerHeight, x + margin, y + margin);

    scoreBoard = new ModeScoreBoard(env, 2 * innerHeight / 3, innerHeight, topView.x + topView.width + margin, y + margin);

    int scoreChartX = scoreBoard.x + scoreBoard.width + margin;
    scoreChart = new ModeScoreChart(env, width - scoreChartX - margin, innerHeight - scrollBarHeight - margin, scoreChartX, y + margin);

    scrollBar = new ModeScrollBar(env, scoreChart.width, scrollBarHeight, scoreChartX, scoreChart.y + scoreChart.height + margin, env.chartZoom);

    addChild(topView);
    addChild(scoreBoard);
    addChild(scoreChart);
    addChild(scrollBar);

    topView.enter();
    scoreBoard.enter();
    scoreChart.enter();
    scrollBar.enter();
  }

  void draw() {
    surface.beginDraw();
    surface.background(100, 100, 100);
    surface.endDraw();
    super.draw();
  }

  void update() {
    env.chartZoom = scrollBar.value;
  }
}