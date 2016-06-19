PVector pos;

float dt = 1/60.0;

float t = 0;

// Una vuelta por segundo
float T = 1;
//radio
float r = 50.0;

void setup() {
  size(400, 400);
  pos = new PVector(100, 100);
}

void draw() {
  background(255);

  stroke(75);
  fill(255);
  ellipse(width/2, height/2, 100, 100);
  
  t += dt;

  //Se utiliza la fórmula: radio*sin(w*t) y radio*cos(w*t)
  //w = 2*PI/T
  pos.x = r*sin(TWO_PI*t/T);
  pos.y = r*cos(TWO_PI*t/T);

  stroke(0);
  fill(255,0,0);
  translate(pos.x, pos.y);
  ellipse(width/2, height/2, 16, 16);
}