PVector location;
PVector velocity;
PVector acceleration;
PVector force;
PVector gravity;

float dt;
float mass;
float ang; //angulo del plano inclinado
float kr; //Constante de rozamiento

void setup() {
  size(640, 360); 
  
  dt = 0.3;
  mass = 20;
  ang = 30;
  kr = 50;
  
  location = new PVector(0,0);
  velocity = new PVector(0,0);
  acceleration = new PVector(0,0);
  force = new PVector(0,0);
  gravity = new PVector(0, 9.8);
}

void draw() {
  background(255);
  update();
  
  line(0,0,width,height);
  fill(255,0, 0);
  ellipse(location.x,location.y-10,20,20); //y = y - radio para que quede bien en el dibujo
}

void update() {
  //Aplicamos las fuerzas
  float f_resultante = (mass*gravity.y*sin(radians(ang))) - (kr * velocity.mag()); 
  force.x = f_resultante*cos(radians(ang));
  force.y = f_resultante*sin(radians(ang));
  
  applyForce(force);
  
  //Aplicamos Euler
  location.x = location.x + velocity.x * dt;
  location.y = location.y + velocity.y * dt;
         
  velocity.x = velocity.x + acceleration.x * dt;
  velocity.y = velocity.y + acceleration.y * dt;
  
  acceleration.set(0,0);
}

void applyForce(PVector force)
{
  acceleration.add(force.x/mass, force.y/mass);
}