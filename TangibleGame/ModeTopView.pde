class ModeTopView extends Mode {
  final color traceColor;
  final float ballDiameter;
  PVector lastBallPosition;

  ModeTopView(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P2D);

    ballDiameter = project(env.plate.ball.radius) * 2;
    traceColor = darken(env.plate.fillColor);
    lastBallPosition = env.plate.ball.position.copy();

    surface.beginDraw();
    surface.noStroke();
    surface.background(opaque(env.plate.fillColor));
    surface.endDraw();
  }

  void draw() {
    surface.beginDraw();

    surface.translate(height / 2, width / 2);

    for (ShapeCylinder cylinder : env.plate.cylinders) {
      surface.fill(cylinder.fillColor);
      surface.ellipse(project(cylinder.position.x), project(cylinder.position.y), project(cylinder.radius) * 2, project(cylinder.radius) * 2);
    }

    surface.fill(traceColor);
    surface.ellipse(project(lastBallPosition.x), project(lastBallPosition.y), ballDiameter, ballDiameter);

    surface.fill(env.plate.ball.fillColor);
    surface.ellipse(project(env.plate.ball.position.x), project(env.plate.ball.position.y), ballDiameter, ballDiameter);

    surface.endDraw();
    super.draw();

    lastBallPosition = env.plate.ball.position.copy();
  }

  color opaque(color c) {
    return color(red(c), green(c), blue(c));
  }

  color darken(color c) {
    return color(red(c) - 25, green(c) - 25, blue(c) - 25);
  }

  float project(float v) {
    return (v / env.plate.width) * width;
  }
}