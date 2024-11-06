import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

// const LOGO_PARAM_K1 = 1.5;
// const LOGO_PARAM_K2 = 4.5;
// const LOGO_PARAM_K3 = 0.1;
// const LOGO_PARAM_K4 = 0.1;
// const LOGO_PARAM_K5 = 0.4;
// const LOGO_PARAM_ALPHA = 66;

const ONE_DEGREE_IN_RADIAN = Math.PI / 180;
// const LOGO_ALPHA_IN_RADIAN = ONE_DEGREE_IN_RADIAN * LOGO_PARAM_ALPHA;
// const LOGO_TAN_ALPHA = Math.tan(LOGO_ALPHA_IN_RADIAN);
// const LOGO_CTANG_ALPHA = 1 / LOGO_TAN_ALPHA;

// // const LOGO_PARAM_K2 = (1 + LOGO_PARAM_K1) * 2 * (-1) / Math.tan(LOGO_ALPHA_IN_RADIAN * 2);

// const LOGO_SIN_ALPHA = Math.sin(LOGO_ALPHA_IN_RADIAN);
// const LOGO_WIDTH_RATIO_BY_PARAM_A = 2 + 2 * LOGO_PARAM_K1;
// const LOGO_HEIGHT_RATIO_BY_PARAM_A = LOGO_PARAM_K2 + LOGO_CTANG_ALPHA + LOGO_PARAM_K1 * LOGO_CTANG_ALPHA;
// const LOGO_SIZE_RATIO = LOGO_WIDTH_RATIO_BY_PARAM_A / LOGO_HEIGHT_RATIO_BY_PARAM_A;
// const LOGO_HEIGHT_RATIO_IN_CIRCLE = 1 / Math.sqrt(1 + LOGO_SIZE_RATIO * LOGO_SIZE_RATIO);
// const LOGO_WIDTH_RATIO_IN_CIRCLE = LOGO_SIZE_RATIO * LOGO_HEIGHT_RATIO_IN_CIRCLE;
// const LOGO_RADIUS_RATIO_BY_PARAM_A = (0.5 * (1 + LOGO_PARAM_K1) * (1 + LOGO_PARAM_K1)) / (LOGO_PARAM_K2 + LOGO_CTANG_ALPHA + LOGO_CTANG_ALPHA * LOGO_PARAM_K1) +
//     0.5 * (LOGO_PARAM_K2 + LOGO_CTANG_ALPHA + LOGO_CTANG_ALPHA * LOGO_PARAM_K1);

// const LOGO_DIGIT_PARAM_K1 = 3.5;
// const LOGO_DIGIT_WIDTH_RATIO_BY_PARAM_A = LOGO_PARAM_K1 / 2 - LOGO_PARAM_K3;
// const LOGO_DIGIT_HEIGHT_RATIO_BY_PARAM_A = LOGO_PARAM_K2 / 2 - LOGO_PARAM_K3 - 1 / (2 * LOGO_SIN_ALPHA);

// const LOGO_DATA_AREA_HEIGHT = LOGO_PARAM_K5 * 2 * LOGO_PARAM_K1 * LOGO_CTANG_ALPHA;
// // const LOGO_DATA_AREA_HEIGHT = 1 / LOGO_SIN_ALPHA - LOGO_PARAM_K4;
// const LOGO_DATA_AREA_WIDTH = ((2 * LOGO_PARAM_K1 + 1) * LOGO_CTANG_ALPHA - LOGO_PARAM_K4 - LOGO_DATA_AREA_HEIGHT) * LOGO_TAN_ALPHA - LOGO_PARAM_K4;
// const LOGO_DATA_AREA_LETTER_HEIGHT = LOGO_DATA_AREA_HEIGHT;
// const LOGO_DATA_AREA_LETTER_WIDTH = (LOGO_DATA_AREA_WIDTH - 4 * LOGO_PARAM_K4) / 5;
// // const LOGO_DATA_AREA_LETTER_WIDTH = 0.5 * LOGO_DATA_AREA_LETTER_HEIGHT;

