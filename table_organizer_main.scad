include <polyround.scad>
include <table_organizer_header.scad>

$fn = 20;

module create_item_spaces(thicknessList, idx = 0, xOff = 0) {
    if (idx < len(thicknessList)) {
        // create current item and recurse
        itemPoints = [
            [thicknessList[idx], mainBaseHeight - mainWallThickness, itemCornerRadius],
            [0, mainBaseHeight - mainWallThickness,         itemCornerRadius],
            [0, 0,                          0],
            [thicknessList[idx], 0,              0],
        ];

        translate([xOff + mainWallThickness, 0, 0]) {
            polygon(polyRound(itemPoints, fn = 20));
        }

        create_item_spaces(thicknessList, idx + 1, xOff + mainWallThickness + thicknessList[idx]);
    }
}

module create_item_spaces_for_hex(thicknessList, idx = 0, xOff = 0) {
    if (idx < len(thicknessList)) {
        // create current item and recurse
        itemPoints = [
            [thicknessList[idx] - itemCornerRadius * 2, mainBaseHeight, 0],
            [0, mainBaseHeight, 0],
            [0, 0,                          0],
            [thicknessList[idx] - itemCornerRadius * 2, 0,              0],
        ];

        translate([xOff + mainWallThickness + itemCornerRadius, 0, 0]) {
            polygon(polyRound(itemPoints, fn = 20));
        }

        create_item_spaces_for_hex(thicknessList, idx + 1, xOff + mainWallThickness + thicknessList[idx]);
    }
}

module main_wall_base() {
    difference() {
        polygon(polyRound(mainBasePoints, fn = 20));
        create_item_spaces(mainItemThicknessList);
    }
}

module hex_pattern_odd(count) {
    for (i = [0:1:count]) {
        translate([((basePatternHoleRadius + basePatternGapHori) * 2 + basePatternHoleRadius) * i, 0, 0]) circle(basePatternHoleRadius, $fn = 6);
    }
    for (i = [1:1:count]) {
        translate([-((basePatternHoleRadius + basePatternGapHori) * 2 + basePatternHoleRadius) * i, 0, 0]) circle(basePatternHoleRadius, $fn = 6);
    }
}

module hex_pattern_even(count) {
    for (i = [0:1:count - 1]) {
        translate([(((basePatternHoleRadius + basePatternGapHori) * 2 + basePatternHoleRadius) * i + (basePatternHoleRadius * 1.5) + basePatternGapHori), 0, 0]) circle(basePatternHoleRadius, $fn = 6);
    }

    for (i = [0:1:count - 1]) {
        translate([-(((basePatternHoleRadius + basePatternGapHori) * 2 + basePatternHoleRadius) * i + (basePatternHoleRadius * 1.5) + basePatternGapHori), 0, 0]) circle(basePatternHoleRadius, $fn = 6);
    }
}


module hex_pattern_odd_offset(count, off) {
    translate([0, (basePatternHeight * 2 + basePatternGapThickness) * off, 0]) hex_pattern_odd(count);
}

module hex_pattern_even_offset(count, off = 1) {
    dir = off / abs(off);
    off = abs(off) - 1;

    translate([0, ((basePatternHeight + basePatternGapThickness / 2) + (basePatternHeight * 2 + basePatternGapThickness) * off) * dir, 0]) hex_pattern_even(count);
}

module hex_pattern(count = 5) {

    for (i = [-count:1:count - 1]) {
        hex_pattern_odd_offset(3, i);
    }

    for (i = [-count:1:-1]) {
        hex_pattern_even_offset(4, i);
    }
    for (i = [1:1:count]) {
        hex_pattern_even_offset(4, i);
    }
}

module main_back_plate() {
    lx(mainZHeight)  {
        difference() {
            main_wall_base();
            square([mainBaseWidth, mainBaseHeight - mainWallThickness]);
        }
    }
}

module hex_cylinders() {
    translate([mainBaseWidth / 2, mainBaseHeight / 2, mainZHeight / 2 + basePatternZOffset]) {
        rotate([0, 90, 0]) {
            lx(mainBaseWidth, center = true) hex_pattern();
        }
    }
}

mainSidePoints = [
    [0, mainBaseHeight, 0],
    [-mainZHeight, mainBaseHeight, 0],
    [-mainZHeight, 0, mainSideCornerRadius],
    [0, 0, 0],
];

module main_side_plate() {
    polygon(polyRound(mainSidePoints, fn = 12));
}

module main_side_shell() {
    shell2d(-mainSideEdgeThickness) {
        main_side_plate();
    }
}

module main_side_shell_3d() {
    rotate([0, 90, 0]) {
        lx(mainBaseWidth) {
            main_side_shell();
        }
    }
}

module main_body() {
    intersection() {
        rotate([0, 90, 0]) {
            lx(mainBaseWidth) {
                main_side_plate();
            }
        }
        lx(mainZHeight) main_wall_base();
    }
}


/*create_item_spaces(mainItemThicknessList);*/


/*main_side_shell_3d();*/
/*main_body();*/

/*hex_cylinders();*/

module main_top_body() {
    difference() {
        main_body();
        difference() {
            intersection() {
                hex_cylinders();
                main_body();
            }
            main_side_shell_3d();
        }
        intersection() {
            translate([mainBaseWidth / 2, mainBaseHeight / 2, mainZHeight / 2 + basePatternZOffset]) {
                rotate([0, 90, 90]) {
                    lx(mainBaseHeight, center = true) hex_pattern(10);
                }
            }
            lx(mainZHeight - mainSideEdgeThickness) create_item_spaces_for_hex(mainItemThicknessList);
        }
    }
}

main_top_body();
