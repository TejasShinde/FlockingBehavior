public class Creature{
  PVector p, v, d;
  PVector f_fc, f_ca, f_vm;
  float wij_fc, wij_ca, wij_vm;
  PVector catastrophePos;
  PVector f_attract;
  
  public Creature() {
    p = new PVector(0, 0);
    v = new PVector(0, 0);
    d = new PVector(0, 0);
    f_fc = new PVector(0, 0);
    f_ca = new PVector(0, 0);
    f_vm = new PVector(0, 0);
    f_attract = new PVector(0, 0);
    wij_fc = 0;  wij_ca = 0;  wij_vm = 0;
    catastrophePos = new PVector(0, 0, 0);
  }
  
  public Creature(PVector _p) {
    this();
    p.set(_p.x, _p.y);
  }

  public Creature(PVector _p, PVector _v) {
    this();
    p.set(_p.x, _p.y);
    v.set(_v.x, _v.y);
  }

  public void drawCreature() {
    float px_screen = p.x * width, py_screen = p.y * height;
    float tail = random(7,15);
    //println("drawing creature at " + px_screen +" "+ py_screen );
    fill(255,0,255,150);
    stroke(255,0,255);
    ellipse(px_screen, py_screen, 7, 7);
    d.set(v.x, v.y);  d.normalize();  d.mult(-1 * tail);
    line(px_screen, py_screen, px_screen+d.x, py_screen+d.y);
    ellipse(px_screen+d.x, py_screen+d.y, 3, 3);
    noStroke();
    if(catastrophe){
      if(attract)  fill(int(random(100)), int(random(200,255)), int(random(100)));
      else         fill(int(random(200,255)), int(random(100)), int(random(100)));
      float radius = random(20);
      ellipse(catastrophePos.x * width, catastrophePos.y * height, radius, radius);
      noFill();
    }
  }
  
  public void moveToRandom(){
    p.set(random(1), random(1));
  }
  
  public void move(float delT){
    p.set(p.x + v.x * delT, p.y + v.y * delT);
  }
  
  public void catastrophe(float x, float y){
    catastrophePos.set(x, y);
  }
  
  public void applyForces(float delT, int creature_count) {
    PVector f;
    f = readForces(creature_count);
    /*Assuming a unit mass. Hence acceleration = force*/
    v.set(v.x + f.x * delT, v.y + f.y * delT);
    if(v.mag() > 4.0)  {
      v.normalize();
      v.mult(4.0);
    }
    if(v.mag() < 1.9) {
      v.normalize();
      v.mult(1.9);
    }
    /*Apply wall collision*/
    if(p.x >= 1 || p.x <= 0) {  v.set(-v.x, v.y);  }
    if(p.y >= 1 || p.y <= 0) {  v.set(v.x, -v.y);  }
    
    /*Confine*/
    if(p.x >= 1) {  p.x = 1 - random(0,50)/5000;  }
    if(p.x <= 0) {  p.x = 0 + random(0,50)/5000;  }
    if(p.y >= 1) {  p.y = 1 - random(0,50)/5000;  }
    if(p.y <= 0) {  p.y = 0 + random(0,50)/5000;  }
  }
  
  public void clearForces(){
    f_fc = new PVector(0, 0);
    f_ca = new PVector(0, 0);
    f_vm = new PVector(0, 0);
    f_attract = new PVector(0, 0);
    wij_fc = 0;  wij_ca = 0;  wij_vm = 0;
  }
  
  public void addFlockCenterForce(PVector pj, float wij){
    PVector pij = PVector.sub(pj, this.p);
    pij.mult(wij);
    f_fc.add(pij);
    wij_fc += wij;
  }
  
  public void addCollisionAvoidanceForce(PVector pj, float wij) {
    PVector pji = PVector.sub(this.p, pj);
    pji.mult(wij);
    f_ca.add(pji);
    wij_ca += wij;
  }
  
  public void addVelocityMatchForce(PVector vj, float wij) {
    PVector vij = PVector.sub(vj, this.v);
    vij.mult(wij);
    f_vm.add(vij);
    wij_vm += wij;
  }
  
  public void addCatastropheForce(){
    PVector a;
    if(attract)  a = PVector.sub(catastrophePos, p);
    else  a = PVector.sub(p, catastrophePos);
    f_attract.set(a.x, a.y);
  }
  
  private PVector readForces(int creature_count) {
    PVector fw, f_total = new PVector(0, 0);
    float ww = creature_count*0.1*300, wfc = creature_count*0.5*1000, wca = creature_count*0.05*1300, wvm = 10.0/creature_count;
    float w_attract = creature_count*0.1*800;
    fw = wanderForce();
    fw.mult(ww);
    if(wij_fc > 0){
      f_fc.div(wij_fc);
      f_fc.mult(wfc);
    }
    if(wij_ca > 0){
      f_ca.div(wij_ca);
      f_ca.mult(wca);
    }
    if(wij_vm > 0){
      f_fc.div(wij_vm);
      f_vm.mult(wvm);
    }
    
    if(wander)     f_total.add(fw);
    if(centering)  f_total.add(f_fc);
    if(collision)  f_total.add(f_ca);
    if(vmatch)     f_total.add(f_vm);
    
    if(catastrophe){
      f_attract.mult(w_attract);
      f_total.add(f_attract);
    }
    return f_total;
  }
  
  private float getRandomSign() {
    float sign = random(-1,1);
    return sign/abs(sign);
  }
  private PVector wanderForce() {
    float fx, fy, mag = 1;
    fx = mag * noise(p.x)*getRandomSign();
    fy = mag * noise(p.y)*getRandomSign();
    PVector fw = new PVector(fx, fy);
    fw.normalize();
    return fw;
  }

};

