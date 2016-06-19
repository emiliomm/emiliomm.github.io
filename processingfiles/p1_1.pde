// Práctica 1 de Simulación
// Miguel Lozano
// Curso 13-14


float dt = 0.8;

final int EULER = 0;
final int EULER_SEMI = 1;


int modo = 0; //modo actual


// Extremos
Extremo[] vExtr = new Extremo[1]; //El vector antes tenia longitud 2, pero solo se usa un extremo
Extremo[] vFijos = new Extremo[2];
Muelle[] vMuelles = new Muelle[2];


//Archivo para almacenar los datos de la curva a representar
//PrintWrinter output;


void setup() {
  size(640, 360);
  // Create objects at starting location
  
  // Creación de los puntos fijos A y B
  
  vFijos[0] = new Extremo(width*0.5, (1.0/8.0)*height);
  vFijos[1] = new Extremo(width*0.5, (7.0/8.0)*height);
  
  
  // Creación del extremo común de los muelles
  
  vExtr[0] = new Extremo(0.5*width, 0.5*height);
  
  
  //Creación de los muelles
  
  vMuelles[0] = new Muelle(vFijos[0], vExtr[0],0);
  vMuelles[1] = new Muelle(vFijos[1], vExtr[0],0);
  
  //Creacion del fichero
  //output = createWriter("Positions.txt");
}

void draw() {
  background(255);
  for (int i = 0; i < vMuelles.length; i++) {
    vMuelles[i].update();
    vMuelles[i].display();
    //Escribimos el fichero
    //if (i==0)
    //  output.prinln(vMuelles[0].len-vMuelles[0].len_reposo);
  }
  
  if (keyPressed) {
    if (key == '0')
    {
      modo = 0;
    }
    if (key == '1')
    {
      modo = 1;
    }
  }
  
  fill(0);
  text("Modo actual: " + modo, 50, 300);
  text("Pulsa la tecla 0 para la simulación se realice con Euler Exp", 50, 320);
  text("Pulsa la tecla 1 para la simulación se realice con Euler Semi", 50, 330);
  
  for (int i = 0; i < vExtr.length; i++) {
    vExtr[i].update(modo);
    vExtr[i].display();
    vExtr[i].drag(mouseX, mouseY);
  }
}

void mousePressed() {
  for (Extremo b : vExtr) {
    b.clicked(mouseX, mouseY);
  }
}

void mouseReleased() {
  for (Extremo b : vExtr) {
    b.stopDragging();
  }
}
void keyPressed() {
  //if(key == 'f' || key == 'F'){
  //  output.flush();
  //  output.close();
  //}
}

class Muelle {
  PVector longActual = new PVector();
  float longReposo;
  float k = 0.4;

  Extremo a;
  Extremo b;

  Muelle(Extremo A, Extremo B, int lReposo) {
    a = A;
    b = B;

    //lReposo
    longReposo = 5;
  }

  void update() {
    longActual = PVector.sub(b.location, a.location);
    float modLongActual = longActual.mag();
    longActual.normalize();
    
    PVector fMuelle1 = new PVector(0, 0);
    PVector fk1 = PVector.mult(longActual, k * (modLongActual - longReposo));
    PVector fk1_amort = PVector.mult(a.velocity, a.damping);
    fMuelle1 = PVector.sub(fk1, fk1_amort); //FUERZA k amortiguada = ks*(l_actual − l_reposo) − kd * vmuelle
    a.applyForce(fMuelle1);
    
    PVector fMuelle2 = new PVector(0, 0);
    PVector fk2 = PVector.mult(longActual, (-k) * (modLongActual - longReposo));
    PVector fk2_amort = PVector.mult(b.velocity, b.damping);
    fMuelle2 = PVector.sub(fk2, fk2_amort); //FUERZA k amortiguada = ks*(l_actual − l_reposo) − kd * vmuelle
    b.applyForce(fMuelle2);
  }

  void display() {
    strokeWeight(2);
    stroke(0);
    line(a.location.x, a.location.y, b.location.x, b.location.y);
  }
}

class Extremo {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float masa = 10;

  PVector grav;

  PVector dragOffset;
  boolean dragging = false;
  float damping; //amort

  // Constructor
  Extremo(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    
    grav = new PVector(0, 9.8);
    
    dragOffset = new PVector();
    
    //Tiene amortiguación
    damping = 0.4;
  }

  //Utilizamos Euler-semi
  void update(int mode) {
    applyForce(grav); //aplicamos la gravedad

    switch(mode){
    case EULER:
      location.add(velocity.mult(dt));
      velocity.add(acceleration.mult(dt));
      break;
    case EULER_SEMI:
      velocity.add(acceleration.mult(dt));
      location.add(velocity.mult(dt));
      break;
    }
    acceleration = new PVector(0, 0);
  }


  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(masa);
    acceleration.add(f);
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    fill(255, 0, 0);

    if (dragging) {
      fill(50);
    }
    
    ellipse(location.x, location.y, masa * 2, masa * 2);
  }

  void clicked(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    
    if (d < masa) {
      dragging = true;
      dragOffset.x = location.x-mx;
      dragOffset.y = location.y-my;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(int mx, int my) {
    if (dragging) {
      location.x = mx + dragOffset.x;
      location.y = my + dragOffset.y;
    }
  }
}