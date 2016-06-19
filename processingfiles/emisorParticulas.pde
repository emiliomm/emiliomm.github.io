float dt = 0.1;
float g = -9.8;

int num_filas = 8; //num filas del emisor

PVector fuerz_grav; //fuerza de gravedad

Particulas ps;

int num_particulasCreadas = 0; //num de particulas creadas por el momento
 
void setup()
{
  size(800,600);
  
  fuerz_grav = new PVector(0, 0);
  PVector center = new PVector(width/2, height/2);
  
  ps = new Particulas(center);
}
 
void draw()
{
  background(255);
  ps.addParticula();
  ps.run();
}

class Particulas
{
  ArrayList<Particle> particulas;
  PVector pos_inicial;
   
  Particulas(PVector place)
  {
    particulas = new ArrayList<Particle>();
    pos_inicial = place.get();
  }
   
  void addParticula()
  {
    Particle p = new Particle(pos_inicial);
    particulas.add(p);
  }
   
  //Ejecutamos las particulas contenidas en el array
  //y comprobamos si deben dejar de existir
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

class Particle
{
  float masa = 1.2;
  
  float angulo;
  PVector vecAngulo;
  //fuerza aplicada a la velocidad inicial
  float mag = 40;
  
  int fila; //numero de fila en la que la partícula saldrá del emisor
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float lifespan;
   
  Particle(PVector pos)
  {
    fila = num_particulasCreadas % num_filas;
    num_particulasCreadas++;
    
    //calculamos el angulo según la fila de la particula
    angulo = (60+10*fila) * PI/180;
    vecAngulo = new PVector(cos(angulo), sin(angulo));
    velocity = PVector.mult(vecAngulo,mag);
    
    location = pos.get();
    acceleration = new PVector(0,0);
    
    //tiempo de vida
    lifespan = 400.0;
  }
  
   void run()
  {
    update();
    display();
  }
   
  void update()
  {
    fuerz_grav.y = -masa*g;
    applyForce(fuerz_grav);
    
    //Utilizamos euler semiimplicito
    velocity.sub(PVector.mult(acceleration, dt));
    location.sub(PVector.mult(velocity, dt));
    acceleration.set(0,0);
    lifespan -= 1;
  }
  
  void applyForce(PVector force)
  {
    PVector f = force.get();
    f.div(masa);
    acceleration.add(f);
  }
 
  void display()
  {
    stroke(255,0,0);
    fill(255,0,0);
    ellipse(location.x,location.y,6,6);
  } 
   
  boolean isDead()
  {
    if(lifespan<0.0)
      return true;
    else
      return false;
  }
}