class Simulation {
  
  //boolean stop = false;
  FlowField field;
  ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();;
  Path[] path = new Path[8]; // the 8 paths
  Light[] lights = new Light[4]; // the 4 traffic lights
  int[] carsonPath = new int[4]; // Number of cars on a certain path
  
  Simulation() {
    noStroke();
    int dif = 80; // the distance two paths are from each other
    field = new FlowField();
    // We initialize each path individually in order to set their positions 
    path[0] = new Path(new PVector (width/2-dif,height), new PVector(width/2-dif,height/2),0);//in
    path[1] = new Path(new PVector (0,height/2-dif), new PVector(width/2,height/2-dif),1);//in
    path[2] = new Path(new PVector (width/2+dif,0), new PVector(width/2+dif,height/2),2);//in
    path[3] = new Path(new PVector (width,height/2+dif), new PVector(width/2,height/2+dif),3);//in
    path[4] = new Path(new PVector (width/2,height/2+dif), new PVector(-(field.radius*4),height/2+dif),4);//out
    path[5] = new Path(new PVector (width/2-dif,height/2), new PVector(width/2-dif,-(field.radius*4)),5);//out
    path[6] = new Path(new PVector (width/2,height/2-dif), new PVector(width+(field.radius*4),height/2-dif),6);//out;
    path[7] = new Path(new PVector (width/2+dif,height/2), new PVector(width/2+dif,height+(field.radius*4)),7);//out
    
    dif  = (int)path[0].radius*4; // the distance between the traffic lights and the path
    // Again we initialize the traffic lights individually so to set their positions
    lights[0] = new Light(path[0], width/2 - dif , height/2 +dif,0);
    lights[1] = new Light(path[1], width/2 - dif, height/2 - dif, HALF_PI);
    lights[2] = new Light(path[2], width/2 + dif, height/2 -dif, PI);
    lights[3] = new Light(path[3], width/2 +dif, height/2 +dif, -1*HALF_PI);
    
    // initialize the arrays
    for (int i = 0; i < lights.length; i++){
      carsonPath[i] = 0;
    }
    

    frameRate(60);
  }
  
  
  void run(int cars) {   
    background(#006400);
    generateCars(cars);
    
    // Display the path and traffic lights 
    for (int i = 0; i < path.length; i++){
      path[i].display();
      if (i < lights.length) {
        lights[i].display();
      }
    }
    
    field.display(); // display the field/roundabout
    
    int num = trafficLogic(); // returns the next traffic light to be on
    if (num == 5) {
      off(); // the break between two traffic lights turning on
    } else {
      lights[num].update();;
    }
    
    int cid = 0; // id of path car is on
    int pid = 0; // id of path light is on
    
    // check every vehicle
    for (int i = 0; i < vehicles.size(); i++){
      Vehicle car = vehicles.get(i);
      cid = car.p.id;
      int k;
      
      // check if car is on any of the paths light is on
      for (k = 0; k < lights.length; k++){
        if (cid == lights[k].p.id){
          pid = k;
        }
      }
      // if it is and the light is off stop 
      if (cid == pid && !lights[pid].go){ // design decision to make cars stay at start until called - expanded in project report
        car.velocity.normalize();
        car.display();
      } else {
        go(i); // if not go
      }
    
    }
  }
  
  // method to generate a number of cars from each path
  void generateCars(int num) {
    for (int i = 0; i < lights.length; i++){ 
      if (lights[i].go){ // we only generate them in a green light - design decision
        if (carsonPath[i] < num) { // add cars until we reach limit
          carsonPath[i]++;
          PVector start = path[i].start.get();
          Vehicle car = new Vehicle(start,  path[i]);
          vehicles.add(car);
        }
      }
    }
  }
  
  // calculate a new path (must be one of the outgoing paths)
  void newPath(int i, int comeFrom, Vehicle car){
    int num = floor(random(4,path.length));
    car.p = path[num];
    car.reachedEnd = false;
    
    // set the blinkers on the car based on where the car is going
    switch(comeFrom){ 
      case 0: 
        switch(num) {
          case 4 : car.left = true; //left
                   car.right = false;
                   break;
          case 5 : car.right = true; //straight
                   car.left = true;
                   break;
          case 6 :
          case 7 : car.right = true; //right
                   car.left = false;
                   break;
        }
        break;
      case 1 :
        switch(num) {
          case 5 : car.left = true; //left
                   car.right = false;
                   break;
          case 6 : car.right = true; //straight
                   car.left = true;
                   break;
          case 7 :
          case 4 : car.right = true; //right
                   car.left = false;
                   break;
        }
        break;
      case 2: 
        switch(num) {
          case 6 :car.left = true; //left
                   car.right = false;
                   break;
          case 7 : car.right = true; //straight
                   car.left = true;
                   break;
          case 4 :
          case 5 : car.right = true; //right
                   car.left = false;
                   break;
        }
        break;
      case 3 :
        switch(num) {
          case 7 :car.left = true; //left
                   car.right = false;
                   break;
          case 4 : car.right = true; //straight
                   car.left = true;
                   break;
          case 5 :
          case 6 : car.right = true; //right
                   car.left = false;
                   break;
        }
        break;   
    }
    // set the path the car is on as the new path decided
  }
  
  // method to turn off all traffic lights
  void off() {
    for (int i = 0; i < lights.length; i++) {
      lights[i].go = false;
    }
  }
  
  // method to decide which traffic light is next
  int trafficLogic(){
   int m = frameCount; // used framCount rather than millis() to keep time between lights switching same regardless of frameRate 
   int turn = m % 960;  // arbitrary number
   int num = 0;
   if (turn >= 0 && turn < 200) {
     num = 0;
   } else 
   if (turn >= 240 && turn < 440) {
     num = 1;
   } else 
   if (turn >= 480 && turn < 680) {
     num = 2;
   } else 
   if (turn >= 720 && turn < 920) {
     num = 3;
   } else {
     num = 5;
   }
   return num;
  }
  
  // method to make the car move
  void go(int i){
    Vehicle car = vehicles.get(i);
    
    // make the roundAbout affect the car
    PVector attract = field.lookup(car.position.get());
    car.applyForce(attract);
    
    // car moves based on rules provided
    car.applyBehaviors(vehicles);
    car.run();
    
    // when we reach the end of our path we calculate a new path, set reachedEnd as true and begin countdown for our blinkers to stay on
    if (car.reachedEnd()) {
      newPath(i,car.p.id,car); 
      car.reachedEnd = true;
      car.blinkers = frameCount;
    }
    
    // if our blinkers were on for long enough switch it off
    if ((frameCount - car.blinkers) > 100 && car.reachedEnd){
      car.reachedEnd = false;
      car.left = false;
      car.right = false;
    }
    
    // if the car hits the border we remove its data
    if (car.hitborder) {
      carsonPath[car.oldp.id]--; // number of cars on that path decreas
      vehicles.remove(i); // remove car from arrayList

    } 
  }
}
