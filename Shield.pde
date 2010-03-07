float max_energy = 5.0;
float max_size = 500;

class Shield{
	float x,y,e,sz;
	boolean active;
	Shield(){
		active = false;
	}
	
	void create(float x,float y){
		this.x = x;
		this.y = y;
		e = max_energy;
		active = true;
		println("creating shield...");
	}
	
	void update(){
		if(active){
			sz = e/max_energy * max_size;
			e *= 0.999;
			render();
		}
	}
	
	void render(){
		pushMatrix();
		translate(x,y);
		tint(0,96,220,e/max_energy*255);
		image(shield,-sz/2,-sz/2,sz,sz);
		image(texture,-sz,-sz,sz*2,sz*2);
		popMatrix();
	}
}
