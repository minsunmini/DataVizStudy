PImage mapImage;
Table locationTable;
Table valueTable;
int rowCount = 0;

float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

PFont univers;

void setup() {
  size(640, 400);
  mapImage = loadImage("map.png");
  locationTable = new Table("locations.tsv");
  valueTable = new Table("random.tsv");
  univers = loadFont("Univers-Bold-12.vlw");

  //need to know how many row
  rowCount = locationTable.getRowCount (); 

  for (int row = 0; row < rowCount; row++) {
    float value = valueTable.getFloat(row, 1);
    if (value < dataMin) {
      dataMin = value;
    } 
    if (value > dataMax) {
      dataMax = value;
    }
    println(dataMin);
  }
}


void draw() {

  image(mapImage, 0, 0);

  for (int row = 0; row < rowCount; row++) {

    String stateAbb = locationTable.getRowName(row);

    float locationX = locationTable.getFloat(stateAbb, 1);
    float locationY = locationTable.getFloat(stateAbb, 2);

    drawData(locationX, locationY, stateAbb);
  }
}

void drawData (float locationX, float locationY, String stateAbb) {
  fill(0, 0, 255, 80);
  noStroke();

  float value = valueTable.getFloat(stateAbb, 1);
  float diameter = 0;

  if (value >= 0) {
    float mappedValue = map(value, 0, dataMax, 0, 255);
    diameter = map(value, 0, dataMax, 3, 40);
    fill (0,0,255, mappedValue);
  } 
  else {
    float mappedValue = map(value, 0, dataMin, 0, 255);
     diameter = map(value, 0, dataMin, 3, 40);
    fill(255, 0, 0, mappedValue);
  }
  ellipse(locationX, locationY, diameter, diameter);
}

