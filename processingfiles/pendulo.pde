float dt;
float t;
float g;

Pendul p1, p2, p3;

void setup() {
  size(600, 600);
  background(0);
  
  dt = 1/15.0;
  t = dt*129.0;
  g = 9.8;

  PVector posOrigen = new PVector(300, 0);

  p1 = new Pendul(0, 300, posOrigen);//Pendulo real
  p2 = new Pendul(1, 300, posOrigen);//Pendulo euler exp.
  p3 = new Pendul(2, 300, posOrigen);//Pendulo rk2
}

void draw() {
  background(255);

  p1.update();
  p2.update();
  p3.update();

  p1.dibuja();
  p2.dibuja();
  p3.dibuja();

  textSize(13);
  
  fill(0, 0, 204);
  text("Real", 200, 380);
  fill(0, 204, 0);
  fill(0, 204, 0);
  text("Euler exp", 200, 400);
  fill(204, 0, 0);
  text("RK2", 200, 420);
}

class Pendul{
  int modo;
  
  float theta;//angulo
  float vel;
  float acc;
  float l; //longitud;
  
  PVector pos;
  PVector posOrigen;
  
  Pendul(int mode, float longitud, PVector posorigen)
  {
    modo = mode; //Tipo de pendulo
    
    pos = new PVector();
    posOrigen = posorigen;
    
    l = longitud;
    
    if(modo != 0)
      theta = 1;
    else
      theta = 0;
  }
  
  void update()
  {
    switch(modo)
    {
      case 0://Real
      theta = sin(sqrt(g/l)*t);
       
      pos.x = l * cos(theta + HALF_PI)+posOrigen.x;
      pos.y = l * sin(theta + HALF_PI)+posOrigen.y;
      break;
      case 1://Euler ex.
      theta += vel * dt;
      vel += acc * dt;
      acc = (-1 * g/l) * sin(theta);
       
      pos.x = l * cos(theta+HALF_PI)+posOrigen.x;
      pos.y = l * sin(theta+HALF_PI)+posOrigen.y;
      break;
      case 2://RK2
      acc = (-1 * g/l) * sin(theta);
      float vel2 = vel + acc * dt;
      theta += (vel + vel2) * 0.5 * dt;
      float acc2 = (-1 * g/l) * sin(theta);
      vel += (acc + acc2) * 0.5 * dt;
       
      pos.x = l * cos(theta+HALF_PI)+posOrigen.x;
      pos.y = l * sin(theta+HALF_PI)+posOrigen.y;
      break;
    }
    t+= dt/3.2;
  }
  
  void dibuja()
  {
    switch(modo)
    {
    case 0:
    stroke(0, 0, 204);
    break;
    case 1:
    stroke(0, 204, 0);
    break;
    case 2:
    stroke(204,0,0);
    break;
    }
    strokeWeight(3);
    
    line(posOrigen.x, posOrigen.y, pos.x, pos.y);
    
    switch(modo)
    {
    case 0:
    fill(0, 0, 204);
    break;
    case 1:
    fill(0, 204, 0);
    break;
    case 2:
    fill(204,0,0);
    break;
    }
    
    ellipse(pos.x, pos.y, 50, 50);
  }

}