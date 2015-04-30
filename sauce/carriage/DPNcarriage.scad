include <Primitivas.scad>

clearance=0.4;
switchable_fan=0; //Tells if the fan is removable without screws.

//Detalles de las tuercas (probablemente M3). NO TOCAR
nut_gap=6+clearance;
nut_height=3+clearance;

//Detalles de la placa
nozzleplatew=20;
nozzleplatel=62.5;
bolt_separation=47.50+3;


//VENTILADORES (COMENTAR LOS QUE NO SEAN)

/*
//Detalles del ventilador 40mm
fan_depth=11.5;
fan_side=40+clearance;
vent_radius=38.40;
fan_bolt_spacing=32+clearance;
*/

/*
//Detalles del ventilador 30mm
fan_depth=6.5;
fan_side=30+clearance;
vent_radius=28.40;
fan_bolt_spacing=24+clearance;
*/

//Detalles del ventilador 35mm
fan_depth=10.28+clearance;
fan_side=35+clearance;
vent_radius=28.40+5;
fan_bolt_spacing=29+clearance;


//FEEDER details
feeder_height=8;
bowden_depth=5;
bowden_rosca=9.7;
feeder_ranura=3;
feeder_ranura_sep=5;
buttress_lenght=20;
feeder_grade=2;
feeder_qual=30;


//LM8UU details

LM8UU_Diam=15;
LM8UU_Length=24;
LM8UU_quantity=3;

//Thermal cartridge (Thanks Misan)

thermal_height=10;
thermal_lenght=24;
thermal_width=15;
thermal_hole_l=6+(4.5/2); //these are figured out
thermal_hole_w=6/2;

//Carriage Characteristics

car_width=70;
car_height=35;
top_width=50;
sep_nozzles=21.4;
rosca=3;
sur=3;
nozzle_bolt_depth=30;
nut_depth=12;
nut_reach=18;
walls=3;
//car_lenght=120;
car_lenght=2*sep_nozzles+2*fan_depth+40;

base_reinforcement=2;

if(switchable_fan!=0){
	assign(car_lenght=2*sep_nozzles+2*fan_depth+20);
}




chamber_width=40;



//belt holder characteristics.

holder_height=35;
holder_wall=3;
holder_center_wall=8;
holder_bolt_sep=10;
holder_plat=17;
holder_rosca=3;
holder_margin=0;
holder_qual=20;
holder_grade=3;

ret_width=1.2;
ret_height=4;

scars=1;
scars_depth=1;

//Cable holder characteristics

ch_width=2;
ch_length=10+2*ch_width;
ch_height=4;
ch_gap=5;
ch_entrance=4;
ch_radius=1.3;
ch_extra=4;


/////////////////////////////////////
//THE CARRIAGE
/////////////////////////////////////

