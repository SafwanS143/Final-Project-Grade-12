class Projectile {
  
  // FIELDS
  float vInst, vInitial, vX, vY, t;
  int theta, thetaInst;
  PVector pathPos, projectilePos;
  float gravity;
  color pathColor;
  float time, animationTime, lastAnimationTime;
  String direction;
  
  // CONSTRUCTOR
  Projectile(int theta, float x, float y, int vInitial) {
    this.theta = theta;
    this.thetaInst = theta;
    this.pathPos = new PVector(x, y);
    this.projectilePos = this.pathPos;
    this.gravity = 9.81;
    this.vInitial = vInitial;
    this.pathColor = color(255, 0, 0);
    this.animationTime = 0;
    this.lastAnimationTime = 0.0;
    this.t = 0.0;
    this.direction = "[]";
  }
  
  // METHODS
  void showStats() {
    
    float displayTime;
    
    // If animation running, calculate for instantaneous velocity and direction
    if(isRunning) {
      displayTime = this.animationTime;
      
      
      this.vX = this.vInitial * cos(radians(this.theta));
      this.vY = this.vInitial * sin(radians(this.theta)) - 9.81 * this.animationTime;
      
      // Instantaneous values
      this.vInst = sqrt(sq(this.vX) + sq(this.vY));
      this.thetaInst = round(degrees(atan(this.vY / this.vX)));
      
      // Sets direction of instantaneous velocity
      if(isApproximatelyZero(this.vX) && this.vY > 0) {
        this.direction = "[Up]";
      }
      
      else if(isApproximatelyZero(this.vX) && this.vY < 0) {
        this.direction = "[Down]";
      }
      
      else if(isApproximatelyZero(this.vY) && this.vX > 0) {
        this.direction = "[Forward]";
      }
      
      else if(isApproximatelyZero(this.vY) && this.vX < 0) {
        this.direction = "[Backwards]";
      }
      
      else {
        if(this.vY < 0 && this.vX > 0) {
          this.direction = "[Forward " + abs(this.thetaInst) + "° " + "down]";
        }
        
        else if(this.vY > 0 && this.vX > 0) {
          this.direction = "[Forward " + abs(this.thetaInst) + "° " + "up]";
        }
        
        else if(this.vY < 0 && this.vX < 0) {
          this.direction = "[Backwards " + abs(this.thetaInst) + "° " + "down]";
        }
        
        else if(this.vY > 0 && this.vX < 0) {
          this.direction = "[Backwards " + abs(this.thetaInst) + "° " + "up]";
        }
      }
      
    }
    
    // Will show the last time if animation was already run
    else {
      displayTime = this.lastAnimationTime;
    }
    
    if(this.vX == 0) {
      this.vX = abs(this.vX);
    }
    
    // Shows info on screen
    displayInfo(this.vInst, this.vInitial, this.direction, this.vX, this.vY, displayTime);
    
  }
  
  // MODE 1
  void drawProjectilePath() {
    
    // Path color is red by default
    this.pathColor = color(255, 0, 0);
    
    // Creates a placeholder to calculate end points
    float timeOfFlightPlacehold = 90.0;
    
    // Draws parabolic path
    if(!isRunning) {
      this.time = 0.0;
      noFill();
      strokeWeight(3);
      
      // Draws parabolic path
      beginShape();
      for (float t = 0; t <= 1; t += 0.0001) {
        
        // Find x and y values along the path using kinematic equations
        float x = pathPos.x + this.vInitial * cos(radians(this.theta)) * timeOfFlightPlacehold * t;
        float y = pathPos.y - this.vInitial * sin(radians(this.theta)) * timeOfFlightPlacehold * t + 0.5 * gravity * sq(t * timeOfFlightPlacehold);
        
        // Stop drawing path if it is on the target
        if(abs(x - target.x) < 26 && abs(y - target.y) < 1) {
          
          // Set variables if cannon is going up or down
          if(this.theta == 90 || this.theta == 270) {
            
            // Condition needed for downward motion
            if(this.theta == 270) {
              this.vInitial *= -1;
            }
            
            // Calculate for time and displacement if the projectile is pointed straight up or down
            float dy = this.pathPos.y - target.y;
            
            float time1 = (-this.vInitial - sqrt(sq(this.vInitial) - 4 * (-4.905) * (-dy))) / (-9.81);
            float time2 = (-this.vInitial + sqrt(sq(this.vInitial) - 4 * (-4.905) * (-dy))) / (-9.81);
            
            if(time2 < time1 && time2 > 0)
              this.time = time2;
            else
              this.time = time1;
              
            // Condition needed for downward motion
            if(this.theta == 270) {
              this.vInitial = -abs(this.vInitial);
            }
          }
          
          // Set time in a normal case
          else {
            this.time = abs(x - this.pathPos.x) / abs(this.vInitial * cos(radians(this.theta)));
          }
          
          // Change the color to green 
          this.pathColor = color(0, 255, 0);
          break;
        }
        
        vertex(x, y);
        
      }
      stroke(this.pathColor);
      endShape();
      strokeWeight(1);
    }
  }
  
  // MODE 2
  void setVariablesModeTwo() {
    
    // Calculate for displacements
    float dx = target.x - this.pathPos.x;
    float dy = this.pathPos.y - target.y;
    
    // Equation for finding the velocity needed to reach the target (Formula checked by Mr. Zehr)
    float vSquared = (-4.905 * sq(dx)) / ((dy - dx * tan(radians(this.theta))) * sq(cos(radians(this.theta))));
        
    // Calculating velocity and time if the cannon is pointed straight up
    if((this.theta == 90 || (this.theta == 270 && dy < 0)) && abs(dx) < 4) {
      
      if(dy > 0) 
        this.vInitial = sqrt((dy + 1) * 2 * gravity);
      
      else
        this.vInitial = 1;
        
      float time1 = (-this.vInitial - sqrt(sq(this.vInitial) - 4 * (-4.905) * (-dy))) / (-9.81);
      if(time1 < 0)
        this.time = (-this.vInitial + sqrt(sq(this.vInitial) - 4 * (-4.905) * (-dy))) / (-9.81);
      else
        this.time = time1;
    }
    
    // Angle wont reach target if speed is complex, or if pointed in the wrong direction
    else if(vSquared < 0 || (cos(radians(this.theta)) < 0 && dx > 0) || (cos(radians(this.theta)) > 0 && dx < 0) || (this.theta == 90 || this.theta == 270)) {
      this.vInitial = 0.0;
      this.time = 0.0;
      fill(255, 0, 0);
      textSize(20);
      text("WARNING! ANGLE DOESN'T REACH TARGET", 100, 30);
    }
    
    
    // Calculates for velocity and time in the normal case
    else {
      this.vInitial = sqrt(vSquared);
      this.time = abs(dx / (this.vInitial * cos(radians(this.theta))));
    }
  }
  
  // Updates the projectile
  void updateProjectile(int theta, float x, float y, int vInitial) {
    if(!isRunning) {
      this.theta = theta;
      this.pathPos = new PVector(x, y);
      this.vInitial = vInitial;
    }
  }
  
  void updateProjectileModeTwo(int theta, float x, float y) {
    if(!isRunning) {
      this.theta = theta;
      this.pathPos = new PVector(x, y);
    }
  }
  
  void drawProjectile() {
    
    // Updating the position of the projectile
    if (isRunning) {
      this.projectilePos = new PVector(pathPos.x + this.vInitial * cos(radians(this.theta)) * this.animationTime, pathPos.y - this.vInitial * sin(radians(this.theta)) * this.animationTime + 0.5 * gravity * sq(this.animationTime));
  
      // Drawing the projectile
      fill(0, 255, 255);
      noStroke();
      circle(this.projectilePos.x, this.projectilePos.y, 10);
  
      // Another time going from 0 - actual time to go through the path of the projectile
      if (this.animationTime < this.time) {
        this.animationTime += 1/60.0;
      } 
      
      // Break the animation if the time is up
      else {
        isRunning = false;
        this.projectilePos = new PVector(pathPos.x, pathPos.y);
        this.lastAnimationTime = this.animationTime;
        this.animationTime = 0.0;
      }
    }
  }
  
  // Resets stats
  void resetStats() {
    this.vInst = 0.0;
    this.vX = 0.0;
    this.vY = 0.0;
    this.lastAnimationTime = 0.0;
    this.direction = "[]";
  }
  
}
