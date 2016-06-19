PVector location;
PVector velocity;
float dt = 1/30.0;
int pendiente = 0; //pendiente actual en grados

void setup() {
  size(600, 500);
  location = new PVector(8, 250);
  velocity = new PVector(50, 0);
}

void draw() {
  background(255);

  //Dibujamos las lineas con las pendientes indicadas
  stroke(0);
  //0º
  line(0, 250, 100, 250);    
  //45º
  line(100, 250, 200, 150);
  //30º
  line(200, 150, 300, 150-(100/cos(PI/6))*sin(PI/6));
  //30º
  line(300, 150-(100/cos(PI/6))*sin(PI/6), 400, 150);
  //45º
  line(400, 150, 500, 250);
  //0º
  line(500, 250, 600, 250);

  //Calculamos la velocidad
  location.x += velocity.x*dt;         
  location.y += velocity.y*dt;

  //Calculamos la velocidad y la pendiente en cada tramo
  if (location.x > 0 && location.x < 100) {
    pendiente = 0;
  }
  if (location.x > 100 && location.x < 200) {      
    velocity.x = 12.5;
    velocity.y = -12.5;
    pendiente = 45;
  } else if (location.x > 200 && location.x < 300) { 
    velocity.x = 16.666667*2;                         
    velocity.y = -9.623*2;
    pendiente = 30;
  } else if (location.x > 300 && location.x < 400) {   
    velocity.x = 16.666667*2;                        
    velocity.y = 9.623*2;
  } else if (location.x > 400 && location.x < 500) {   
    velocity.x = 57.735*1.75;
    velocity.y = 57.735*1.75;
    pendiente = 45;
  } else if (location.x > 500 && location.x < 600) {  
    velocity.x = 50;
    velocity.y = 0;
    pendiente = 0;
  }
  //Si la bola se sale de la ventana, vuelve a la posicion inicial
  else if (location.x > 600) {
    location.x = 8;
    location.y = 250;
  }  
  
  //Dibujamos la pendiente y la velocidad actuales
  fill(0);
  text("Velocidad X: "+velocity.x, 300, 425);
  text("Velocidad Y: "+velocity.y, 300, 450);
  text("Pendiente: "+pendiente, 300, 475);

  //Dibujamos la bola
  stroke(0);
  strokeWeight(1);
  fill(255,0,0);
  ellipse(location.x, location.y, 16, 16);
}