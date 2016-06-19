// Práctica 1 de Simulación
// Miguel Lozano
// Curso 13-14

final int EULER = 0;
final int EULER_SEMI = 1;
final int RK2 = 2;
final int RK4 = 3;

int modo = 0; //modo actual



// Extremos 
Extremo Extr = new Extremo(width*.5, height*.5);
Extremo Fijo = new Extremo(width*.25, height*.5);
Muelle Muellin = new Muelle(Fijo, Extr);


//Archivo para almacenar los datos de la curva a representar
//PrintWriter output;

float v_inicial;


void setup() {
  size(640, 360);
  // Create objects at starting location
 
   v_inicial = 5;
    Extr = new Extremo(width*.625, height*.5, v_inicial);
    Fijo = new Extremo(width*.25, height*.5);
    
    Muellin = new Muelle(Fijo, Extr);
    
   
    //Creacion del fichero
    //output = createWriter("Positions.txt");
}

void draw() {
  background(255); 
  
    strokeWeight(2);
    stroke(0);
    
    if (keyPressed) {
      if(key == '0')
      {
        modo = 0;
      }
      if(key == '1')
      {
        modo = 1;
      }
      if(key == '2')
      {
        modo = 2;
      }
      if(key == '3')
      {
        modo = 3;
      }
      if(key == 'r')
      {
        v_inicial = 5;
    Extr = new Extremo(width*.625, height*.5, v_inicial);
    Fijo = new Extremo(width*.25, height*.5);
    
    Muellin = new Muelle(Fijo, Extr);
      }
    }
    
    line(0, height*0.5 - Extr.mass, width*0.25, height*0.5 - Extr.mass);
    line(width*0.25, height*0.5 - Extr.mass, width*0.25, height*0.5 + Extr.mass);
    line(width*0.25, height*0.5 + Extr.mass, width, height*0.5 + Extr.mass);

    Muellin.update();
    Muellin.display();
    
    Extr.update(modo);
    Extr.display();
    Extr.drag(mouseX);
    
    //v_inicial = 5
    float sol_analitica = sqrt((Muellin.k/Extr.mass)*Muellin.len*Muellin.len+v_inicial*v_inicial);
    
    float error = abs(Extr.velocity-sol_analitica);
    
    //output.println(error); 
    
    fill(0);
    text("Modo actual: " + modo, 300, 300);
  text("Pulsa la tecla R para reiniciar", 300, 310);
  text("Pulsa la tecla 0 para la simulación se realice con Euler Exp", 300, 320);
  text("Pulsa la tecla 1 para la simulación se realice con Euler Semi", 300, 330);
  text("Pulsa la tecla 2 para la simulación se realice con RK2", 300, 340);
  text("Pulsa la tecla 3 para la simulación se realice con RK4", 300, 350);
}

void mousePressed() {
    Extr.clicked(mouseX, mouseY);
}

void mouseReleased() {
    Extr.stopDragging();
}
void keyPressed(){
  //if(key == 'f' || key == 'F'){
  //  output.flush();
  //  output.close();
  //}
  
}  

class Muelle { 
  // Constantes de configuraci�n del muelle
  float len;
  float len_reposo;
  float k = 15.0;
  float fuerza;
  
//Extremos del muelle
  Extremo a;
  Extremo b;
 

  // Constructor
  Muelle(Extremo a_, Extremo b_) {
    a = a_;
    b = b_;
    len_reposo = b.location-a.location;
    len = b.location-a.location;
  } 

  // Calculate spring force
  void update() {
    
    
    len = b.location-a.location;
    
    
    b.actualizarParametros(a.location, k, len_reposo);
    b.force = fuerza;

  }

//dibuja una linea recta que representa al muelle
  void display() {
    strokeWeight(2);
    stroke(0);
    line(a.location, height*.5, b.location, height*.5);
  }
}
  
class Extremo { 
  float location;
  float velocity;
  float acceleration;
  float mass = 10.0, dt = 0.1;
  
  float force; 


  float location_otro_extremo;
  float k;
  float len_reposo;

      
  // Arbitrary damping to simulate friction / drag 
  float damping = 0.5;

  // For mouse interaction
  PVector dragOffset;
  PVector amortiguamiento;
  boolean dragging = false;

  // Constructor
  Extremo(float x, float y) {
    location = x;
    velocity = 0;
    acceleration = 0;
    dragOffset = new PVector() ;
    force = 0;
    } 
  //Constructor con velocidad inicial
    Extremo(float x, float y, float v_ini) {
    location = x;
    velocity = v_ini;
    acceleration = 0;
    dragOffset = new PVector() ;
    force = 0;
    } 


  void actualizarParametros(float l, float k2, float lenrep)
  {
    location_otro_extremo = l;
    k = k2;
    len_reposo = lenrep;
  }
  
  //le pasamos la localizacion
  //devuelve la aceleracion
  float aplicaFuerza(float loc_actual)
  {
    float len = loc_actual-location_otro_extremo;
    force = -k*(len-len_reposo);
    float acc = applyForce(force);
    return acc;
  }
  
  

  // Standard Euler integration
  void update(int mode) { 
   
    acceleration = aplicaFuerza(location);
    //�Considerar fuerza de amortiguamiento tambi�n?
    
    switch(mode) {
      case EULER:
        location = location + velocity * dt;
        velocity = velocity + acceleration * dt;
        
        break;
      case EULER_SEMI:
        velocity = velocity + acceleration * dt;
        location = location + velocity * dt;
        break;
      case RK2:
       float location2, velocity2, acceleration2;
       location2 = location + velocity*dt;
       velocity2 = velocity + acceleration*dt;
       acceleration2 = aplicaFuerza(location2);
       location = location + (velocity + velocity2)*dt/2;
       velocity = velocity + (acceleration2 + acceleration)*dt/2;
       break;
      case RK4:
      float location3, velocity3, acceleration3, location4, velocity4, acceleration4, location5, velocity5, acceleration5;
       location3 = location + velocity*dt/2;
       velocity3 = velocity + acceleration*dt/2;
       acceleration3 = aplicaFuerza(location3);
       
       location4 = location + velocity3*dt/2;
       velocity4 = velocity + acceleration3*dt/2;
       acceleration4 = aplicaFuerza(location4);
       
       location5 = location + velocity4*dt;
       velocity5 = velocity + acceleration4*dt;
       acceleration5 = aplicaFuerza(location5);
       
       float velsum = velocity + velocity3*2+velocity4*2+velocity5;
       float accsum = acceleration + acceleration3*2+acceleration4*2+acceleration5;
       
       location = location + velsum*dt/6;
       velocity = velocity + accsum*dt/6;
        break;
    }
  }

  // Newton's law: F = M * A
  //devuelve aceleracion
  float applyForce(float force) {
     float acc;
     acc = force/mass;
     return acc;
  }


  // Dibujo el extremo como un circulo de radio proporcional a su peso
  void display() { 
    stroke(0);
    strokeWeight(2);
    fill(255, 0, 0);
    if (dragging) {
      fill(0);
    }
    ellipse(location,height*.5,mass*2,mass*2);
   


  } 

  // The methods below are for mouse interaction

  // This checks to see if we clicked on the mover
  void clicked(int mx, int my) {
    float d = dist(mx,my,location,height*.5);
    if (d < mass) {
      dragging = true;
      dragOffset.x = location-mx;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(int mx) {
    if (dragging && mx >= width*0.25 + mass) {
      location = mx + dragOffset.x;
      velocity = 0;
    }
  }
}