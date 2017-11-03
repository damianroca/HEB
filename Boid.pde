// The Boid class

class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  //blue 135,206,235
  int col1;
  int col2;
  int col3;
  Boolean direction;
  PVector target;
  Boolean unique=false;
  float mvel;
  int iter=0;
  
  //Apply the rules within a distance from the boid
  //ArrayList<Boid> neighbors;
    Boid(float x, float y) {
      acceleration = new PVector(0, 0);
      velocity = PVector.random2D();
      location = new PVector(x, y);
      r = 2.0;
      //do not overwrite the value here
      maxspeed = 1.5;
      //println(m_vel);
      //Influence the reaction infront of obstacles
      maxforce = 0.10;
  }

  void run(Flock f) {
    //Apply the set of rules that create the emergent flock behavior
    //Determine if we use all the boids or just the neighbors to apply the rules
    maxspeed=mvel;
    if(all_or_radius){
      flock(f.boids,f);
    }else{
      flock(getNeighbors(f.boids),f);
    }    
    //Update the location of the boids
    update();
    //To create the infinite display
    borders();
    //Draw the boids themselves -- as a triangle
    render(f);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  ArrayList<Boid> getNeighbors (ArrayList<Boid> b) {
    ArrayList<Boid> close = new ArrayList<Boid>();
    for (Boid test : b) {
      if (test == this) continue; //Do not compute with itself  -- original distance at 70 .. check with the document
      if (abs(test.location.x - this.location.x) < 200 &&
        abs(test.location.y - this.location.y) < 200) {
        close.add(test);
      }
    }
    return close;
  }  

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, Flock f) {
    //Use PVector to store the modified acceleration to be applied next cycle
    
    //the these 4 rules are applied to each flock instance we create :)
    // RULE 1: Separation --> Collision avoidance,, default value of the distance is 30
    PVector sep = separate(boids,70);   
    // RULE 2: Alignment --> Velocity Matching
    PVector ali = align(boids,55);      
    // RULE 3: Cohesion --> Flock centering
    PVector coh = cohesion(boids,55);  
    // RULE 4: Avoid obstacles
    PVector avoid_obs = avoidObstacles(world.obstacles);
    //RULE 5: Follow the mouse
   
   PVector follow = new PVector(0,0,0);
    if(r5_follow){
       follow = mouse();  
    }
    
    //RULE 6: Same rules applied to the other flock -- for the second level behavior -- second level flock
    // This rule only creates a second level flock between the two 1st level flocks -- each flock of the first level has implemented the first level rules
    //since they are instances of the same classes
    
    //Each type of flock, represented by different colors, need to apply the three rules to the other flock to create a second level flock.  flock_A <--> flock_B
    PVector avoid_2 = new PVector (0, 0);
    if(f.getName()=="flock1"){
      avoid_2 = separate(flock2.boids,70);
    }else if(f.getName()=="flock2") {
      avoid_2 = separate(flock.boids,70);
    }   
    PVector velocity_2 = new PVector (0, 0);
    if(f.getName()=="flock1"){
      velocity_2 = align(flock2.boids,70);
    }else if(f.getName()=="flock2") {
      velocity_2 = align(flock.boids,70);
    }
    PVector cohesion_2 = new PVector (0, 0);
    if(f.getName()=="flock1"){
      cohesion_2 = cohesion(flock2.boids,70);
    }else if(f.getName()=="flock2") {
      cohesion_2 = cohesion(flock.boids,70);
    }
    
    //One possibility is just to implement the collision avoidance rule between flocks
    PVector avoid_others = new PVector (0, 0);
    if(f.getName()=="flock1"){
      avoid_others = separate(flock2.boids,70);
    }else if(f.getName()=="flock2") {
      avoid_others = separate(flock.boids,70);
    }
    
    //Conditionals to detect the presence of the other boids
  if(f.getName()=="flock1"){
      //flock 1 is looking for boids of the flock2 in its proximity      
        for (Boid other : flock2.boids) {
          float d = PVector.dist(location, other.location);
            if ((d > 0) && (d < 100)) {
                target= new PVector(550, 570);
                mvel=1.2;    
                println("AAAA");
            }else if((d > 0) && (d < 80)){
              mvel= 0.7;
              target= new PVector(1024, 570);
            }else{
              mvel=1.0;
              target= new PVector(1024, 570);
            }
        }
    }else if(f.getName()=="flock2") {
      //flock2 is looking for boids of the flock1 in its proximity 
         for (Boid other : flock.boids) {
          float d = PVector.dist(location, other.location);
            if ((d > 0) && (d < 90)) {
                 target= new PVector(1024, 100);
                 mvel=2.0;
                  println("BBBB");
            }
          }
    }  
    
    
    if(change){
      //method to turn blue if there is a boid from the other flock close
      if(f.getName()=="flock1"){
        float desiredseparation = 100;
        // For every boid in the system, check if it's too close
        for (Boid other : flock2.boids) {
          float d = PVector.dist(location, other.location);
          // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
          if ((d > 0) && (d < desiredseparation)) {
            col1=135;
            col2=206;
            col3=235;
           // println("   change color to blue   ");
          }else{
            col1=f.color1;
            col2=f.color2;
            col3=f.color3;
            //println("   default color   ");
          }
        } 
      }else if(f.getName()=="flock2"){
        
      }
    }else{
      col1=f.color1;
      col2=f.color2;
      col3=f.color3;
    }
    
    
    // Arbitrarily weight these forces -- Very important -- Determine the emergent
    if(r1_separate){
       sep.mult(3.0);
    }else{
       sep.mult(0.0);
    }
    if(r2_alignment){
       ali.mult(1.0);
    }else{
       ali.mult(0.0);
    }
    if(r3_cohesion){
      coh.mult(1.0);
    }else{
      coh.mult(0.0);
    }
    if(r4_obstacles){
      avoid_obs.mult(3.0);
    }else{
      avoid_obs.mult(0.0);
    }
    if(r5_follow){
      follow.mult(1.0);
    }else{
      follow.mult(0.0);
    }
    //control the flock 2
    if(r6_flock_2){
        avoid_2.mult(3.0);
        velocity_2.mult(1.0);
        cohesion_2.mult(1.0);
    }else{
        avoid_2.mult(0.0);
        velocity_2.mult(0.0);
        cohesion_2.mult(0.0);
    }
    
    //ponderate the rule to avoid collisions between different types of boids
    avoid_others.mult(3.0);
  
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(avoid_obs);
    applyForce(follow);
    applyForce(avoid_others);
    
    applyForce(avoid_2);
    applyForce(velocity_2);
    applyForce(cohesion_2);
  }

  // Method to update location
  void update() {
    // Update velocity with the acceleration from the three rules
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    desired.setMag(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render(Flock fl) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    //color inside the triangle
    fill(col1,col2,col3);
    //color of the triangle borders
    stroke( 102, 102, 102);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    //Method that really draw the triangles
    beginShape(TRIANGLES);
      //Size of the triangles being displaid
      vertex(0, -r*4);
      vertex(-r*2, r*3);
      vertex(r*2, r*3);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    //if (location.x < -r) location.x = width+r;
    //if (location.y < -r) location.y = height+r;
    //if (location.x > width+r) location.x = -r;
    //if (location.y > height+r) location.y = -r;   
    
    if (location.x < -r) velocity.x=10;
    if (location.y < -r) velocity.y = 10;
    if (location.x > width+r) velocity.x = -10;
    if (location.y > height+r) velocity.y = -10;   
    
  }

//Each rule is implemented here
  // RULE 1: Separation
  // Method checks for nearby boids and steers away
  // the desired distance is specified as a parameter because 1st level uses one value and seconf level uses another
  PVector separate (ArrayList<Boid> boids, float desiredseparation) {
    //float desiredseparation = 30;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    //Average -- divide by how many
    //Modifies the emergent behavior -- It allows overlappings
    //if (count > 0) {
    //  steer.div((float)count);
    //}
    ////As long as the vector is greater than 0
    //if (steer.mag() > 0) {
    //  // Implement Reynolds: Steering = Desired - Velocity
    //  steer.normalize();
    //  steer.mult(maxspeed);
    //  steer.sub(velocity);
    //  steer.limit(maxforce);
    //}
    return steer;
  }

  // RULE 2: Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids, float neighbordist) {
    //float neighbordist = 55;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
    //return sum;
  }

  // RULE 3: Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids,float neighbordist) {
    //float neighbordist = 55;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
  //RULE 4: Avoid Obstacles
  PVector avoidObstacles(ArrayList<Obstacle> av) {
    PVector steer = new PVector(0, 0);
    int count = 0;
    //default is 40
    float neighbordist = 40;
    for (Obstacle other : av) {
      //Distance between the boids (location) and each obstacle (other.pos)
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < neighbordist)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);       
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }


 //RULE 5: modify the velocity when the intersection is reached
  //PVector mouse () {
  //  PVector steer = new PVector(0, 0);
  //  PVector[] t = new PVector[5];
  //  t[0]=new PVector(1024,290);

  //  PVector m=t[0];
  //  PVector diff = PVector.sub(m, location);
  //  //using the old boolean to choose destination to control the maxspeed of the platoon
  //  if(direction){
  //    maxspeed = 2.5;println("A");
  //  }else{
  //    maxspeed = 1.5;println("B");
  //  } 
  //  //apply a constant to ponderate the vector
  //  diff.div(800);
  //  steer.add(diff);
  //  return steer; 
  //}

    ////RULE 5: modify the velocity when the intersection is reached
  //PVector mouse () {
    //PVector steer = new PVector(0, 0);
    //PVector[] t = new PVector[5];
    //t[0]=new PVector(460,290);
    //t[1]=new PVector(1024,290);

    //PVector m=t[iter];
    //PVector diff = PVector.sub(m, location);
    //if(m.dist(location)<60){
    //  if (iter<1){
    //    iter++;
    //    println(iter);
    //  }   
    //  if(!unique){
    //    unique=true;
    //    maxspeed = 3.0;
    //    println("modified velocity");
        
    //    if(random(0,1)<0.5){
    //        maxspeed = 3.0;println("A");
    //      }else{
    //        maxspeed = 1.5;println("B");
    //      }
    //  }
    //}
    ////apply a constant to ponderate the vector
    //diff.div(800);
    //steer.add(diff);
    //return steer; 
 // }
