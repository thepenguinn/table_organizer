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

// hex pattern

basePatternHoleRadius = 6;
basePatternGapThickness = 2;
basePatternHeight = sin(60) * basePatternHoleRadius;
basePatternGapHori = basePatternGapThickness / sin(60);
basePatternZOffset = - basePatternHoleRadius / 0.556;

module lx(h, center = false) {
    mirror([0, 0, h < 0 ? 1 : 0]) linear_extrude(abs(h), center = center) children();
}
