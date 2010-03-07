import processing.opengl.*;
import javax.media.opengl.*;
import sms.*;


Terrain ground;

int MAX_BALLIES = 500; // Today is a strange day, I shall call these particles Ballies...
Ballie[] b = new Ballie[MAX_BALLIES];

Shield forceShield;

PImage sprite;
PImage texture;
PImage bg;
PImage shield;

PGraphicsOpenGL pgl;
GL gl;

boolean control_down = false;

float tiltCenter;
float tilt;

void setup(){
	size(800,500,OPENGL);
	
	pgl = (PGraphicsOpenGL)g;
	gl = pgl.gl;
	
	smooth();
	ground = new Terrain();
	
	tiltCenter = Unimotion.getSMSX();
	
	forceShield = new Shield();
	
	sprite = loadImage("particle.png");
	texture = loadImage("smoke.png");
	bg = loadImage("bg.png");
	shield = loadImage("bubble.png");
	
	for(int i=0;i<MAX_BALLIES;i++){
		b[i] = new Ballie(i);
		b[i].create(random(width),random(height*0.5));
	}   
}

float ballie_push_force = 0.05;

void keyPressed(){
	println("key: " + key + " keyCode: " + keyCode);
	switch(keyCode){
		case 38: //up
			ballie_force_size_factor *= 0.5;
			break;
		case 40: //down
			ballie_force_size_factor *= 2;
			break;
		case 37: //left
			ballie_push_force *= 0.5;
			break;
		case 39: //right
			ballie_push_force *= 2;
			break;
		case CONTROL:
			control_down = true;
			break;
	}
	switch(key){
		case 'r':
			ground.increaseRoughness();
			break;
		case 's':
			ground.smooth();
			break;
		case 'a':
			ground.reactive = !ground.reactive;
			break;
		case 'j':
			for(int i=0;i<MAX_BALLIES;i++){
				b[i].ay = -3;
			}
			break;
		case 't':
			println("SMS X: " + Unimotion.getSMSX());
			break;
		case '\n':
			ground.regenerate();
			break;
		
	}
}

void keyReleased(){
	switch(keyCode){
		case CONTROL:
			control_down = false;
			break;
	}
}

void mousePressed(){
	if(keyCode==SHIFT){
		ground.raise(mouseX);
	}
	else if(control_down){
		forceShield.create(mouseX,mouseY);
	}
	else{
		boom(mouseX,mouseY);		
	}
}

float d,a;
float boom_force = 200.0;
void boom(float x,float y){
	for(int i=0;i<MAX_BALLIES;i++){
		d = dist(x,y,b[i].x,b[i].y);
		if(d<200){
			a = atan2(b[i].y-y,b[i].x-x);
			b[i].vx += boom_force * 1/d * cos(a);
			b[i].vy += boom_force * 1/d * sin(a);
		}
	}
}

float tilt_force = 0.0025;

void draw(){
	pgl.beginGL();
	gl.glDisable(GL.GL_DEPTH_TEST);
	gl.glEnable(GL.GL_BLEND);
	gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
	pgl.endGL();

	background(0);
	tint(255);
	image(bg,0,0,width,height);
	
	forceShield.update();
	
	fill(16,64,92);
	ground.update();
	fill(255,128);
	
	tilt = (Unimotion.getSMSX() - tiltCenter) * -tilt_force;
	for(int i=0;i<MAX_BALLIES;i++){
		b[i].update();
	}
}
