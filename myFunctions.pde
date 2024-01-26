void displayInfo(float vInst, float vInitial, String direction, float vX, float vY, float displayTime) {
  // Displays info onto screen
    fill(173, 216, 230);
    textSize(20);
    text("V Inst: " + nf(vInst, 1, 2) + " m/s " + direction, 31, 60);
    text("Vx: " + nf(vX, 1, 2) + " m/s", 31, 90);
    text("Vy: " + nf(vY, 1, 2) + " m/s", 31, 120);
    text("Δt: " + nf(displayTime, 1, 2) + " s", 31, 150);
    
    if(mode == "theta" && vInitial > 0 && isRunning) {
      text("V Initial: " + nf(vInitial, 1, 2) + " m/s", 31, 30);
    }
}

void setGUIVisibility() {
  boolean setVisibility;
  
  if(isRunning) {
      setVisibility = false;
    }
    
    else {
      setVisibility = true;
    }
  
  if(mode == "speed and theta"){
    label6.setVisible(true);
    speedSlider.setVisible(setVisibility);
  }
  
  else {
    speedSlider.setVisible(false);
    label6.setVisible(false);
    
  }
  
  // Makes GUI visible or not depending on if the animation is running
  startPositionX.setVisible(setVisibility);
  startPositionY.setVisible(setVisibility);
  endPositionX.setVisible(setVisibility);
  endPositionY.setVisible(setVisibility);
  thetaSlider.setVisible(setVisibility);
  playButton.setVisible(setVisibility);
  dropList1.setVisible(setVisibility);
  demo1.setVisible(setVisibility);
  demo2.setVisible(setVisibility);
  demo3.setVisible(setVisibility);
  demo4.setVisible(setVisibility);
  demo5.setVisible(setVisibility);
  demo6.setVisible(setVisibility);
  
}

void setDemoValues(int i) {
  // File reading
  String thisRow = allData[i - 1];
  
  String[] thisDemoParts = thisRow.split(",");
  
  myProjectile.resetStats();
  
  // Sets variables for mode 1
  if(i < 4) {
    dropList1.setSelected(0);
    mode = "speed and theta";
    speedSlider.setValue(int(thisDemoParts[5]));
  }
  
  // Sets variables for mode 2
  else {
    dropList1.setSelected(1);
    mode = "theta";
  }
  
  startPositionX.setValue(int(thisDemoParts[0]));
  startPositionY.setValue(int(thisDemoParts[1]));
  endPositionX.setValue(int(thisDemoParts[2]));
  endPositionY.setValue(int(thisDemoParts[3]));
  thetaSlider.setValue(int(thisDemoParts[4]));
}

// Draws direction and scale
void drawDirectionAndScale() {
  line(50, 525, 100, 525);
  line(75, 500, 75, 550);
  textSize(10);
  text("Up", 70, 490);
  text("Down", 60, 570);
  text("Forward", 105, 530);
  text("Backward", 0, 530);
  
  noFill();
  strokeWeight(2);
  beginShape();
  vertex(585, 560);
  vertex(585, 570);
  vertex(535, 570);
  vertex(535, 560);
  endShape();
  
  fill(255, 255, 0);
  text("50 m", 505, 570);
}
