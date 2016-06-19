// Práctica 1 de Simulación
// Miguel Lozano
// Curso 13-14

final int EULER = 0;
final int EULER_SEMI = 1;


int modo = 0; //modo actual


// Extremos 
Extremo[] vExtr = new Extremo[1]; //El vector antes tenia longitud 2, pero solo se usa un extremo
Extremo[] vFijos = new Extremo[2];
Muelle[] vMuelles = new Muelle[2];


//Archivo para almacenar los datos de la curva a representar
//PrintWriter output;


void setup() {
  size(640, 360);
  // Create objects at starting location
 
     //Creación de los puntos fijos A y B
     
     vFijos[0] = new Extremo(width*0.5, (1.0/8.0)*height);
     vFijos[1] = new Extremo(width*0.5, (7.0/8.0)*height);
    
    
    // Creación del extremo común de los muelles
    
    vExtr[0] = new Extremo(0.5*width, 0.5*height);
    
    
    //Creación de los muelles
    
    vMuelles[0] = new Muelle(vFijos[0], vExtr[0]);
    vMuelles[1] = new Muelle(vFijos[1], vExtr[0]);
   
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
    //  output.println(vMuelles[0].len-vMuelles[0].len_reposo); 
  }
  
  if (keyPressed) {
      if(key == '0')
      {
        modo = 0;
      }
      if(key == '1')
      {
        modo = 1;
      }
  }
  
  fill(0);
    text("Modo actual: " + modo, 50, 300);
  text("Pulsa la tecla 0 para la simulación se realice con Euler Exp", 50, 320);
  text("Pulsa la tecla 1 para la simulación se realice con Euler Semi", 50, 330);
 
  for (int i = 0; i < vExtr.length; i++){  
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
void keyPressed(){
  //if(key == 'f' || key == 'F'){
  //  output.flush();
  //  output.close();
  //}
  
}

class Muelle { 

 
  // Constantes de configuraci�n del muelle
  float len_reposo;
  float len;
  PVector dir;
  float k = 15.0;
  PVector fuerza;
  
//Extremos del muelle
  Extremo a;
  Extremo b;
 

  // Constructor
  Muelle(Extremo a_, Extremo b_) {
    a = a_;
    b = b_;
    len_reposo = sqrt((b.location.x - a.location.x)*(b.location.x - a.location.x) + (b.location.y - a.location.y)*(b.location.y - a.location.y));
    len = len_reposo;
    dir = new PVector();
    fuerza = new PVector();
  } 

  // Calculate spring force
  void update() {
//aplicar la fuerza del muelle de acuerdo con laley de Hook.

  len = sqrt((b.location.x - a.location.x)*(b.location.x - a.location.x) + (b.location.y - a.location.y)*(b.location.y - a.location.y));
   
  dir = new PVector(b.location.x - a.location.x, b.location.y - a.location.y);
  dir.normalize();
  
  fuerza.x = -k * (len - len_reposo) * dir.x;
  fuerza.y = -k * (len - len_reposo) * dir.y;
  
  b.applyForce(fuerza);

  PVector fuerza2 = new PVector();
  fuerza2.x = k * (len - len_reposo) * dir.x;
  fuerza2.y = k * (len - len_reposo) * dir.y;
  
  a.applyForce(fuerza2);
  
  

//Recuerda que en un muelle aparecen DOS fuerzas contrarias y de igual magnitud que fuerzan al muelle a recuperearse 

//Definiendo la fuerza como un PVector de processing puede ser �til usar los siguiente m�todos
  //fuerza.mag() devuelve el m�dulo
  //fuerza.normalize()  normaliza el vector
   //fuerza.mult(h)  multiplica elvector por el escalar h  


  }

//dibuja una linea recta que representa al muelle
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
  float mass = 10.0, dt = .4;
  PVector gravity;
  PVector force;
 


      
  // Arbitrary damping to simulate friction / drag 
  float damping = 0.5;

  // For mouse interaction
  PVector dragOffset;
  PVector amortiguamiento;
  boolean dragging = false;

  // Constructor
  Extremo(float x, float y) {
    location = new PVector(x,y);
    velocity = new PVector();
    acceleration = new PVector();
    force = new PVector();
    gravity = new PVector(0, 9.8);
    
    
    dragOffset = new PVector();
  } 



  // Standard Euler integration
  void update(int mode) { 
   
    //Usar el m�todo applyForce para aplicar al extremo la fuerza de la gravedad

    //�Considerar fuerza de amortiguamiento tambi�n?
    
    
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
      //Cuidado!!!  �Vas a conservar la aceleraci�n de un paso de simulaci�n al siguiente?
     acceleration = new PVector(0,0);
  }

  // Newton's law: F = M * A
  void applyForce(PVector force) {
 
   //Dado el vector fuerza, conseguir la aceleraci�n y aplicarla al extremo
   
   
   acceleration.add(new PVector(force.x/mass, force.y/mass));
   

  }


  // Dibujo el extremo como un circulo de radio proporcional a su peso
  void display() { 
    stroke(0);
    strokeWeight(2);
    fill(255,0,0);
    if (dragging) {
      fill(50);
    }
    ellipse(location.x,location.y,mass*2,mass*2);
   
      //Aqu� ser�a un sitio par escribir datos en el fichero


  } 

  // The methods below are for mouse interaction

  // This checks to see if we clicked on the mover
  void clicked(int mx, int my) {
    float d = dist(mx,my,location.x,location.y);
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