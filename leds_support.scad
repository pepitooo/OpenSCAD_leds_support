


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

$fn=30;
module ledfootprint(diameter, border)
{
	OFFSET_BORDER = 4;
	
	rotate_extrude($fn=200) 
	polygon([[0,-7],
		[9,-7],[diameter / 2,0],
		[diameter / 2,OFFSET_BORDER],[diameter / 2 + border,OFFSET_BORDER],[diameter / 2 + border,OFFSET_BORDER+1],[diameter / 2 + (border - 0.1) ,OFFSET_BORDER+1], 
		[diameter / 2 + border,OFFSET_BORDER+1.2],
		[diameter / 2 + border,15],[0,15]], convexity = N);
}

module support_hole() 
{
	rotate(a=90, v=[0,0,1]) 
		translate([6,-2,6])
			rotate(a=90, v=[1,0,0]) 
				cylinder(h=10,r=2.5/2);
	rotate(a=90, v=[0,0,1]) 
		translate([-6,-2,6])
			rotate(a=90, v=[1,0,0]) 
				cylinder(h=10,r=2.5/2);
}

module cable_hole()
{
	translate([8,0,11.5]) 
	cube(size = [4,9.70,1.30], center = true);
}

module clips() 
{
	lenght_clip=5;
	translate([0,9.9,9])
		rotate(a=90, v=[0,0,1])
			rotate(a=90, v=[1,0,0]) 
			linear_extrude(height=lenght_clip, center = true)
				polygon([[0,0],[0,2],[1,1],[1,0]], convexity = N);
			
	translate([0,-9.9,9])
		rotate(a=-90, v=[0,0,1])
			rotate(a=90, v=[1,0,0]) 
				linear_extrude(height=lenght_clip, center = true)
					polygon([[0,0],[0,2],[1,1],[1,0]], convexity = N);
}

module led_support() {
	difference() {
		union() {
			translate([0,0,6]) roundedBox([20,20,12], 5, true);
			clips();
		}
		translate([4,0,3]) ledfootprint(5.1, 0.4);
		translate([-4,4,3]) ledfootprint(5.1, 0.4);
		translate([-4,-4,3]) ledfootprint(5.1, 0.4);

		translate([0,0,11]) roundedBox([17,17,3], 5, true);
		support_hole();
		cable_hole();		

	}
}

module cap_locker() {
		rotate(a=-90, v=[0,0,1])
			translate([10.75,0,3])
				cube(size = [1.5,7,6.5], center = true);

		rotate(a=-90, v=[0,0,1])
			translate([-10.75,0,3])
				cube(size = [1.5,7,6.5], center = true);
}

module cap() {
	difference() {
		translate([0,0,13.2]) roundedBox([20,20,3], 5, true);
		hole_wire();	
		led_support();
	}
	difference() {
		translate([0,0,8.45]) cap_locker();
		clips();
	}
}


led_support();
translate([0,0,5]) cap();