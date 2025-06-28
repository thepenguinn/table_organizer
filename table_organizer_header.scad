// kindle // 13 cm3
// calculator
// power bank
// instrument box
// habit tracker
// phone stand

kindleThickness        = 1 * 10 ; // cm
calculatorThickness    = 1 * 10 ; // cm
powerBankThickness     = 2 * 10 ; // cm
instrumentBoxThickness = 1 * 10 ; // cm
habitTrackerThickness  = 1 * 10 ; // cm
phoneStandThickness    = 3 * 10 ; // cm

mainBaseHeight = 10 * 10 ; // cm
mainBaseThickness = 2;
mainWallThickness = 2;

mainBaseCornerRadius = 6;
mainSideCornerRadius = 16;
mainSideEdgeThickness = mainWallThickness;
itemCornerRadius = 4;

mainZHeight = 7 * 10; // cm

mainItemThicknessList = [
    kindleThickness,
    calculatorThickness,
    instrumentBoxThickness,
    habitTrackerThickness,
    powerBankThickness,
    phoneStandThickness,
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
    [mainBaseWidth, mainBaseHeight, mainBaseCornerRadius],
    [0, mainBaseHeight,             mainBaseCornerRadius],
    [0, 0,                          0],
    [mainBaseWidth, 0,              0],
];

// hex pattern

basePatternHoleRadius = 6;
basePatternGapThickness = 2;
basePatternHeight = sin(60) * basePatternHoleRadius;
basePatternGapHori = basePatternGapThickness / sin(60);

module lx(h, center = false) {
    mirror([0, 0, h < 0 ? 1 : 0]) linear_extrude(abs(h), center = center) children();
}