// const LOGO_POINTS = [
//     [0, 0],                                                                                                                 // P1
//     [0, LOGO_PARAM_K2],                                                                                                     // P2
//     [1 + LOGO_PARAM_K1, LOGO_PARAM_K2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA],                                            // P3
//     [1 + LOGO_PARAM_K1, LOGO_PARAM_K2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA - 1 / LOGO_SIN_ALPHA],                       // P4
//     [1, LOGO_PARAM_K2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA - 1 / LOGO_SIN_ALPHA - LOGO_PARAM_K1 * LOGO_CTANG_ALPHA],    // P5
//     [1, LOGO_CTANG_ALPHA],                                                                                                  // P6

//     [1, (1 + 2 * LOGO_PARAM_K1) * LOGO_CTANG_ALPHA],                                                                        // P7
//     [1, (1 + 2 * LOGO_PARAM_K1) * LOGO_CTANG_ALPHA + 1 / LOGO_SIN_ALPHA],                                                   // P8
//     [1 + LOGO_PARAM_K1, 1 / LOGO_SIN_ALPHA + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA],                                       // P9
//     [1 + LOGO_PARAM_K1, LOGO_PARAM_K2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA],                                            // P10
//     [2 + LOGO_PARAM_K1, LOGO_PARAM_K2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA - LOGO_CTANG_ALPHA],                         // P11
//     [2 + LOGO_PARAM_K1, 1 / LOGO_SIN_ALPHA + LOGO_CTANG_ALPHA * LOGO_PARAM_K1],                                             // P12
//     [2 + 2 * LOGO_PARAM_K1, 1 / LOGO_SIN_ALPHA],                                                                            // P13
//     [2 + 2 * LOGO_PARAM_K1, 0],                                                                                             // P14

//     [1 + LOGO_PARAM_K1, LOGO_PARAM_K2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA - LOGO_RADIUS_RATIO_BY_PARAM_A],             // P15
//     [1 + LOGO_PARAM_K1, LOGO_PARAM_K2 / 2 + (1 + LOGO_PARAM_K1) * LOGO_CTANG_ALPHA / 2],                                    // P16
    
//     [                                                                                                                       // P17
//         2 + LOGO_PARAM_K1 + LOGO_PARAM_K3, 
//         1 / LOGO_SIN_ALPHA + LOGO_PARAM_K1 * LOGO_CTANG_ALPHA + LOGO_PARAM_K3
//     ],
//     [                                                                                                                       // P18
//         2 + LOGO_PARAM_K1 + LOGO_PARAM_K3 + LOGO_PARAM_K1 / 2, 
//         (LOGO_PARAM_K1 / 2 - LOGO_PARAM_K3) * LOGO_CTANG_ALPHA + 1 / LOGO_SIN_ALPHA + LOGO_PARAM_K3
//     ],
//     [                                                                                                                       // P19
//         2 + LOGO_PARAM_K1 + LOGO_PARAM_K3, 
//         1 / (2 * LOGO_SIN_ALPHA) + LOGO_PARAM_K1 * LOGO_CTANG_ALPHA + LOGO_PARAM_K3 + LOGO_PARAM_K2 / 2
//     ],
//     [                                                                                                                       // P20
//         2 + LOGO_PARAM_K1 + LOGO_PARAM_K3 + LOGO_PARAM_K1 / 2, 
//         (LOGO_PARAM_K1 / 2 - LOGO_PARAM_K3) * LOGO_CTANG_ALPHA + 1 / (2 * LOGO_SIN_ALPHA) + LOGO_PARAM_K3 + LOGO_PARAM_K2 / 2
//     ],

//     [                                                                                                                       // P21
//         1 + LOGO_PARAM_K4, 
//         (5 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH) - LOGO_PARAM_K4) * LOGO_CTANG_ALPHA
//     ],
//     [                                                                                                                       // P22
//         1 + LOGO_PARAM_K4 + LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH,
//         (4 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH) - LOGO_PARAM_K4) * LOGO_CTANG_ALPHA
//     ],
//     [                                                                                                                       // P23
//         1 + LOGO_PARAM_K4 + 2 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH), 
//         (3 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH) - LOGO_PARAM_K4) * LOGO_CTANG_ALPHA
//     ],
//     [                                                                                                                       // P24
//         1 + LOGO_PARAM_K4 + 3 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH), 
//         (2 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH) - LOGO_PARAM_K4) * LOGO_CTANG_ALPHA
//     ],
//     [                                                                                                                       // P25
//         1 + LOGO_PARAM_K4 + 4 * (LOGO_PARAM_K4 + LOGO_DATA_AREA_LETTER_WIDTH), 
//         LOGO_DATA_AREA_LETTER_WIDTH * LOGO_CTANG_ALPHA
//     ],

