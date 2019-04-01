class Light{
  Path p;
  boolean go;
  int x;
  int y;
  float rot;
  //int timer;
  
  Light(Path path, int x_, int y_, float rot_) {
    p = path;
    go = false;
    x = x_;
    y = y_;
    rot = rot_;
  }
  
  void update() {
    go = true;
  }
  void reset() {
    go = false;
  }
  void display() {
    pushMatrix();
    translate(x,y);
    rotate(rot);
    fill(127);
    int w = 80;
    int h = 150;
    int r = 30;
    rect(0, 0, w,h);
    if (go){
      fill(0);
      ellipse(w/2,h/4, r,r); // red light on top
      fill(0,255,0);
      ellipse(w/2,3*h/4,r,r);// green light below
    } else {
      fill(255,0,0);
      ellipse(w/2,h/4, r,r); // red light on top
      fill(0);
      ellipse(w/2,3*h/4,r,r);// green light below
    }
    popMatrix();
  }
}
