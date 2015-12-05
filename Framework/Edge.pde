class Edge {
  Node from; 
  Node to; 
  float minutes;
  String col;
  color startCol;
  boolean active;
  
  color red = color(230,16,19);
  color green = color(1,104,64);
  color blue = color(0, 48, 148);
  color orange = color(255, 131, 5);
  
  Edge(Node from, Node to, float minutes, String col) {
    this.from = from; 
    this.to = to; 
    this.minutes = minutes;
    this.col = col;
    this.active = true;
    
    char colorChar = col.charAt(0);
    if (colorChar == 'r'){
      startCol = color(1, 93, 90);
    } else if (colorChar == 'g'){
      startCol = color(1,104,64);
    } else if (colorChar == 'b'){
      startCol = color(0, 48, 148);
    } else if (colorChar == 'o'){
      startCol = color(255, 131, 5);
    }
  }
  
  Node getFromNode() {
    return from;
  }
  
  Node getToNode() {
    return to;
  }
  
  float getMinutes() {
    return minutes;
  }
  
  String getCol(){
    return col;
  }
  
  color getStartColor(){
    return startCol;
  }
  
  void setActive(boolean temp){
    this.active = temp;
  }
  
  void draw() {
    char colorChar = col.charAt(0);
    if (colorChar == 'r'){
      stroke(red);
      if(this.active == false){
         stroke(230, 0, 200);
      }
    } else if (colorChar == 'g'){
      stroke(green);
      if(this.active == false){
         stroke(230, 0, 200);
      }
    } else if (colorChar == 'b'){
      stroke(blue);
      if(this.active == false){
         stroke(230, 0, 200);
      }
    } else if (colorChar == 'o'){
      stroke(orange);
      if(this.active == false){
         stroke(230, 0, 200);
      }
    }
    
    strokeWeight(2);
    line(from.x, from.y, to.x, to.y);
  }
}  