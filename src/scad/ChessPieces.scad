$fn = 25;

ROYAL_FOOT_DIA = 0.7625;
FIGURE_FOOT_DIA = 0.66;
PAWN_FOOT_DIA = 0.56;
PAWN_FOOT_RADIUS = PAWN_FOOT_DIA / 2;
PAWN_HIP_RADIUS = 0.75 * PAWN_FOOT_RADIUS;
PAWN_NECK_RADIUS = 0.4 * PAWN_FOOT_RADIUS;
WALL_THICKNESS = 0.03;


RING_HEIGHT = 0.05;
BASE_HEIGHT = 0.2;
BODY_HEIGHT = 0.5;
HEAD_HEIGHT = 0.4;

// Segment Input Parameters:
// - Profile
// - Height
// - Bottom radius
// - Top radius
// - Wall thickness

// Profiles:
//
//          OGEE        BULLNOSE       COVE        VEE
//  ^           |         ,-'               |        /
//  |          /         /                  |       /
//  h       ,-'         |                  /       <
//  |      |             \               ,'         \
//  v       '-.           '-.        _.-'            \

PAWN = [
    segment("VEE", RING_HEIGHT, PAWN_FOOT_RADIUS, PAWN_FOOT_RADIUS),
    segment("OGEE", BASE_HEIGHT, PAWN_FOOT_RADIUS, PAWN_HIP_RADIUS),
    segment("VEE", RING_HEIGHT, PAWN_HIP_RADIUS, PAWN_HIP_RADIUS),
    segment("COVE", BODY_HEIGHT, PAWN_HIP_RADIUS, PAWN_NECK_RADIUS),
    segment("VEE", RING_HEIGHT, PAWN_NECK_RADIUS, PAWN_NECK_RADIUS),
    segment("VEE", HEAD_HEIGHT, PAWN_NECK_RADIUS, 0)
];

chess_piece(PAWN);

outline_profile(segment("VEE", 1.0, 1.0, 1.0, 0.3));
translate([0, 1.01, 0])
outline_profile(segment("COVE", 1.0, 1.0, 0.5, 0.3));
translate([0, 2.02, 0])
outline_profile(segment("VEE", 1.0, 0.5, 1.0, 0.3));
translate([0, 3.03, 0])
outline_profile(segment("OGEE", 1.0, 1.0, 0.5, 0.3));
translate([0, 4.04, 0])
outline_profile(segment("VEE", 1.0, 0.5, 0.5, 0.3));




// Square outline
difference() {
    cube([1, 1, 0.01], center = true);
    cube([0.99, 0.99, 0.02], center = true);
}

function segment(name, height, bottom_radius, top_radius, wall_thickness = WALL_THICKNESS) = [name, height, bottom_radius, top_radius, wall_thickness];
function get_name(segment) = segment[0];
function get_height(segment) = segment[1];
function get_bottom_radius(segment) = segment[2];
function get_top_radius(segment) = segment[3];
function get_wall_thickness(segment) = segment[4];

module chess_piece(segments) {
    
    for (index = [0:len(segments) - 1]) {
        segment = segments[index];
        name = get_name(segment);
        height = get_height(segment);        
        accumulated_height = accumulate_height(segments, index);
        base_height = accumulated_height - height;
        
        echo("Drawing segment ", index, name, " at height ", base_height);
        
        translate([0, 0, base_height])
        rotate_extrude()
        polygon(profile(segment));
    }
}

module outline_profile(segment) {
    polygon(profile(segment));
}

function profile(segment) =
    let(name = get_name(segment))
    name == "OGEE" ? ogee2_profile(segment) :
    name == "VEE" ? vee_profile(segment) :
    /*name == "COVE" ? */cove_profile(segment);

function accumulate_height(segments, index) = 
    let(height = get_height(segments[index]))
    index == 0 ? height : height + accumulate_height(segments, index - 1);


//function ogee_profile(segment) =
//    let(
//        height = get_height(segment),
//        bottom_radius = get_bottom_radius(segment),
//        top_radius = get_top_radius(segment),
//        wall_thickness = get_wall_thickness(segment),
//        delta = abs(top_radius - bottom_radius)
//    )
//[
//    for (t = [0:height/$fn:height])
//    [
//        0.06 * sin(250 * t / height) + top_radius + delta * (1 - t),
//        t
//    ]
//];

