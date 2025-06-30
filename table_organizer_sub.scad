include <polyround.scad>
include <table_organizer_header.scad>

$fn = 20;

module sub_base_plate() {
    polygon(polyRound(subBasePoints, fn = 12));
}

module sub_tall_major_plate() {
    polygon(polyRound(subTallMajorPoints, fn = 12));
}

module sub_tall_major_vertical() {
    translate([-subTallCornerRadius - subWallThickness, -subWallThickness, 0])
    square([subWallThickness + subTallCornerRadius * 2, subTallHoleHeight + subWallThickness * 2]);

    translate([subTallMajorHoleWidth - subTallCornerRadius, -subWallThickness, 0])
    square([subWallThickness + subTallCornerRadius * 2, subTallHoleHeight + subWallThickness * 2]);
}

module sub_tall_major_horizontal() {
    translate([-subWallThickness, -subTallCornerRadius - subWallThickness, 0])
    square([subTallMajorHoleWidth + subWallThickness * 2, subWallThickness + subTallCornerRadius * 2]);

    translate([-subWallThickness, subTallHoleHeight - subTallCornerRadius, 0])
    square([subTallMajorHoleWidth + subWallThickness * 2, subWallThickness + subTallCornerRadius * 2]);
}

module sub_tall_minor_plate() {
    polygon(polyRound(subTallMinorPoints, fn = 12));
}

module sub_tall_minor_vertical() {
    translate([-subTallCornerRadius - subWallThickness, -subWallThickness, 0])
    square([subWallThickness + subTallCornerRadius * 2, subTallHoleHeight + subWallThickness * 2]);

    translate([subTallMinorHoleWidth - subTallCornerRadius, -subWallThickness, 0])
    square([subWallThickness + subTallCornerRadius * 2, subTallHoleHeight + subWallThickness * 2]);
}

module sub_tall_minor_horizontal() {
    translate([-subWallThickness, -subTallCornerRadius - subWallThickness, 0])
    square([subTallMinorHoleWidth + subWallThickness * 2, subWallThickness + subTallCornerRadius * 2]);

    translate([-subWallThickness, subTallHoleHeight - subTallCornerRadius, 0])
    square([subTallMinorHoleWidth + subWallThickness * 2, subWallThickness + subTallCornerRadius * 2]);
}

module place_sub_tall() {
    translate([subWallThickness, subBaseHeight - subWallThickness - subTallHoleHeight, 0]) children(0);
    translate([subTallMinorHoleWidth + subWallThickness * 2, subBaseHeight - subWallThickness - subTallHoleHeight, 0]) children(1);

    translate([subWallThickness, subBaseHeight - subWallThickness * 2 - subTallHoleHeight - subTallHoleHeight, 0]) children(1);
    translate([subTallMajorHoleWidth + subWallThickness * 2, subBaseHeight - subWallThickness * 2 - subTallHoleHeight - subTallHoleHeight, 0]) children(0);
}

module sub_tall_plate() {
    place_sub_tall() {
        sub_tall_minor_plate();
        sub_tall_major_plate();
    }
}

module hexed_tall_wall() {
    difference() {
        lx(subZHeight) shell2d(subWallThickness) sub_tall_plate();
        difference() {
            translate([0, 0, subWallHexZOffset]) rotate([-90, 0, 0]) translate([subBaseWidth / 2, 0, 0]) lx(subBaseHeight) rotate([0, 0, 90]) hex_pattern();
            intersection() {
                lx(subZHeight) {
                    place_sub_tall() {
                        sub_tall_minor_vertical();
                        sub_tall_major_vertical();
                    }
                }
                lx(subZHeight) shell2d(subWallThickness) sub_tall_plate();
            }
        }
        difference() {
            translate([0, 0, subWallHexZOffset]) rotate([0, 90, 0]) translate([0, subBaseHeight / 2, 0]) lx(subBaseWidth) hex_pattern();
            intersection() {
                lx(subZHeight) {
                    place_sub_tall() {
                        sub_tall_minor_horizontal();
                        sub_tall_major_horizontal();
                    }
                }
                lx(subZHeight) shell2d(subWallThickness) sub_tall_plate();
            }

        }
    }
    lx(subWallEdge) shell2d(subWallThickness) sub_tall_plate();
    translate([0, 0, subZHeight - subWallEdge]) lx(subWallEdge) shell2d(subWallThickness) sub_tall_plate();
}

module sub_short_plate() {
    polygon(polyRound(subShortPoints, fn = 12));
}

module place_sub_short() {
    translate([subWallThickness, subWallThickness, 0]) children(0);
}

module sub_side_plate() {
    polygon(polyRound(subSidePoints, fn = 12));
}

module sub_side_full() {
        rotate([0, 90, 0]) lx(subBaseWidth) sub_side_plate();
}

module sub_side_shelled_full() {
        rotate([0, 90, 0]) lx(subBaseWidth) shell2d(-subSideWallEdge) sub_side_plate();
}

module sub_short_z_shelled() {
    intersection() {
        children(0);
        lx(subZHeight) {
            difference() {
                shell2d(subWallThickness) {
                    place_sub_short() {
                        sub_short_plate();
                    }
                }
                shell2d(subWallThickness) {
                    sub_tall_plate();
                }
            }
        }
    }
}

module hexed_short_wall() {
    difference() {
        sub_short_z_shelled() {
            sub_side_full();
        }
        difference() {
            translate([0, 0, subWallHexZOffset]) rotate([0, 90, 0]) translate([0, subBaseHeight / 2, 0]) lx(subBaseWidth) hex_pattern();
            sub_short_z_shelled() {
                sub_side_shelled_full();
            }
        }
        intersection() {
            translate([0, 0, subWallHexZOffset]) rotate([-90, 0, 0]) translate([subBaseWidth / 2, 0, 0]) lx(subBaseHeight) rotate([0, 0, 90]) hex_pattern();
            rotate([-90, 0, 0]) lx(subWallThickness * 2) polygon(polyRound(subFrontPoints, fn = 12));
        }
    }
}

module sub_bottom_plate() {
    shell2d(subWallThickness, -100) {
        union() {
            place_sub_short() {
                sub_short_plate();
            }
            sub_tall_plate();
        }
    }
}


module hexed_bottom_plate() {
    difference() {
        sub_bottom_plate();
        translate([subBaseWidth / 2, subBaseHeight / 2, 0]) hex_pattern();
    }
    shell2d(-subWallThickness) sub_bottom_plate();
}

module sub_full() {
    translate([0, 0, subBottomHexThickness]) {
        translate([0, 0, -subBottomHexThickness]) {
            lx(-subBottomFullThickess) {
                sub_bottom_plate();
            }
        }
        lx(-subBottomHexThickness) {
            hexed_bottom_plate();
        }
    }
    hexed_short_wall();
    hexed_tall_wall();
    mirror([1, 0, 0]) {
        translate([0, mainBaseHeight - holderThickness * 5 / 2 - holderOffset, 0]) holder();
        intersection() {
            union() {
                rotate([0, 90, 0]) lx(subBaseWidth) shell2d(-subSideWallEdge, -100) sub_side_plate();
                lx(subBottomThickness * 2, center = true)square(100);
            }
            translate([0, holderThickness * 5 / 2 + holderOffset, 0]) holder();
        }
    }
}

/*#lx(subBottomThickness * 2, center = true)square(100);*/
sub_full();
