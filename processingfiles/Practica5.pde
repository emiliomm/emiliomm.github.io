//Emilio Montejano Mora

/*
Controles

r = crea ola radial
s = crea ola simple
g = crea ola gestner
e = reiniciamos malla
*/

Malla mar;
float dt = 0.0;

float eyeX = 100, eyeY = 250, eyeZ = 50;

void setup() {
  size(800, 600, P3D);
  mar = new Malla(20, 14, 10);
}

void draw() {
  background(255);

  camera(eyeX, eyeY, eyeZ,100,100, 0, 0, 1, 0);
  
  //Actualizamos la malla
  strokeWeight(0);
  noStroke();
  noFill();
  mar.update();
  mar.display();
} //<>//

void keyPressed(){
   Ola o;
   switch(key)
   {
     //radial
     case 'r':
     o = new Ola(0, random(1,3), random(4,8), random(1,2), random(3,5), new PVector(random(0,1), random(0,1),0), new PVector(30,30,0));
     mar.nuevaOla(o);
     break;
     //simple / direccional
     case 's':
     o = new Ola(1, random(1,2), random(13,16), random(1,2), random(3,5), new PVector(random(0,1), random(0,1),0), new PVector(random(-500,500),random(-500,500),0));
     mar.nuevaOla(o);
     break;
     //gestner
     case 'g':
     o = new Ola(2, random(5,6), random(6,12), random(1,2), random(3,5), new PVector(0, 40,0), new PVector(0,0,0));
     mar.nuevaOla(o);
     break;
     //reiniciamos la malla
     case 'e':
     mar = new Malla(20, 14, 10);
     break;
     default:
     break;
   }
}

class Malla {
  int v_vert; //numero de vertices verticales
  int v_horiz; //numero de vertices horizontales
  int dist_vert;
  
  PVector[][] vertices;
  
  PImage img;
  
  ArrayList<Ola> olas; 

  Malla(int num_vert, int num_hor, int dist) {
    v_vert = num_vert; //número de vertices verticales
    v_horiz = num_hor; //numero de vertices horizontales
    dist_vert = dist; //distancia entre vertices
    
    //Inicializamos las matrices de vectores, olas...
    vertices = new PVector[v_vert][v_horiz];
    olas = new ArrayList<Ola>();

    for (int x = 0; x < v_vert; x++) {
      for (int y = 0; y < v_horiz; y++) {
        vertices[x][y] = new PVector(x*dist_vert, y*dist_vert);
      }
    }
    
    //Cargamos la textura
    img = loadImage("Water_surface_lake.jpg");
  }
  
  void nuevaOla(Ola o)
  {
    olas.add(o);
  }
  
  void update()
  {
     //update seún tipo de ola
    for(int i = 0; i < v_vert; i++){
       for(int j = 0; j < v_horiz; j++){
         
         vertices[i][j].z = 0; //reiniciamos la posicion z a cada update
         
          for(int k=0; k<olas.size(); k++){           
            Ola o = olas.get(k);
            
            switch(o.tipoOla)
            {
              case 0:
              //sumamos el resultado de la onda
              vertices[i][j].z += o.Radial(i, j, dt);
              break;
              case 1:
              //sumamos el resultado de la onda
              vertices[i][j].z += o.Simple(i, j, dt);
              break;
              case 2:
              //Sumamos el resultado de la onda excepto en el eje z
              PVector aux = new PVector();
              aux = o.Gerstner(i, j, dt);
              
              vertices[i][j].x += aux.x;
              vertices[i][j].y += aux.y;
              vertices[i][j].z = aux.z;
              break;
            }
          }
       }
    }
    dt += 0.2; //aumentamos dt
  }

  //Dibujamos la textura y mostramos la bandera
  void display()
  {
    for (int i = 0; i < v_vert - 1; i++) {
      beginShape(QUAD_STRIP);
      texture(img);
      textureMode(IMAGE);
      float u = img.width / v_vert * i;
      
      for (int j = 0; j < v_horiz; j++) {
        stroke(255);
        PVector p = vertices[i][j];
        PVector p1 = vertices[i+1][j];
        
        float v = img.height / v_horiz * j;

        vertex(p.x, p.y, p.z, u, v);
        vertex(p1.x, p1.y, p1.z, u , v);
      }   
      endShape();
    }
  }
}

class Ola {
   
  float A;
  float T;
  float L;
  float C;
  float W;
  int tipoOla;
  PVector dir;
  PVector pos;
   
  Ola(int tipo, float a, float l, float c, float t, PVector direc, PVector posicion){
    tipoOla = tipo;
    
    A = a;
    T = t;
    L = l;
    C = c;
    W = 2*PI/L;
    
    dir = direc;
    pos = posicion;
     
  }
   
  float Simple(float x, float y, float dt){
    float s = PVector.dot(dir,new PVector(x,y));
    float resul = A*cos(W*(s - (C*dt)));
    return resul;
  }
  
  float Radial(float x, float y, float dt){
    float s = dist(x,y,pos.x,pos.y);
    float resul = A*cos(W*(s - (C*dt)));
    return resul;
  }
   
  PVector Gerstner(float x, float y, float dt){   
    //float phi =  2*PI*T;
    float phi = 1;
    
    //float H = 2*A;
    //float Q = (PI*H*C)/L;
    //println(Q);
    
    float Q = 0.1;
       
    //Calculamos la distancia con respecto al empuje
    PVector direccion= new PVector(1, 0, 0);
    PVector emp = new PVector(-x, -y, 0);
    float distancia = PVector.dot(direccion, emp);
     
    PVector resul = new PVector();
    resul.x += Q * A * direccion.x * cos(distancia * W + phi * dt);
    resul.y += Q * A * direccion.x * cos(distancia * W + phi * dt);  
    resul.z += A * sin(distancia * W + phi * dt);  
    return resul;
  }
}