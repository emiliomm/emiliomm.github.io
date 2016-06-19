PVector location;
PVector velocity;
PVector acceleration;
PVector gravity;

float vel_inicial;
float dt;
float mass;
float ang;

void setup() {
  size(640, 360);
  background(255); 
  
  vel_inicial = 50;
  dt = 0.5;
  mass = 2;
  ang = 300;
  
  location = new PVector(100,300);
  velocity = new PVector(0,0);
  acceleration = new PVector(0,0);
  gravity = new PVector(0, 9.8);
  
  velocity.x = vel_inicial*cos(radians(ang));
  velocity.y = vel_inicial*sin(radians(ang));
}

void draw() {
  update();
  fill(255,0,0);
  ellipse(location.x,location.y,20,20);
}

void update() {
  //Aplicamos las fuerzas
  applyForce(gravity);
  
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