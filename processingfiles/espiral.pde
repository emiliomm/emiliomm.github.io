float dt = 0.08;
float t = 0;

float radio = 200;
 
void setup(){
  size(670,600);
  
  background(255);
  smooth();
}
 
void draw(){
  fill(255,0,0);
  
  ellipse(width/2 + radio * cos(t), height/2 + radio * sin(t), 15, 15);
     
  if(radio <= 0)
     dt = 0;
  else{
    radio --;
    t += dt; 
  }
  
  //lineas
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
}