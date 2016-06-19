float  dt = 0.7;

Extremo[] vExtr = new Extremo[5]; //nExtremos = nMuelles+1
Muelle[] Muelles = new Muelle[4]; //nMuelles                    

void setup() {
  size(600, 600);

  for (int i = 0; i < vExtr.length; i++) {
    vExtr[i] = new Extremo(width*0.5 + i*20, -20);
  }

  for (int i = 0; i < Muelles.length; i++) {
    Muelles[i] = new Muelle(vExtr[i], vExtr[i+1], 20);
  }
}

void draw() {
  background(255);

  for (Muelle m : Muelles) {
    m.update();
    m.display();
  }
  for (int i = 1; i < vExtr.length; i++) {
    vExtr[i].update();
    vExtr[i].display();
    vExtr[i].drag(mouseX, mouseY);
  }

  //texto
  fill(0);
  text("Euler Semi (Con amortiguación)", 20, 20);
  text("Se puede agarrar un muelle con el ratón", 20, 40);
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
    longReposo = lReposo;
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
  void update() {
    applyForce(grav); //aplicamos la gravedad

    //Cálculo de velocidad y pos
    velocity.x = velocity.x + acceleration.x * dt;
    velocity.y = velocity.y + acceleration.y * dt;
    location.x = location.x + velocity.x * dt;
    location.y = location.y + velocity.y * dt;

    //Reseteamos la aceleración
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