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

module main_bottom_face() {
    polygon(polyRound(mainBottomPoints, fn = 12));
}

module main_bottom_shell() {
    shell2d(-mainBottomEdgeWidth) {
        main_bottom_face();
    }
}

module main_bottom_hexed() {
    difference() {
        main_bottom_face();
        translate([mainBaseWidth / 2, mainBottomHeight / 2, 0]) hex_pattern(6);
    }
    main_bottom_shell();
}


module holder() {
    lx(holderZHeight) {
        translate([-holderThickness, - holderThickness * 5 / 2, 0]) {
            difference() {
                shell2d(-holderThickness) polygon(polyRound(holderBottomPoints, fn = 12));
                square([holderThickness, holderThickness * 5]);
                translate([holderThickness * 2, holderThickness * 2]) square([holderThickness, holderThickness]);
            }
        }
    }
}

main_top_body();
translate([0, - (mainBottomHeight - mainBaseHeight), 0]) {
    lx(mainBottomThickness) main_bottom_hexed();
}

translate([mainBaseWidth, mainBaseHeight - holderThickness * 5 / 2 - holderOffset, 0]) holder();
translate([mainBaseWidth, holderThickness * 5 / 2 + holderOffset, 0]) holder();
