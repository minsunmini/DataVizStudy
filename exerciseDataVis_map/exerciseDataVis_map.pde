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
  //the value in the random.tsv is reflected in the size of the circle
   //get data value for state
   float value = dataTable.getFloat(abbrev, 1);
   
   //Re-map the value to a number between 2 and 40
   float mapped = map(value, dataMin, dataMax, 2, 40);
   
   //Draw an ellipse for this item
   ellipse(x, y, mapped, mapped);
   */

  /*
  //the value is varied by the color between red to blue
   //change the color
   float value = dataTable.getFloat(abbrev, 1);
   float percent = norm(value, dataMin, dataMax);
   
   //red to blue
   color between = lerpColor(#FF4422, #4422CC, percent);
   fill(between);
   ellipse(x, y, 15, 15);
   */

  /*
  //the value is separated into positive and negative number
   //and smaller the negative number, bigger the red circle
   //and bigger the positive number, bigger the blue circle
   float value = dataTable.getFloat(abbrev, 1);
   float diameter = 0;
   if (value >= 0) {
   diameter = map(value, 0, dataMax, 3, 30);
   fill (#333366);
   } else {
   diameter = map(value, 0, dataMin, 3, 30);
   fill (#EC5166);
   }
   ellipse (x, y, diameter, diameter);
   */

  //*
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
}