module carriage(){
	difference(){
		union(){
	
			//the body
			translate([0,0,-base_reinforcement]){
				if(switchable_fan==0){
					trapecio(car_lenght,car_width,car_lenght,top_width,car_height+base_reinforcement);
				}
				else{
					translate([2,0,0]){
						trapecio(car_lenght+4,car_width,car_lenght+4,top_width,car_height+base_reinforcement);
					}
				}
			}
			//that center block in the body
			roundedprismabox(2*sep_nozzles,car_width,car_height,(rosca/2)+sur);
	
			//The belt holder
			translate([0,(car_width/2)-2,car_height-holder_height]){
				rotate([0,0,90]){
					belt_holder(holder_height,holder_wall,holder_center_wall,holder_plat,nut_gap,holder_wall,holder_rosca,holder_bolt_sep,holder_margin,holder_grade,holder_qual);
				}
			}

			//the cable holder
			if(switchable_fan==0){
				for(i=[-1,1]){		
					translate([i*((((car_lenght/2))-(ch_length/2))+2*ch_width+ch_gap),0,(car_height-ch_height)]){
						rotate([0,0,180+i*90]){
							scale([1,-1,1]){
								cableholder(ch_length,ch_height,ch_gap,ch_width,ch_entrance,ch_radius);
							}
						}	
					}
				}
			}
			else{
					
				translate([((car_lenght/2))+4-(ch_length/2)-ch_width,-(top_width+ch_gap)/2,car_height-ch_height]){
					rotate([0,0,0]){
						scale([-1,1,1]){
							cableholder(ch_length,ch_height,ch_gap,ch_width,ch_entrance,ch_radius);
						}
					}
				}
				translate([(-((car_lenght/2))+(ch_length/2)+ch_width),(top_width+ch_gap)/2,car_height-ch_height]){
					rotate([0,0,180]){
						scale([-1,1,1]){
							cableholder(ch_length,ch_height,ch_gap,ch_width,ch_entrance,ch_radius);
						}
					}
				}	
			}
		}
	
		//center block drills
		translate([0,0,car_height]){
			centerblock_drills(bolt_separation,sep_nozzles,nozzle_bolt_depth,rosca,nut_depth,nut_gap,nut_reach,nut_height);
		}
	
		//the nozzleplate window up there...
		translate([0,0,15]){
			roundedprismabox(2*sep_nozzles,chamber_width,car_height+6,4);
		}
	
		//the actual chamber
		translate([0,0,(fan_side-15)/2]){
			rotate([0,90,0]){
				translate([0,0,-(car_lenght-(2*fan_depth)-(2*walls))/2]){
					roundedprismabox(fan_side+12,chamber_width,car_lenght-(2*fan_depth)-(2*walls),4);
				}
			}
		}
	
		//the fan housing and vent
		
		translate([0,0,(car_height-6)/2]){
			vent2(fan_depth,fan_side,fan_bolt_spacing,car_lenght,rosca,20,switchable_fan);
		}
		
		//The LM8UU's housings
		if(LM8UU_quantity==3){
			translate([0,-25,0]){
				rotate([0,90,0]){
					color([0,1,0])
					cylinder(r1=(LM8UU_Diam/2)+clearance,r2=(LM8UU_Diam/2)+clearance,h=LM8UU_Length+clearance,center=true);
					difference(){
						cylinder(r1=walls+(LM8UU_Diam/2)+1.8,r2=walls+(LM8UU_Diam/2)+1.8,h=4,center=true,$fn=round_quality);
						cylinder(r1=walls+(LM8UU_Diam/2),r2=walls+(LM8UU_Diam/2),h=8,center=true,$fn=round_quality);
					}
				}
			}
			for(i=[-1,1]){
				translate([i*((car_lenght/2)-(LM8UU_Length/2)-2*walls),25,0]){
					rotate([0,90,0]){
						color([0,1,0])
						cylinder(r1=(LM8UU_Diam/2)+clearance,r2=(LM8UU_Diam/2)+clearance,h=LM8UU_Length+clearance,center=true);
						difference(){
							cylinder(r1=walls+(LM8UU_Diam/2)+1.8,r2=walls+(LM8UU_Diam/2)+1.8,h=4,center=true,$fn=round_quality);
							cylinder(r1=walls+(LM8UU_Diam/2),r2=walls+(LM8UU_Diam/2),h=8,center=true,$fn=round_quality);
						}
					}
				}
			}
		}
		else{
			for(j=[-1,1]){
				for(i=[-1,1]){
					translate([i*((car_lenght/2)-(LM8UU_Length/2)-2*walls),j*25,0]){
						rotate([0,90,0]){
							color([0,1,0])
							cylinder(r1=(LM8UU_Diam/2)+clearance,r2=(LM8UU_Diam/2)+clearance,h=LM8UU_Length+clearance,center=true);
							difference(){
								cylinder(r1=walls+(LM8UU_Diam/2)+1.8,r2=walls+(LM8UU_Diam/2)+1.8,h=4,center=true,$fn=round_quality);
								cylinder(r1=walls+(LM8UU_Diam/2),r2=walls+(LM8UU_Diam/2),h=8,center=true,$fn=round_quality);
							}
						}
					}
				}
			}
		}
		
		//belt scars
		translate([0,(car_width+holder_plat)/2,car_height-holder_height]){
			belt_scars(holder_wall,nut_gap,holder_center_wall,scars,scars_depth,holder_bolt_sep-holder_rosca);
		}

		//rail clearance
		rails(1.5);	
	}
	
}

