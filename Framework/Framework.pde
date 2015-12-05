import processing.pdf.*;

// nodes
int nodeCount; 
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

// selection
Node selection;

// record
boolean record; 

// edges
int edgeCount; 
Edge[] edges = new Edge[126];

Table connectionTable;
Table locationTable;

// font
PFont font; 

float[] xArray = new float[126];
float[] yArray = new float[126];

String fromName = " ", toName = " ", minutesName = " ", minutesUnit = " ";

Node A;
Node B;
int numOfNodes = 0;
float numOfMinutes = 0;

boolean[] activeNodes;
boolean[] activeEdges;

color[] startingCol = new color[126];

void setup() {
  size(600, 600);
  font = createFont("SansSerif", 10);
  loadData();
  initializeActiveDataStructures();
  initializeAdjacencyMatrix();
  
  colorMode(HSB);
  for (int i = 0; i < edgeCount; i++){
    startingCol[i] = edges[i].getStartColor();
  }
  

  
}

void loadData() {
  
  connectionTable = new Table("connections.csv");
  locationTable = new Table("locations.csv");
  
  int count = locationTable.getRowCount();
  String index, from, to, col;
  float x, y, min;
  
  for (int i = 0; i < count; i++){
    index = locationTable.getString(i, 0);
    x = Float.parseFloat(locationTable.getString(i, 1));
    xArray[i] = x;
    y = Float.parseFloat(locationTable.getString(i, 2));
    yArray[i] = y;
    addNode(index, x, y);
  }
  
  int count2 = connectionTable.getRowCount();
  for (int q = 0; q < count2; q++){
    from = connectionTable.getString(q, 0);
    to = connectionTable.getString(q, 1);
    col = connectionTable.getString(q, 2);
    min = Float.parseFloat(connectionTable.getString(q, 3));
    
    addEdge(from, to, min, col);
  }
}

void addEdge(String fromLabel, String toLabel, float minutes, String col) {
  // find nodes
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);
  
  // old edge?
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      return; 
    }
  }
  
  // add edge
  Edge e = new Edge(from, to, minutes, col);
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e; 
}

Node findNode(String label) {
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label, 1, 1);
  }
  return n; 
}

Node addNode(String label, float x, float y) {
  
  Node n = new Node(label, x, y, nodeCount);
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n; 
}

void draw() {
  if (record) {
    beginRecord(PDF, "output.pdf");
  }
  
  textFont(font); 
  smooth();
 
  background(255);
  
  float x, y;
  String name;
  
  fill(0, 0, 0);
  text("From: ", 10, 15);
  text(fromName, 40, 15);
  text("To: ", 10, 30);
  text(toName, 30, 30);
  text("Travel Time: ", 10, 45);
  text(minutesName, 75, 45);
  text(minutesUnit, 100, 45);
  
  // draw the edges
  for (int i = 0; i < edgeCount; i++) {
    if (activeEdges[i]){
      edges[i].draw();
    } else {
      edges[i].setActive(false);
      edges[i].draw();
    }
  }
  
  // draw the nodes
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].draw();
  }
  
  if (record) {
    endRecord();
    record = false;
  }
}

void mousePressed() {
  
  
  float x,y;
  if (mouseButton == RIGHT){
    
    if (numOfNodes == 0){
      for (int i = 0; i < nodeCount; i++) {
        x = nodes[i].getX();
        y = nodes[i].getY();
        float xDist = abs(mouseX - x);
        float yDist = abs(mouseY - y);
        if (xDist <= 5 && yDist <= 5){
          A = nodes[i];
          numOfNodes += 1;
          fromName = locationTable.getString(i, 0);
        }
      }
    } else if (numOfNodes == 1){
      for (int i = 0; i < nodeCount; i++) {
        x = nodes[i].getX();
        y = nodes[i].getY();
        float xDist = abs(mouseX - x);
        float yDist = abs(mouseY - y);
        if (xDist <= 5 && yDist <= 5){
          B = nodes[i];
          numOfNodes += 1;
          toName = locationTable.getString(i, 0);
          numOfMinutes = shortestPath(A.getIndex(), B.getIndex());
          minutesName = Float.toString(numOfMinutes);
          minutesUnit = "minutes";
        }
      }
    }
  }
  
  
  if (mouseButton == LEFT) {
    numOfNodes = 0;
    numOfMinutes = 0;
    minutesName = " ";
    minutesUnit = " ";
    fromName = " ";
    toName = " ";
    
    for (int i = 0; i < activeEdges.length; i++){
      activeEdges[i] = true;
      edges[i].setActive(true);
    }
    
    for (int i = 0; i < activeNodes.length; i++){
      activeNodes[i] = true;
    }
    
  }
  
}

void mouseDragged() {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
  }
}

void mouseReleased() {
  selection = null;
}

void keyPressed() {
  if (key == 'p') {
    record = true;
  }
}

void mouseMoved(){
  
}