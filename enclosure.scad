use <raspberrypi.scad>
use <x860.scad>

print=false;
open=true;
device=false;
part="";

if(print) {
  if(part=="bottom")
  bottom();

  if(part=="top")
  rotate([180, 0, 180])
  top();
}
else
{
  if(open) {
    bottom();
    translate([0, 0, enclosure_thickness_xy * 2])
    translate([10 + 2 * outer_x, 0, inner_z])
    rotate([180, 0, 180])
    top();
  }
  else
  {
    %bottom();
    %top();
  }

  if(device) {
    translate([enclosure_thickness_xy + tolerance_device_x, enclosure_thickness_xy, hole_depth + tolerance_z])
    _pi_hdd();
  }
}

enclosure_thickness_xy = 2;
enclosure_thickness_z = 3;
ventilate = true;
vent_hole_d = 2;

spacer_d = 5;
spacer_bottom_z = 8;
spacer_middle_z = 12;
spacer_top_z = 12;

screw_diameter = 2.46 + 0.2;
screw_head_height = 1.7;
screw_head_diameter = 4.8;

hole_depth = max(3, enclosure_thickness_z);

tolerance_z = 0.1;
tolerance_device_y = 4;
tolerance_device_x = 4;
tolerance_top = 0.3;

board_z=1.4;

device_x=88;
device_y=56;
device_z= spacer_bottom_z + board_z + spacer_middle_z + board_z + spacer_top_z;

inner_x=device_x + tolerance_device_x;
inner_y=device_y + tolerance_device_y;
inner_z=device_z + 2 * tolerance_z + 2*(hole_depth-enclosure_thickness_z);

outer_x=inner_x + 2 * enclosure_thickness_xy;
outer_y=inner_y + 2 * enclosure_thickness_xy;
outer_z=inner_z + 2 * enclosure_thickness_z;

$eps = 1/80;
$fn=20;

board_holes=[
  [ 3.5,  3.5  ],
  [ 3.5,  52.5 ],
  [ 61.5, 52.5 ],
  [ 61.5, 3.5  ]
];

vent_holes=5;
vent_hole_padding_x=(52.5 - 3.5) / 6;
vent_hole_padding_y=(61.5 - 3.5) / 6;

vent_hole_distance_y=(52.5 - 3.5 - 2 * vent_hole_padding_y) / (vent_holes);
vent_hole_distance_x=(61.5 - 3.5 - 2 * vent_hole_padding_x) / (vent_holes);

module top()
  difference() {
    translate([0, 0, outer_z])
    mirror([0, 0, 1])
    _plate(top=true);

    translate([tolerance_device_x, 0, hole_depth])
    _holes();
  }

module bottom()
  difference() {
    union() {
      _plate();

      translate([0, 0, enclosure_thickness_z])
      _box(inner_z);
    }

    translate([tolerance_device_x, 0, hole_depth])
    _holes();
  }

module _ventilation_holes() {
  
  translate([3.5 + vent_hole_padding_x, 3.5 + vent_hole_padding_y, 0])
  {
    for(i = [0:vent_holes]) {
      hull() {
        translate([i * vent_hole_distance_x, 0, 0])
        cylinder(h=enclosure_thickness_z*2, d=vent_hole_d);
        
        translate([0, i * vent_hole_distance_y, 0])
        cylinder(h=enclosure_thickness_z*2, d=vent_hole_d);
      }
    }
    
    for(i = [1:vent_holes]) {
      hull() {
        translate([i * vent_hole_distance_x, vent_holes * vent_hole_distance_y, 0])
        cylinder(h=enclosure_thickness_z*2, d=vent_hole_d);
        
        translate([vent_holes * vent_hole_distance_x, i * vent_hole_distance_y, 0])
        cylinder(h=enclosure_thickness_z*2, d=vent_hole_d);
      }
    }
  }
}

module _plate(top=false)
  difference() {
    union() {
      _cube_round([outer_x, outer_y, enclosure_thickness_z], enclosure_thickness_xy*2);

      translate([enclosure_thickness_xy + tolerance_device_x, enclosure_thickness_xy, 0])
      for(hole = board_holes) {
        translate(hole)
        cylinder(h=hole_depth, d=6);
      };

      if(top){
        translate([enclosure_thickness_xy + tolerance_top, enclosure_thickness_xy + tolerance_top, enclosure_thickness_z])
        _cube_round([inner_x - tolerance_top * 2, inner_y - tolerance_top * 2, enclosure_thickness_z/3], enclosure_thickness_xy);
      }
    }

    translate([enclosure_thickness_xy + tolerance_device_x, enclosure_thickness_xy, 0])
    {
      for(hole = board_holes) {
        translate(hole)
        translate([0, 0, hole_depth])
        cylinder(h=hole_depth, d=5);

        translate(hole)
        cylinder(h=hole_depth, d=screw_diameter);

        translate(hole)
        cylinder(h=screw_head_height, d1=screw_head_diameter, d2=screw_diameter);
      };

      if(top && ventilate) {
        _ventilation_holes();
      }
    }
  };

