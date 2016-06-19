/* @pjs preload="../img/bandera.jpg"; */

Malla malla;
float dt = 0.5;

void setup() {
  size(800, 600, P3D);
  malla = new Malla(20, 14, 10);
}

void draw() {
  background(122);

  camera(400, 100, 400, 0, 100, 0, 0, 1, 0);

  //Dibujamos el palo
  stroke(255, 255, 255);
  strokeWeight(10);
  line(0, -5, 0, 500);
  
  //Actualizamos la malla
  strokeWeight(0);
  noStroke();
  noFill();
  malla.update();
  malla.display();
} //<>//

class Malla {
  int v_vert; //numero de vertices verticales
  int v_horiz; //numero de vertices horizontales
  int dist_vert;
  float masa;
  PVector[][] vertices;
  PVector[][] fuerzas;
  PVector[][] acceleration;
  PVector[][] velocity;
  PVector[][] normales;
  PImage img;

  Malla(int num_vert, int num_hor, int dist) {
    v_vert = num_vert; //número de vertices verticales
    v_horiz = num_hor; //numero de vertices horizontales
    dist_vert = dist; //distancia entre vertices
    
    //Inicializamos las matrices de vectores, fuerzas, etc.
    vertices = new PVector[v_vert][v_horiz];
    fuerzas = new PVector[v_vert][v_horiz];
    acceleration = new PVector[v_vert][v_horiz];
    velocity = new PVector[v_vert][v_horiz];
    normales = new PVector[v_vert][v_horiz];

    for (int x = 0; x < v_vert; x++) {
      for (int y = 0; y < v_horiz; y++) {
        fuerzas[x][y] = new PVector();
        acceleration[x][y] = new PVector();
        velocity[x][y] = new PVector();
        vertices[x][y] = new PVector(x*dist_vert, y*dist_vert);
        normales[x][y] = new PVector();
      }
    }
    
    masa = 0.5;
    
    //Cargamos la textura
    img = loadImage("img/bandera.jpg");
  }
  
  //Copiado del pdf (ver tema4)
  void update()
  {
    PVector gravity = new PVector(0, 1.2, 0); //con valores mas altos, la bandera quedaba muy baja
    int m_DirectDistance = dist_vert;
    int m_AslantDistance = (int) sqrt(2.0)*m_DirectDistance;
    float k = 0.2;
    float m_Damping = 0.9;
    PVector vDamp = new PVector(0, 0, 0);

    //Recorremos la malla, sumando las fuerzas
    //de las respectivas estructuras
    for (int x = 0; x < v_vert; x++)
    {
      for (int y = 0; y < v_horiz; y++)
      {
        //Reiniciamos la fuerza
        fuerzas[x][y].set(0, 0, 0);
        PVector VertexPos = vertices[x][y];

        fuerzas[x][y] = gravity;         

        //Structured
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x-1, y, VertexPos, m_DirectDistance, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x+1, y, VertexPos, m_DirectDistance, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x, y-1, VertexPos, m_DirectDistance, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x, y+1, VertexPos, m_DirectDistance, k));

        //Bend
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x-1, y-1, VertexPos, m_AslantDistance, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x-1, y+1, VertexPos, m_AslantDistance, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x+1, y-1, VertexPos, m_AslantDistance, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x+1, y+1, VertexPos, m_AslantDistance, k));

        //Shear
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x-2, y, VertexPos, m_AslantDistance*2, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x+2, y, VertexPos, m_AslantDistance*2, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x, y-2, VertexPos, m_AslantDistance*2, k));
        fuerzas[x][y] = PVector.add(fuerzas[x][y], getForce(x, y+2, VertexPos, m_AslantDistance*2, k));

        //Aplicamos el viento
        viento(x, y);

        vDamp.set(velocity[x][y].x, velocity[x][y].y, velocity[x][y].z);
        vDamp.mult(-m_Damping);

        //Si nos encontramos en la primera columna, no
        //aplicamos la fuerza, ya que nuestra bandera se despazaría
        //sin mantenerse fija en el palo
        if (x > 0)
        {
          fuerzas[x][y] = PVector.add(fuerzas[x][y], vDamp); 
          acceleration[x][y] = PVector.div(fuerzas[x][y], masa);
          acceleration[x][y].mult(dt);
          velocity[x][y].add(acceleration[x][y]);
          velocity[x][y].mult(dt);
          vertices[x][y].add(velocity[x][y]);
        }
      }
    }
  }
  
  PVector getForce(int vecinaI, int vecinaJ, PVector VertexPos, int StandardDistance, float k)
  {
    //Comprobamos que no transpasamos los límites
    if ((vecinaI >= 0 ) && (vecinaI < v_vert) &&(vecinaJ >= 0 ) && (vecinaJ < v_horiz))
    {
      //Calculamos la distancia con el vertice vecino
      PVector distancia = new PVector();
      distancia.x = vertices[vecinaI][vecinaJ].x - VertexPos.x;
      distancia.y = vertices[vecinaI][vecinaJ].y - VertexPos.y;
      distancia.z = vertices[vecinaI][vecinaJ].z - VertexPos.z;
      float len = distancia.mag();

      //Calculamos el vector Fuerza y lo devolvemos
      PVector fuerza_resultante = PVector.mult(distancia, (len - StandardDistance) / len);
      fuerza_resultante = PVector.mult(fuerza_resultante, k);
      
      return fuerza_resultante;
    }
    //si no hay vecino, devolvemos un vector 0
    else
    {
      return new PVector(0, 0, 0);
    }
  }
  
  void viento(int vx, int vy)
  {
    PVector arista1, arista2;
    
    //Calculamos el vector normal del vertice considerado
    //Para hacer la fuerza del viento proporcional al producto escalar
    //entre el vector viento y el vector normal
    if (vy % 2 == 0)
    {
      //sacamos dos aristas y calculamos su producto vectorial, obteniendo el v normal
      //para la primera columna
      if (vx == 0)
      {
        arista1 = PVector.sub(vertices[vx+1][vy], vertices[vx][vy]);
        arista2 = PVector.sub(vertices[vx][vy+1], vertices[vx][vy]);
      }
      //para el resto de columnas
      else
      {
        arista1 = PVector.sub(vertices[vx][vy+1], vertices[vx][vy]);
        arista2 = PVector.sub(vertices[vx-1][vy], vertices[vx][vy]);
      }
      
      normales[vx][vy] = arista1.cross(arista2);
      normales[vx][vy].normalize();
    }
    else
    {
      normales[vx][vy] = normales[vx][vy-1];
    }

    // creamos el vector viento
    PVector viento = new PVector();
    
    viento.x = 0.12 + random(3);
    viento.y = 0.012 + random(1,3)*-1;
    viento.z = 0.012 + random(-3,3);

    //normalizamos las normales y las convertimos a positivo
    //una vez hecho esto, lo multiplicamos por el viento
    //con esto calculamos cuanto "afecta" el viento a
    viento.x *= abs(normales[vx][vy].dot(new PVector(1, 0, 0)));
    viento.y *= abs(normales[vx][vy].dot(new PVector(0, 1, 0)));
    viento.z *= abs(normales[vx][vy].dot(new PVector(0, 0, 1)));

    // Aplicamos el viento
    fuerzas[vx][vy].add(viento);
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