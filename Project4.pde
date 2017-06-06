//Con el maouse se comienza a dibuja una guirnalda :D

Particula[] particulas;

int num,cnt,px,py;
float lanzamiento = -1;
boolean comienzo = false, aclarar = false;

void setup() {
  size(900,650);
  background(0);
  smooth();
  rectMode(CENTER-DIAMETER);
  ellipseMode(CENTER-DIAMETER);
    
  cnt=0;
  num=150;
  particulas=new Particula[num];
  for(int i=0; i<num; i++) particulas[i]=new Particula();

  px=-1;
  py=-1;
}

void draw() {
  if(aclarar) {
    background(255);
    aclarar=false;
  }
  if(comienzo) {
    stroke(0);
    noFill();
    pushMatrix();
    strokeWeight(2);
    translate(width/2-28,height/2-3);
    
    scale(2,2);
    beginShape();
    vertex(5,0);
    vertex(0,0);
    vertex(0,5);
    vertex(5,5);
    endShape();
    beginShape();
    vertex(8,-3);
    vertex(8,5);
    endShape();
    line(11,-3,11,-1);
    beginShape();
    vertex(11,0);
    vertex(11,5);
    endShape();
    beginShape();
    vertex(19,0);
    vertex(14,0);
    vertex(14,5);
    vertex(19,5);
    endShape();
    line(22,-3, 22,5);
    line(22,2, 24,2);
    line(24,2, 27,-1);
    line(24,2, 27,5);
    
    popMatrix();  
  }
  noStroke();
  
  if(mousePressed) {
    int i;
    float Flores;
    
    if(px==-1) {
      px=mouseX;
      py=mouseY;
      Flores=0;
    }
    else if(px==mouseX && py==mouseY) Flores=int(random(36))*10;
    else Flores=degrees(atan2(mouseY-py,mouseX-px))-90;
  
    i=0;
    while(i<num) {
      if(particulas[i].Noe<1) {
        particulas[i].init(Flores);
        break;
      }
      i++;
    }
    
    px=mouseX;
    py=mouseY;
  }
  
  for(int i=0; i<num; i++) 
    if(particulas[i].Noe>0) particulas[i].Enredadera();
}

void mousePressed() {
  if(comienzo) {
    aclarar=true;
    comienzo=true;
  }

  float time=millis();
  if(lanzamiento!=-1 && (time-lanzamiento)<200) {
    aclarar=true;
    for(int i=0; i<num; i++) particulas[i].Noe=0;
    lanzamiento=-1;
  }
  else lanzamiento=time;
}


class Particula {
  Vec2D v,vD;
  float dir,dirMod,speed;
  int Joss,Noe,Rodri;
  
  Particula() {
    v=new Vec2D(0,0);
    vD=new Vec2D(0,0);
    Noe=0;
  }

  void init(float _dir) {
    dir=_dir;

    float prob=random(100);
    if(prob<80) Noe=15+int(random(30));
    else if(prob<99) Noe=45+int(random(50));
    else Noe=100+int(random(100));
    
    if(random(100)<80) speed=random(2)+0.5;
    else speed=random(2)+2;

    if(random(100)<80) dirMod=20;
    else dirMod=60;
    
    v.set(mouseX,mouseY);
    initMove();
    dir=_dir;
    Rodri=10;
    if(random(100)>50) Joss=0;
    else Joss=1;
  }
    
  void initMove() {
    if(random(100)>50) dirMod=-dirMod;
    dir+=dirMod;
    
    vD.set(speed,0);
    vD.rotate(radians(dir+90));

    Rodri=10+int(random(5));
    if(random(100)>90) Rodri+=30;
  }
  
  void Enredadera() {
    Noe--;
    
    if(Noe>=30) {
      vD.rotate(radians(1));
      vD.mult(1.01f);
    }
    //colores hojas
    v.add(vD);
    if(Joss==0) fill(196-Noe,235,91,150);
    else fill(48,189-(Noe/2),119-Noe,100);
      
    pushMatrix();
    translate(v.x,v.y);
    rotate(radians(dir));
    rect(0,0,1,16);
    popMatrix();
    
    //colores frutillas
    if(Noe==0) {
      if(random(100)>50) fill(160,84,219,200);
      else fill(219,84,129,200);
      float size=2+random(4);
      if(random(100)>95) size+=5;
      ellipse(v.x,v.y,size,size);
    }
    if(v.x<0 || v.x>width || v.y<0 || v.y>height) Noe=0;
    
    if(Noe<30) {
      Rodri--;
      if(Rodri==0) {
        initMove();
      }
    }
   } 
  
}

// Vectores
class Vec2D {
  float x,y;

  Vec2D(float _x,float _y) {
    x=_x;
    y=_y;
  }

  Vec2D(Vec2D v) {
    x=v.x;
    y=v.y;
  }

  void set(float _x,float _y) {
    x=_x;
    y=_y;
  }

  void set(Vec2D v) {
    x=v.x;
    y=v.y;
  }

  void add(float _x,float _y) {
    x+=_x;
    y+=_y;
  }

  void add(Vec2D v) {
    x+=v.x;
    y+=v.y;
  }

  void sub(float _x,float _y) {
    x-=_x;
    y-=_y;
  }

  void sub(Vec2D v) {
    x-=v.x;
    y-=v.y;
  }

  void mult(float m) {
    x*=m;
    y*=m;
  }

  void div(float m) {
    x/=m;
    y/=m;
  }

  float length() {
    return sqrt(x*x+y*y);
  }

  float angulo() {
    return atan2(y,x);
  }

  void estavilizar() {
    float l=length();
    if(l!=0) {
      x/=l;
      y/=l;
    }
  }

  Vec2D tangent() {
    return new Vec2D(-y,x);
  }

  void rotate(float val) {
    double cosval=Math.cos(val);
    double sinval=Math.sin(val);
    double tmpx=x*cosval - y*sinval;
    double tmpy=x*sinval + y*cosval;

    x=(float)tmpx;
    y=(float)tmpy;
  }
}