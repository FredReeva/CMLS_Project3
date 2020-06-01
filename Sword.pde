// older
/*
void sword(float posX, float posY, float prevX, float prevY) {
  
  stroke(rCol, gCol, bCol);
  strokeWeight(10);
  strokeCap(ROUND);
  strokeJoin(ROUND);
      
  fill(rCol, gCol, bCol);
  
  
    triangle(-5 - (posX - width/2)*0.20, +25, (posX - width/2), (posY - height*0.75), (prevX - width/2), (prevY - height*0.75)); 

 }
 */
 
// newer by manuel
void sword(PVector tip, PVector prevTip, PVector hold, float alpha) {
  
  stroke(rCol, gCol, bCol, alpha); //alpha
  strokeWeight(10);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  fill(rCol, gCol, bCol, alpha); //alpha
  triangle(0, 0, tip.x,tip.y, prevTip.x,prevTip.y);
  //line(0,0,tip.x,tip.y);
  
  stroke(200, 200, 200);
  strokeWeight(15);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  fill(200, 200, 200);
  line(0,0,hold.x,hold.y);
  

 } 
 
