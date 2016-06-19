PVector vel;
float h, f;
float dt = 0.1;
int cont = 0;

float g = -9.8;

//propiedades de la particula floatante
PVector pos;
PVector acceleration;

PVector fuerz_grav; //fuerza de gravedad
PVector fuerz_flot; //fuerza de flotación
PVector fuerz_roz; //fuerza de rozamiento

float densidad = 0.007;
float vol_sum; //volumen sumergido de la particula
float acc = 0;
float radio = 20;
float masa = 20;

ArrayList <Particulas> ps;
int num_particulas;

void setup() {
  size(600, 500);
  background(255);

  pos = new PVector(600/2, 0);
  vel = new PVector(0, 0);
  acceleration = new PVector(0, 0);
  
  fuerz_grav = new PVector(0, 0);
  fuerz_flot = new PVector(0, 0);
  fuerz_roz = new PVector(0, 0);
  
  radio = 20;
  num_particulas = 30;

  //creamos el array de particulas splash
  ps =new ArrayList<Particulas>();
  
  
}

void draw() {
  background(255);

  //la particula está parcialente sumergida
  if (pos.y+radio >= height/2 && pos.y-radio < height/2) {
    h = pos.y + radio - height/2;
    acc = sqrt(2*h*radio-h*h);
    vol_sum = (3*acc*acc+h*h*PI*h)/6;
    
    //aplicamos las fuerzas de flotabilidad y rozamiento
    fuerz_flot.y = densidad*vol_sum*g;
    fuerz_roz.y = -vel.y*5;
    
    applyForce(fuerz_flot);
    applyForce(fuerz_roz);
  }
  //la particula está totalmente sumergida
  else if (pos.y+radio >= height/2) {
    vol_sum = 4*PI*radio*radio*radio/10;
    
    //aplicamos las fuerzas de flotabilidad y rozamiento
    fuerz_flot.y = densidad*vol_sum*g;
    fuerz_roz.y = -vel.y*5;
    
    applyForce(fuerz_flot);
    applyForce(fuerz_roz);
  }

  //Aplicamos la gravedad y euler
  Euler();

  //Dibujamos el agua
  fill(0, 0, 255);
  stroke(0, 0, 255);
  rect(0, height/2, width, height/2);

  //Dibujamos la particula
  stroke(0);
  fill(255, 0, 0);
  ellipse(pos.x, pos.y, radio, radio);
  
  //cuando la partícula da al mar, creamos las particulas del agua que rebotarán
  if (pos.y+radio > (height/2)-3 && pos.y+radio < (height/2)) {
    ps.add(new Particulas(num_particulas, new PVector(width/2, height/2)));
  }
  
  //ejecutamos las particulas en el interior del array de particulas
  for(int i = 0; i < ps.size();i++)
  {
    Particulas part = ps.get(i);
    part.run();
  }

  //reiniciamos la aceleracion
  acceleration.x=0;
  acceleration.y=0;
}

//Aplicamos la gravedad y euler
void Euler()
{
  fuerz_grav.y = -masa*g;
  applyForce(fuerz_grav);

  vel.y += acceleration.y*dt;
  pos.y += vel.y*dt;
}

//Aplicamos la fuerza pasada en la función
void applyForce(PVector force) {
  PVector f = force.get();
  f.div(masa);
  acceleration.add(f);
}

class Particulas {

  //Almacenamos un array de particulas y su posicion inicial
  ArrayList<Particle> particulas;    
  PVector pos_inicial;                   

  Particulas(int num_p, PVector pos) {
    
    particulas = new ArrayList<Particle>();
    pos_inicial = pos.get();
    
    //Añadimos las particulas indicadas en el array
    for (int i = 0; i < num_p; i++) {
      particulas.add(new Particle(pos_inicial)); 
    }
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

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector loc) {
    acceleration = new PVector(random(-0.03, 0.03), 0.05);
    velocity = new PVector(random(-2, 2), -2);
    location = loc.get();
    
    //tiempo de vida
    lifespan = 100.0;
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1;
  }

  void display() {
    stroke(0, 0, 255, 125);
    fill(0, 0, 255, 125);
    ellipse(location.x, location.y, 4, 4);
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}