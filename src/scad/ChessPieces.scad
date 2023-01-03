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

extrude(ring_profile(PAWN_FOOT_RADIUS, RING_HEIGHT));

translate([0, 0, RING_HEIGHT])
extrude(filigree_profile(PAWN_FOOT_RADIUS, PAWN_HIP_RADIUS, BASE_HEIGHT));

translate([0, 0, RING_HEIGHT + BASE_HEIGHT])
extrude(ring_profile(PAWN_HIP_RADIUS, RING_HEIGHT));

translate([0, 0, RING_HEIGHT + BASE_HEIGHT + RING_HEIGHT])
extrude(slant_profile(PAWN_HIP_RADIUS, PAWN_NECK_RADIUS, BODY_HEIGHT));

//cylinder(h=0.01, r = PAWN_HIP_RADIUS);

difference() {
    cube([1, 1, 0.01], center = true);
    cube([0.99, 0.99, 0.02], center = true);
}

function filigree_profile(r1, r2, h) =
    let(delta = r1 - r2)
[
    for (t = [0:h/$fn:h])
    [
        0.06 * sin(250 * t / h) + r2 + delta * (1 - t),
        t
    ]
];
    
function ring_profile(radius, height) =
    let(curve_radius = height / 2)
[
    for (angle = [-90:180/$fn:90])
    [
        curve_radius * cos(angle) + radius,
        curve_radius * sin(angle) + curve_radius
    ]
];
    
function slant_profile(r1, r2, h) =
[
    for (t = [0:h/$fn:h])
    [
        r1 - 0.001 * tan(180 * t / h),
        t
    ]
];

module extrude(profile) {
    rotate_extrude() polygon(profile);
}