// ];

// const LOGO_DIGITS_POINTS = LyatskiyTeamWatchFaceFont.getAngledLettersPoints(
//     LOGO_DIGIT_WIDTH_RATIO_BY_PARAM_A / LOGO_DIGIT_PARAM_K1, 
//     LOGO_DIGIT_WIDTH_RATIO_BY_PARAM_A, 
//     LOGO_DIGIT_HEIGHT_RATIO_BY_PARAM_A, 
//     90 - LOGO_PARAM_ALPHA);

// const LOGO_LETTERS_POINTS_IN_DATA_AREA = LyatskiyTeamWatchFaceFont.getAngledLettersPoints(
//     LOGO_DATA_AREA_LETTER_WIDTH / LOGO_DIGIT_PARAM_K1, 
//     LOGO_DATA_AREA_LETTER_WIDTH, 
//     LOGO_DATA_AREA_LETTER_HEIGHT, 
//     90 - LOGO_PARAM_ALPHA);



module LyatskiyTeamWatchFaceLogo {

    class Logo {
        private var _points;

        private var _paramA = 1.0;
        private var _offsetX = 0.0;
        private var _offsetY = 0.0;

        private var _paramAlpha;

        private var _dataAreaLetterHeight;
        private var _dataAreaLetterWidth;
        private var _clockAreaDigitWidth;
        private var _clockAreaDigitHeight;

        function initialize(params) {
            var k1 = params[:k1];
            var k2 = params[:k2];
            var k3 = params[:k3];
            var k4 = params[:k4];
            var k5 = params[:k5];
            var alpha = params[:alpha];

            _paramAlpha = alpha;

            var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha;
            var tanAlpha = Math.tan(alphaInRadian);
            var ctanAlpha = 1 / tanAlpha;
            var sinAlpha = Math.sin(alphaInRadian);
            
            var radiusByParamA = (0.5 * (1 + k1) * (1 + k1)) / (k2 + ctanAlpha + ctanAlpha * k1) +
                0.5 * (k2 + ctanAlpha + ctanAlpha * k1);

            var dataAreaHeight = k5 * 2 * k1 * ctanAlpha;
            var dataAreaWidth = ((2 * k1 + 1) * ctanAlpha - k4 - dataAreaHeight) * tanAlpha - k4;

            _dataAreaLetterHeight = dataAreaHeight;
            _dataAreaLetterWidth = (dataAreaWidth - 4 * k4) / 5;

            _clockAreaDigitWidth = k1 / 2 - k3;
            _clockAreaDigitHeight = k2 / 2 - k3 - 1 / (2 * sinAlpha);

            _points = [
                [0, 0],                                                                         // P1
                [0, k2],                                                                        // P2
                [1 + k1, k2 + (1 + k1) * ctanAlpha],                                            // P3
                [1 + k1, k2 + (1 + k1) * ctanAlpha - 1 / sinAlpha],                             // P4
                [1, k2 + (1 + k1) * ctanAlpha - 1 / sinAlpha - k1 * ctanAlpha],                 // P5
                [1, ctanAlpha],                                                                 // P6

                [1, (1 + 2 * k1) * ctanAlpha],                                                  // P7
                [1, (1 + 2 * k1) * ctanAlpha + 1 / sinAlpha],                                   // P8
                [1 + k1, 1 / sinAlpha + (1 + k1) * ctanAlpha],                                  // P9
                [1 + k1, k2 + (1 + k1) * ctanAlpha],                                            // P10
                [2 + k1, k2 + (1 + k1) * ctanAlpha - ctanAlpha],                                // P11
                [2 + k1, 1 / sinAlpha + ctanAlpha * k1],                                        // P12
                [2 + 2 * k1, 1 / sinAlpha],                                                     // P13
                [2 + 2 * k1, 0],                                                                // P14

                [1 + k1, k2 + (1 + k1) * ctanAlpha - radiusByParamA],                           // P15
                [1 + k1, k2 / 2 + (1 + k1) * ctanAlpha / 2],                                    // P16
                
                [                                                                               // P17
                    2 + k1 + k3, 
                    1 / sinAlpha + k1 * ctanAlpha + k3
                ],
                [                                                                               // P18
                    2 + k1 + k3 + k1 / 2, 
                    (k1 / 2 - k3) * ctanAlpha + 1 / sinAlpha + k3
                ],
                [                                                                               // P19
                    2 + k1 + k3, 
                    1 / (2 * sinAlpha) + k1 * ctanAlpha + k3 + k2 / 2
                ],
                [                                                                               // P20
                    2 + k1 + k3 + k1 / 2, 
                    (k1 / 2 - k3) * ctanAlpha + 1 / (2 * sinAlpha) + k3 + k2 / 2
                ],

                [                                                                               // P21
                    1 + k4, 
                    (5 * (k4 + _dataAreaLetterWidth) - k4) * ctanAlpha
                ],
                [                                                                               // P22
                    1 + k4 + k4 + _dataAreaLetterWidth,
                    (4 * (k4 + _dataAreaLetterWidth) - k4) * ctanAlpha
                ],
                [                                                                               // P23
                    1 + k4 + 2 * (k4 + _dataAreaLetterWidth), 
                    (3 * (k4 + _dataAreaLetterWidth) - k4) * ctanAlpha
                ],
                [                                                                               // P24
                    1 + k4 + 3 * (k4 + _dataAreaLetterWidth), 
                    (2 * (k4 + _dataAreaLetterWidth) - k4) * ctanAlpha
                ],
                [                                                                               // P25
                    1 + k4 + 4 * (k4 + _dataAreaLetterWidth), 
                    _dataAreaLetterWidth * ctanAlpha
                ]
            ];
        }

