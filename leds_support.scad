$fn=100;
LED_DIAMETER = 5.15;
LED_BORDER = 0.8;
CLIP_SIZE = 0.4;
SUPPORT_DIAMETER  = 2.5;
BOX_HIGHT = 15;

// size is a vector [w, h, d]
module roundedBox(size, radius, sidesonly)
{
	rot = [ [0,0,0], [90,0,90], [90,90,0] ];
	if (sidesonly) {
		cube(size - [2*radius,0,0], true);
		cube(size - [0,2*radius,0], true);
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				 y = [radius-size[1]/2, -radius+size[1]/2]) {
			translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
		}
	}
	else {
		cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);

		for (axis = [0:2]) {
			for (x = [radius-size[axis]/2, -radius+size[axis]/2],
					y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
				rotate(rot[axis]) 
					translate([x,y,0]) 
					cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true);
			}
		}
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				y = [radius-size[1]/2, -radius+size[1]/2],
				z = [radius-size[2]/2, -radius+size[2]/2]) {
			translate([x,y,z]) sphere(radius);
		}
	}
}

module ledfootprint(diameter, border)
{
	OFFSET_BORDER = 4;
	
	rotate_extrude() 
	polygon([[0,-7],
		[9,-7],[diameter / 2,0],
		[diameter / 2,OFFSET_BORDER],[diameter / 2 + border,OFFSET_BORDER],
        //[diameter / 2 + border,OFFSET_BORDER+1],
        //[diameter / 2 + (border - 0.1) ,OFFSET_BORDER+1], 
		//[diameter / 2 + border,OFFSET_BORDER+1.2],
		[diameter / 2 + border,20],[0,20]], convexity = N);
}


module support_hole() 
{
	rotate(a=90, v=[0,0,1]) 
		translate([6,-2,6])
			rotate(a=90, v=[1,0,0]) 
				cylinder(h=10,r=SUPPORT_DIAMETER/2);
	rotate(a=90, v=[0,0,1]) 
		translate([-6,-2,6])
			rotate(a=90, v=[1,0,0]) 
				cylinder(h=10,r=SUPPORT_DIAMETER/2);
}

module cable_hole()
{
	translate([9,0,12.7]) 
	    cube(size = [7,9.70,2], center = true);
}

module clips() 
{
	lenght_clip=6.5;
	translate([0,8.45,9])
		rotate(a=90, v=[0,0,1])
			rotate(a=90, v=[1,0,0]) 
			linear_extrude(height=lenght_clip, center = true)
				polygon([[0,0],[0,2],[CLIP_SIZE,1],[CLIP_SIZE,0]], convexity = N);
			
	translate([0,-8.45,9])
		rotate(a=-90, v=[0,0,1])
			rotate(a=90, v=[1,0,0]) 
				linear_extrude(height=lenght_clip, center = true)
					polygon([[0,0],[0,2],[CLIP_SIZE,1],[CLIP_SIZE,0]], convexity = N);
}

module cap_locker() {
		rotate(a=-90, v=[0,0,1])
			translate([9.5,0,3])
				cube(size = [1.5,10,6.5], center = true);

		rotate(a=-90, v=[0,0,1])
			translate([-9.5,0,3])
				cube(size = [1.5,10,6.5], center = true);
}

module cap() {
	difference() {
		translate([0,0,13.2]) 
            roundedBox([20,20,3], 5, true);
		translate([0,0,-0.1]) cable_hole();	
	    //led_support();
        translate([0,0,5.5])
            difference() {
                roundedBox([21,21,BOX_HIGHT], 5, true);
                translate([0,0,4]) 
                    roundedBox([16.2,16.2,9.5], 5, true);
                }
        
	}
    
}

module clips_hole() {
	translate([0,0,7.5])
		scale([1.1,1,1]) 
			cap_locker();
}

module led_support() {
	difference() {
		union() {
			translate([0,0,6]) roundedBox([20,20,BOX_HIGHT], 5, true);
		}
		translate([4,0,1]) ledfootprint(LED_DIAMETER, LED_BORDER);
		translate([-4,4,1]) ledfootprint(LED_DIAMETER, LED_BORDER);
		translate([-4,-4,1]) ledfootprint(LED_DIAMETER, LED_BORDER);

		translate([0,0,BOX_HIGHT -2]) roundedBox([16,16,9.5], 5, true);
		support_hole();
		cable_hole();	
		//scale([1.05,1,1]) 
		//clips_hole();
	}
	//clips();
}

led_support();
translate([0,0,16]) 
 cap();