function bullnose_profile(segment) =
    let(
        r_min = min(r1, r2),
        delta = abs(r1 - r2),
        angle = asin(delta),
        r = height / (1 + cos(angle)),
        //r = sqrt(delta*delta + height*height) + height,
        //angle = 2 * atan( delta / (2 * r) ),
        is_top_angled = r2 > r1,
        top_angle = 90 - (is_top_angled ? angle : 0),
        bottom_angle = -90 + (is_top_angled ? 0 : angle),
        bottom_offset = is_top_angled ? 0 : cos(angle),
        swing = top_angle - bottom_angle
    )
[
    for (a = [bottom_angle:swing/$fn:top_angle])
    [
        r * cos(a) + r_min,
        r * (sin(a) + bottom_offset)
    ]
];


function vee_profile(segment) =
    let(
        height = get_height(segment),
        bottom_radius = get_bottom_radius(segment),
        top_radius = get_top_radius(segment),
        wall_thickness = get_wall_thickness(segment),
        delta = abs(top_radius - bottom_radius),
        r_min = min(top_radius, bottom_radius)
    )
[
    [bottom_radius - wall_thickness, 0],
    [bottom_radius, 0],
    [r_min + height/2, height/2],
    [top_radius, height],
    [max(0, top_radius - wall_thickness), height],
];


function cove_profile(segment) =
    let(
        height = get_height(segment),
        bottom_radius = get_bottom_radius(segment),
        top_radius = get_top_radius(segment),
        wall_thickness = get_wall_thickness(segment),
        delta = abs(bottom_radius - top_radius)
    )
[
    [bottom_radius - wall_thickness, 0],
    [bottom_radius, 0],
    for (t = [0 : height/$fn : height])
    [
        top_radius + delta * cove_function(1-t/height),
        t
    ],
    [top_radius, height],
    [top_radius - wall_thickness, height],
    for (t = [height : -height/$fn : 0])
    [
        top_radius - wall_thickness + delta * cove_function(1-t/height),
        t
    ],
];
    
function ogee_profile(segment) =
    let(
        height = get_height(segment),
        bottom_radius = get_bottom_radius(segment),
        top_radius = get_top_radius(segment),
        wall_thickness = get_wall_thickness(segment),
        delta = abs(bottom_radius - top_radius)
    )
[
    [bottom_radius - wall_thickness, 0],
    [bottom_radius, 0],
    for (t = [0 : height/$fn : height])
    [
        top_radius + delta * ogee_function(1-t/height),
        t
    ],
    [top_radius, height],
    [top_radius - wall_thickness, height],
    for (t = [height : -height/$fn : 0])
    [
        top_radius - wall_thickness + delta * ogee_function(1-t/height),
        t
    ],
];

function cove_function(t) = t*t*t*t;
function cove_array(height) = [for (t = [0 : height/$fn : height]) cove_function(1-t/height)];
    
function ogee_function(t) = t - 0.2*sin(360*t);
function ogee_array(height) = [for (t = [0 : height/$fn : height]) ogee_function(1-t/height)];
    
function generic_profile(segment, array) =
    let(
        height = get_height(segment),
        bottom_radius = get_bottom_radius(segment),
        top_radius = get_top_radius(segment),
        wall_thickness = get_wall_thickness(segment),
        delta = abs(bottom_radius - top_radius)
    )
[
    [bottom_radius - wall_thickness, 0],
    [bottom_radius, 0],
    for (t = [0 : height/$fn : height])
    [
        top_radius + delta * array[t * $fn / height],
        t
    ],
    [top_radius, height],
    [top_radius - wall_thickness, height],
    for (t = [height : -height/$fn : 0])
    [
        top_radius - wall_thickness + delta * array[t * $fn / height],
        t
    ],
];
  
function ogee2_profile(segment) = generic_profile(segment, ogee_array(get_height(segment)));
    
echo(ogee_array(1));