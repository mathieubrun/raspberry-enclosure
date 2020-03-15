$fn = 20;

board_x=85;
board_y=56;
board_z=1.4;
board_r=3;
board_hole_d=2.75;
board_holes=[
  [ 3.5,  3.5  ],
  [ 3.5,  52.5 ],
  [ 61.5, 52.5 ],
  [ 61.5, 3.5  ]
];

pi3();

module pi3()
{
  color("green") 
  difference()
  {
    translate([board_r, board_r, 0])
    minkowski()
    {
      cube([board_x - board_r*2, board_y - board_r*2, board_z/2]);
      cylinder(r=board_r, h=board_z/2);
    }

    for(hole = board_holes) {
      translate(hole)
      cylinder(d=board_hole_d, h=board_z);
    };
  }

  translate([0, 0, board_z])
  {
    // header
    translate([7, board_y - 6, -3.3])
    cube([51, 5.1, 12]);

    // eth
    translate([66, 2.5, 0])
    cube([21, 16, 13.7]);

    // usb1
    translate([69, 23.4, 0])
    cube([18, 13.1, 15.6]);
    translate([86, 22.4, 0])
    cube([1, 15.1, 16.6]);
    
    // usb2
    translate([69, 40.4, 0])
    cube([18, 13.1, 15.6]);
    translate([86, 39.4, 0])
    cube([1, 15.1, 16.6]);
    
    // micro usb
    translate([6.6, -1.5, 0])
    cube([8, 6, 3]);

    // hdmi
    translate([24.5, -1.5, 0])
    cube([15, 11.5, 6.2]);

    // jack
    translate([50, -2.5, 0])
    {
      translate([0, 2.5, 0])
      cube([7.2, 12.5, 6]);

      translate([3.6, 0, 2.8])
      rotate([-90, 0, 0]) cylinder(d=6, h=2.5);
    }
  }

  // microSD card
  translate([-2.4, 23.5, -1.6])
  cube([15, 11, 1.6]);
}

