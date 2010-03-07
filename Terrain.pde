class Terrain{
	float roughness;
	int spacing,sections,tallness;
	int[] heights; 
	int[] originals;
	boolean reactive;
	Terrain(){
		reactive = false;
		roughness = 2.3;
		spacing = 5;
		sections = width/spacing + 1;
		tallness = 100;
		heights = new int[sections];
		originals = new int[sections];
		generate();
		for(int i=0;i<5;i++){
			smooth();
		}
	}
	void regenerate(){
		generate();
		for(int i=0;i<5;i++){
			smooth();
		}
	}
	void generate(){
		int last = (int)random(5,tallness);
		for(int i=0;i<sections;i++){
			heights[i] = last + (int)random(tallness * roughness);
			//print(heights[i] + ", ");
			originals[i] = heights[i];
		}
	}
	void smooth(){
		for(int i=1;i<sections-1;i++){
			heights[i] = (heights[i] + heights[i-1] + heights[i+1])/3; 
			originals[i] = heights[i];
		}
	}
	void increaseRoughness(){
		roughness += 0.1;
		generate();
	}
	void raise(int mx){
		int offset = abs(((int)(mx/ground.spacing)))% (ground.sections-1);
		heights[offset] += 5;
		originals[offset] += 5;
		for(int i=offset;i>0 && abs(offset-i)!=20;i--){
			heights[i] += 20-abs(offset-i);
			originals[i] = heights[i];
		}
		for(int i=offset;i<sections && abs(offset-i)!=20;i++){
			heights[i] += 20- abs(offset-i);
			originals[i] = heights[i];
		}
		
	}
	void update(){
		for(int i=0;i<sections;i++){
			heights[i] = (heights[i] * 9+ originals[i])/10;
		}
		render();
	}
	void renderSurface(){
		for(int i=1;i<sections;i++){
			pushMatrix();
			translate(i*spacing,height-heights[i]);
			rotate(radians(i*777%300));
			tint(255,128,0);
			image(texture,-i*999%80/2,-i*999%80/2,i*999%80,i*999%80);
			popMatrix();
		}
	}
	void render(){
		renderSurface();
		gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE_MINUS_SRC_ALPHA);
		fill(0,200);
		for(int i=1;i<sections;i++){
			quad((i-1)*spacing,height-heights[i-1],i*spacing,height-heights[i],i*spacing,height,(i-1)*spacing,height);
		}
		gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
	}
}