///////////////////////////////////
//THE BOWDEN FEEDER
///////////////////////////////////

module feeder(clear){
	difference(){
		union(){
			difference(){
				roundedprismabox(nozzleplatel,-clearance+nozzleplatew,feeder_height,nozzleplatew/2);
				for(i=[-1:1]){
					translate([0,i*(feeder_ranura_sep),0]){
						cube([nozzleplatel-12,feeder_ranura,20],center=true);
					}
				}
			}
			translate([0,0,(feeder_height)+bowden_depth/2]){	
				cylinder(r1=nozzleplatew/2,r2=(bowden_rosca/2)+0.5,h=bowden_depth,center=true,$fn=round_quality);
			}
			for(i=[-1,1]){
				translate([i*(bolt_separation/2),0,0]){
					cylinder(r1=(nozzleplatel-bolt_separation)/2,r2=(nozzleplatel-bolt_separation)/2,h=feeder_height,$fn=round_quality);
				}
			}
			for(i=[-1,1]){
				for(j=[-1,1]){
					translate([-j*((bowden_rosca-1)/2),i*(feeder_ranura_sep-(feeder_ranura/2)-((feeder_ranura_sep-feeder_ranura)/2)),bowden_depth+feeder_height]){
						rotate([180,0,90+j*90]){
							grade_buttress(0,buttress_lenght,(feeder_ranura_sep-feeder_ranura),bowden_depth,feeder_grade,feeder_qual);
						}
					}
				}
			}
			cylinder(r1=nozzleplatew/2,r2=nozzleplatew/2,h=feeder_height);
		}
		for(i=[-1,1]){
			translate([i*(bolt_separation/2),0,-1]){
				cylinder(r1=(rosca+clear)/2,r2=(rosca+clear)/2,h=2+feeder_height,$fn=round_quality);
			}
		}
		translate([0,0,feeder_height]){
			cylinder(r1=(9.7+clear)/2,r2=(9.7+clear)/2,h=bowden_depth+2);
		}
		cylinder(r1=3.2/2,r2=3.2/2,h=100,center=true,$fn=round_quality);
	}
}




///////////////////////////////
//THE NOZZLES
///////////////////////////////
module nozzles(){
for(i=[-1,1]){
	color([1,0,0])
	translate([i*sep_nozzles/2,0,car_height]){
		prusanozzle(90-i*90,2);
	}
}
}
//////////////////////////////////
//RAILS
//////////////////////////////////
/*
color([1,1,1])
rails(0);
*/
//////////////////////////////////
//LM8UUs
//////////////////////////////////
module LM8UUs(){
if(LM8UU_quantity==3){
	translate([0,-25,0]){
		rotate([0,90,0]){
			color([0,1,0])
			cylinder(r1=LM8UU_Diam/2,r2=LM8UU_Diam/2,h=LM8UU_Length,center=true);
		}
	}
	for(i=[-1,1]){
		translate([i*((car_lenght/2)-(LM8UU_Length/2)-2*walls),25,0]){
			rotate([0,90,0]){
				color([0,1,0])
				cylinder(r1=LM8UU_Diam/2,r2=LM8UU_Diam/2,h=LM8UU_Length,center=true);
			}
		}
	}
}
else{
	for(j=[-1,1]){
		for(i=[-1,1]){
			translate([i*((car_lenght/2)-(LM8UU_Length/2)-2*walls),j*25,0]){
				rotate([0,90,0]){
					color([0,1,0])
					cylinder(r1=LM8UU_Diam/2,r2=LM8UU_Diam/2,h=LM8UU_Length,center=true);
				}
			}
		}
	}
}
}