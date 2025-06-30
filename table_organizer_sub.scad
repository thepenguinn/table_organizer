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

module sub_tall_minor_plate() {
    polygon(polyRound(subTallMinorPoints, fn = 12));
}

module sub_tall_minor_vertical() {
    translate([-subTallCornerRadius - subWallThickness, -subWallThickness, 0])
    square([subWallThickness + subTallCornerRadius * 2, subTallHoleHeight + subWallThickness * 2]);

    translate([subTallMinorHoleWidth - subTallCornerRadius, -subWallThickness, 0])
    square([subWallThickness + subTallCornerRadius * 2, subTallHoleHeight + subWallThickness * 2]);
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
            rotate([-90, 0, 0]) translate([subBaseWidth / 2, 0, 0]) lx(subBaseHeight) rotate([0, 0, 90]) hex_pattern();
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
    }
    lx(subWallEdge) shell2d(subWallThickness) sub_tall_plate();
    translate([0, 0, subZHeight - subWallEdge]) lx(subWallEdge) shell2d(subWallThickness) sub_tall_plate();
}

hexed_tall_wall();
