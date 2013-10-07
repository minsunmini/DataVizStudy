PImage mapImage;
Table locationTable;
Table valueTable;
int rowCount = 0;

float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

void setup() {
  size(640, 400);
  mapImage = loadImage("map.png");
  locationTable = new Table("locations.tsv");
  valueTable = new Table("random.tsv");

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
  fill(0, 80);
  noStroke();

  float value = valueTable.getFloat(stateAbb, 1);
  float mappedValue = map(value, dataMin, dataMax, 2, 40);
  ellipse(locationX, locationY, mappedValue, mappedValue);
}

