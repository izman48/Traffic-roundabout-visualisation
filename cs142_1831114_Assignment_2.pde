/* This is a Simulation of the traffic system in a roundabout with one lane roads.
 * Autonomous agents are used in this simulation therfore vehicles following certain rules(forces)
 * and making decisions on their own. Vehicles will be generated in each road (specified by an adjustable toggle)
 * and will only move when the traffic light is green. The vehicles are not programmed to reach the end
 * of the road and wait for the light to turn green, rather they aren't generated until the light is green.
 * This is a design decision i made  because I wasn't able to get vehicles to stay a good distance from each
 * other and waiting in one spot when the light is red and would therefore cause problems with the system. 
 * The roundabout is a flowfield which spirals and when the vehicle is looking for it's next path it follows
 * the roundabout first. While the cehicles are in the roundabout there will be instances of overlap between
 * 2 vehicles. This is also a design decision because the alternative would be thhe vehciles pushing each
 * other of the path.
 *
 * 
 * - Iesa Wazeer - 1831114
*/



import controlP5.*;
ControlP5 startScreen;  //CP5 control object
ControlP5 simulatorScreen;  //CP5 control object
Toggle start;
Toggle escape;
Toggle fast;
Slider cars;
Simulation traffic; // What is going to run the traffic
int NumOfCars = 4; 
int maxCars = 10;
PFont font;

void setup() {
  size(1920, 1080);
  font = createFont("data/OpenSans-Light.ttf",25,true);
  textFont(font);
  
  traffic = new Simulation();
  startScreen = new ControlP5(this);
  simulatorScreen = new ControlP5(this);
  
  int buttonSizeX = width/5;
  int buttonSizeY = height/5;
  
  start = startScreen.addToggle("start");
  start
    .setPosition(width/2 -buttonSizeX, height/2 - buttonSizeY-20)
    .setState(false)
    .setSize(buttonSizeX*2+20, buttonSizeY*2)
    .setColorCaptionLabel(0)
    .setCaptionLabel("Click The Button to Start")
    .setColorActive(#006400)
    .setColorForeground(color(0,125,0))
    .setColorBackground(color(#6B8E23))
  ;
  
  escape = simulatorScreen.addToggle("escape");
  escape
   .setPosition(buttonSizeX/10, buttonSizeY/5)
   .setState(false)
   .setSize(buttonSizeX/8,buttonSizeY/8)
   .setColorCaptionLabel(0)
   .setCaptionLabel("")
   .setColorActive(#006400)
   .setColorForeground(color(0,125,0))
   .setColorBackground(color(#6B8E23))
  ; 
  
  cars = simulatorScreen.addSlider("NumOfCars");
  cars
    .setPosition(width - buttonSizeX*0.85, buttonSizeY/5)
    .setRange(1,maxCars)
    .setSize(100,20)
    .setColorCaptionLabel(0)
    .setValue(NumOfCars)
    .setColorActive(#006400)
    .setColorForeground(color(0, 125, 0))
    .setColorBackground(color(0,0,0))  
    .setCaptionLabel("Number of Cars")
  ; 
 
  startScreen.setFont(font);
  simulatorScreen.setFont(font);

  simulatorScreen.hide();
}

void draw() {
  background(#006400);
  hideButton();
  if (start.getState())
    traffic.run(NumOfCars);

}

// Reset all the values
void reset() {
  start.setState(false);
  escape.setState(false);
  Simulation newSim = new Simulation();
  traffic = newSim;
  NumOfCars = 4;
  cars.setValue(NumOfCars);
}

// To switch from cp5 session to another
void hideButton() {
  if (start.getState()) {
    startScreen.hide();
    simulatorScreen.show();
    
    if (escape.getState()){
      reset();
      startScreen.show();
      simulatorScreen.hide();
    }
  } 
}
/*REFERENCES ; Craig Reynold's Autonomous Agents.
               Nature of Code Autonomous Agents Series 
*/
