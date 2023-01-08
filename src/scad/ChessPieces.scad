$fn = 25;

ROYAL_FOOT_DIA = 0.7625;
FIGURE_FOOT_DIA = 0.66;
PAWN_FOOT_DIA = 0.56;
PAWN_FOOT_RADIUS = PAWN_FOOT_DIA / 2;
PAWN_HIP_RADIUS = 0.75 * PAWN_FOOT_RADIUS;
PAWN_NECK_RADIUS = 0.5 * PAWN_FOOT_RADIUS;

RING_HEIGHT = 0.05;
BASE_HEIGHT = 0.2;
BODY_HEIGHT = 0.5;
HEAD_HEIGHT = 0.4;

// Segment Input Parameters:
// - Profile
// - Height
// - Bottom radius
// - Top radius

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

// Square outline
difference() {
    cube([1, 1, 0.01], center = true);
    cube([0.99, 0.99, 0.02], center = true);
}

function segment(name, height, bottom_radius, top_radius) = [name, height, bottom_radius, top_radius];
function get_name(segment) = segment[0];
function get_height(segment) = segment[1];
function get_bottom_radius(segment) = segment[2];
function get_top_raduis(segment) = segment[3];


module chess_piece(segments) {
    
    for (index = [0:len(segments) - 1]) {
        segment = segments[index];
        name = get_name(segment);
        height = get_height(segment);
        bottom_radius = get_bottom_radius(segment);
        top_radius = get_top_raduis(segment);
        
        accumulated_height = accumulate_height(segments, index);
        base_height = accumulated_height - height;
        
        echo("Drawing segment ", index, name, " at height ", base_height);
        
        translate([0, 0, base_height])
        rotate_extrude()
        polygon(profile(name, height, bottom_radius, top_radius));
    }
}

function profile(name, height, bottom_radius, top_radius) =
    name == "OGEE" ? ogee_profile(height, bottom_radius, top_radius) :
    name == "VEE" ? vee_profile(height, bottom_radius, top_radius) :
    /*name == "COVE" ? */cove_profile(height, bottom_radius, top_radius);

function accumulate_height(segments, index) = 
    let(height = get_height(segments[index]))
    index == 0 ? height : height + accumulate_height(segments, index - 1);



function ogee_profile(h, r1, r2) =
    let(delta = r1 - r2)
[
    for (t = [0:h/$fn:h])
    [
        0.06 * sin(250 * t / h) + r2 + delta * (1 - t),
        t
    ]
];

//height3 = 1;
//r13 = 0.25;
//r23 = 0;
//r_min3 = min(r13, r23);
//delta3 = abs(r13 - r23);
//angle3 = asin(delta3);
//r3 = height3 / (1 + cos(angle3));
//is_top_angled3 = r23 > r13;
//bottom_angle3 = -90 + (is_top_angled3 ? 0 : angle3);
//top_angle3 = 90 - (is_top_angled3 ? angle3 : 0);
//bottom_offset3 = is_top_angled3 ? 0 : cos(angle3);
//swing3 = top_angle3 - bottom_angle3;
//echo("r_min" , min(r13, r23));
//echo("delta" , abs(r13 - r23));
//echo("r", r3);
//echo("angle" , asin(delta3));
//echo("bottom_angle" , bottom_angle3);
//echo("top_angle" , top_angle3);
//echo("bottom_offset3", bottom_offset3);
//echo("swing" , top_angle3 - bottom_angle3);


//for (h = [1:1]) {
//    for (r1 = [1:1]) {
//        for (r2 = [1:1]) {
//            translate([5*r1, 5*r2, h])
//            polygon(bullnose_profile(h, r1, r2));
//        }
//    }
//}

//polygon(bullnose_profile(1, 0.25, 0));

//   ,-'r2 ^
//  /      |
// |       h
//  \      |
//   '-.r1 v
function bullnose_profile(height, r1, r2) =
    let(
        r_min = min(r1, r2),
        delta = abs(r1 - r2),
        angle = asin(delta),
        r = height / (1 + cos(angle)),
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

//   /r2 ^
//  /    |
// <     h
//  \    |
//   \r1 v
function vee_profile(height, r1, r2) =
    let(
        delta = abs(r2 - r1),
        r_min = min(r1, r2)
    )
[
    [r1, 0], [r_min + height/2, height/2], [r2, height]
];

//
//
//
function cove_profile(h, r1, r2) =
[
    [r2, 0],
    for (t = [0 : h/$fn : h])
        let(delta = r1 - r2, u = delta * 3.75 * (1 - t/h), u2 = u * u)
    [
        r2 + u2,
        t
    ]
];

module extrude(profile) {
    rotate_extrude() polygon(profile);
}

function hypotenuse(a, b) = sqrt(a*a + b*b);
