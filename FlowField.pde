class FlowField {
  PVector[][] field;
  int cols,rows;
  int scale;
  float maxForce;
  PVector pos;
  int radius;
  
  FlowField() {
    pos = new PVector(width/2, height/2-radius/2);
    radius = 110;
    maxForce = 1;
    scale = 20;
    cols = floor(width/scale);
    rows = floor(height/scale);
    field = new PVector[cols][rows];
    init();
  }
  
  // making every square inside the radius of the circle be a spiral flowfield
  void init() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //Pointing towards centre
        float diffy = pos.y - j*scale;
        float diffx = pos.x - i*scale;
        float dist = sqrt((diffy*diffy)+(diffx*diffx));

        if(dist < radius*2){
          float theta = atan((diffy)/(diffx));
          if (pos.x < i*scale) {
           theta += PI;
          }
          PVector dir = new PVector(cos(theta),sin(theta));
          dir.setMag(maxForce);
          // Rotating it
          dir.rotate(-1*HALF_PI);
          field[i][j] = dir;
        } else {
          field[i][j] = new PVector(0,0);
        }
      }
    }
  }
  
  
  void display() {
    fill(127);
    ellipse(pos.x,pos.y,radius*4,radius*4);
  //  for (int i = 0; i < cols; i++) {
  //    for (int j = 0; j < rows; j++) {
  //      drawVector(field[i][j],i*scale,j*scale,scale-2);
  //    }
  //  }
    
    fill(#214fc6);
    ellipse(pos.x,pos.y,radius/2,radius/2);

  }
  
  // Draws the direction of the vector with an arrow
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    translate(x, y);
    float len = v.mag();
    rotate(v.heading());
    line(0, 0, len, 0);
    translate(len, 0);
    fill(0, 0, 0);
    beginShape();
    vertex(0, -3);
    vertex(0, 3);
    vertex(3, 0);
    endShape(CLOSE);
    popMatrix();
  }
  
  // returns the vector of the flowfield at a certain position
  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/scale,0,cols-1));
    int row = int(constrain(lookup.y/scale,0,rows-1));
    return field[column][row].get();
  }
  
}
