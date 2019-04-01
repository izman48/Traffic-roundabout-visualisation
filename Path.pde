class Path {

  // A Path is a point from start to end
  PVector start;
  PVector end;
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;
  int id;

  Path(PVector s, PVector e, int i) {
    // Arbitrary radius of 20
    radius = 70;
    start = s.get();
    end = e.get();
    id = i;
}

  // Draw the path
  void display() {
    fill(127);
    strokeWeight(radius*2);
    stroke(127,255);
    line(start.x,start.y,end.x,end.y);

    strokeWeight(radius/5);
    stroke(255);
    line(start.x,start.y,end.x,end.y);
    strokeWeight(1);
    
    
  }
}
