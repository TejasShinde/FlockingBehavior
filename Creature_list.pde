public class Creature_list{
  ArrayList<Creature> creature_list;
  int creature_count;
  float r_fc, r_ca, r_vm;
  PVector cat;

  public Creature_list(){
    creature_list = new ArrayList<Creature>();
    creature_count = 0;
    r_fc = 0.8;
    r_ca = 0.115;
    r_vm = 0.5;
    cat = new PVector(0, 0);
  }

  public void add_creature(Creature c){
    creature_list.add(c);
    creature_count = creature_list.size();
  }
  
  public void remove_creature(){
    if(creature_count == 0)  return;
    creature_list.remove(creature_count - 1);
    creature_count = creature_list.size();
  }

  public void add_creature(PVector p){
    Creature c = new Creature(p);
    add_creature(c);
  }

  public void add_creature(PVector p, PVector v){
    Creature c = new Creature(p, v);
    add_creature(c);
    if(catastrophe)
      c.catastrophePos.set(cat.x, cat.y);
  }
  
  public void scatter(){
    int i;
    Creature c;
    for(i = 0; i < creature_count; ++i){
      c = creature_list.get(i);
      c.moveToRandom();
    }
  }

  public void setCatastrophe(float x, float y){
    int i;
    Creature c;
    x = x/width;  y = y/height;
    cat.set(x, y);
    for(i = 0; i < creature_count; ++i){
      c = creature_list.get(i);
      c.catastrophe(x, y);
    }    
  }

  public void render() {
    int i;
    Creature c;
    for(i = 0; i < creature_count; ++i){
      c = creature_list.get(i);
      c.drawCreature();
    }
  }

  public void animate(){
    float timestep = 7e-4;
    int i;
    Creature c;
    for(i = 0; i < creature_count; ++i){
      c = creature_list.get(i);
      computeForces(i);
      c.applyForces(timestep, creature_count);
      c.move(timestep);
    }
  }

  private float distance(PVector p1, PVector p2){
    float r;
    r = (p1.x-p2.x)*(p1.x-p2.x);
    r += (p1.y-p2.y)*(p1.y-p2.y);
    return sqrt(r);
  }
  
  private void computeForces(int id) {
    int j;
    float wij, r, eps = 1e-7;
    Creature c = creature_list.get(id);
    Creature cnear;
    c.clearForces();
    for(j = 0; j < creature_count; ++j){
      if(j == id)  continue;
      cnear = creature_list.get(j);
      r = distance(c.p, cnear.p);
      wij = 1.0/(r+eps);//max(r_fc - r, 0);
      if(r < r_fc) {
        c.addFlockCenterForce(cnear.p, wij);
      }
      if(r < r_ca) {
        c.addCollisionAvoidanceForce(cnear.p, population_size*wij);
      }
      if(r < r_vm) {
        c.addVelocityMatchForce(cnear.v, wij);
      }
      if(catastrophe){
        c.addCatastropheForce();
      }
    }  
  }

};
