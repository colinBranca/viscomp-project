void settings() {
  size(1000,1000,P2D);;
}

void setup(){
  background(256, 256, 256);
}

void draw(){
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0); //The first vertex of your cuboid
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  //rotated around x
  float[][] transform1 = rotateXMatrix(PI/8);
  input3DBox = transformBox(input3DBox, transform1);
  projectBox(eye, input3DBox).render();
  
  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
  
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
}

/********************************/
/* Step 1.1 – Represent a point */
/********************************/

class My2DPoint {
  float x;
  float y;

  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;

  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

/***********************************/
/* Step 1.2 – Projecting the point */
/***********************************/

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float z_I = -eye.z / (p.z - eye.z);
  return new My2DPoint((p.x - eye.x)*z_I, (p.y - eye.y)*z_I);
}

/**********************************/
/* Step 1.3 – Projecting a cuboid */
/**********************************/

class My2DBox {
  My2DPoint[] s;
  
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  
  void render(){
    line(s[0].x, s[0].y, s[1].x, s[1].y);
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[0].x, s[0].y, s[4].x, s[4].y);
    line(s[1].x, s[1].y, s[2].x, s[2].y);
    line(s[1].x, s[1].y, s[5].x, s[5].y);
    line(s[2].x, s[2].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[6].x, s[6].y);
    line(s[3].x, s[3].y, s[7].x, s[7].y);
    line(s[4].x, s[4].y, s[5].x, s[5].y);
    line(s[4].x, s[4].y, s[7].x, s[7].y);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
    line(s[6].x, s[6].y, s[7].x, s[7].y);
  }
}

class My3DBox {
  My3DPoint[] p;
  
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[] {new My3DPoint(x,y+dimY,z+dimZ),
                              new My3DPoint(x,y,z+dimZ),
                              new My3DPoint(x+dimX,y,z+dimZ),
                              new My3DPoint(x+dimX,y+dimY,z+dimZ),
                              new My3DPoint(x,y+dimY,z),
                              origin,
                              new My3DPoint(x+dimX,y,z),
                              new My3DPoint(x+dimX,y+dimY,z)
    };
  }

  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox(My3DPoint eye, My3DBox box) {
  My2DPoint[] result = new My2DPoint[box.p.length];
  
  for(int i = 0; i != box.p.length; ++i) {
    result[i] = projectPoint(eye, box.p[i]);
  }
  
  return new My2DBox(result);
}

/*****************************************/
/* Step 2.1 – Homogeneous Representation */
/*****************************************/

float[] homogeneous3DPoint (My3DPoint p) {
  return new float[] {p.x, p.y, p.z , 1};
}

/**************************************/
/* Step 2.2 – Transformation Matrices */
/**************************************/

float[][]  rotateXMatrix(float angle) {
  return new float[][] {
    {1, 0,           0,          0},
    {0, cos(angle),  sin(angle), 0},
    {0, -sin(angle), cos(angle), 0},
    {0, 0,           0,          1}
  };
}

float[][] rotateYMatrix(float angle) {
  return new float[][] {
    {cos(angle),  0, sin(angle), 0},
    {0,           1, 0,          0},
    {-sin(angle), 0, cos(angle), 0},
    {0,           0, 0,          1}
  };
}

float[][] rotateZMatrix(float angle) {
  return new float[][] {
    {cos(angle), -sin(angle), 0, 0},
    {sin(angle), cos(angle),  0, 0},
    {0,          0,           1, 0},
    {0,          0,           0, 1}
  };
}

float[][] scaleMatrix(float x, float y, float z) {
  return new float[][] {
    {x, 0, 0, 0},
    {0, y, 0, 0},
    {0, 0, z, 0},
    {0, 0, 0, 1}
  };
}

float[][] translationMatrix(float x, float y, float z) {
  return new float[][] {
    {1, 0, 0, x},
    {0, 1, 0, y},
    {0, 0, 1, z},
    {0, 0, 0, 1}
  };
}

/*****************************/
/* Step 2.3 – Matrix Product */
/*****************************/

float[] matrixProduct(float[][] a, float[] b) {
  float[] result = new float[a.length];
  
  for(int i = 0 ; i != a.length; ++i) {
    float sumProduct = 0.0;
    for(int j = 0; j != a[0].length; ++j) {
      sumProduct += a[i][j] * b[j];
    } //end j
    
    result[i] = sumProduct;
  } //end i
  
  return result;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] result = new My3DPoint[box.p.length];
  
  for(int i = 0; i != box.p.length; ++i) {
    My3DPoint p = box.p[i];
    result[i] = euclidian3DPoint(matrixProduct(transformMatrix, new float[] {p.x, p.y, p.z, 1}));
  }
  
  return new My3DBox(result);
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}