float dt = 0.1;

//Arrays y vectores donde acumulamos las particulas y los planos
ArrayList<Particle> particulas;
ArrayList<Plano> planos;

//Variables comunes en las partículas
float masa = 5;
float radio = 5;

//Otras variables
int num_bolas; //bolas por fila
int num_filas;
static int w_x = 800;  //tamaño ventana X
static int w_y = 500; // tamaño ventana Y

/*
Tipo 0 --> Particulas normales sin ninguna estructura de datos
Tipo 1 --> Particulas normales con estructura Grid
Tipo 2 --> Particulas normales con estructura Tabla Hash
*/
int tipo = 1;

Grid g;
TablaHash h;

void setup()
{
  //las variables w_x y w_y contienen el tamaño de la ventana , pero la funcion size()
  // no permite utilizar variables por lo que los valores estan puestos a mano con el valor de dichas variables.
  size(800, 600); 

  planos =  new ArrayList<Plano>(); 

  Plano pl1 = new Plano(new PVector(100, 50), new PVector(120, 450));
  Plano pl2 = new Plano(new PVector(700, 50), new PVector(680, 450));
  Plano pl3 = new Plano(new PVector(120, 450), new PVector(680, 450));
  Plano pl4 = new Plano(new PVector(0, 100), new PVector(720, 200));
  Plano pl5 = new Plano(new PVector(0, 200), new PVector(720, 100));

  planos.add(pl1);
  planos.add(pl2);
  planos.add(pl3);
  planos.add(pl4);
  planos.add(pl5);

  particulas =  new ArrayList<Particle>(); 

  //Rellena el array partículas
  num_bolas = 10; //bolas por fila
  num_filas = 10;
  for (int i = 0; i < num_filas; i++)
  {
    for (int j = 0; j < num_bolas; j++)
    {
      Particle p =  new Particle( new PVector(150+(radio*2+5)*j, 10+(radio*2+5)*i), new PVector(0, 0), radio, masa, color(255, 0, 0));
      particulas.add(p);
    }
  }

  //Inicializa las estructuras de datos necesarias según el tipo
  switch(tipo)
  {
  case 1: //Rellena el array con partículas normales, y la estructura grid
    g = new Grid();
    break;
  case 2: //Rellena el array con partículas muelle
    h = new TablaHash(num_bolas*num_filas, 160, 100);
    break;
  }
}

void draw()
{
  background (255);
  fill(255);
  text("Frame-Rate: " + frameRate, 15, 15);
  text("Numero de particulas: " + num_bolas*num_filas, 15, 35);

  if (tipo==0)
    text("Tipo de particulas: normales sin estructura", 15, 55);
  else if (tipo==1)
    text("Tipo de particulas: normales con estructura Grid", 15, 55);
  else
    text("Tipo de particulas: normales con estructura Hash", 15, 55);

  //Calcula las colisiones según el tipo
  switch(tipo)
  {
  //Particulas sin estructuras de datos
  case 0:
    //Comprueba colisiones entre partículas y plano
    for (int i = 0; i < particulas.size(); i++)
    {
      Particle p = particulas.get(i);
      for (int j = i+1; j < particulas.size(); j++)
      {
        Particle p2 = particulas.get(j);
        p.checkCollisions(p2);
        for (int k = 0; k < planos.size(); k++)
        {
          Plano pl = planos.get(k);
          pl.checkCollisions(p);
        }
      }
      p.move();
      p.display();
    }

    //Dibuja los planos
    for (int i = 0; i < planos.size(); i++)
    {
      Plano pl = planos.get(i);
      pl.display();
    }
    break;
  //Particulas con estructura grid
  case 1:
    //Actualizamos el grid con la nueva posicion de las particulas cada frame
    g.GuardarParticulas(particulas, w_x, w_y);

    //Comprueba las colisiones con las partículas del grid
    g.CalcularColisiones();

    //Dibuja los planos
    for (int i = 0; i < planos.size(); i++)
    {
      Plano pl = planos.get(i);
      pl.display();
    }
    break;
  case 2:
    //Vacia y rellena la tabla hash cada frame
    h.Vaciar();
    h.Rellenar(particulas);

    //Calcula la colision de la particula con su celda
    for (int i = 0; i < particulas.size(); i++)
    {
      Particle p = particulas.get(i);
      ArrayList<Particle> pl = h.GetAdyacentes(p.location);
      for (int j = 0; j < pl.size(); j++)
      {
        Particle p2 = pl.get(j);
        //Si no son la misma particula
        if (p.location != p2.location)
        {
          p.checkCollisions(p2);
        }
      }

      for (int j = 0; j < planos.size(); j++)
      {
        Plano pla = planos.get(j);
        pla.checkCollisions(p);
      }

      p.move();
      p.display();
    }

    //Dibuja planos
    for (int i = 0; i < planos.size(); i++)
    {
      Plano pl = planos.get(i);
      pl.display();
    }

    break;
  }

  //Calcula el tiempo de computación
  float tcomp = millis()/1000.0;
  
  if (keyPressed) {
      if(key == '0')
      {
        tipo = 0;
        setup();
      }
      if(key == '1')
      {
        tipo = 1;
        setup();
      }
      if(key == '2')
      {
        tipo = 2;
        setup();
      }
  }
  
  fill(0);
    text("Tipo actual: " + tipo, 200, 550);
  text("Pulsa la tecla 0 para la simulación se realice con particulas normales y colisiones normales", 200, 560);
  text("Pulsa la tecla 1 para la simulación se realice con particulas normales y colisiones con estructura Grid", 200, 570);
  text("Pulsa la tecla 2 para la simulación se realice con particulas normales y colisiones con estructura de Tabla Hash", 200, 580);
}