        function setParamA(value) {
            _paramA = value;
        }

        function setOffset(x, y) {
            _offsetX = x;
            _offsetY = y;
        }

        function getWidth() {
            return (_points[13][0] - _points[0][0]) * _paramA;
        }

        function getHeight() {
            return (_points[2][1] - _points[0][1]) * _paramA;
        }

        function getPoint(num) {
            return [
                _points[num - 1][0] * _paramA + _offsetX,
                _points[num - 1][1] * _paramA + _offsetY
            ];
        }

        function getCircleCenterPoint() {
            return getPoint(15);
        }

        function getRadius() {
            return (_points[2][1] - _points[14][1]) * _paramA;
        }

        function getLetterLPoints() {
            var points = new [6];

            for (var i = 0; i <= 5; ++i) {
                points[i] = [
                    _points[i][0] * _paramA + _offsetX,
                    _points[i][1] * _paramA + _offsetY
                ];
            }

            return points;
        }

        function getLetterTPoints() {
            var points = new [8];
            var j = 0;

            for (var i = 6; i <= 13; ++i) {
                points[j] = [
                    _points[i][0] * _paramA + _offsetX,
                    _points[i][1] * _paramA + _offsetY
                ];
                j = j + 1;
            }

            return points;
        }

        function getDigitPointsInClockArea(digit, position) {
            var points = getAngledLetterPoints(
                digit.toString(), 
                _clockAreaDigitWidth * _paramA,
                _clockAreaDigitHeight * _paramA,
                3.5, // TODO
                90 - _paramAlpha);
            var reperPoint = getPoint(16 + position);

            shiftPoints(
                points,
                reperPoint[0],
                reperPoint[1]);
            
            return points;
        }

        function getLetterPointsInDataArea(letter, position) {
            var points = getAngledLetterPoints(
                letter, 
                _dataAreaLetterWidth * _paramA,
                _dataAreaLetterHeight * _paramA,
                3.5, // TODO
                90 - _paramAlpha);
            var reperPoint = getPoint(20 + position);

            shiftPoints(
                points,
                reperPoint[0],
                reperPoint[1]);

            return points;
        }
    }

