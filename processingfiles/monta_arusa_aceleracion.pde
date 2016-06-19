PVector location;
PVector velocity1, velocity2, velocity3;
float acceleration = 0.0;
float dt = 1/30.0;
int pendiente = 0; //pendiente actual en grados

void setup() {
  size(800, 500);
  location = new PVector(8, 350);
  
  //lAS VELOCIDADES INICIALES PARA LAS DIFERENTES PENDIENTES
  velocity1 = new PVector(50, 0);
  velocity2 = new PVector(12.5,-12.5);
  velocity3 = new PVector(25, 25);
}

void draw() {
  background(255);

  //Dibujamos las lineas con las pendientes indicadas
  stroke(0);
  line(0, 350, 200, 350);                               // 0º pendiente
  line(200, 350, 400, 150);                             // 45º pendiente
  line(400, 150, 600, 350);                             // 45º pendiente
  line(600, 350, 800, 350);                             // 0º pendiente

  if (location.x > 0 && location.x < 200){            
      acceleration = 0;
      velocity1.x += acceleration*dt;                          
      velocity1.y += acceleration*dt;
      location.x += velocity1.x*dt;
      location.y += velocity1.y*dt;
      pendiente= 0;
      fill(0);
      text("Velocidad en X: "+velocity1.x,400,425);
      text("Velocidad en Y: "+velocity1.y,400,450);
    } else if (location.x >= 200 && location.x < 400){   // Velocidad reducida a un tercio de la inicial
      acceleration = 0.25;
      velocity2.x -= acceleration*dt;
      velocity2.y += acceleration*dt;
      location.x += velocity2.x*dt;
      location.y += velocity2.y*dt;
       pendiente= 45;
      fill(0);
      text("Velocidad en X: "+velocity2.x,400,425);
      text("Velocidad en Y: "+velocity2.y,400,450);   
    } else if (location.x > 400 && location.x < 600){   // Velocidad reducida a la mitad de la inicial
      acceleration = 5;
      velocity3.x += acceleration*dt;
      velocity3.y += acceleration*dt;
      location.x += velocity3.x*dt;
      location.y += velocity3.y*dt;
      fill(0);
      text("Velocidad en X: "+velocity3.x,400,425);
      text("Velocidad en Y: "+velocity3.y,400,450);    
    } else if(location.x > 600 && location.x < 800){
      acceleration = 0;
      velocity1.x += acceleration*dt;
      velocity1.y += acceleration*dt;
      location.x += velocity1.x*dt;
      location.y += velocity1.y*dt;
      pendiente= 0;
      fill(0);
      text("Velocidad en X: "+velocity1.x,400,425);
      text("Velocidad en Y: "+velocity1.y,400,450);
    }
  
  text("Pendiente: " + pendiente,400,400);

  //Dibujamos la bola
  stroke(0);
  strokeWeight(1);
  fill(255,0,0);
  ellipse(location.x, location.y, 16, 16);
  
  //Si la bola se sale de la ventana, vuelve a la posicion inicial
  if (location.x > 800) {
    location.x = 8;
    location.y = 350;
  } 
}