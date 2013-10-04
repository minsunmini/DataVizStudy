//create an image variable that will hold the file
PImage mapImage;
Table locationTable;
Table nameTable;
int rowCount;
Table dataTable;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

//global variables set in drawData() and read in draw()
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

void setup() {
  size(640, 400);
  
  //load the font
  PFont font = loadFont("Univers-Bold-12.vlw");
  textFont(font); //sets the font
  
  //load the image of United States
  mapImage = loadImage("map.png");

  //Make a data table from a file that contains
  //the coordinates of each state
  locationTable = new Table("locations.tsv");

  //The row count will be used a lot, so store it globally
  rowCount = locationTable.getRowCount();

  //read the data table
  dataTable = new Table("random.tsv");
  
  //read the name table
  nameTable = new Table("names.tsv");

  //find the minimum and maximum values.
  for (int row = 0; row < rowCount; row++) {
    float value = dataTable.getFloat(row, 1);

    if (value > dataMax) {
      dataMax = value;
    }
    if (value < dataMin) {
      dataMin = value;
    }
    println(dataMin);
    println(dataMax);
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);
  closestDist = MAX_FLOAT;

  //drawing attributes for the ellipses
  smooth ();
  fill(192, 0, 0);
  noStroke();

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
}

//map the size of the ellipse to the data value
void drawData (float x, float y, String abbrev) {

  /*
  //same as the above example, but instead of size
  //I will use transparency (alpha)
  float value = dataTable.getFloat(abbrev, 1);
  float transparency = 0;

  if (value >=0) {
    transparency = map(value, 0, dataMax, 0, 255);
    fill(#333366, transparency);
  } 
  else {
    transparency = map(value, 0, dataMin, 0, 255);
    fill(#EC5166, transparency);
  }
  ellipse (x, y, 20, 20);
  */
  
  //roll over
  float value = dataTable.getFloat(abbrev, 1);
  float radius = 0;
  if (value >= 0) {
    radius = map(value, 0, dataMax, 1.5, 15);
    fill(#4422CC); //blue
  } else {
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
    closestText = name + " " + value;
    closestTextX = x;
    closestTextY = y-radius-4;
  }
}

