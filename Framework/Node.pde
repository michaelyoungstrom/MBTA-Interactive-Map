class Node {
  String label;
  float x, y; 
  int index;  
  
  Node(String label, float x, float y, int index) {
    this.label = label; 
    this.x = x;
    this.y = y;
    this.index = index;
  }
  
  int getIndex() {
    return index;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }

  void draw() {
    stroke(0); 
    strokeWeight(1);
    
    fill(255);  
    ellipse(x, y, 5, 5);
  }
  
  void mouseClicked(){
    print("hi");
  }
}