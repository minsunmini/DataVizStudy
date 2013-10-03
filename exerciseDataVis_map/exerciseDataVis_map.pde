//create an image variable that will hold the file
PImage mapImage;
Table locationTable;
int rowCount;
Table dataTable;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

void setup() {
  size(640, 400);
  //load the image of United States
  mapImage = loadImage("map.png");

  //Make a data table from a file that contains
  //the coordinates of each state
  locationTable = new Table("locations.tsv");

  //The row count will be used a lot, so store it globally
  rowCount = locationTable.getRowCount();
  
  //read the data table
  dataTable = new Table("random.tsv");
  
  //find the minimum and maximum values.
  for (int row = 0; row < rowCount; row++) {
    float value = dataTable.getFloat(row, 1);
    
    if (value > dataMax) {
      dataMax = value;
    }
    if (value < dataMin) {
      dataMin = value;
    }
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);

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
}

//map the size of the ellipse to the data value
void drawData (float x, float y, String abbrev) {
  
  /*
  //get data value for state
  float value = dataTable.getFloat(abbrev, 1);
  
  //Re-map the value to a number between 2 and 40
  float mapped = map(value, dataMin, dataMax, 2, 40);
  
  //Draw an ellipse for this item
  ellipse(x, y, mapped, mapped);
  */
  
  //change the color
  float value = dataTable.getFloat(abbrev, 1);
  float percent = norm(value, dataMin, dataMax);
  
  //red to blue
  color between = lerpColor(#FF4422, #4422CC, percent);
  fill(between);
  ellipse(x, y, 15, 15);
}
