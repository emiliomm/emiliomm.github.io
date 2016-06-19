Particulas ps;
 
void setup() {
  size(640,360);
  
  PVector pos = new PVector(width/2,height);
  ps = new Particulas(pos);
}
 
void draw() {
 background(255);
 ps.addParticle();
 ps.run();
}
 
class Particulas
{
  ArrayList<Particle> particulas;
  PVector pos_inicial;
  
  float tam;
 
  Particulas(PVector location) {
    pos_inicial = location.get();
    particulas = new ArrayList<Particle>();
  }
 
  void addParticle()
  {
    particulas.add(new Particle(pos_inicial, random(7, 15)));
  }
 
  void run() {
    for (int i = particulas.size()-1; i >= 0; i--) {
      Particle p = particulas.get(i);
      p.run();
      if (p.isDead()) {
        particulas.remove(i);
      }
    }
  }
}

 
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float tam;
  float lifespan;
  float opacidad; 
 
  Particle(PVector loc, float mas) {
    location = loc.get();
    velocity = new PVector(random(-0.2,0.2),-0.4);
    acceleration = new PVector(0,0);
    tam = mas;
    lifespan = 500;
     opacidad = 150;
  }
 
  void run() {
    update();
    display();
}
 
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    
    //Cambiamos las propiedades de la partícula
    lifespan -= 1.0;
    tam -= 0.01;
    opacidad -= 0.5;
  }
 
  void display() {
    stroke(255,0,0, opacidad);
    fill(255,0,0, opacidad);
    ellipse(location.x,location.y, tam, tam);
  }
   
  boolean isDead() {
    if (lifespan<0.0)
      return true;
    else
      return false;
  }
}