    function createLogoOnScreen(logoParams, screenParams) {
        var logo = new Logo(logoParams);

        var deviceScreenWidth = screenParams[:width];
        var deviceScreenHeight = screenParams[:height];
        var deviceScreenShape = screenParams[:shape];
        var deviceScreenPadding = screenParams[:padding];

        var logoParamA;
        var offsetX;
        var offsetY;
        
        var screenWidth = deviceScreenWidth * (1 - deviceScreenPadding);
        var screenHeight = deviceScreenHeight * (1 - deviceScreenPadding);

        if (deviceScreenShape == System.SCREEN_SHAPE_ROUND) { // API Level 1.2.0
            var logoCenterPointByParamA = logo.getCircleCenterPoint();
            var logoRadiusByParamA = logo.getRadius();

            logoParamA = screenWidth / (2 * logoRadiusByParamA);
            offsetX = deviceScreenWidth / 2 - logoCenterPointByParamA[0] * logoParamA;
            offsetY = deviceScreenWidth / 2 - logoCenterPointByParamA[1] * logoParamA;
        } else {
            var logoHeight;
            var logoWidth;
            var logoWidthByParamA = logo.getWidth();
            var logoHeightByParamA = logo.getHeight();
            var logoSizeRatio = logoWidthByParamA / logoHeightByParamA;
            var deviceScreenSizeRatio = deviceScreenWidth / deviceScreenHeight;
            
            if (logoSizeRatio < deviceScreenSizeRatio) {
                logoHeight = screenHeight;
                logoWidth = logoSizeRatio * logoHeight;
            } else {
                logoWidth = screenWidth;
                logoHeight = logoWidth / logoSizeRatio;
            }

            logoParamA = logoWidth / logoWidthByParamA;
            offsetX = (deviceScreenWidth - logoWidth) / 2;
            offsetY = (deviceScreenHeight - logoHeight) / 2;
        }

        logo.setParamA(logoParamA);
        logo.setOffset(offsetX, offsetY);

        return logo;
    }

    // function getLetterLPoints(a, offsetX, offsetY) {
    //     var points = new [6];

    //     for (var i = 0; i <= 5; ++i) {
    //         points[i] = [
    //             LOGO_POINTS[i][0] * a + offsetX,
    //             LOGO_POINTS[i][1] * a + offsetY
    //         ];
    //     }

    //     return points;
    // }

    // function getLetterTPoints(a, offsetX, offsetY) {
    //     var points = new [8];
    //     var j = 0;

    //     for (var i = 6; i <= 13; ++i) {
    //         points[j] = [
    //             LOGO_POINTS[i][0] * a + offsetX,
    //             LOGO_POINTS[i][1] * a + offsetY
    //         ];
    //         j = j + 1;
    //     }

    //     return points;
    // }


    // function calculateLogoPoints(logoParams) {
    //     var k1 = logoParams[:k1];
    //     var k2 = logoParams[:k2];
    //     var k3 = logoParams[:k3];
    //     var k4 = logoParams[:k4];
    //     var k5 = logoParams[:k5];
    //     var alpha = logoParams[:alpha];

    //     var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha;
    //     var tanAlpha = Math.tan(alphaInRadian);
    //     var ctanAlpha = 1 / tanAlpha;
    //     var sinAlpha = Math.sin(alphaInRadian);
        
    //     var radiusByParamA = (0.5 * (1 + k1) * (1 + k1)) / (k2 + ctanAlpha + ctanAlpha * k1) +
    //         0.5 * (k2 + ctanAlpha + ctanAlpha * k1);

    //     var dataAreaHeight = k5 * 2 * k1 * ctanAlpha;
    //     var dataAreaWidth = ((2 * k1 + 1) * ctanAlpha - k4 - dataAreaHeight) * tanAlpha - k4;
    //     var dataAreaLetterHeight = dataAreaHeight;
    //     var dataAreaLetterWidth = (dataAreaWidth - 4 * k4) / 5;

    //     return [
    //         [0, 0],                                                                         // P1
    //         [0, k2],                                                                        // P2
    //         [1 + k1, k2 + (1 + k1) * ctanAlpha],                                            // P3
    //         [1 + k1, k2 + (1 + k1) * ctanAlpha - 1 / sinAlpha],                             // P4
    //         [1, k2 + (1 + k1) * ctanAlpha - 1 / sinAlpha - k1 * ctanAlpha],                 // P5
    //         [1, ctanAlpha],                                                                 // P6

    //         [1, (1 + 2 * k1) * ctanAlpha],                                                  // P7
    //         [1, (1 + 2 * k1) * ctanAlpha + 1 / sinAlpha],                                   // P8
    //         [1 + k1, 1 / sinAlpha + (1 + k1) * ctanAlpha],                                  // P9
    //         [1 + k1, k2 + (1 + k1) * ctanAlpha],                                            // P10
    //         [2 + k1, k2 + (1 + k1) * ctanAlpha - ctanAlpha],                                // P11
    //         [2 + k1, 1 / sinAlpha + ctanAlpha * k1],                                        // P12
    //         [2 + 2 * k1, 1 / sinAlpha],                                                     // P13
    //         [2 + 2 * k1, 0],                                                                // P14

