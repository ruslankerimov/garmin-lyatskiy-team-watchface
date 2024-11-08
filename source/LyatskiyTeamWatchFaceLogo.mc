import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

const ONE_DEGREE_IN_RADIAN = Math.PI / 180;

module LyatskiyTeamWatchFaceLogo {

    typedef Point as [ Numeric, Numeric ];
    typedef Points as Array<Point>;

    class Logo {
        private var _points as Points;

        private var _paramA as Numeric = 1.0;
        private var _offsetX as Numeric = 0.0;
        private var _offsetY as Numeric = 0.0;

        private var _paramAlpha as Numeric;

        private var _dateAreaCharHeight as Numeric;
        private var _dateAreaCharWidth as Numeric;
        private var _clockAreaCharWidth as Numeric;
        private var _clockAreaCharHeight as Numeric;

        function initialize(params as Dictionary<Symbol, Numeric>) {
            var k1 = params[:k1] as Numeric;
            var k2 = params[:k2] as Numeric;
            var k3 = params[:k3] as Numeric;
            var k4 = params[:k4] as Numeric;
            var k5 = params[:k5] as Numeric;
            var k6 = params[:k6] as Numeric;
            var alpha = params[:alpha] as Numeric;
            var a = params[:a] as Numeric?;

            if (a != null) {
                _paramA = a;
            }

            _paramAlpha = alpha;

            var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha;
            var tanAlpha = Math.tan(alphaInRadian);
            var ctanAlpha = 1 / tanAlpha;
            var sinAlpha = Math.sin(alphaInRadian);
            
            var radiusByParamA = (0.5 * (1 + k1) * (1 + k1)) / (k2 + ctanAlpha + ctanAlpha * k1) +
                0.5 * (k2 + ctanAlpha + ctanAlpha * k1);

            var dataAreaHeight = k5 * 2 * k1 * ctanAlpha;
            // var dataAreaWidth = ((2 * k1 + 1) * ctanAlpha - k4 - dataAreaHeight) * tanAlpha - k4;

            _dateAreaCharHeight = dataAreaHeight;
            // _dateAreaCharWidth = (dataAreaWidth - 4 * k4) / 5;
            _dateAreaCharWidth = 0.5 * _dateAreaCharHeight;

            _clockAreaCharWidth = k1 / 2 - k3;
            _clockAreaCharHeight = k2 / 2 - k3 - 1 / (2 * sinAlpha);

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
                    (1 + 2 * k1 - k4) * ctanAlpha - _dateAreaCharHeight - k4
                ],
                [                                                                                // P22
                    1 + k4 + k6 + _dateAreaCharWidth,
                    (1 + 2 * k1 - k4) * ctanAlpha - _dateAreaCharHeight - k4 - (_dateAreaCharWidth + k6) * ctanAlpha
                ],
                [                                                                               // P23
                    1 + k4 + 2 * (k6 + _dateAreaCharWidth), 
                    (1 + 2 * k1 - k4) * ctanAlpha - _dateAreaCharHeight - k4 - (_dateAreaCharWidth + k6) * 2 * ctanAlpha
                ],
                [                                                                               // P24
                    1 + k4 + 3 * (k6 + _dateAreaCharWidth), 
                    (1 + 2 * k1 - k4) * ctanAlpha - _dateAreaCharHeight - k4 - (_dateAreaCharWidth + k6) * 3 * ctanAlpha
                ],
                [                                                                               // P25
                    1 + k4 + 4 * (k6 + _dateAreaCharWidth), 
                    (1 + 2 * k1 - k4) * ctanAlpha - _dateAreaCharHeight - k4 - (_dateAreaCharWidth + k6) * 4 * ctanAlpha
                ]
            ];
        }

        function setParamA(value as Numeric) as Void {
            _paramA = value;
        }

        function setOffset(x as Numeric, y as Numeric) as Void {
            _offsetX = x;
            _offsetY = y;
        }

        function getWidth() as Numeric {
            return (_points[13][0] - _points[0][0]) * _paramA;
        }

        function getHeight() as Numeric {
            return (_points[2][1] - _points[0][1]) * _paramA;
        }

        function getPoint(num as Number) as Point {
            return [
                _points[num - 1][0] * _paramA + _offsetX,
                _points[num - 1][1] * _paramA + _offsetY
            ];
        }

        function getCircleCenterPoint() as Point {
            return getPoint(15);
        }

        function getRadius() as Numeric {
            return (_points[2][1] - _points[14][1]) * _paramA;
        }

        function getLetterLPoints() as Points {
            var points = [] as Points;

            for (var i = 1; i <= 6; ++i) {
                points.add(getPoint(i));
            }

            return points;
        }

        function getLetterTPoints() as Points {
            var points = [] as Points;

            for (var i = 7; i <= 14; ++i) {
                points.add(getPoint(i));
            }

            return points;
        }

        function getDigitPointsInClockArea(digit as Number, position as Number, charParamK as Numeric) as Points {
            var points = getAngledCharPoints(
                digit.toString().toCharArray()[0], 
                _clockAreaCharWidth * _paramA,
                _clockAreaCharHeight * _paramA,
                charParamK,
                90 - _paramAlpha);
            var reperPoint = getPoint(16 + position);

            shiftPoints(
                points,
                reperPoint[0],
                reperPoint[1]);
            
            return points;
        }

        function getCharPointsInDateArea(char as Char, position as Number, charParamK as Numeric) as Points {
            var points = getAngledCharPoints(
                char, 
                _dateAreaCharWidth * _paramA,
                _dateAreaCharHeight * _paramA,
                charParamK,
                90 - _paramAlpha);
            var reperPoint = getPoint(20 + position);

            shiftPoints(
                points,
                reperPoint[0],
                reperPoint[1]);

            return points;
        }
    }

    function createLogoOnScreen(logoParams as Dictionary<Symbol, Numeric>, screenParams as Dictionary<Symbol, Numeric>) as Logo {
        var logo = new Logo(logoParams);

        var deviceScreenWidth = screenParams[:width] as Number;
        var deviceScreenHeight = screenParams[:height] as Number;
        var deviceScreenShape = screenParams[:shape] as Number;
        var deviceScreenPadding = screenParams[:padding] as Float;

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

    function shiftPoints(points as Points, sx as Numeric, sy as Numeric) as Void {
        for (var i = 0; i < points.size(); ++i) {
            points[i][0] += sx;
            points[i][1] += sy;
        }
    }

    function getCharPoints(char as Char, width as Numeric, height as Numeric, k as Numeric) as Points {
        var points;
        var paramA = width / k;

        switch (char) {
            case '0':
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
            case '1':
                points = [
                    [width - paramA, 0],
                    [width - paramA, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case '2':
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
            case '3':
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
            case '4':
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
            case '5':
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
            case '6':
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
            case '7':
                points = [
                    [0, 0],
                    [0, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case '8':
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
            case '9':
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
            case 'п':
                points = [
                    [0, 0],
                    [0, height],
                    [paramA, height],
                    [paramA, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case 'н':
                points = [
                    [0, 0],
                    [0, height],
                    [paramA, height],
                    [paramA, height / 2 + paramA / 2],
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
            case 'т':
                points = [
                    [0, 0],
                    [0, paramA],
                    [width / 2 - paramA / 2, paramA],
                    [width / 2 - paramA / 2, height],
                    [width / 2 + paramA / 2, height],
                    [width / 2 + paramA / 2, paramA],
                    [width, paramA],
                    [width, 0]
                ];
                break;
            case 'с':
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, height - paramA],
                    [paramA, height - paramA],
                    [paramA, paramA],
                    [width, paramA],
                    [width, 0]
                ];
                break;
            case 'р':
                points = [
                    [0, paramA],
                    [0, height],
                    [paramA, height],
                    [paramA, height / 2 + paramA / 2],
                    [width, height / 2 + paramA / 2],
                    [width, 0],
                    [0, 0],
                    [0, paramA],
                    [width - paramA, paramA],
                    [width - paramA, height / 2 - paramA / 2],
                    [paramA, height / 2 - paramA / 2],
                    [paramA, paramA]
                ];
                break;
            case 'ч':
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
            case 'в':
                points = [
                    [0, height / 2 + paramA / 2],
                    [0, height],
                    [width - paramA, height],
                    [width, height - paramA],
                    [width, height / 2 + paramA / 2],
                    [width - paramA, height / 2],
                    [width, height / 2 - paramA / 2],
                    [width, paramA],
                    [width - paramA, 0],
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
            case 'б':
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
            default:
                points = [];
        }

        return points;
    }

    function getAngledCharPoints(char as Char, width as Numeric, height as Numeric, k as Numeric, alpha as Numeric) as Points {
        var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha;
        var scaleCoef = 1 / Math.cos(alphaInRadian); // TODO cached
        var slideCoef = Math.tan(alphaInRadian);
        var points = getCharPoints(char, width, height / scaleCoef, k);

        for (var i = 0; i < points.size(); ++i) {
            points[i][1] = (points[i][1] - points[i][0] * slideCoef) * scaleCoef;
        }

        return points;
    }
}