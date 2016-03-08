int height = 700;//600;  // screen height
int width = 700;//600;   // screen width

Creature_list cl;
int population_size = 20;

/*user interface flags*/
boolean simulate = true;
boolean attract  = true;
boolean pathTrace = false;
boolean centering = true;
boolean vmatch = true;
boolean collision = true;
boolean wander = true;
boolean catastrophe = false;

boolean filming = false;

int frameCounter = 0;

void settings() {
  size(width, height);     // set size of screen (in pixels)
}

void setup() {
  initCreatureList();
}

void draw() {
  if(!pathTrace){
    background(0x0);
  }
  if(mousePressed){
    foo();
  }
  if(simulate){
    cl.animate();
  }
  cl.render();
  
  scribe(creatureCount(), 10, 10);
  
  scribe(centeringStatus(), 500, 10);
  scribe(vMatchStatus(), 500, 20);
  scribe(collisionAvoidanceStatus(), 500, 30);
  scribe(wanderingStatus(), 500, 40);
  
  scribe("Press [a/A:Attraction mode ON] [r/R:Repulsion mode ON] [c/C:Clear] [s/S:Scatter] [p/P:Show path trace]", 10, height - 35);
  scribe("[1:Toggle centering] [2:Toggle Velocity Matching] [3:Toggle Collision Avoidance] [4:Toggle Wandering]", 10, height - 25);
  scribe("[=/+:Add a creature] [-:Remove a creature] [' ':start/stop simulation]", 10, height - 15);
  scribe(getMessage(), 10, height - 5);
  
  if(filming)  saveFrame("FRAMES/"+nf(frameCounter++,4)+".jpg");
}

String creatureCount(){
  StringBuilder s = new StringBuilder();
  s.append("Creature Count: ");
  s.append(cl.creature_count);
  return s.toString();
}

String centeringStatus(){
  if(centering)  return "Centering: ON";
  else           return "Centering: OFF";
}

String vMatchStatus(){
  if(vmatch)  return "Velocity Matching: ON";
  else           return "Velocity Matching: OFF";
}

String collisionAvoidanceStatus(){
  if(collision)  return "Collision Avoidance: ON";
  else           return "Collision Avoidance: OFF";
}

String wanderingStatus(){
  if(wander)  return "Wandering: ON";
  else           return "Wandering: OFF";
}

String getMessage() {
  if(attract == true)  return "Click to attract the flock towards the cursor click";
  else                 return "Click to repel the flock away from the cursor click";
} 

void scribe(String S, float x, float y) {
  fill(255,255,0);
  text(S,x,y);
  noFill();
} // writes on screen at (x,y) with current fill color

void initCreatureList() {
  int i;
  cl = new Creature_list();
  for(i = 0; i < population_size; ++i){
    add_creature_to_list();
  }
}

void add_creature_to_list() {
  float v;
  v = random(-1,1);
  PVector pos = new PVector(random(1), random(1));
  PVector vel =  new PVector(v/abs(v), v);
  cl.add_creature(pos, vel);
}

void remove_creature_from_list() {
  cl.remove_creature();
}

void keyPressed() {
  switch(key){
    case 'a': case 'A':
    attract = true;
    break;
    
    case 'r': case 'R':
    attract = false;
    break;
    
    case 's': case 'S':
    cl.scatter();
    catastrophe = false;
    break;
    
    case 'p': case 'P':
    pathTrace = !pathTrace;
    break;
    
    case 'c': case 'C':
    population_size = 0;
    initCreatureList();
    population_size = 10;
    catastrophe = false;
    break;
    
    case '1':
    centering = !centering;
    break;
    
    case '2':
    vmatch = !vmatch;
    break;
    
    case '3':
    collision = !collision;
    break;
    
    case '4':
    wander = !wander;
    break;
    
    case '=': case '+':
    if(cl.creature_count<400)
      add_creature_to_list();
    break;
    
    case '-':
    remove_creature_from_list();
    break;
    
    case ' ':  simulate = !simulate;
    break;
    
    case 'f':  case'F':  filming = !filming;
    break;
  }
}

void foo() {
  cl.setCatastrophe(mouseX, mouseY);
  catastrophe = true;
}