    //         [1 + k1, k2 + (1 + k1) * ctanAlpha - radiusByParamA],                           // P15
    //         [1 + k1, k2 / 2 + (1 + k1) * ctanAlpha / 2],                                    // P16
            
    //         [                                                                               // P17
    //             2 + k1 + k3, 
    //             1 / sinAlpha + k1 * ctanAlpha + k3
    //         ],
    //         [                                                                               // P18
    //             2 + k1 + k3 + k1 / 2, 
    //             (k1 / 2 - k3) * ctanAlpha + 1 / sinAlpha + k3
    //         ],
    //         [                                                                               // P19
    //             2 + k1 + k3, 
    //             1 / (2 * sinAlpha) + k1 * ctanAlpha + k3 + k2 / 2
    //         ],
    //         [                                                                               // P20
    //             2 + k1 + k3 + k1 / 2, 
    //             (k1 / 2 - k3) * ctanAlpha + 1 / (2 * sinAlpha) + k3 + k2 / 2
    //         ],

    //         [                                                                               // P21
    //             1 + k4, 
    //             (5 * (k4 + dataAreaLetterWidth) - k4) * ctanAlpha
    //         ],
    //         [                                                                               // P22
    //             1 + k4 + k4 + dataAreaLetterWidth,
    //             (4 * (k4 + dataAreaLetterWidth) - k4) * ctanAlpha
    //         ],
    //         [                                                                               // P23
    //             1 + k4 + 2 * (k4 + dataAreaLetterWidth), 
    //             (3 * (k4 + dataAreaLetterWidth) - k4) * ctanAlpha
    //         ],
    //         [                                                                               // P24
    //             1 + k4 + 3 * (k4 + dataAreaLetterWidth), 
    //             (2 * (k4 + dataAreaLetterWidth) - k4) * ctanAlpha
    //         ],
    //         [                                                                               // P25
    //             1 + k4 + 4 * (k4 + dataAreaLetterWidth), 
    //             dataAreaLetterWidth * ctanAlpha
    //         ]
    //     ];
    // }

    // function calculateLogoSizes(logoParams, deviceScreenWidth, deviceScreenHeight, deviceScreenShape) {
    //     var logoParamA;
    //     var padding = 0.05;
    //     var offsetX;
    //     var offsetY;
    //     var screenWidth = deviceScreenWidth * (1 - padding);
    //     var screenHeight = deviceScreenHeight * (1 - padding);

    //     var logoPoints = calculateLogoPoints(logoParams);

    //     if (deviceScreenShape == System.SCREEN_SHAPE_ROUND) { // API Level 1.2.0
    //         const ctanAlpha = 1 / Math.tan(ONE_DEGREE_IN_RADIAN * logoParamAlpha);
    //         var radiusByParamA = (0.5 * (1 + logoParamK1) * (1 + logoParamK1)) / (logoParamK2 + ctanAlpha + ctanAlpha * logoParamK1) +
    //             0.5 * (logoParamK2 + ctanAlpha + ctanAlpha * logoParamK1);

    //         logoParamA = screenWidth / (2 * radiusByParamA);
    //         offsetX = deviceScreenWidth / 2 - (1 + logoParamK1) * logoParamA;
    //         offsetY = deviceScreenWidth / 2 - (logoParamK2 + (1 + logoParamK1) * ctanAlpha - radiusByParamA) * logoParamA;
    //     } else {
    //         var logoHeight;
    //         var logoWidth;
    //         var logoWidthByParamA = logoPoints[13][0] - logoPoints[0][0];
    //         var logoHeightByParamA = logoPoints[3][1] - logoPoints[0][1];
    //         var logoSizeRatio = logoWidthByParamA / logoHeightByParamA;
    //         var deviceScreenSizeRatio = deviceScreenWidth / deviceScreenHeight;
            
    //         if (logoSizeRatio < deviceScreenSizeRatio) {
    //             logoHeight = screenHeight;
    //             logoWidth = logoSizeRatio * logoHeight;
    //         } else {
    //             logoWidth = screenWidth;
    //             logoHeight = logoWidth / logoSizeRatio;
    //         }

    //         logoParamA = logoWidth / logoWidthByParamA;
    //         offsetX = (deviceScreenWidth - logoWidth) / 2;
    //         offsetY = (deviceScreenHeight - logoHeight) / 2;
    //     }

