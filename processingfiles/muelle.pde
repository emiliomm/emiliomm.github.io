float dt = 0.1;
float g = -9.8;//gravedad

//Muelles
muell a, b, c, d;

void setup() {
  size(800,300);
  stroke(0,0,0);
  strokeWeight(2);
  
  a = new muell(100,100,2,100,-0.6,0,0); //Euler exp. sin amortiguacion
  b = new muell(300,100,2,100,-0.6,0.2,0); //Euler exp. con amortiguacion
  c = new muell(500,100,2,100,-0.6,0,1); //RK2 sin amortiguacion
  d = new muell(700,100,2,100,-0.6,0.2,1); //RK2 con amortiguacion
}

 
void draw() {
  background(255);
  
  line(0,10,width,10);
  
  a.update();
  b.update();
  c.update();
  d.update();
  
  line(a.pos.x,10,a.pos.x,a.pos.y);
  line(b.pos.x,10,b.pos.x,b.pos.y);
  line(c.pos.x,10,c.pos.x,c.pos.y);
  line(d.pos.x,10,d.pos.x,d.pos.y);
  
  fill(255,0,0);
  ellipse(a.pos.x,a.pos.y,30,30);
  
  fill(255,160,122);
  ellipse(b.pos.x,b.pos.y,30,30);
  
  fill(0,0,255);
  ellipse(c.pos.x,c.pos.y,30,30);
  
  fill(160,122,255);
  ellipse(d.pos.x,d.pos.y,30,30);
 
  fill(0,0,0);
  text("Euler exp. sin amortiguación", 35, height-50);
  text("Euler exp. con amortiguación", 235, height-50);
  text("RK2 sin amortiguación", 435, height-50);
  text("RK2 con amortiguación", 635, height-50);
}

class muell{
  
  float m;
  float long_reposo;
  
  float ks; //elasticidad
  float kd; //amortiguación
  
  int mode; //0 Euler, 1 RK2
  
  PVector acc;
  PVector vel;
  PVector pos;
  
  muell(int posX, int posY, float masa, float l_reposo, float k_s, float k_d, int modo)
  {
    m = masa;
    long_reposo = l_reposo;
    ks = k_s;
    kd = k_d;
    mode = modo;
    
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    pos = new PVector(posX,posY);
  }
  
  float devuelveAcc(float POS, float VEL)
  {
  PVector Fk = new PVector(0,0);
  PVector Fs = new PVector(0,0);
  PVector Fd = new PVector(0,0);
  PVector Ft = new PVector(0,0);
  
  float aceleracion = 0.0;
   
  Fs.y = ks * (POS - long_reposo);//ley de hooke
  Fd.y = kd * VEL; //fuerza de amortiguacion
  Fk.y = Fs.y - Fd.y; //Ley de hooke con amortiguacion
  Ft.y = Fk.y + (m*g); //fuerza total
  aceleracion = Ft.y / m;
   
  return aceleracion;
  }
  
  void update()
  {
    switch(mode)
    {
      case 0://euler explicito
      acc.y = devuelveAcc(pos.y, vel.y);
      pos.y = pos.y + vel.y * dt;
      vel.y = vel.y + acc.y * dt;
      break;
      case 1://rk2
      PVector vel_media = new PVector();
      PVector pos_media = new PVector();
      PVector acc_media = new PVector();
      
      //Calculamos la aceleracion
      acc.y = devuelveAcc(pos.y, vel.y);
      
      //vel punto medio
      vel_media.x = vel.x + acc.x * (dt/2.0);
      vel_media.y = vel.y + acc.y * (dt/2.0);
       
      //pos punto medio
      pos_media.x = pos.x + vel.x * (dt/2.0);
      pos_media.y = pos.y + vel.y * (dt/2.0);
       
      //calculamos la aceleracion en el punto medio
      acc_media.y = devuelveAcc( pos_media.y, vel_media.y);
       
      //vel actual con acc punto medio
      vel.x = vel.x + acc_media.x * dt;
      vel.y = vel.y + acc_media.y * dt;
       
      //pos actual con vel media
      pos.x = pos.x + vel_media.x * dt;
      pos.y = pos.y + vel_media.y * dt; 
      break;
    }
  }
}