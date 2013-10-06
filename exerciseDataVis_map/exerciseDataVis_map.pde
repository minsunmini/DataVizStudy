PImage mapImage;
Table locationTable;
Table nameTable;
int rowCount;

Table dataTable;
float dataMin = -10; //set the min&max so we can do changing data
float dataMax = 10;
Integrator [] interpolators;

//global variables set in drawData() and read in draw()
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

void setup() {
  size(640, 400);

  //load the image of United States
  mapImage = loadImage("map.png");

  //load table
  locationTable = new Table("locations.tsv");

  //The row count will be used a lot, so store it globally
  rowCount = locationTable.getRowCount();

  //read the data table
  dataTable = new Table("random.tsv");

  //read the name table
  nameTable = new Table("names.tsv");

  //Setup: load initial values into the Integrator.
  interpolators = new Integrator[rowCount];

  for (int row = 0; row < rowCount; row++) {
    float initialValue = dataTable.getFloat(row, 1);
    //interpolators[row] = new Integrator(initialValue);
    //or
    //you can change the motion by playing with Integrator object
    //Integrator(put initial value, damping, attraction)
    interpolators[row] = new Integrator(initialValue, 0.5, 0.01); //slower
    //interpolators[row] = new Integrator(initialValue, 0.9, 0.1); //bouncy
  }

  //load the font
  PFont font = loadFont("Univers-Bold-12.vlw");
  textFont(font); //sets the font

  smooth();
  noStroke();
  
  //one way to change how fast the shape change is to
  //set the framerate
  frameRate(30); 
}

void draw() {
  background(255);
  image(mapImage, 0, 0);

  //Draw: update the Integrator with the current values, which
  //are either those from the setup() function or those
  //loaded by the target() function issued in updateTable().
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].update();
  }

  closestDist = MAX_FLOAT;

  for (int row = 0; row < rowCount; row++) {
    String abbrev = dataTable.getRowName(row);

    float x = locationTable.getFloat(abbrev, 1);
    float y = locationTable.getFloat(abbrev, 2);

    drawData(x, y, abbrev);
  }

  //use global variables set in drawData()
  //to draw text related to closest circle.
  if (closestDist != MAX_FLOAT) {
    fill(0);
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
  }

  println(closestDist);
}

//map the size of the ellipse to the data value
void drawData (float x, float y, String abbrev) {

  //figure out what row this is.
  int row = dataTable.getRowIndex(abbrev);

  //get the current value.
  float value = interpolators[row].value;

  float radius = 0;
  if (value >= 0) {
    radius = map(value, 0, dataMax, 1.5, 15);
    fill(#4422CC); //blue
  } 
  else {
    radius = map(value, 0, dataMin, 1.5, 15);
    fill(#FF4422);
  }
  ellipseMode(RADIUS); //change the ellipse mode to Radius
  ellipse(x, y, radius, radius); //this will draw the circle

  //create a variable to hold distance
  float d = dist(x, y, mouseX, mouseY);

  //because following check is done each time a new cirlcle
  //is drawn, we end of with the values of the circle
  //closest to the mouse

  if ((d < radius +2) && (d < closestDist)) {
    closestDist = d;
    String name = nameTable.getString(abbrev, 1);
    //nf() sets specifies the number of digits to the
    //left & right of the decimal point.

    //nfp() put "+" or "-" signs depending on the value
    closestText = name + " " + nfp(value, 0, 2);
    closestTextX = x;
    closestTextY = y-radius-4;
  }
}

//when key is pressed the values are randomized and overwritten
void keyPressed() {
  if (key == ' ') {
    updateTable();
  }
}

void updateTable () {
  for (int row = 0; row < rowCount; row++) {
    float newValue = random(-10, 10);
    interpolators[row].target(newValue);
  }
}

