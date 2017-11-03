/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

import controlP5.*;
ControlP5 cp5;
controlP5.Button b;

//Booleans to control the buttons functionalities
Boolean bound;
Boolean all_or_radius=true;
Boolean r1_separate;
Boolean r2_alignment;
Boolean r3_cohesion;
Boolean r4_obstacles;
Boolean r5_follow;
Boolean r6_flock_2;
Boolean second;
Boolean change;

//control how many times you clicked a button
int count;
//Global variables
//Create a flock of birds 
Flock flock;
Flock flock2;
  boolean first=true;
//Create a world: obstacles that define the environment
World world;

//By default the mouse is adding boids
String add="boid";
//to control the displayed messages on the screen
PFont info;

//Constructor method. Set up the environment and the elements to be included
//in the simulation
void setup() {
  
  info = createFont("Arial",30,true); // Arial, 16 point, anti-aliasing on
  count=0;
  //Define the size of the display. Both values are writen in width and height
  size(1024, 576);
  //orange
  //flock = new Flock(255,178,102);
  //Light grey
  flock = new Flock(211,211,211);
  flock.setName("flock1");
  world = new World();
  //red
  //flock2 = new Flock(255,102,102);
  //Dark grey
  flock2 = new Flock(128,128,128);
  flock2.setName("flock2");
  add="";
  change=false;
  //blue 135,206,235

  // Add an initial set of boids into the system
  //for (int i = 0; i < 8; i++) {
  //    flock.addBoid(new Boid(width/2+random(-50,+50),height/2+random(-50,+50)),false,new PVector(465,0));
  //}
  
  // Add an initial set of boids into the system
  for (int i = 0; i < 8; i++) {
      //PArameter true is to make boids go to target destination instead of following the mouse. Also modified with true the flag of r5_destination to enforce since the beginning
      flock.addBoid(new Boid(170+random(-20,+20),290+random(-20,+20)),true,new PVector(1024,290),1.0);
  }
  for (int i = 0; i < 8; i++) {
        flock2.addBoid(new Boid(20+random(-20,+20),290+random(-20,+20)),true,new PVector(1024,290),1.3);
  }


  // Add an initial set of boids into the system
  //for (int i = 0; i < 20; i++) {
  //  //width and heigth are system var that have the size of the display 
  //  //The boids marked with true will go to a target destination point while the rest will follow the mouse pointer
  //  //This trick only works for the initial boids, not implemented in the rest
  //  //The boids are marked randomly to appear at the center of the canvas
  //  if(i<0){
  //     flock.addBoid(new Boid(width/2+random(-50,+50),height/2+random(-50,+50)),true);
  //  }else{
  //     flock.addBoid(new Boid(width/2+random(-50,+50),height/2+random(-50,+50)),false);
  //  }
  //}
  
  
  //true indicates they will go to the target destination instead of following the mouse when specified.
  
  /////////////Configuration for four group of boids going to its opposite point//////////////////
  ////group A
  //for (int i = 0; i < 6; i++) {
  //   flock.addBoid(new Boid(10+random(-50,+50),290+random(-20,+20)),true,new PVector(1024,290));
  //}
  ////group B
  //for (int i = 0; i < 6; i++) {
  //   flock.addBoid(new Boid(475+random(-50,+50),30+random(-20,+20)),true,new PVector(465,576));
  //}
  ////group C
  //for (int i = 0; i < 6; i++) {
  //   flock.addBoid(new Boid(1014+random(-50,+50),290+random(-20,+20)),true,new PVector(0,290));
  //}
  ////group D
  //for (int i = 0; i < 6; i++) {
  //   flock.addBoid(new Boid(475+random(-50,+50),566+random(-20,+20)),true,new PVector(465,0));
  //}
  
  
  ///////////////////////////4 platoons going to all directions//////////////////////////////////
  //for (int i = 0; i < 2; i++) {
  //   flock.addBoid(new Boid(10+random(-50,+50),290+random(-20,+20)),true,new PVector(1024,290));
  //   flock.addBoid(new Boid(10+random(-50,+50),290+random(-20,+20)),true,new PVector(465,0));
  //   flock.addBoid(new Boid(10+random(-50,+50),290+random(-20,+20)),true,new PVector(465,576)); 
  //}
  ////group B
  //for (int i = 0; i < 2; i++) {
  //   flock.addBoid(new Boid(475+random(-50,+50),30+random(-20,+20)),true,new PVector(465,576));
  //   flock.addBoid(new Boid(475+random(-50,+50),30+random(-20,+20)),true,new PVector(0,290));
  //   flock.addBoid(new Boid(475+random(-50,+50),30+random(-20,+20)),true,new PVector(1024,290));
  //}
  ////group C
  //for (int i = 0; i < 2; i++) {
  //   flock.addBoid(new Boid(1014+random(-50,+50),290+random(-20,+20)),true,new PVector(0,290));
  //   flock.addBoid(new Boid(1014+random(-50,+50),290+random(-20,+20)),true,new PVector(465,0));
  //   flock.addBoid(new Boid(1014+random(-50,+50),290+random(-20,+20)),true,new PVector(465,576)); 
     
  //}
  ////group D
  //for (int i = 0; i < 2; i++) {
  //   flock.addBoid(new Boid(475+random(-50,+50),566+random(-20,+20)),true,new PVector(465,0));
  //   flock.addBoid(new Boid(475+random(-50,+50),566+random(-20,+20)),true,new PVector(0,290));
  //   flock.addBoid(new Boid(475+random(-50,+50),566+random(-20,+20)),true,new PVector(1024,290));
  //}
  
  
  //////////////////////////////////direction lines separated/////////////////////////////////////
  ///////Version 1
  //flock.addBoid(new Boid(10,235),true,new PVector(1024,235));
  //flock.addBoid(new Boid(10,345),true,new PVector(1024,345));
  
  //flock.addBoid(new Boid(1014,290),true,new PVector(0,290));
  //flock.addBoid(new Boid(1014,290),true,new PVector(0,290));
  
    //////////////////////////////////direction lines separated -- multiple vehicles/////////////////////////////////////
  ///////Version 1
  
  //Boids at the left
  //flock.addBoid(new Boid(10,255),true,new PVector(1024,235));
  //flock.addBoid(new Boid(30,255),true,new PVector(1024,235));
  //flock.addBoid(new Boid(50,255),true,new PVector(1024,235));
  
  //flock.addBoid(new Boid(10,335),true,new PVector(1024,345));
  //flock.addBoid(new Boid(30,335),true,new PVector(1024,345));
  //flock.addBoid(new Boid(50,335),true,new PVector(1024,345));
  
  ////Boids at the right
  //flock.addBoid(new Boid(1014,290),true,new PVector(0,290));
  //flock.addBoid(new Boid(1014,290),true,new PVector(0,290));
  //flock.addBoid(new Boid(1014,290),true,new PVector(0,290));
  //flock.addBoid(new Boid(1014,290),true,new PVector(0,290));
  
  //////////Version 2  -- boid separation of 30 and obstacle separation 20
  ////Boids at the left
  //flock.addBoid(new Boid(10,255),true,new PVector(1024,255));
  //flock.addBoid(new Boid(30,255),true,new PVector(1024,255));
  //flock.addBoid(new Boid(50,255),true,new PVector(1024,255));
  
  //flock.addBoid(new Boid(10,275),true,new PVector(1024,200));
  //flock.addBoid(new Boid(30,275),true,new PVector(1024,180));
  //flock.addBoid(new Boid(50,275),true,new PVector(1024,200));
 
  ////Boids at the right
  //flock.addBoid(new Boid(980,335),true,new PVector(0,350));
  //flock.addBoid(new Boid(1000,335),true,new PVector(0,350));
  //flock.addBoid(new Boid(1020,335),true,new PVector(0,350));
  
  //flock.addBoid(new Boid(980,305),true,new PVector(0,370));
  //flock.addBoid(new Boid(1000,305),true,new PVector(0,370));
  //flock.addBoid(new Boid(1020,305),true,new PVector(0,370));
  
  
  ///////////////////////////////////Destination modifications////////////////////////////////////////////////
  //Boids at the left
  //Add random destinations instead of a single point   +random(-10,+10)
  //If only boid of the three has a random deviation nothing happens. If the three have the same random, the line is maintained
  
  //flock.addBoid(new Boid(10,290),true,new PVector(1000+random(-50,+50),290+random(-50,+50)));
  //flock.addBoid(new Boid(30,290),true,new PVector(1000+random(-50,+50),290+random(-50,+50)));
  //flock.addBoid(new Boid(50,290),true,new PVector(1000+random(-50,+50),290+random(-50,+50)));
  //println(1000+random(-50,+50),290+random(-50,+50));
  
  //boid to follow a set of targets
  //flock.addBoid(new Boid(10,290),true,new PVector(1000,290));

  
  //Boids at the right
  //flock.addBoid(new Boid(980,335),true,new PVector(0,350));
  //flock.addBoid(new Boid(1000,335),true,new PVector(0,350));
  //flock.addBoid(new Boid(1020,335),true,new PVector(0,350));

  
  
  //SEt of boids to try the splitting rule and the maxspeed rule 5
  //for (int i = 0; i < 1; i++) {
  //   flock.addBoid(new Boid(10,290),true,new PVector(1024,290));
  //   flock.addBoid(new Boid(10,290),true,new PVector(1024,290));
  //   flock.addBoid(new Boid(10,290),true,new PVector(1024,290)); 
  //   flock.addBoid(new Boid(10,290),true,new PVector(1024,290));
  //}
  
  
  //two groups of boids to test a persecution problem
    //for (int i = 0; i < 1; i++) {
    // flock.addBoid(new Boid(200,290),false,new PVector(1024,290));
    // flock.addBoid(new Boid(205,295),false,new PVector(1024,290));
    // flock.addBoid(new Boid(210,290),false,new PVector(1024,290)); 
    // flock.addBoid(new Boid(215,295),false,new PVector(1024,290));
  //}
//  //
    //for (int i = 0; i < 1; i++) {
    // flock.addBoid(new Boid(10,290),true,new PVector(1024,290));
    // flock.addBoid(new Boid(15,295),true,new PVector(1024,290));
    // flock.addBoid(new Boid(20,290),true,new PVector(1024,290)); 
    // flock.addBoid(new Boid(25,295),true,new PVector(1024,290));
  //}
//  
  
  //Define the limits of the world for the flocks. If we do not execute this method
  //the boids cross the display
  bound=true;
  //Apply or not the rules, controlled with buttons
  r1_separate=true;
  r2_alignment=true;
  r3_cohesion=true;
  r4_obstacles=true;
  //modified r5 to true the boids go to the target destination since the beginning
  r5_follow=true;
  r6_flock_2=false;
  //second controls the appearance of the second flock -- true to enable it from the beginning
  second=true;
  setupBoundaries();
  
  cp5 = new ControlP5(this);
  cp5.addButton("Reset")
     .setPosition(0,0)
     .setSize(60,20)
     .setId(1);
  cp5.addButton("Bound")
     .setPosition(60,0)
     .setSize(60,20)
     .setId(2);
  cp5.addButton("Separate")
     .setPosition(120,0)
     .setSize(60,20)
     .setId(3);
  cp5.addButton("Align")
     .setPosition(180,0)
     .setSize(60,20)
     .setId(4);
  cp5.addButton("Cohesion")
     .setPosition(240,0)
     .setSize(60,20)
     .setId(5);
  cp5.addButton("Obstacle")
     .setPosition(300,0)
     .setSize(60,20)
     .setId(6);
  cp5.addButton("Add_Boids")
     .setPosition(360,0)
     .setSize(60,20)
     .setId(7);  
  cp5.addButton("Add_Obs")
     .setPosition(420,0)
     .setSize(60,20)
     .setId(8);  
  cp5.addButton("Delete")
     .setPosition(480,0)
     .setSize(60,20)
     .setId(9); 
  cp5.addButton("Follow")
     .setPosition(540,0)
     .setSize(60,20)
     .setId(9);   
  cp5.addButton("Second")
     .setPosition(0,20)
     .setSize(60,20)
     .setId(10); 
  cp5.addButton("Flock2")
     .setPosition(60,20)
     .setSize(60,20)
     .setId(11);
  cp5.addButton("Change")
     .setPosition(120,20)
     .setSize(60,20)
     .setId(12);     
  }

