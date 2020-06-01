// lightsaber
void sword(PVector tip, PVector prevTip, PVector hold, float alpha) {
  
  // lightsaber
  stroke(rCol, gCol, bCol, alpha);
  strokeWeight(10);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  fill(rCol, gCol, bCol, alpha);
  triangle(0, 0, tip.x,tip.y, prevTip.x,prevTip.y);
  
  // holder
  stroke(200, 200, 200);
  strokeWeight(15);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  fill(200, 200, 200);
  line(0,0,hold.x,hold.y);
  
 } 
 
