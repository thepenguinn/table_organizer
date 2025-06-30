// kindle // 13 cm3
// calculator
// power bank
// instrument box
// habit tracker
// phone stand

kindleThickness        = 1.8 * 10 ; // cm 1.5
calculatorThickness    = 2.0 * 10 ; // cm 1.7
powerBankThickness     = 1.8 * 10 ; // cm 1.5
instrumentBoxThickness = 2.1 * 10 ; // cm 1.8
habitTrackerThickness  = 2.7 * 10 ; // cm 2.4
phoneStandThickness    = 2.1 * 10 ; // cm 1.8

mainBaseHeight = 8 * 10 ; // cm
mainWallThickness = 2;

mainBaseCornerRadius = 4;
mainBaseLeftCornerRadius = mainBaseCornerRadius;
mainBaseRightCornerRadius = mainBaseCornerRadius;

mainBottomHeight = 11 * 10 ; // cm
mainBottomThickness = 1;
mainBottomCornerRadius = mainBaseCornerRadius;
mainBottomEdgeWidth = 2;
mainBottomEdgeHeight = 2;

mainSideCornerRadius = 32;
mainSideEdgeThickness = mainWallThickness;
itemCornerRadius = 2;

mainZHeight = 8.5 * 10; // cm

mainItemThicknessList = [
    habitTrackerThickness,
    kindleThickness,
    phoneStandThickness,
    calculatorThickness,
    instrumentBoxThickness,
    powerBankThickness,
];

function sum_list(list, idx = 0) =
idx < len(list) - 1 ?
list[idx] + sum_list(list, idx + 1)
:
list[idx]
;

mainBaseWidth = sum_list(mainItemThicknessList) + mainWallThickness * (len(mainItemThicknessList) + 1);

if (mainBaseWidth > 210) {
    echo("WARN: mainBaseHeight is greater than 210 mm");
}
echo("mainBaseHeight =", mainBaseWidth);

mainBasePoints = [
    [mainBaseWidth, mainBaseHeight, mainBaseRightCornerRadius],
    [0, mainBaseHeight,             mainBaseLeftCornerRadius],
    [0, 0,                          0],
    [mainBaseWidth, 0,              0],
];

mainBottomPoints = [
    [mainBaseWidth, mainBottomHeight, mainBottomCornerRadius],
    [0, mainBottomHeight,             mainBottomCornerRadius],
    [0, 0,                          mainBottomCornerRadius * 3],
    [mainBaseWidth, 0,              mainBottomCornerRadius * 3],
];

subTallMajorHoleWidth = 6 * 10; // cm
subTallMinorHoleWidth = 2 * 10; // cm
subTallHoleHeight = 2 * 10; // cm
subTallCornerRadius = 2;

subWallThickness = 2;
subWallEdge = 2;
subBaseCornerRadius = 4;

subBaseHeight = mainBaseHeight;
subBaseWidth = subTallMajorHoleWidth + subTallMinorHoleWidth + subWallThickness * 2;

subZHeight = 5 * 10 ; // cm

subTallMajorPoints = [
    [subTallMajorHoleWidth, subTallHoleHeight, subTallCornerRadius],
    [0,                     subTallHoleHeight, subTallCornerRadius],
    [0,                     0,                 subTallCornerRadius],
    [subTallMajorHoleWidth, 0,                 subTallCornerRadius],
];

subTallMinorPoints = [
    [subTallMinorHoleWidth, subTallHoleHeight, subTallCornerRadius],
    [0,                     subTallHoleHeight, subTallCornerRadius],
    [0,                     0,                 subTallCornerRadius],
    [subTallMinorHoleWidth, 0,                 subTallCornerRadius],
];

subBasePoints = [
    [subBaseWidth, subTallHoleHeight, subBaseCornerRadius],
    [0,            subTallHoleHeight, subBaseCornerRadius],
    [0,            0,                 0],
    [subBaseWidth, 0,                 0],
];

// hex pattern

basePatternHoleRadius = 6;
basePatternGapThickness = 2;
basePatternHeight = sin(60) * basePatternHoleRadius;
basePatternGapHori = basePatternGapThickness / sin(60);
basePatternZOffset = - basePatternHoleRadius / 0.556;

holderThickness = 2;
holderCornerRadius = 1;
holderOffset = 10;
holderZHeight = 4 * 10; // cm

holderBottomPoints = [
    [holderThickness * 3, holderThickness * 5, holderCornerRadius],
    [0, holderThickness * 5,             holderCornerRadius],
    [0, 0,                          holderCornerRadius],
    [holderThickness * 3, 0,              holderCornerRadius],
];

module lx(h, center = false) {
    mirror([0, 0, h < 0 ? 1 : 0]) linear_extrude(abs(h), center = center) children();
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