//Method that keeps executing as an infinite loop. It controls the display
void draw() {
  //Set up the background color. 50:grey  255:white . Do it at the beginning or it overwrites everything
  background(255);

  //Display the boids
  flock.run();
  //controlling the display of the second flock in the screen
  //if(second){
  //  flock2.run();
  //}
  flock2.run();
  //Display the obstacles
  world.putObstacles();
  
  //to delete objects in the display
  if(add=="delete"){
    noFill();
    stroke(0, 100, 260);
    rect(mouseX - 15, mouseY - 15, 15 * 2, 15 *2);
    if (mousePressed) {
      for (int i=flock.boids.size()-1; i>-1;i--) {
        Boid d= flock.boids.get(i);
        if (abs(d.location.x - mouseX) < 15 && abs(d.location.y - mouseY) < 15) {
          flock.boids.remove(i);
        }}
      for (int i=flock2.boids.size()-1; i>-1;i--) {
        Boid d= flock2.boids.get(i);
        if (abs(d.location.x - mouseX) < 15 && abs(d.location.y - mouseY) < 15) {
          flock2.boids.remove(i);
        }}  
      for (int i=world.obstacles.size()-1;i>-1;i--) {
        Obstacle d= world.obstacles.get(i);
        if (abs(d.location.x - mouseX) < 15 && abs(d.location.y - mouseY) < 15) {
            world.obstacles.remove(i);
        }       
      }
    }  
  }
  
  if(cp5.isMouseOver(cp5.getController("Reset"))){
    textFont(info,16);                  
    fill(255);     
    text("Reset the display",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Bound"))){
    textFont(info,16);                  
    fill(255);     
    text("Eliminate the obstacles, including the bounds",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Separate"))){
    textFont(info,16);                  
    fill(255);     
    text("Do not apply the first rule, R1_Collision_Avoidance between boids",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Align"))){
    textFont(info,16);                  
    fill(255);     
    text("Do not apply the second rule, R2_Velocity_Matching ",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Cohesion"))){
    textFont(info,16);                  
    fill(255);     
    text("Do not apply the third rule, R3_Flock_Centering or cohesion",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Obstacle"))){
    textFont(info,16);                  
    fill(255);     
    text("Boids do not avoid obstacles, any of them",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Add_Boids"))){
    textFont(info,16);                  
    fill(255);     
    text("With mouse click/dragged (left and right) you will add boids",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Add_Obs"))){
    textFont(info,16);                  
    fill(255);     
    text("With mouse click/dragged (left and right) you will add obstacles",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Delete"))){
    textFont(info,16);                  
    fill(255);     
    text("Delete boids or obstacles inside the remarked area",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Follow"))){
    textFont(info,16);                  
    fill(255);     
    text("Make the boids follow the mouse pointer",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Second"))){
    textFont(info,16);                  
    fill(255);     
    text("Add a second independent boid ... by now :)",140,40);
  }else if(cp5.isMouseOver(cp5.getController("Flock2"))){
    textFont(info,16);                  
    fill(255);     
    text("Activate the second level flock",140,40);
  }
}

public void controlEvent(ControlEvent theEvent) {
  count++;
  println("Button pressed");
  switch(theEvent.getName()){
   case "Reset":{reset();break;} //To call the setup method again does not work, problems with buttons
   case "Bound":{bound=!bound;setupBoundaries();println("Obstacle bound: " + bound);break;}
   case "Separate":{r1_separate=!r1_separate;println("Rule 1, separation: " + r1_separate);break;}
   case "Align":{r2_alignment=!r2_alignment;println("Rule 2, velocity: " + r2_alignment);break;}
   case "Cohesion":{r3_cohesion=!r3_cohesion;println("Rule 3, center: " + r3_cohesion);break;}
   case "Obstacle":{r4_obstacles=!r4_obstacles;println("Avoid obstacles: " + r4_obstacles);break;} 
   case "Add_Boids":{add="boid";println("Adding boids by clicking ");break;} 
   case "Add_Obs":{add="obs";println("Adding obtacles by clicking ");break;}
   case "Delete":{add="delete";println("Delete");break;}
   case "Follow":{r5_follow=!r5_follow;println("Follow the mouse: " + r5_follow);break;}
   case "Second":{second=!second;second(second);println("Second flock displayed: " + second);break;}
   case "Flock2":{r6_flock_2=!r6_flock_2;println("Flocking between flocks: " + r6_flock_2);break;}
   case "Change":{change=!change;println("Change boids color: " + change);break;}
  }
}

void second(boolean s){
  // Add the seconf flock ... we do not need to replicat the three basic rules because they are embedded for each boid
    if(s&&first){
      for (int i = 0; i < 8; i++) {
        flock2.addBoid(new Boid(20+random(-20,+20),290+random(-20,+20)),true,new PVector(1024,290),1.5);
        first=false;
      }
    }
}
  

void reset(){
   world.obstacles.clear();
   flock.boids.clear();
   bound=true;
  //Apply or not the rules, controlled with buttons
  r1_separate=true;
  r2_alignment=true;
  r3_cohesion=true;
  r4_obstacles=true;
  r5_follow=false;
  setupBoundaries();
  
  // Add an initial set of boids into the system
  for (int i = 0; i < 20; i++) {
    //width and heigth are system var that have the size of the display
    flock.addBoid(new Boid(width/2+random(-50,+50),height/2+random(-50,+50)),false,new PVector(0,0),1.5);
  }
}

// Set up the limits on the square/rectangle of the display window
void setupBoundaries() {
  if(bound){
    //Put obstacles at the x-axis of the display
    //Change the offset 20 to make the wall more consistent
    for (int x = 0; x < width; x+= 10) {
      //The offset 5 define how much of the obstacle is inside the display
        world.addObstacle(new Obstacle(x, -2));
        world.addObstacle(new Obstacle(x, height +2));
    }
    //Put obstacles at the y-axis of the display
    for (int x = 0; x < height; x+= 10) {
        world.addObstacle(new Obstacle(-2, x));
        world.addObstacle(new Obstacle(width +2, x));
    } 
    
    
    ////Draw an intersection
   ////draw horizontal lines defining the intersection
    //for (int x = 00; x < width; x+= 10) {
    //     if((x<400)||(x>530)){
    //       world.addObstacle(new Obstacle(x, 230));
    //       world.addObstacle(new Obstacle(x, 350));
    //     }
    //}
   ////draw vertical lines defining the intersection 
  //for (int x = 0; x < height; x+= 10) {
    //  if((x<230)||(x>350)){
    //        world.addObstacle(new Obstacle(400,x));
    //        world.addObstacle(new Obstacle(530,x));
    //  }
 // }
//  


    
    //Draw a highway with an obstacle -- scenario 2 of the chapter
    for (int x = 00; x < width; x+= 10) {
     //The offset 5 define how much of the obstacle is inside the display
       world.addObstacle(new Obstacle(x, 210));
       world.addObstacle(new Obstacle(x, 350));
    }
   //Defininf the obstacle  in the highway for scenario 2 
   //world.addObstacle(new Obstacle(600, 230));
   //world.addObstacle(new Obstacle(600, 240));
   //world.addObstacle(new Obstacle(600, 250));
   //world.addObstacle(new Obstacle(600, 260));
   
   
   //world.addObstacle(new Obstacle(610, 260));
   //world.addObstacle(new Obstacle(620, 260));
   //world.addObstacle(new Obstacle(630, 260));
   //world.addObstacle(new Obstacle(640, 260));
   //world.addObstacle(new Obstacle(650, 260));

   //world.addObstacle(new Obstacle(650, 230));
   //world.addObstacle(new Obstacle(650, 240));
   //world.addObstacle(new Obstacle(650, 250));
   //world.addObstacle(new Obstacle(650, 260));
    
  }else{
        world.remObstacles();
  }  
}

//Methods to make the simulation interactive with mouse or keyboard

// Add a new boid into the System
void mousePressed() {
  switch(add){
     case "boid":
       flock.addBoid(new Boid(mouseX,mouseY),false,new PVector(0,0),1.5);
     break;
     case "obs":
       world.addObstacle(new Obstacle(mouseX,mouseY));
     break;
  }
}

//Add boids while the mouse is clicked and moving
void mouseDragged() {
  if(add == "boid"){
    flock.addBoid(new Boid(mouseX,mouseY),false,new PVector(0,0),1.5);
  }
  if(add== "obs"){
    world.addObstacle(new Obstacle(mouseX,mouseY));
  }
}