import g4p_controls.*;

// GLOBAL VARIABLES
PVector target = new PVector(550, 295);
PVector cannon = new PVector(50, 300);
int theta = 45;
boolean isRunning = false;
String mode = "speed and theta";
int initSpeed = 30;
int spacing = 30;
String[] allData;
PImage cannonImage;

// Variables to calculate midpoint of cannon
float alpha = atan(5.0/50.0);
float cannonEndDistance = sqrt(sq(5) + sq(50));

// Making new cannon object
Projectile myProjectile = new Projectile(theta, cannon.x + cannonEndDistance * cos(radians(theta) + alpha), cannon.y - cannonEndDistance * sin(radians(theta) + alpha), initSpeed);

void setup() {
  size(600, 600);
  background(0);
  createGUI();
  frameRate(60);
  imageMode(CENTER);
  
  allData = loadStrings("demoData.txt");
  
  cannonImage = loadImage("cannon.png");
  
  cannonImage.resize(130, 100);
}

void draw() {
  background(0);
  
  setGUIVisibility();
  
  drawSpace();
  
  // Updates the Projectile for mode 1
  if(mode == "speed and theta") {
    myProjectile.drawProjectilePath();
      
    myProjectile.updateProjectile(theta, cannon.x + cannonEndDistance * cos(radians(theta) + alpha), cannon.y - cannonEndDistance * sin(radians(theta) + alpha), initSpeed);
  }
  
  // Update and set variables for mode 2
  else {
    myProjectile.setVariablesModeTwo();
    
    myProjectile.updateProjectileModeTwo(theta, cannon.x + cannonEndDistance * cos(radians(theta) + alpha), cannon.y - cannonEndDistance * sin(radians(theta) + alpha));
  }
  
  // Draws projectile
  myProjectile.drawProjectile();
  
  // Shows stats
  myProjectile.showStats();
}

void drawSpace() {
  
  // Draws the target
  fill(255, 0, 0);
  stroke(255, 0, 0);
  
  if(mode == "speed and theta")
    rect(target.x - 25, target.y, 50, 10);
  else
    rect(target.x - 4, target.y, 8, 10);


  // Draws the rotated cannon
  strokeWeight(2);
  fill(150);
  stroke(150);
  
  // Pushes a new canvas
  pushMatrix();
  
  // Moves the cannon back to the center so it rotates properly
  // Same as subtracting x and y values
  translate(cannon.x, cannon.y);  
  rotate(radians(-theta));  
  image(cannonImage, 0, 0);
  
  // Returns object to normal canvas
  popMatrix();  
  strokeWeight(1);
  stroke(255, 255, 0);
  
  // Draws direction and scale
  drawDirectionAndScale();
}
