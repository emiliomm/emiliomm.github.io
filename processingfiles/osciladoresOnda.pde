//funcion1
float[] posX1= new float[700];
float[] posY1= new float[700];

//funcion2
float[] posX2= new float[700];
float[] posY2= new float[700];

float x1 = 0;
float y1 = 0;

float x2 = 0;
float y2 = 0;

void setup() {
  size(650, 500);
  posX1[0]=0;
  posX2[0]=0;
  for (int i=0; i<700-1; i++)
  {
    //funcion1
    posX1[i+1] = posX1[i]+1;
    posY1[i] = sin(posX1[i]/10)*exp(-0.002*posX1[i])*100 + 300;
    
    //funcion2
    posX2[i+1] = posX2[i]+1;
    posY2[i] = sin(3*posX2[i]/10)*100 + 0.5*sin(3.5*posX2[i]/10)*100 + 300;
    
  }
}

void draw() {
  background(255);
  
   //Cuadricula
  for (int i=0; i<height; i+=20) {
    stroke(220,220,220); 
    line(0, i, width, i);
  } 

  for (int i=0; i<width; i+=20) {
    stroke(220,220,220); 
    line(i, 0, i, height);
  }
  
  //avanzamosw la particula a la siguiente posicion
  if (x1<width && y1<height)
  {
    x1 = x1+1;
  }
  else
  {
    //Si la particula avanza más allá de la ventana, vuelve a la posición original
    x1 = 0;
  }
  
  if (x2<width && y2<height)
  {
    x2 = x2+1;
  }
  else
  {
    //Si la particula avanza más allá de la ventana, vuelve a la posición original
    x2 = 0;
  }
  
  y1 = sin(x1/10)*exp(-0.002*x1)*100 + 300;

  //Dibujamos la onda
  for (int i=0; i<700-1; i++)
  {
      stroke(255,0,0); 
      line(posX1[i], posY1[i], posX1[i+1], posY1[i+1]);
  }
  
  fill(255,0,0);
  ellipse(x1, y1, 16, 16);
  
  y2 = sin(3*x2/10)*100 + 0.5*sin(3.5*x2/10)*100 + 300;

  //Dibujamos la onda
  for (int i=0; i<700-1; i++)
  {
      stroke(0,0,255); 
      line(posX2[i], posY2[i], posX2[i+1], posY2[i+1]);
  }
  
  fill(255,0,0);
  ellipse(x1, y1, 16, 16);
  
  fill(0,0,255);
  ellipse(x2, y2, 16, 16);
}