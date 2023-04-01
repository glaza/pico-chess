include <gospel.scad>

// Entire board: 375mm
// Square size: 46.875mm
// Cell size: 23.4375mm
$fn = 25;
THICK = 0.75;
GAP = 0.25;
TIP = 1;
EDGE = 23.4375;
WALL = EDGE - THICK;
LONG_WALL = 2*EDGE;
DEPTH = 18.5 - TIP;
SHAFT = 3.5;
WIRE_DIA = 3;
REED_DIA = 2.5;
REED_WIRE = 2;
REED_LENGTH = 14;
SHORT_WALL = EDGE - SHAFT/2;
WELL_DEPTH = 5;


row_max = 4;
col_max = 4;
for (row = [1 : row_max]) {
    for (col = [1 : col_max]) {
        x(col*2.0*EDGE) y(row*2.0*EDGE)

//        // TopLeft
//        square(left = false,
//               right = col != col_max,
//               bottom = row != 1,
//               top = false );
        
//        // TopRight
//        square(left = col <= col_max,
//               right = false,
//               bottom = row != 1,
//               top = false );
        
//        // BottomLeft
//        square(left = false,
//               right = col != col_max,
//               bottom = false,
//               top = true );
        
        // BottomRight
        square(left = true,
               right = false,
               bottom = false,
               top = true );
    }
}
//square();

module square(left = false, right = true, bottom = true, top = false) {
    blue() y(EDGE/2) z(DEPTH/2)
    cube([THICK, WALL, DEPTH], center = true);

    magenta() y(-EDGE/2) z(DEPTH/2 - REED_DIA/2)
    cube([THICK, EDGE - 2*SHAFT + GAP, DEPTH - REED_DIA], center = true);

    cyan() y(-EDGE/2) z(DEPTH/4 - REED_DIA/2)
    difference() {
        cube([THICK, EDGE, DEPTH/2 - REED_DIA], center = true);
        y(-EDGE/2+WIRE_DIA-THICK/2-0.75) z(WIRE_DIA/2-0.25) ry(90)
        cylinder(h = 2*SHAFT, d = WIRE_DIA, center = true);
    }

    red() x(THICK/2) z(DEPTH/2)
    difference() {
        cube([LONG_WALL, THICK, DEPTH], center = true);
        x(2.5) z(-DEPTH + 11.5) rx(90)
        cylinder(h = 2*THICK, d = WIRE_DIA, center = true);
    }

    if (right) {
        green() x(EDGE) y(-THICK/2) z(DEPTH/2)
        difference() {
            cube([THICK, LONG_WALL, DEPTH], center = true);
            y(REED_DIA/2+THICK-WALL) z(WIRE_DIA-DEPTH/2) ry(90)
            cylinder(h = 2*SHAFT, d = WIRE_DIA, center = true);
        }
    }
    
    if (left) {
        white() x(-EDGE) y(-THICK/2) z(DEPTH/2)
        difference() {
            cube([THICK, LONG_WALL, DEPTH], center = true);
            y(REED_DIA/2+THICK-WALL) z(WIRE_DIA/2+THICK-DEPTH/2) ry(90)
            cylinder(h = 2*SHAFT, d = WIRE_DIA, center = true);
        }
    }
    
    if (bottom) {
        yellow() x(THICK/2) y(-EDGE) z(DEPTH/2)
        difference() {
            cube([LONG_WALL, THICK, DEPTH], center = true);
            x(2.5) z(-DEPTH + 11.5) rx(90)
            cylinder(h = 2*THICK, d = WIRE_DIA, center = true);
        }
    }

    if (top) {
        black() x(THICK/2) y(EDGE) z(DEPTH/2)
        difference() {
            cube([LONG_WALL, THICK, DEPTH], center = true);
            x(2.5) z(-DEPTH + 11.5) rx(90)
            cylinder(h = 2*THICK, d = WIRE_DIA, center = true);
        }
    }
    y(-SHAFT/2) z(DEPTH - REED_DIA) well();

    y(SHAFT/2-EDGE) z(DEPTH - REED_DIA) well();

    // Tips
    z(DEPTH + TIP/2) 
    for (row = [0 : 1]) {
        for (col = [0 : 1]) {
            x((col-1)*EDGE) y((1-row)*EDGE) 
            cube([THICK, THICK, TIP], center = true);
        }
    }
    

    // Reed Switch
//    y(-EDGE/2) z(DEPTH - REED_DIA/2) rx(90)
//    cylinder(h = REED_LENGTH, d = REED_DIA, center = true);
}

module well() {
    z(-WELL_DEPTH/2) ry(180)
    difference() {
        cylinder(h = WELL_DEPTH, d = SHAFT, center=true);
        cylinder(h = WELL_DEPTH + 1, d = REED_WIRE, center=true);
    }
}