module _box(height)
  difference() {
    _cube_round([outer_x, outer_y, height], enclosure_thickness_xy * 2);

    translate([enclosure_thickness_xy, enclosure_thickness_xy, -$eps])
    _cube_round([inner_x, inner_y, height + 2 * $eps], enclosure_thickness_xy);
  };


eth_hole_width = 17;
eth_hole_height = 15;
eth_hole_depth = 25.5;

usb_hole_width = 14;
usb_hole_height = 17;
usb_hole_depth = 22.5;

usb_hdd_hole_height = 8;

micro_usb_hole_width = 10;
micro_usb_hole_height = 4;

sd_hole_width = 18;
sd_hole_height = 5;

hdmi_hole_width = 16;
hdmi_hole_height = 8;

audio_hole_d = 7;

module _holes()
  union() {
    // pi
    translate([0, 0, spacer_bottom_z + board_z + spacer_middle_z + board_z]) {
      // Ethernet
      translate([device_x - eth_hole_depth + 5, 12.5 - eth_hole_width/2, 7 - eth_hole_height/2])
      cube([eth_hole_depth + 5, eth_hole_width, eth_hole_height]);

      // USB
      translate([device_x - usb_hole_depth + 5, 31.5 - usb_hole_width/2, 8 - usb_hole_height/2])
      cube([usb_hole_depth + 5, usb_hole_width, usb_hole_height]);
      translate([device_x, 31.5 - usb_hole_width/2 - 1, 8 - usb_hole_height/2])
      cube([1, usb_hole_width + 2, usb_hole_height + 1]);

      translate([device_x - usb_hole_depth + 5, 49 - usb_hole_width/2, 8 - usb_hole_height/2])
      cube([usb_hole_depth + 5, usb_hole_width, usb_hole_height]);
      translate([device_x, 49 - usb_hole_width/2 - 1, 8 - usb_hole_height/2])
      cube([1, usb_hole_width + 2, usb_hole_height + 1]);
      
      // micro USB
      translate([12.5 - micro_usb_hole_width/2, -4, 1.5 - micro_usb_hole_height/2])
      cube([micro_usb_hole_width, 10, micro_usb_hole_height]);

      // HDMI
      translate([34 - hdmi_hole_width/2, -6, 3.5- hdmi_hole_height/2])
      cube([hdmi_hole_width, 13, hdmi_hole_height]);

      // Audio
      translate([55.5, 0, -0.5 + audio_hole_d/2])
      rotate([-90,0,0]) cylinder(d=audio_hole_d, h=5);


      // Micro SD Card
      translate([-10, 31 - sd_hole_width/2, -2 - sd_hole_height/2])
      cube([20, sd_hole_width, sd_hole_height]);
    }

    // hdd
    translate([0, 0, spacer_bottom_z + board_z]) {
      // USB
      translate([device_x - enclosure_thickness_xy, 49 - usb_hole_width/2, 4 - usb_hdd_hole_height/2])
      cube([10, usb_hole_width, usb_hdd_hole_height]);

      // micro USB
      translate([device_x - enclosure_thickness_xy, 12 - micro_usb_hole_width/2, 2 - micro_usb_hole_height/2])
      cube([10, micro_usb_hole_width, micro_usb_hole_height]);
    }
  }

module _cube_round(size, r)
  translate([r, r, 0])
  minkowski() {
    cube([
      size[0] - 2*r,
      size[1] - 2*r,
      size[2] - 0.1
    ]);
    cylinder(h=0.1, r=r);
  }

module _pi_hdd() {
  union()
  {
    translate([0, 0, spacer_bottom_z + board_z + spacer_middle_z]      )
    pi3();

    // spacers
    for(hole = board_holes) {
      translate(hole)
      {
        cylinder(d=spacer_d, h=spacer_bottom_z, $fn=6);

        translate([0, 0, spacer_bottom_z + board_z])
        {
          cylinder(d=spacer_d, h=spacer_middle_z, $fn=6);

          translate([0, 0, spacer_middle_z + board_z])
          cylinder(d=spacer_d, h=spacer_top_z, $fn=6);
        }
      }
    };

    translate([0, 0, spacer_bottom_z])
    x860();
  }
}

