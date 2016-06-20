class Score {
  final float MIN_CHANGE = 4.0;
  Environment env;
  float value;
  float lastChange;
  float max = 0;
  float min = 0;
  ArrayList<Float> history;

  Score(Environment env) {
    this.value = 0;
    this.env = env;
    this.history = new ArrayList<Float>();
  }

  void save() {
    history.add(value);

    if (value > min) {
      min = value;
    }
    if (value > max) {
      max = value;
    }
  }

  void hitCylinder() {
    update(env.plate.ball.velocity.mag());
  }

  void hitEdge() {
    update(-env.plate.ball.velocity.mag());
  }

  void update(float change) {
    if (change >= MIN_CHANGE || change <= -MIN_CHANGE) {
      lastChange = change;
      value += lastChange;
    }
  }
}