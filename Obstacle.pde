class Obstacle {
   PVector location;
   
   Obstacle (float xx, float yy) {
     location = new PVector(xx,yy);
   }
   
   void go () {
     
   }
   
   void place () {
     fill(0, 0, 0);
     ellipse(location.x, location.y, 10, 10);
   }
}