class TablaHash {
  private int size;

  private int tamCeldaX;
  private int tamCeldaY;

  private EntradaHash[] table; //Celdas de la tabla

  //Pasamos el numero de particulas y el tamaño de celda
  TablaHash(int num_particulas, int tamX, int tamY) {
    size = num_particulas;
    tamCeldaX = tamX;
    tamCeldaY = tamY;

    table = new EntradaHash[size];

    //Rellenamos la tabla con null
    for (int i = 0; i < size; i++)
      table[i] = null;
  }

  //Devuelve el valor, en nuestro caso la celda con el array de particulas
  //la clave es la posicion de la particula
  //Si no hay ninguna celda creada, devolvemos null
  ParticleArray Get(PVector clave) {
    int hash = CalculaHash(clave);

    if (table[hash] == null)
    {
      return null;
    }
    else
      return table[hash].DevuelveValor();
  }

  //Añadimos la particula a la tabla
  //la clave es la posicion de la particula
  void Add(PVector clave, Particle pl) {
    int hash = CalculaHash(clave);

    //Si no existe la celda, la creamos con la partícula
    if (table[hash] == null)
      table[hash] = new EntradaHash(clave, pl);
    //Si ya existe la celda, añadimos la particula indicada
    else
      table[hash].Add(pl);
  }

  //En nuestro caso la Clave será la posicion de la particula
  int CalculaHash(PVector clave)
  { 
    int xd = (int)floor(clave.x/tamCeldaX);
    int yd = (int)floor(clave.y/tamCeldaY);
    
    int hash = (73856093*xd + 19349663*yd) % size;
    
    //Si el hash da negativo (coordenadas de las particulas negativas)
    //lo convertimos en positivo
    if(hash < 0)
    {
      hash += size;
    }

    return hash;
  }

  //Rellenamos la tabla hash con el vector particulas indicado
  void Rellenar(ArrayList<Particle> pl)
  {
    for (int i = 0; i < pl.size(); i++)
    {
      Particle p = pl.get(i);
      Add(p.location, p);
    }
  }

  //vacia la tabla hash
  void Vaciar()
  {
    //Rellenamos la tabla con null
    for (int i = 0; i < size; i++)
      table[i] = null;
  }
  
  //Obtiene los vecinos de una clave determinada
  ArrayList GetAdyacentes(PVector clave) {
     ArrayList<Particle> ArrayCeldas = new ArrayList<Particle>();
     float ang;
     PVector nPos = new PVector(0, 0);
      
     //Obtenemos el array con la clave indicada
     ArrayCeldas.addAll(Get(clave).GetArray());
      
     //Calculamos la posición de las celdas vecinas
     //según las posiciones adyacentes de las celdas
     for (int i = 0; i < 8; i++) {
       ang = QUARTER_PI * i;
       nPos.x = clave.x + tamCeldaX * cos(ang);
       nPos.y = clave.y + tamCeldaY * sin(ang);
       
       if(Get(nPos) != null)
         ArrayCeldas.addAll(Get(nPos).GetArray());
     }
      
     return ArrayCeldas;
  }
}

class EntradaHash {
  private PVector clave; //en nuestro caso, la posicion de la particula
  private ParticleArray valor; //en nuestro caso, un array de particulas

  //Añade una particula a una nueva celda
  EntradaHash(PVector cl, Particle pl) {
    clave = cl;
    valor = new ParticleArray();
    valor.Add(pl);
  }

  //Añade una particula a una celda ya existente
  void Add(Particle pl)
  {
    valor.Add(pl);
  }

