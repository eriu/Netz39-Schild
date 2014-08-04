use<schriftNetz39.scad>
sizex = 400;
sizey = 100;
sizez = 500;

plateThick = 6;
logoDepth = plateThick;
logoOffset = 30;
border = 2;
holdersize = 20;
screwThick = 5;
screwLen = 10;
screwHeadThick = 10;
screwHeadLen = 1;

screwOffsetMain = 20;
screwOffsetBoTo = 50;
screwOffsetSide = 30;

//plateColor = [1,1,1,0.9];
//logoColor = [0,0,0];

module coordSystem()
{
	cube([1,1,1000],center=true);
	cube([1,1000,1],center=true);
	cube([1000,1,1],center=true);
}

module screw(len,diameter,headheight,headD,slot=false)
{
		difference()
		{	
			cylinder(h=headheight,d=headD);
			if(slot)
			{
				cube([headheight,headD,headheight],center=true);
				cube([headD,headheight,headheight],center=true);
			}
			
		}
		difference()
		{
			cylinder(h=len,d=diameter);
			if(slot)
			{
				cube([headheight,headD,headheight],center=true);
				cube([headD,headheight,headheight],center=true);
			}
		}
}

module mainPlate(width, height, thickness, logoDepth, logoOffset, screwposX, screwposY)
{
	logosize = width - logoOffset*2;
  sthickness = thickness+0.01;
	difference()
	{
		color(plateColor)
		cube([width,height,thickness]);
	
		color(logoColor)
		translate([logoOffset,height-logoOffset,thickness-logoDepth])
		scale([logosize,logosize,logoDepth*100])
		import("logoNetz39.stl");

		color(logoColor)
		translate([logoOffset,logoOffset,thickness])
		scale([logosize/18.15/2,logosize/18.15/2,logoDepth])
		translate([18.15,3.547,0])
		schriftNetz39(1);

		// screws
		translate([screwposX,screwposY,sthickness])
		rotate([180,0,0])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);

		translate([width-screwposX,screwposY,sthickness])
		rotate([180,0,0])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);

		translate([width-screwposX,height-screwposY,sthickness])
		rotate([180,0,0])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);

		translate([screwposX,height-screwposY,sthickness])
		rotate([180,0,0])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);
	}
}

module groundPlate(width, height, thickness, LEDthickness, border, screwposX, screwposY)
{
	sthickness = thickness+0.01;
	color(plateColor)
	difference()
	{
		cube([width,height,thickness]);
		translate([-1,border,thickness-LEDthickness])
		cube([width+2,thickness,LEDthickness+1]);
		translate([-1,height-border-thickness,thickness-LEDthickness])
		cube([width+2,thickness,LEDthickness+1]);

		// screw
		translate([screwposX,screwposY,sthickness])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);

		translate([width-screwposX,screwposY,sthickness])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);

		translate([width-screwposX,height-screwposY,sthickness])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);

		translate([screwposX,height-screwposY,sthickness])
		screw(screwLen,screwThick,screwHeadLen,screwHeadThick);
	}
}

module holder(width, height, depth)
{
	difference()
	{
		cube(width, height, depth);
	}
}

mainplate1 = true;
mainplate2 = true;
sideplate1 = true;
sideplate2 = true;
bottomplate = true;
topplate = true;
holders = true;

if(true)
{
	if(holders)
	{
		color([0.5,0.5,0.5])
		{
			//bottom
			translate([plateThick,border+plateThick,plateThick])
			holder([sizex-2*plateThick,holdersize,holdersize]);

			translate([plateThick,sizey-holdersize-border-plateThick,plateThick])
			holder([sizex-2*plateThick,holdersize,holdersize]);
	
			//top
			translate([plateThick,border+plateThick,sizez-holdersize-plateThick])
			holder([sizex-2*plateThick,holdersize,holdersize]);
		
			translate([plateThick,sizey-holdersize-border-plateThick,sizez-holdersize-plateThick])
			holder([sizex-2*plateThick,holdersize,holdersize]);
		}

		color([0.8,0.8,0.8])
		{
			//sides
			translate([plateThick,border+plateThick,holdersize+plateThick])
			holder([holdersize,holdersize,sizez-2*plateThick-2*holdersize]);

			translate([plateThick,sizey-holdersize-border-plateThick,holdersize+plateThick])
			holder([holdersize,holdersize,sizez-2*plateThick-2*holdersize]);

			translate([sizex-holdersize-plateThick,border+plateThick,holdersize+plateThick])
			holder([holdersize,holdersize,sizez-2*plateThick-2*holdersize]);

			translate([sizex-holdersize-plateThick,sizey-holdersize-border-plateThick,holdersize+plateThick])
			holder([holdersize,holdersize,sizez-2*plateThick-2*holdersize]);
		}
	}

	if(mainplate1)
	{
		translate([plateThick,plateThick+border,plateThick])
		rotate([90,0,0])
		!mainPlate(sizex-plateThick*2,sizez-plateThick*2,plateThick,logoDepth,logoOffset,screwOffsetMain,holdersize/2);
	}

	if(mainplate2)
	{
		translate([sizex-plateThick,sizey-plateThick-border,plateThick])
		rotate([90,0,180])
		mainPlate(sizex-plateThick*2,sizez-plateThick*2,plateThick,logoDepth,logoOffset,screwOffsetMain,holdersize/2);
	}

	if(bottomplate)
	{
		groundPlate(sizex,sizey,plateThick,4,border,screwOffsetBoTo,holdersize/2+border+plateThick);
	}

	if(topplate)
	{
		translate([0,sizey,sizez])
		rotate([180,0,0])
		groundPlate(sizex,sizey,plateThick,4,border,screwOffsetBoTo,holdersize/2+border+plateThick);
	}

	if(sideplate1)
	{
		translate([0,0,sizez-plateThick])
		rotate([0,90,0])
		groundPlate(sizez-2*plateThick,sizey,plateThick,4,border,screwOffsetSide,holdersize/2+border+plateThick);
	}

	if(sideplate2)
	{
		translate([sizex,0,plateThick])
		rotate([0,-90,0])
		groundPlate(sizez-2*plateThick,sizey,plateThick,4,border,screwOffsetSide,holdersize/2+border+plateThick);
	}
}