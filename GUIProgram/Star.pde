class Star {
  float x;
  float y;
  float z;
  
  float sx;
  float sy;
  
  float px;
  float py;
  float pz;
   
  Star() {
    x = random (-width, width);
    y = random (-height, height);
    z = random (width);
    pz = z;
  }
  
  void update(int speed) {
    
    pz = z;
    z = z - speed;
    if (z < 1) {
      z = width;
      pz = z;
      x = random(-width, width);
      y = random (-height, height);
    }
  }
  
  void show() {
    
    sx = map(x / z, 0, 1, 0, width);
    sy = map(y / z, 0, 1, 0, height);
    
    px = map(x / pz, 0, 1, 0, width);
    py = map(y / pz, 0, 1, 0, height);    
    
    float r = map(z, 0, width, 8, 0);
    ellipse(sx, sy, r, r);
    
    stroke(255);
    line(px, py, sx, sy);
  }
}