//  
  
  ////RULE 5: split the flock
  //PVector mouse () {
  //  PVector steer = new PVector(0, 0);
  //  PVector[] t = new PVector[5];
  //  t[0]=new PVector(460,290);
  //  t[1]=new PVector(465,0);
  //  t[2]=new PVector(465,576);

  //  PVector m=t[iter];
  //  PVector diff = PVector.sub(m, location);
  //  if(m.dist(location)<60){
  //    if (iter<1){
  //      iter++;
  //      println(iter);
  //    }   
  //    if(!unique){
  //      unique=true;
  //        if(random(0,1)<0.5){
  //          iter=1;println("Boid to A");
  //        }else{
  //          iter=2;println("Boid to B");
  //        }
  //    }
      
  //  }
  //  //apply a constant to ponderate the vector
  //  diff.div(800);
  //  steer.add(diff);
  //  return steer; 
  //}
  
  ////RULE 5: Follow an array of targets
  //PVector mouse () {
  //  PVector steer = new PVector(0, 0);
    
  //  PVector[] t = new PVector[5];
  //  t[0]=new PVector(400,290);
  //  t[1]=new PVector(465,220);
  //  t[2]=new PVector(465,370);
  //  t[3]=new PVector(540,290);
  //  t[4]=new PVector(1015,290);
  //  PVector m=t[iter];
  //  PVector diff = PVector.sub(m, location);
  //  if(m.dist(location)<10){
  //    if (iter<4){
  //      iter++;
  //      println(iter);
  //    }else{
  //      iter=4;
  //    }
  //  }
  //  //apply a constant to ponderate the vector
  //  diff.div(800);
  //  steer.add(diff);
  //  return steer; 
  //}
  
  ////RULE 5: Follow the mouse or a destination point  -- modified to implement second level rules to optimize the transition between different types of boids
  PVector mouse () {
    PVector steer = new PVector(0, 0);
    PVector m;
    //Default scenario where the boids go to the designated target
    m= target;
    

     

    PVector diff = PVector.sub(m, location);
    //apply a constant to ponderate the vector
    diff.div(800);
    steer.add(diff);
    //necessary not to accumulate the deviation 
    //m=target;
    return steer;
  }
  
    ////RULE 5: Follow the mouse or a destination point  -- traditional rule
  //PVector mouse () {
  //  PVector steer = new PVector(0, 0);
  //  PVector m;
  //  if(direction){
  //   //target specified in each void
  //   m= target;
  //   //apply a random deviation to the destination, also restore the value after the calculations
  //   //m.add(random(-20,+20),random(-20,+20));
  //   //println("First do not follow the mouse");
  //  }else{
  //   m= new PVector (mouseX,mouseY);
  //   //println("rest do");
  //  }
  //  PVector diff = PVector.sub(m, location);
  //  //apply a constant to ponderate the vector
  //  diff.div(800);
  //  steer.add(diff);
  //  //necessary not to accumulate the deviation 
  //  //m=target;
  //  return steer;
  //}
//  
  ////RULE 6: Avoid the other flock as if they were obstacles   --> it is not used in the current code
  //PVector avoid_others(ArrayList<Boid> av) {
  //PVector steer = new PVector(0, 0);
  //int count = 0;
  //float neighbordist = 50;
  //for (Boid other : av) {
  //  //Distance between the boids (location) and each obstacle (other.pos)
  //  float d = PVector.dist(location, other.location);
  //  // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
  //  if ( (d < neighbordist)) {
  //    // Calculate vector pointing away from neighbor
  //    PVector diff = PVector.sub(location, other.location);       
  //    diff.normalize();
  //    diff.div(d);        // Weight by distance
  //    steer.add(diff);
  //    count++;            // Keep track of how many
  //  }
  //}
  //return steer;
  //}  
  

} 
  