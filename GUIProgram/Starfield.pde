// starfield generation
void starfield(int speed){
  
  strokeWeight(2);
  
  translate(width/2, height*0.75);
    
  for (int i=0; i<stars.length; i++) {
    stars[i].update(speed);
    
    stars[i].show();
  }
}