  //Devuelve la clave, en nuestro caso, la posición de la particula
  PVector DevuelveClave() {
    return clave;
  }

  //Devuelve el valor, en nuestro caso la celda con un array de partículas
  ParticleArray DevuelveValor() {
    return valor;
  }
}

class Grid {
  private int nceldasX; //numero de divisiones del espacio en X
  private int nceldasY; //numero de divisiones del espacio en X

  private ParticleArray[][] grid;//Aqui se almacenan las particulas

  Grid()
  {
    nceldasX = 160;
    nceldasY = 100;
    grid = new ParticleArray[nceldasX][nceldasY];

    for (int i = 0; i < nceldasX; i++)
      for (int j = 0; j < nceldasY; j++)
        grid[i][j] = new ParticleArray();
  }

  //Guarda las particulas del vector pasado en el grid
  //w = tamaño ventana processing
  void GuardarParticulas(ArrayList<Particle> p, int wx, int wy)
  {
    //Vaciamos el grid
    VaciarGrid();

    //tamaño celda = (tamaño ventana / nceldas X ; tamaño ventana / nceldas Y ) 
    float tamcx = wx/nceldasX;
    float tamcy = wy/nceldasY;

    //Guarda las particulas del array pasado en el grid
    for (int i = 0; i < p.size(); i++)
    {
      Particle part = p.get(i);

      float posx = part.location.x/tamcx;
      int posactx = (int)posx;
      float posy = part.location.y/tamcy;
      int posacty = (int)posy;

      //Si la particula se sale de la ventana, no la almacenamos
      if (posx < nceldasX && posx >= 0 && posy < nceldasY && posy >= 0)
        grid[posactx][posacty].Add(part);
    }
  }

  //Vacia el grid
  void VaciarGrid()
  {
    for (int i = 0; i < nceldasX; i++)
      for (int j = 0; j < nceldasY; j++)
        grid[i][j] = new ParticleArray();
  }

  //Calcula las colisiones entre las particulas del grid, incluidas as 8 contiguas
  void CalcularColisiones()
  {
    for (int i = 0; i < nceldasX; i++)
    {
      for (int j = 0; j < nceldasY; j++)
      {
        CalcularColisionesCeldasContiguas(i, j);
      }
    }
  }

  //Calcula las colisiones entre la celda indicada y las contiguas
  void CalcularColisionesCeldasContiguas(int x, int y)
  {
    ParticleArray p = grid[x][y];
    ParticleArray array2 = new ParticleArray();

    for (int i = 0; i < p.Size(); i++)
    {
      Particle p1 = p.Get(i);

      //Comprobamos las colisiones de la particula en su grid
      for (int m = i+1; m < p.Size(); m++)
      {
        Particle p2 = p.Get(m);
        p1.checkCollisions(p2);
      }

      //Calculamos las colisiones de la particula con las celdas contiguas del grid
      for (int m = 0; m < 8; m++)
      {
        //Cogemos el array de la particula contigua correspondiente
        switch(m)
        {
        case 0:
          if (x > 0 && y > 0)
            array2 = grid[x-1][y-1];
          break;
        case 1:
          if (x>0)
            array2 = grid[x-1][y];
          break;
        case 2:
          if (y<99 && x > 0)
            array2 = grid[x-1][y+1];
          break;
        case 3:
          if (y>0)
            array2 = grid[x][y-1];
          break;
        case 4:
          if (y<99)
            array2 = grid[x][y+1];
          break;
        case 5:
          if (x<99 && y > 0)
            array2 = grid[x+1][y-1];
          break;
        case 6:
          if (x<99)
            array2 = grid[x+1][y];
          break;
        case 7:
          if (y<99 && x<99)
            array2 = grid[x+1][y+1];
          break;
        }

        //Comprobamos las colisiones de la particula en su grid
        for (int j = i+1; j < array2.Size(); j++)
        {
          Particle p2 = array2.Get(j);
          p1.checkCollisions(p2);
        }
      }

      for (int j = 0; j < planos.size(); j++)
      {
        Plano pla = planos.get(j);
        pla.checkCollisions(p1);
      }

      p1.move();
      p1.display();
    }
  }
}

class ParticleArray
{
  //Clase que guarda un array de particulas
  //Util para la estructura grid, permitiendo guardar
  //un arraylist dentro de un array2d(una matriz)
  
  private ArrayList<Particle> p;

  ParticleArray()
  {
    p = new ArrayList<Particle>();
  }

  void Add(Particle part)
  {
    p.add(part);
  }

  Particle Get(int i)
  {
    return p.get(i);
  }

  int Size()
  {
    return p.size();
  }
  
