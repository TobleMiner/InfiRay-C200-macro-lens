MOUNT_LENGTH = 48.5;
MOUNT_WIDTH = 24.5;
MOUNT_STEPS = 5;
MOUNT_STEP_WIDTH = 2;
MOUNT_STEP_HEIGHT = 1;

STOCK_LENSE_POS_X = 15.5;
STOCK_LENSE_DIAMETER = 14.5;

STOCK_VISIBLE_LIGHT_LENSE_POS_X = 32;
STOCK_VISIBLE_LIGHT_LENSE_DIAMETER = 12;

LENS_HOLE_DIAMETER = 15;
LENS_DIAMETER = 18;
LENS_HEIGHT = 2.8;
LENS_POS_Z = 1;

LED_DISTANCE = 10.8;
LED_DIAMETER = 7;

SCREW_HEAD_SIZE = 2.5; // non-oversized: 2
SCREW_HOLE_SIZE = 1.5; // non-oversized: 1.1
SCREW_THREAD_SIZE = 1; // non-oversized: 0.8

MAGNET_DIAMETER = 5.3; // non-oversized 5
SMALL_MAGNET_DIAMETER = 3.3; // non-oversized 3

BOTTOM = true;
TOP = true;

module rounded_rect(vec) {
    length = vec[0];
    width = vec[1];
    height = vec[2];
    cylinder(height, width/2, width/2, $fn=100);
    translate([0, -width/2, 0]) cube([length - width, width, height]);
    translate([length - width, 0, 0]) cylinder(height, width/2, width/2, $fn=100);
}

module lens_mount_step(rank, length, width, height) {
        translate([MOUNT_WIDTH/2, 0, rank * MOUNT_STEP_HEIGHT]) rounded_rect([length, width, height]);
}

module lens_mount_steps(start, end, undersize=0) {
    for (step = [ start : end - 1]) {
        lens_mount_step(step - start, MOUNT_LENGTH + MOUNT_STEP_WIDTH * step - undersize, MOUNT_WIDTH + MOUNT_STEP_WIDTH * step - undersize, MOUNT_STEP_HEIGHT);
    }
}

module screw_thread() {
    cylinder(2.8, SCREW_THREAD_SIZE/2, SCREW_THREAD_SIZE/2, $fn=100);
}

module screw_hole() {
    cylinder(0.8, SCREW_HEAD_SIZE/2, SCREW_HEAD_SIZE/2, $fn=100);
    translate([0, 0, 0.8]) cylinder(100, SCREW_HOLE_SIZE/2, SCREW_HOLE_SIZE/2, $fn=100);
}

module lens_mount_top_bottom_features(top) {
    translate([11, 0, 0]) if (top) screw_thread(); else screw_hole();
    translate([29, -9.5, 0]) if (top) screw_thread(); else screw_hole();
    translate([29, 9.5, 0]) if (top) screw_thread(); else screw_hole();
}

module magnet() {
    cylinder(4, MAGNET_DIAMETER/2, MAGNET_DIAMETER/2, $fn=100);
}

module small_magnet() {
    cylinder(3, SMALL_MAGNET_DIAMETER/2, SMALL_MAGNET_DIAMETER/2, $fn=100);
}

module lens_mount_bottom() {
    difference() {
        lens_mount_steps(0, 2);
        lens_mount_top_bottom_features(false);
    }
}

module lens_mount_top() {
    translate([0, 0, 2 * MOUNT_STEP_HEIGHT]) {
        difference() {
            union() {
                // undersize top size slightly to compensate for inaccuracy in screw mount
                lens_mount_steps(2, MOUNT_STEPS, undersize=0.2);
                lens_mount_step(MOUNT_STEPS - 2, MOUNT_LENGTH + MOUNT_STEP_WIDTH * (MOUNT_STEPS - 1), MOUNT_WIDTH + MOUNT_STEP_WIDTH * (MOUNT_STEPS - 1), 0);
            }
            lens_mount_top_bottom_features(true);
        }
    }
}

module lens_mount_shape() {
    if (BOTTOM) lens_mount_bottom();
    if (TOP) lens_mount_top();
    /*
    translate([MOUNT_WIDTH/2, 0, 0]) for (step = [ 0 : MOUNT_STEPS - 1]) {
        translate([0, 0, step * MOUNT_STEP_HEIGHT]) rounded_rect([MOUNT_LENGTH + MOUNT_STEP_WIDTH * step, MOUNT_WIDTH + MOUNT_STEP_WIDTH * step, MOUNT_STEP_HEIGHT]);
    }
    */
}

module led() {
    cylinder(10, LED_DIAMETER/2, LED_DIAMETER/2, $fn=100);
}

module lens_holder() {
    cylinder(10, STOCK_LENSE_DIAMETER/2, STOCK_LENSE_DIAMETER/2, $fn=100);
    translate([0, 0,LENS_POS_Z]) cylinder(LENS_HEIGHT, LENS_DIAMETER/2, LENS_DIAMETER/2, $fn=100);
    translate([0, 0,LENS_POS_Z + LENS_HEIGHT + 1]) cylinder(4, STOCK_LENSE_DIAMETER/2, LENS_DIAMETER/2, $fn=100);
}

module visible_light_lense() {
    cylinder(10, STOCK_VISIBLE_LIGHT_LENSE_DIAMETER/2, STOCK_VISIBLE_LIGHT_LENSE_DIAMETER/2, $fn=100);
}

module lens_mount_features() {
    translate([3, 0, 0.5]) magnet();
    translate([9, -LED_DISTANCE/2, 0]) led();
    translate([9, LED_DISTANCE/2, 0]) led();
    translate([STOCK_LENSE_POS_X + STOCK_LENSE_DIAMETER/2, 0, 0]) lens_holder();
    translate([38, -9, 0.5]) small_magnet();
    translate([38, 9, 0.5]) small_magnet();
    translate([STOCK_VISIBLE_LIGHT_LENSE_POS_X + STOCK_VISIBLE_LIGHT_LENSE_DIAMETER/2, 0, 0]) visible_light_lense();
}

module lens_mount() {
    difference() {
        lens_mount_shape();
        lens_mount_features();
    }
}

lens_mount();