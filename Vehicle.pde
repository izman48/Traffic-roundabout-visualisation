class Vehicle {
  boolean hitborder = false;
  boolean left = false;
  boolean right = false;
  boolean onroad = false;
  boolean reachedEnd = false;
  int blinkers;
  

  // PVectors
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float r;           // Car size
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  // Car colours and blinker colours
  color blue = #044F67;
  color red = #CF000F;
  color green = #006442;
  color orange1 = #F9690E;
  color silver = #BDC3C7;
  color orange = #FFA500;
  color col;
  Path p; // path car is on
  Path oldp; // path car was created on
  
  Vehicle( PVector l, Path path) {
    blinkers  = 0;
    p = path;
    oldp = p;
    position = l.get();
    r = 10.0;
    maxspeed = 7;
    maxforce = 0.15;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    int num = (int)Math.floor(random(0,5));
    switch (num){
      case 0: col = blue;
              break;
      case 1: col = red;
              break;
      case 2: col = green;
              break;
      case 3: col = orange1;
              break;
      case 4: col = silver;
              break;
    }
  } 

  public void run() {
    update();
    borders();
    display();
  }
  
  // A function to deal with path following and separation
  void applyBehaviors(ArrayList vehicles) {
    // Follow path force
    PVector f = follow();
    // Separate from other vehicles force
    PVector s = separate(vehicles);
    // Arbitrary weighting
    f.mult(3);
    s.mult(3);
    applyForce(f);
    if (onroad) // makes sure cars dont go out of the roundabout when other vehicles are nearby
      applyForce(s);
  }
  
  // Check if vehicle has reached the end of the road
  boolean reachedEnd(){
    PVector dist = PVector.sub(position,p.end);
    return (dist.mag() < 200); 
  }
  
  // makes the car either seek the path or seek the end of the path
  PVector follow() {

    // Predict position 50 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(50);
    PVector predictpos = PVector.add(position, predict);

    // Look at the line segment
    PVector a = p.start;
    PVector b = p.end;

    // Get the normal p oint to that line
    PVector normalPoint = getNormalPoint(predictpos, a, b);

    // Find target point a little further ahead of normal
    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);  // This could be based on velocity instead of just an arbitrary 10 pixels
    PVector target = PVector.add(normalPoint, dir);

    // How far away are we from the path?
    float distance = PVector.dist(predictpos, normalPoint);
   
    // Only if the distance is greater than the path's radius do we bother to steer if not we 
    // just seek the end of the target
    if (distance > p.radius) {
      onroad = false;
      return seek(target);
    } else {
      onroad = true;
      return seek(p.end.get());
    }
  }



  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }
 

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    float d = desired.mag();
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Vepositionity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separate (ArrayList vehicles) {
    float desiredseparation = r*10;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every vehicle in the system, check if it's too close
    for (int i = 0 ; i < vehicles.size(); i++) {
      Vehicle other = (Vehicle) vehicles.get(i);
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  void display() {
    float theta = velocity.heading() + radians(90);
    strokeWeight(1);
    
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta); // makes the car point towards velocity
    fill(col);
    stroke(col);
    beginShape();
    vertex(-r, -r*2); //top left
    vertex(r, -r*2); // top right
    vertex(r, r*2);//bottom right
    vertex(-r, r*2);//bottom left
    endShape();
    int rad = 10; // size  of blinkers
    if (left){
      fill(orange);
      ellipse(-r,r*2,rad,rad);//right
    } else {
      fill(0,0,0);
      ellipse(-r,r*2,rad,rad);//right
    }
    if (right){ 
      fill(orange);
      ellipse(r,r*2,rad,rad);//left
      
    } else { 
      fill(0,0,0);
      ellipse(r,r*2,rad,rad);//left
      
    }
    popMatrix();
  }
  
   // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
  
  // Method to apply force to acceleration
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // check if vehicle is off screen
  void borders() {
    
    if (position.x < -r) {
      hitborder = true;
    }
    if (position.y < -r) {
      hitborder = true;
    }
    if (position.x > width+r) {
      hitborder = true;
    }
    if (position.y > height+r){
      hitborder = true;
    }
  }
}
