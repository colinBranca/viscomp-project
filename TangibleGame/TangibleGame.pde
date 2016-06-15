import processing.video.*;

Environment env = new Environment();
Mode world;
ImageProcessing imgproc;
QuadGraph graph;
Hough hough;
ArrayList<PVector> intersect = new ArrayList<PVector>();

Movie cam;

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
  
  cam = new Movie(this, "testvideo.mp4"); //Put the video in the same directory
  cam.loop();
  
  // Create plate
  imgproc = new ImageProcessing(loadImage("board2.jpg"));
  hough = imgproc.applyTransformations(imgproc.img);

  graph = new QuadGraph(hough.lines, imgproc.img.width, imgproc.img.height);
  graph.getIntersections(intersect);
  graph.drawListOfIntersections(intersect);

  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  
  //Rotation
  TwoDThreeD twoDthree = new TwoDThreeD(imgproc.img.width, imgproc.img.height);
  PVector rot = twoDthree.get3DRotations(intersect);

  env.plate = new ShapePlate(width/3, width/70, width/3);
  env.plate.fill(color(150, 150, 150, 120));
  //ICI
  env.plate.rotSpeed = new BoundedFloat(50, 1, 100);
  env.plate.rotX = new BoundedFloat(rot.x, - PI / 3, PI / 3);
  env.plate.rotZ = new BoundedFloat(rot.y, - PI / 3, PI / 3);
  //A ICI

  // Create ball
  env.plate.ball = new ShapeBall(20, env.plate);
  env.plate.ball.fill(255, 180, 255);

  env.score = new Score(env);

  env.chartZoom = new BoundedFloat(6, 1, 11);

  world = new ModeWorld(env, width, height, 0, 0);
}

void draw() {
  world.update();
  world.draw();
}

void keyPressed() {
  world.keyPressed();
};

void keyReleased() {
  world.keyReleased();
};

void mouseDragged() {
  world.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  world.mouseWheel(event);
}

void mouseClicked() {
  world.mouseClicked();
}

void mousePressed() {
  world.mousePressed();
}

void mouseReleased() {
  world.mouseReleased();
}