// The World (a list of Obstacle objects)
// It uses the class Obstacle

class World{
    ArrayList<Obstacle> obstacles; // An ArrayList for all the boids

  World() {
    obstacles = new ArrayList<Obstacle>(); // Initialize the ArrayList
  }
  
  //Method to be called from draw to put the obstacles in the display continuosly
  void putObstacles (){
    for (Obstacle o : obstacles) {
          o.place();
    } 
  }

  void addObstacle(Obstacle o) {
    obstacles.add(o);
  }
  
  void remObstacles() {
    obstacles.clear();
  }
  
}