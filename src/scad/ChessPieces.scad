$fn = 25;

ROYAL_DIA = 0.7625;
FIGURE_DIA = 0.66;
PAWN_DIA = 0.56;

FOOT_RADIUS = 0.05;

echo(base_profile(1));


extrude(foot_profile(1, FOOT_RADIUS));
translate([0, 0, 2 * FOOT_RADIUS]) extrude(base_profile(1));

%cube([1, 1, 0.000001], center = true);


function base_profile(diameter) = [ for (t = [0:1/$fn:1]) [0.075 * sin(250 * t) + 0.4125 * diameter, 0.25 * t] ];
    
function foot_profile(diameter, radius = 0.05) = [ for (angle = [-90:1/$fn:90]) [radius * cos(angle) + 0.4125 * diameter, radius * sin(angle) + radius] ];

module extrude(profile) {
    rotate_extrude() polygon(profile);
}