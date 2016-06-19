float dt = 1/30.0;

float lineaDisparo = 0;

Bola b;
PVector raton;
 
void setup(){
  size(500,500);
}
void draw(){
  background(255);
   
  line(200, 250, 300, 250);
  line(250, 200, 250, 300);
   
  raton = new PVector(mouseX,mouseY);
  PVector centro = new PVector(width/2,height/2);
   
  //colocamos la linea que apunta hacia el ratón en el centro
  raton.sub(centro);
  lineaDisparo = sqrt((raton.x*raton.x)+(raton.y * raton.y));
  raton.x = raton.x/ lineaDisparo;
  raton.y = raton.y/ lineaDisparo;
  raton.mult(50);
   
  translate(width/2,height/2);
  line(0,0,raton.x,raton.y);
  fill(255,0,0);
  
  if(b != null)
    b.pintar();
}

void mouseClicked()
{
  b = new Bola(raton.x, raton.y);
}

class Bola
{
  float posX, posY;
  float v = 20;
  float direccionX, direccionY;
  
  Bola(float pX, float pY)
  {
    posX = pX;
    posY = pY;
    direccionX = posX;
    direccionY = posY;
  }
  
  public void pintar()
  {
     fill(255, 0, 0);
     ellipse(posX, posY, 15, 15);
     
     posX += v*dt + direccionX/8;
     posY += v*dt + direccionY/8;
  }
}