  ArrayList<Particle> GetArray()
  {
    return p;
  }
}

class Particle {
  PVector F;
  PVector acceleration;
  PVector velocity;
  PVector location;

  float radio;
  float masa;
  float kr;

  color Color;

  Particle(PVector l, PVector v, float r, float m, color c) {
    F = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    velocity = v.get();
    location = l.get();
    radio = r;
    masa = m;

    kr = 0; //Sin friccion

    Color = c;
  }

  //Calcula la fuerza y el movimiento de la particula
  void move() {
    actualizaFuerza();

    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration = new PVector(F.x/masa, F.y/masa);

    //--->utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.x = velocity.x + acceleration.x*dt;
    velocity.y = velocity.y + acceleration.y*dt;

    location.x = location.x + velocity.x*dt;
    location.y = location.y + velocity.y*dt;
  }

  //Comprueba las colisiones con la particula pasada
  void checkCollisions(Particle q)
  { 
    //Calculamos la distancia
    PVector Dist = PVector.sub(q.location, location);

    //Calculamos si colisiona
    if (Dist.mag() < (radio + q.radio)) {
      //Descomponemos la velocidad de la particula actual y de la que estamos comprobando la colision
      //En velocidad normal y tangencial

      //Multiplicamos el vector distancia por la proyección del vector velocidad sobre la distancia
      PVector Vn1 = PVector.mult(Dist.normalize(null), PVector.dot(velocity, Dist) / Dist.mag());
      PVector Vn2 = PVector.mult(Dist.normalize(null), PVector.dot(q.velocity, Dist) / Dist.mag());
      PVector Vt1 = PVector.sub(velocity, Vn1);
      PVector Vt2 = PVector.sub(q.velocity, Vn2);

      //Calculamos L
      float L = radio + q.radio - Dist.mag();
      float vrel = PVector.sub(Vn1, Vn2).mag();

      if (vrel < 20)
        vrel = 20;

      location = PVector.add(PVector.mult(Vn1, -L/vrel), location);

      //Calculamos las velocidades de salida
      float m1 = masa;
      float m2 = q.masa;
      float u1 = Vn1.dot(Dist) / Dist.mag();
      float u2 = Vn2.dot(Dist) / Dist.mag();
      float v1 = ((m1 - m2)*u1+2*m2*u2) / (m1 + m2);
      float v2 = ((m2 - m1)*u2+2*m1*u1) / (m1 + m2);

      //Vector velocidad normal
      PVector Vn1_ = PVector.mult(Dist.normalize(null), v1);
      PVector Vn2_ = PVector.mult(Dist.normalize(null), v2);

      velocity = PVector.add(Vn1_, Vt1);
      velocity = PVector.mult(velocity, 0.99);
      q.velocity = PVector.add(Vn2_, Vt2);  
      q.velocity = PVector.mult(q.velocity, 0.99);
    }
  }

  void actualizaFuerza() {
    //Aplicamos la fuerza de la gravedad
    PVector g = new PVector(0, 9.8);

    F.x = g.x;
    F.y = g.y;
  }

  // Method to display
  void display() {
    stroke(Color);
    fill(Color);
    ellipse(location.x, location.y, radio*2, radio*2);
  }
}

class Plano {
  PVector pto1;
  PVector pto2;
  PVector plano;  
  PVector normal;  

  Plano(PVector p1, PVector p2) {
    pto1 = p1;
    pto2 = p2;
    plano = PVector.sub(pto2, pto1);
    normal =  new PVector(-plano.y, plano.x);
    normal.normalize();
  }

  //Calculamos la colision del plano con la partícula pasada
  void checkCollisions(Particle b) {       
    plano.normalize();    
    float dcol = PVector.dot(PVector.sub(b.location, pto1), normal);
    float d = dcol - b.radio;

    //Comprobamos si la particula ha colisionado con el plano
    if (b.location.x > pto1.x && b.location.x < pto2.x || b.location.y > pto1.y &&  b.location.y < pto2.y) {          
      if (abs(d) < (b.radio*2)) {
        //Si colisiona, recalculamos la velocidad de la particula
        PVector ds = PVector.mult(normal, abs(d));
        ds.normalize();
        b.location.sub(ds);    
        float nv = PVector.dot(normal, b.velocity);        
        PVector Vn = PVector.mult(normal, nv);        
        PVector Vt = PVector.sub(b.velocity, Vn);        
        b.velocity = (PVector.sub(Vt, PVector.mult(Vn, 0.6)));
      }
    }
  }

  void display()
  {
    stroke(255, 0, 0);
    line(pto1.x, pto1.y, pto2.x, pto2.y);
  }
}