    //     return [
    //         logoParamA,
    //         offsetX,
    //         offsetY,
    //         logoPoints
    //     ];
    // }

    function shiftPoints(points, sx, sy) {
        for (var i = 0; i < points.size(); ++i) {
            points[i][0] += sx;
            points[i][1] += sy;
        }
    }

    function getLetterPoints(letter, width, height, k) {
        var points;
        var paramA = width / k;

        switch (letter) {
            case "0":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, 0],
                    [paramA, 0],
                    [paramA, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height - paramA],
                    [paramA, height - paramA],
                    [paramA, 0]
                ];
                break;
            case "1":
                points = [
                    [width - paramA, 0],
                    [width - paramA, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case "2":
                points = [
                    [0, 0],
                    [0, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height / 2 - paramA / 2],
                    [0, height / 2 - paramA / 2],
                    [0, height],
                    [width, height],
                    [width, height - paramA],
                    [paramA, height - paramA],
                    [paramA, height / 2 + paramA / 2],
                    [width, height / 2 + paramA / 2],
                    [width, 0]
                ];
                break;
            case "3":
                points = [
                    [0, 0],
                    [0, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height / 2 - paramA / 2],
                    [0, height / 2 - paramA / 2],
                    [0, height / 2 + paramA / 2],
                    [width - paramA, height / 2 + paramA / 2],
                    [width - paramA, height - paramA],
                    [0, height - paramA],
                    [0, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case "4":
                points = [
                    [0, 0],
                    [0, height / 2 + paramA / 2],
                    [width - paramA, height / 2 + paramA / 2],
                    [width - paramA, height],
                    [width, height],
                    [width, 0],
                    [width - paramA, 0],
                    [width - paramA, height / 2 - paramA / 2],
                    [paramA, height / 2 - paramA / 2],
                    [paramA, 0]
                ];
                break;
            case "5":
                points = [
                    [0, 0],
                    [0, height / 2 + paramA / 2],
                    [width - paramA, height / 2 + paramA / 2],
                    [width - paramA, height - paramA],
                    [0, height - paramA],
                    [0, height],
                    [width, height],
                    [width, height / 2 - paramA / 2],
                    [paramA, height / 2 - paramA / 2],
                    [paramA, paramA],
                    [width, paramA],
                    [width, 0]
                ];
                break;
            case "6":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, height / 2 - paramA / 2],
                    [paramA, height / 2 - paramA / 2],
                    [paramA, height / 2 + paramA / 2],
                    [width - paramA, height / 2 + paramA / 2],
                    [width - paramA, height - paramA],
                    [paramA, height - paramA],
                    [paramA, paramA],
                    [width, paramA],
                    [width, 0]
                ];
                break;
            case "7":
                points = [
                    [0, 0],
                    [0, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case "8":
                points = [
                    [0, height / 2 + paramA / 2],
                    [0, height],
                    [width, height],
                    [width, 0],
                    [0, 0],
                    [0, height / 2 + paramA / 2],
                    [width - paramA, height / 2 + paramA / 2],
                    [width - paramA, height / 2 - paramA / 2],
                    [paramA, height / 2 - paramA / 2],
                    [paramA, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height - paramA],
                    [paramA, height - paramA],
                    [paramA, height / 2 + paramA / 2]
                ];
                break;
            case "9":
                points = [
                    [0, height],
                    [width, height],
                    [width, 0],
                    [0, 0],
                    [0, height / 2 + paramA / 2],
                    [width - paramA, height / 2 + paramA / 2],
                    [width - paramA, height / 2 - paramA / 2],
                    [paramA, height / 2 - paramA / 2],
                    [paramA, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height - paramA],
                    [0, height - paramA]
                ];
                break;
            default:
                points = [];
        }

        return points;
    }

    function getAngledLetterPoints(letter, width, height, k, alpha) {
        var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha;
        var scaleCoef = 1 / Math.cos(alphaInRadian); // TODO cached
        var slideCoef = Math.tan(alphaInRadian);
        var points = getLetterPoints(letter, width, height / scaleCoef, k);

        for (var j = 0; j < points.size(); ++j) {
            points[j][1] = (points[j][1] - points[j][0] * slideCoef) * scaleCoef;
        }

        return points;
    }
}