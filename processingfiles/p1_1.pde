final int EULER = 0;
final int EULER_SEMI = 1;


int modo = 0; 


Extremo[] vExtr = new Extremo[1];
Extremo[] vFijos = new Extremo[2];
Muelle[] vMuelles = new Muelle[2];




void setup() {
  size(640, 360);

  vFijos[0] = new Extremo(width*0.5, (1.0/8.0)*height);
  vFijos[1] = new Extremo(width*0.5, (7.0/8.0)*height);



  vExtr[0] = new Extremo(0.5*width, 0.5*height);



  vMuelles[0] = new Muelle(vFijos[0], vExtr[0]);
  vMuelles[1] = new Muelle(vFijos[1], vExtr[0]);

}

void draw() {
  background(255); 
  for (int i = 0; i < vMuelles.length; i++) {
    vMuelles[i].update();
    vMuelles[i].display();
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


class Muelle { 

  float len_reposo;
  float len;
  PVector dir;
  float k = 15.0;
  PVector fuerza;

  Extremo a;
  Extremo b;

  Muelle(Extremo a_, Extremo b_) {
    a = a_;
    b = b_;
    len_reposo = sqrt((b.location.x - a.location.x)*(b.location.x - a.location.x) + (b.location.y - a.location.y)*(b.location.y - a.location.y));
    len = len_reposo;
    dir = new PVector();
    fuerza = new PVector();
  } 


  void update() {

    len = sqrt((b.location.x - a.location.x)*(b.location.x - a.location.x) + (b.location.y - a.location.y)*(b.location.y - a.location.y));

    dir = new PVector(b.location.x - a.location.x, b.location.y - a.location.y);
    dir.normalize();

    fuerza.x = -k * (len - len_reposo) * dir.x;
    fuerza.y = -k * (len - len_reposo) * dir.y;

    b.applyForce(fuerza);

    PVector fuerza2 = new PVector(0,0);
    fuerza2.x = k * (len - len_reposo) * dir.x;
    fuerza2.y = k * (len - len_reposo) * dir.y;

    a.applyForce(fuerza2);
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
  float mass = 10.0, dt = 0.4;
  PVector gravity;
  PVector force;




  float damping = 0.5;

  PVector dragOffset;
  PVector amortiguamiento;
  boolean dragging = false;

  // Constructor
  Extremo(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    force = new PVector(0,0);
    gravity = new PVector(0, 9.8);


    dragOffset = new PVector();
  } 



  // Standard Euler integration
  void update(int mode) { 


    applyForce(gravity);

    switch(mode) {
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

  // Newton's law: F = M * A
  void applyForce(PVector force) {



    acceleration.add(new PVector(force.x/mass, force.y/mass));
  }


  void display() { 
    stroke(0);
    strokeWeight(2);
    fill(255, 0, 0);
    if (dragging) {
      fill(50);
    }
    ellipse(location.x, location.y, mass*2, mass*2);

  }

  void clicked(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < mass) {
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