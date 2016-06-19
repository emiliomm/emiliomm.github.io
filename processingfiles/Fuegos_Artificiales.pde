ArrayList<Cohete> castillo;
int npart = 0;
float dt = 0.12;

//Dirección del viento
PVector viento;


void setup() {
  size(1080, 720);

  //el castillo es un array de cohetes
  viento = new PVector(0, 0);
  castillo = new ArrayList<Cohete>();
  npart = 0;
  
}


void draw() {
  background(0);

  for (int i=0; i<castillo.size(); i++) {
    Cohete c = castillo.get(i);
    c.run();
  }



  //escribe en la pantalla el numero de particulas actuales

  fill(255);
  text("Frame-Rate: " + frameRate, 15, 15);
  text("Numero de particulas: " + npart, 15, 35);
  text("Direccion del viento en el eje x: " + viento.x, 15, 55);
  text("Direccion del viento en el eje y:" + viento.y, 15, 75);
  text("Utiliza las flechas del teclado para cambiar", 840, 15);
  text("la dirección del viento", 840, 35);
  
}

//Podeis usar esta funcion para controlar el lanzamiento delcastillo
//cada vez que se pulse el rat�n se lanza otro cohete
//puede haber simultaneamente varios cohetes  (castillo = vector de cohetes )
void mousePressed() {
  PVector pos = new PVector(mouseX, mouseY);

  //--->definir un color.Puede ser aleatorio usando random()
  color miColor = color(random(0, 255), random(0, 255), random(0, 255));

  Cohete c = new Cohete (pos, miColor);
  castillo.add(c);
}

void keyPressed()
{
  if (keyCode == LEFT)
    viento.x--;

  if (keyCode == RIGHT)
    viento.x++;

  if (keyCode == UP)
    viento.y--;

  if (keyCode == DOWN)
    viento.y++;
}

class Cohete {
  //el cohete tiene dos tipos de particulas: la carcasa (una sola) y elsistema de particulas (vector) que forman los puntos de luz
  Particle carcasa;
  ArrayList<Particle> particles;


  //lugar de donde sale la particula
  PVector origin;

  color colorParticulas;

  //esta bandera sirve para indicar cuando se debe explotar la carcasa y pasar de una particula a un sistema de particulas
  boolean explotar;

  int tiempoExplosion;



  Cohete(PVector location, color c) {
    origin = location.get();

    //array de particulas luminosas.Aun NO SE CREAN las particulas concretas
    particles = new ArrayList<Particle>();
    colorParticulas = c;
    explotar = true;

    tiempoExplosion = 100;

    //Este metodo crea la particula carcasa
    crearCarcasa(location);
  }

  void crearCarcasa(PVector loc) {

    //--->se deben de configurar todos los parametros de la carcasa, en concreto  su velocidad inicial (que podeis hacer variable dentro de unos limites)
    //--->tambien el retardo de la explosion


    //--->PVector velocidad = new PVector(.....;
    //--->carcasa = new Particle(....;
    PVector v_inicial = new PVector(0, -75);
    carcasa = new Particle(loc, v_inicial, tiempoExplosion, "cohete", color(255, 255, 255));
  }

  //el argumento pos del siguiente metodo es la posicion donde explota la carcasa
  //este metodo se llama en run()

  void addParticles(PVector pos) {
    PVector velocidad = new PVector(0, 0);
    float ang = 0;
    int time2liveParticulas = int(random(50, 150));

    switch (int(random(1, 4))) {
      //--->COHETE CIRCULAR
    case 1:
      for (int i=0; i<360; i++) {


        float v = random(1, 10);
        //--->preparar una velocidad con una nueva direccion
        velocidad = new PVector(v, v);

        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        //--->a�adir al vector particles una o varias particulas en esa direccion 
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;


      //--->COHETE Estrella 5 puntas
    case 2:
      ang = random(0, 71);
      for (int i=0; i<360; i++) {


        float v = random(1, 10);
        //--->preparar una velocidad con una nueva direccion
        velocidad = new PVector(v, v);

        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        //--->a�adir al vector particles una o varias particulas en esa direccion 
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 72*2*PI/360;
      }


      break;

      //--->COHETE Estrella 6 puntas
    default:
    case 3:
      ang = random(0, 59);
      for (int i=0; i<360; i++) {


        float v = random(1, 10);
        //--->preparar una velocidad con una nueva direccion
        velocidad = new PVector(v, v);

        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        //--->a�adir al vector particles una o varias particulas en esa direccion 
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", color(180, 180, 255));
        particles.add(p);

        ang += 60*2*PI/360;
      }


      break;

      //--->/ETC.
    }
  }

  //Funcion de control del cohete que no deberiais tocar
  void run() {


    if (!carcasa.isDead()) { 
      //Simulacion carcasa
      carcasa.run();
    } else if (carcasa.isDead() && explotar) {
      //Frame de preparacion de las particulas para la  explosion
      npart--;
      explotar = false;

      //aqui se reservan los objetos particula
      addParticles(carcasa.getLocation());
    } else {
      //Simulacion de la palmera pirot�cnica (sistema de particulas)
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.run();
        if (p.isDead()) {
          npart--;
          //Si la particula ha agotado su existencia,se elimina del vector usando el metodo remove() de la clase ArrayList
          particles.remove(i);
        }
      }
    }
  }
}

class Particle {
  PVector F;
  PVector acceleration;
  PVector velocity;
  PVector location;

  float masa;
  float lifespan;
  int ttl;
  boolean anyadida;

  //Hay dos tipos de particula identificada por una etiqueta
  //El tipo "carcasa" es una particula de gran tama�o que simular� en su ascensi�n la carcasa
  //El tipo "particula" que representa un punto de color cuando la carcasa haya explotado
  String tipo;

  color Color;

  Particle(PVector l, PVector v, int time2live, String type, color c) {
    F = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    velocity = v.get();
    location = l.get();

    masa = 1;

    ttl = time2live;
    anyadida = false;
    tipo = type;
    Color = c;
  }


  void run() {
    //---> Solo la primera vez que se ejecute run(), se aumenta npart
    //para ello usar el atributo 'anyadida '  que se pondra a true la primera vez,cuando se cuenta la particula
    if (!anyadida)
    {
      npart++;
      anyadida = true;
    }

    update();
    display();
  }

  // Method to update location
  void update() {
    actualizaFuerza();

    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration = new PVector(F.x/masa, F.y/masa);

    //--->utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.x = velocity.x + acceleration.x*dt;
    velocity.y = velocity.y + acceleration.y*dt;

    location.x = location.x + velocity.x*dt;
    location.y = location.y + velocity.y*dt;

    ttl--;  //descuenta el tiempo de vida de la particula
  }

  void actualizaFuerza() {

    //--->la fuerza tiene dos componentes. En uno, siempre  actua la gravedad
    //la fuerza del viento se puede acoplara la otra componente de la fuerza de la particula (o incluso a las dos)
    PVector g = new PVector(0, 9.8);

    F.x = g.x+viento.x;
    F.y = g.y+viento.y;
  }

  PVector getLocation() {
    return location;
  }

  // Method to display
  void display() {
    if (tipo == "particula") {
      stroke(Color, ttl);
      fill(Color, ttl);
      ellipse(location.x, location.y, 2, 2);
    } else {
      stroke(255);
      fill(255);
      ellipse(location.x, location.y, 5, 5);
    }
  }

  // Sirve para eliminar de la clase cohete a dicha particula
  boolean isDead() {
    if (ttl < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}