
TOLERANCE = 0.05;
WALL_THICKNESS = 1;
SQUARE_LENGTH = 47;
SQUARE_DEPTH = 10;
SQUARE_SIZE = [SQUARE_LENGTH, SQUARE_LENGTH, SQUARE_DEPTH];
REED_SIZE = [15, 2, 2];

chessBoard();
//rotate([0, 0, 180]) scale([-5, -5, -5]) cap(1, 1);

//To Print
//cap(1, 1);

module chessBoard() {
    for (x = [0 : 7]) {
        for (y = [0 : 7]) {
            squareTile(x, y);
            leds(x, y);
            cap(x, y);
        }
    }
}

module squareTile(x, y) {
    color(squareColor(x, y))
    scale(SQUARE_SIZE)
    translate([x, y, -1])
    cube(1);
}

module leds(x, y) {
    for (i = [0 : 1]) {
        for (j = [0 : 1]) {
            translate([x, y, 0] * SQUARE_LENGTH)
            translate([i, j, 0] * SQUARE_LENGTH/2)
            translate([1, 1, 0] * SQUARE_LENGTH/4)
            cylinder(h = 3, r = 2.5);
        }
    }
}

module cap(x, y) {
    translate([x, y, 0] * SQUARE_SIZE.x)
    
    color("grey", 0.5)
    difference() {
        CUBE_LENGTH = SQUARE_LENGTH - TOLERANCE;
        CUBE_SIZE = [CUBE_LENGTH, CUBE_LENGTH, SQUARE_DEPTH];
        cube(CUBE_SIZE);
        
        HALF_LEGTH = (CUBE_LENGTH - 3*WALL_THICKNESS)/2;
        HOLE_SIZE = [HALF_LEGTH, HALF_LEGTH, SQUARE_DEPTH];
        
        translate([WALL_THICKNESS, WALL_THICKNESS, WALL_THICKNESS])
        cube(HOLE_SIZE);
        
        translate([2 * WALL_THICKNESS + HALF_LEGTH, WALL_THICKNESS, 0.32])
        cube(HOLE_SIZE);
        
        translate([WALL_THICKNESS, 2 * WALL_THICKNESS + HALF_LEGTH, 0.64])
        cube(HOLE_SIZE);
        
        translate([2 * WALL_THICKNESS + HALF_LEGTH, 2 * WALL_THICKNESS + HALF_LEGTH, 0.96])
        cube(HOLE_SIZE);
       
//        translate([0, HALF_LEGTH + 1.5 * WALL_THICKNESS, WALL_THICKNESS])
//        #reed();
    }
}

module reed() {
    translate([0, -REED_SIZE.y/2, 0])
    cube(REED_SIZE);
}

function squareColor(x, y) = ((x + y) % 2) ? "white" : "black";