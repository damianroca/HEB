// The Flock (a list of Boid objects)
// It uses the class Boid
class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  int color1;
  int color2;
  int color3;
  String name;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }
  
  //constructor to add a specific color -- to represent different flocks
  //it can be extended to other shapes, etc ... while maintaining the rules
  Flock(int c1, int c2, int c3) {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    color1=c1;
    color2=c2;
    color3=c3;
  }

  void run() {
    for (Boid b : boids) {
      b.run(this);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b, Boolean dir, PVector d, float vel) {
    //When a new boid is added to the system gets the color of the its flock
    b.col1=color1;
    b.col2=color2;
    b.col3=color3;    
    b.direction=dir;
    b.target=d;
    //each boid can have its own maximumspeed -- although currently we define it at the flock level
    b.mvel=vel;
    //Add the boid to the ArrayList of the flock
    boids.add(b);
  }
  
   //void addBoid(Boid b, Boolean dir, PVector d) {
   // //When a new boid is added to the system gets the color of the its flock
   // b.col1=color1;
   // b.col2=color2;
   // b.col3=color3;    
   // b.direction=dir;
   // b.target=d;
   // //Add the boid to the ArrayList of the flock
   // boids.add(b);
  //}
  
  void setName(String s){
    name=s;
  }
  String getName(){
    return name;
  }

}