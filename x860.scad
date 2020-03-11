$fn = 20;

board_x=87;
board_y=56;
board_z=1.6;
board_r=3;
board_hole_d=2.75;
board_holes=[
  [3.5, 3.5],
  [3.5, 52.5],
  [61.5, 52.5],
  [61.5, 3.5]
];

x860();

module x860()
{
  color("green") difference()
  {
    translate([board_r, board_r, 0])
    minkowski()
    {
      cube([board_x - board_r*2, board_y-board_r*2, board_z/2]);
      cylinder(r=board_r, h=board_z/2);
    }
    
    for(hole = board_holes) {
      translate(hole)
      cylinder(d=board_hole_d, h=board_z);
    };
  }
  
  // usb
  translate([board_x - 15, 39.5, board_z]) 
  cube([15, 15, 8]);
  
  // micro usb
  translate([board_x - 4.5, 6, board_z]) 
  cube([6, 8, 3]);  
}


