float radio;

float k;//rozamiento

float dt = 0.5;

//Variables dibujo grafica
float[] p_graficas;
int num = 0;
int num_max = 700;
int altura_grafica = 100;
boolean dibujotodo = false;

PVector position = new PVector(0,0);

Coche coche;
 
void setup() {
  size(700,600);
  k = 0.1;
  radio = 30;
  
  p_graficas = new float[700];
   
  coche = new Coche(1, 50);
}
 
void draw() {
  background(255);
  position.x = position.x + coche.vel * dt;
  coche.UpdateVelo();
   
  line(0,height/2,width,height/2);
  
  fill(255,0,0);
  ellipse(position.x,height/2-radio/2,radio,radio);
  fill(133);
  
  if (keyPressed) {
    if(keyCode == UP)
    {
      coche.AplicarPotencia();
    }
  }
  
  //Nos pasamos de la ventana
  if (position.x-radio > width)
    position.x = 0;
  
  //grafica
  DibujaGrafica();
}

void DibujaGrafica()
{
  if (num>=num_max)
  {
    num = 0;
    dibujotodo = true;
  }
  p_graficas[num] = coche.vel;
  num++;
  
  stroke(233, 6, 6);
  strokeWeight(4);
  line(num-1,altura_grafica-10,num-1,altura_grafica);
  
  text("Pulsa flecha arriba para aumentar la potencia", 435, height-50);
  
  noFill();
  stroke(0);
  strokeWeight(1);
  beginShape();
  if (dibujotodo)
  {
    for (int i = 0; i < num_max; i += 2) {
     curveVertex(i, altura_grafica-p_graficas[i]); // the first control point
    }
  }
  else
  {
    for (int i = 0; i < num; i += 2) {
     curveVertex(i, altura_grafica-p_graficas[i]); // the first control point
    }
  }
  endShape();
}

class Coche {
  float masa;
  float vel;
  float Ec;
  float pot;
   
  Coche(float mas, float potencia) {
    masa = mas;
    pot = potencia;
    vel = 0;
    Ec = 0;
  }
  
  void UpdateVelo() {
    vel = sqrt(Ec*2/masa);
    Ec = Ec + (-k*vel*vel*dt);
  }
  
  void AplicarPotencia() {
    Ec = pot * dt;
  }
}