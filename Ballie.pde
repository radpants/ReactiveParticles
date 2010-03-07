float ballie_force_size_factor = 4;

class Ballie{
	float x,y,vx,vy,ax,ay,sz;
	int id,r,g,bl;
	boolean visible;
	Ballie(int id){
		this.id = id;
		visible = false;
		sz = random(40,100);
		
		r = 0;
		g = (int)random(0,64);
		bl = (int)random(180,255);
	}
	
	void create(float x,float y){
		this.x = x;
		this.y = y;
		visible = true;
	}
	
	float a,d;
	void checkCollisionWithOtherBallies(){
		for(int i=0;i<MAX_BALLIES;i++){
			if(b[i].visible && id != i){
				d = dist(x,y,b[i].x,b[i].y);
				if(d < sz/ballie_force_size_factor + b[i].sz/ballie_force_size_factor){
					//println("distance: " + d);
					a = atan2(b[i].y-y,b[i].x-x);
					ax -= constrain(cos(a), -ballie_push_force,ballie_push_force);
					ay -= constrain(sin(a), -ballie_push_force,ballie_push_force);
//					b[i].ax += constrain(cos(a + radians(180)), -push_force,push_force);
//					b[i].ay += constrain(sin(a + radians(180)), -push_force,push_force);
				}
			}
		}
	}
	boolean angular_reflection = true;
	boolean fluid_repulsion = true;
	
	float ground_repel_force = 1.0;
	void checkCollisionWithTerrain(){
		int offset = abs(((int)(x/ground.spacing)))% (ground.sections-1);
		if( y+sz/2 > height-ground.heights[offset]){
			if(angular_reflection){
				a = atan2(ground.heights[offset+1]-ground.heights[offset],ground.spacing);
				if(fluid_repulsion){
					ax -= ground_repel_force * cos(a - radians(90));
					ay -= ground_repel_force * sin(a + radians(90));
				}
				else{
					ax -= ground_repel_force * 10 * cos(a - radians(90));
					ay -= ground_repel_force * 10 * sin(a + radians(90));
				}
			}
			else{
				ay = -0.3;
			}
			if(ground.reactive){
				ground.heights[offset] -= 5;
			}
		}
	}
	float shield_repel_force = 2.0;
	void checkCollisionWithShield(){
		d = dist(x,y,forceShield.x,forceShield.y);
		if(d < forceShield.sz/4){
			a = atan2(forceShield.y-y,forceShield.x-x);
			ax -= shield_repel_force * cos(a);
			ay -= shield_repel_force * sin(a);
		}
	}
	void applySMSTilt(){
		ax += tilt;
	}
	
	float wall_repel_force = 1.0;
	void checkCollisionWithWalls(){
		if(x<10){
			ax = wall_repel_force;
		}
		else if(x>width-10){
			ax = -wall_repel_force;
		}
	}
	void gravity(){
		ay += 0.1;
	}
	void update(){
		if(visible){
			checkCollisionWithOtherBallies();
			checkCollisionWithTerrain();
			checkCollisionWithWalls();
			applySMSTilt();
			checkCollisionWithShield();
			gravity();
			vx += ax;
			vy += ay;
			x += vx;
			y += vy;
			
			vx *= 0.96;
			vy *= 0.96;
			ax = 0;
			ay = 0;
			render();
		}
	}
	
	void render(){
		pushMatrix();
		translate(x,y);
		//ellipse(0,0,20,20);
		if(ground.reactive){
			tint(bl,g,r);
		}
		else{
			tint(r,g,bl);
		}
		//tint(255,128);
		image(sprite,-sz/2,-sz/2,sz,sz);
		popMatrix();
	}
}