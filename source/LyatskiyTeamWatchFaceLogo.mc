import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

const ONE_DEGREE_IN_RADIAN = Math.PI / 180;

module LyatskiyTeamWatchFaceLogo {

    typedef Point as [ Numeric, Numeric ];
    typedef Points as Array<Point>;

    class Logo {
        private var _points as Points;

        private var _paramA as Numeric;
        private var _paramAlpha as Numeric;

        private var _clockAreaCharWidth as Numeric;
        private var _clockAreaCharHeight as Numeric;

        function initialize(params as Dictionary<Symbol, Numeric>) {
            var k1 = params[:k1] as Numeric;
            var k2 = params[:k2] as Numeric;
            var k3 = params[:k3] as Numeric;
            var k4 = params[:k4] as Numeric;
            var k5 = params[:k5] as Numeric;
            var alpha = params[:alpha] as Numeric;
            var a = params[:a] as Numeric?;

            if (a == null) {
                a = 1.0;
            }

            _paramA = a;
            _paramAlpha = alpha;

            var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha;
            var tanAlpha = Math.tan(alphaInRadian);
            var ctanAlpha = 1 / tanAlpha;
            var sinAlpha = Math.sin(alphaInRadian);
            var cosecAlpha = 1 / sinAlpha;

            var b = a * k1;
            var c = a * k2;
            var d = a * ctanAlpha;
            var e =  a * cosecAlpha;
            var f = (a + b) * ctanAlpha;
            var g = a * k3;
            var k = g * cosecAlpha;
            var h = c + f;
            var i = (c - e) / 2 - k;
            var j = b / 2 - g;
            var l = b * ctanAlpha;
            var m = a + b;
            var w = 2 * m;
            var s = a * k4;
            var n = a * k5;
            var p = s * cosecAlpha;
            var r = (0.5 * (1 + k1) * (1 + k1)) * a / (k2 + ctanAlpha + ctanAlpha * k1) +
                0.5 * a * (k2 + ctanAlpha + ctanAlpha * k1);
            var t = (Math.sqrt(r * r - (n + p + c - r) * (n + p + c - r) + r * r * ctanAlpha * ctanAlpha) - ctanAlpha * (n + p + c - r)) / 
                (1 + ctanAlpha * ctanAlpha);
            var v = (f - n - p) * tanAlpha;

            _clockAreaCharWidth = j;
            _clockAreaCharHeight = i;

            _points = [
                [0, 0],                                                                         // P1
                [0, c],                                                                         // P2
                [m, h],                                                                         // P3
                [m, h - e],                                                                     // P4
                [a, h - e - l],                                                                 // P5
                [a, d],                                                                         // P6

                [a, d + 2 * l],                                                                 // P7
                [a, d + 2 * l + e],                                                             // P8
                [m, f + e],                                                                     // P9
                [m, h],                                                                         // P10
                [m + a, h - d],                                                                 // P11
                [m + a, e + l],                                                                 // P12
                [w, e],                                                                         // P13
                [w, 0],                                                                         // P14

                [m, h - r],                                                                     // P15
                [m, h / 2],                                                                     // P16
                
                [                                                                               // P17
                    m + a + g, 
                    e + k + (2 * j + g) * ctanAlpha
                ],
                [                                                                               // P18
                    m + a + 2 * g + j, 
                    e + k + j * ctanAlpha
                ],
                [                                                                               // P19
                    m + a + g, 
                    e + 2 * k + i + (2 * j + g) * ctanAlpha
                ],
                [                                                                               // P20
                    m + a + 2 * g + j, 
                    e + 2 * k + i + j * ctanAlpha
                ],

                [                                                                               // P21
                    a + s,
                    d + 2 * l - p - n - s * ctanAlpha
                ],
                [                                                                               // P22
                    m + t,
                    f - p - n - t * ctanAlpha
                ],
                [                                                                               // P23
                    m + t, 
                    f - p - t * ctanAlpha
                ],
                [                                                                               // P24
                    a + s, 
                    d + 2 * l - p - s * ctanAlpha
                ],
                [                                                                               // P25
                    m + v, 
                    0
                ],
                [                                                                               // P26
                    m + v, 
                    n
                ]
            ];
        }

        function getParamA() as Numeric {
            return _paramA;
        }

        function setParamA(value as Numeric) as Void {
            var scale = value / _paramA;

            _paramA = value;

            _clockAreaCharWidth *= scale;
            _clockAreaCharHeight *= scale;

            scalePoints(_points, scale, scale);
        }

        function getParamAlpha() as Numeric {
            return _paramAlpha;
        }

        function setOffset(x as Numeric, y as Numeric) as Void {
            shiftPoints(_points, x, y);
        }

        function getWidth() as Numeric {
            return _points[13][0] - _points[0][0];
        }

        function getHeight() as Numeric {
            return _points[2][1] - _points[0][1];
        }

        function getPoint(num as Number) as Point {
            return [
                _points[num - 1][0],
                _points[num - 1][1]
            ];
        }

        function getCircleCenterPoint() as Point {
            return getPoint(15);
        }

        function getRadius() as Numeric {
            return _points[2][1] - _points[14][1];
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

        function getDigitPointsInClockArea(digit as Number, position as Number, thickness as Numeric) as Points {
            var points = getAngledCharPoints(
                digit.toString(), 
                _clockAreaCharWidth,
                _clockAreaCharHeight,
                _clockAreaCharWidth / thickness, // TODO
                _paramAlpha);
            var reperPoint = _points[15 + position];

            shiftPoints(
                points,
                reperPoint[0],
                reperPoint[1]);
            
            return points;
        }
    }

    function createLogoOnScreen(logoParams as Dictionary<Symbol, Numeric>, screenParams as Dictionary<Symbol, Numeric>) as Logo {
        var logo = new Logo(logoParams);
        var currentParamA = logo.getParamA();

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
            var logoRadiusByParamA = logo.getRadius() / currentParamA;

            logoParamA = screenWidth / (2 * logoRadiusByParamA);
            offsetX = deviceScreenWidth / 2 - logoCenterPointByParamA[0] / currentParamA * logoParamA;
            offsetY = deviceScreenWidth / 2 - logoCenterPointByParamA[1] / currentParamA * logoParamA;
        } else {
            var logoHeight;
            var logoWidth;
            var logoWidthByParamA = logo.getWidth() / currentParamA;
            var logoHeightByParamA = logo.getHeight() / currentParamA;
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

    function shiftPointsByPoint(points as Points, point as Point) as Void {
        shiftPoints(points, point[0], point[1]);
    }

    function shiftPoints(points as Points, sx as Numeric, sy as Numeric) as Void {
        for (var i = 0; i < points.size(); ++i) {
            points[i][0] += sx;
            points[i][1] += sy;
        }
    }

    function scalePoints(points as Points, sx as Numeric, sy as Numeric) as Void {
        for (var i = 0; i < points.size(); ++i) {
            points[i][0] *= sx;
            points[i][1] *= sy;
        }
    }

    function getCharPoints(char as String, width as Numeric, height as Numeric, thickness as Numeric) as Points {
        var points;
        var a = thickness;

        switch (char) {
            case "0":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, 0],
                    [a, 0],
                    [a, a],
                    [width - a, a],
                    [width - a, height - a],
                    [a, height - a],
                    [a, 0]
                ];
                break;
            // case '1':
            //     points = [
            //         [width - a, 0],
            //         [width - a, height],
            //         [width, height],
            //         [width, 0]
            //     ];
            //     break;
            case "1":
                points = [
                    [width / 2 - a, 0],
                    [width / 2 - a, a],
                    [width / 2 - a / 2, a],
                    [width / 2 - a / 2, height - a],
                    [0, height - a],
                    [0, height],
                    [width, height],
                    [width, height - a],
                    [width / 2 + a / 2, height - a],
                    [width / 2 + a / 2, 0]
                ];
                break;
            // case '1':
            //     points = [
            //         [0, 0],
            //         [0, a],
            //         [width / 2 - a / 2, a],
            //         [width / 2 - a / 2, height],
            //         [width / 2 + a / 2, height],
            //         [width / 2 + a / 2, 0]
            //     ];
            //     break;
            case "2":
                points = [
                    [0, 0],
                    [0, a],
                    [width - a, a],
                    [width - a, height / 2 - a / 2],
                    [0, height / 2 - a / 2],
                    [0, height],
                    [width, height],
                    [width, height - a],
                    [a, height - a],
                    [a, height / 2 + a / 2],
                    [width, height / 2 + a / 2],
                    [width, 0]
                ];
                break;
            case "3":
                points = [
                    [0, 0],
                    [0, a],
                    [width - a, a],
                    [width - a, height / 2 - a / 2],
                    [0, height / 2 - a / 2],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height - a],
                    [0, height - a],
                    [0, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case "4":
                points = [
                    [0, 0],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height],
                    [width, height],
                    [width, 0],
                    [width - a, 0],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, 0]
                ];
                break;
            case "5":
                points = [
                    [0, 0],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height - a],
                    [0, height - a],
                    [0, height],
                    [width, height],
                    [width, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, a],
                    [width, a],
                    [width, 0]
                ];
                break;
            case "6":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height - a],
                    [a, height - a],
                    [a, a],
                    [width, a],
                    [width, 0]
                ];
                break;
            case "7":
                points = [
                    [0, 0],
                    [0, a],
                    [width - a, a],
                    [width - a, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case "8":
                points = [
                    [0, height / 2 + a / 2],
                    [0, height],
                    [width, height],
                    [width, 0],
                    [0, 0],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, a],
                    [width - a, a],
                    [width - a, height - a],
                    [a, height - a],
                    [a, height / 2 + a / 2]
                ];
                break;
            case "9":
                points = [
                    [0, height],
                    [width, height],
                    [width, 0],
                    [0, 0],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, a],
                    [width - a, a],
                    [width - a, height - a],
                    [0, height - a]
                ];
                break;
            case "п":
                points = [
                    [0, 0],
                    [0, height],
                    [a, height],
                    [a, a],
                    [width - a, a],
                    [width - a, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            case "н":
                points = [
                    [0, 0],
                    [0, height],
                    [a, height],
                    [a, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height],
                    [width, height],
                    [width, 0],
                    [width - a, 0],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, 0]
                ];
                break;
            case "т":
                points = [
                    [0, 0],
                    [0, a],
                    [width / 2 - a / 2, a],
                    [width / 2 - a / 2, height],
                    [width / 2 + a / 2, height],
                    [width / 2 + a / 2, a],
                    [width, a],
                    [width, 0]
                ];
                break;
            case "с":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, height - a],
                    [a, height - a],
                    [a, a],
                    [width, a],
                    [width, 0]
                ];
                break;
            case "р":
                points = [
                    [0, a],
                    [0, height],
                    [a, height],
                    [a, height / 2 + a / 2],
                    [width, height / 2 + a / 2],
                    [width, 0],
                    [0, 0],
                    [0, a],
                    [width - a, a],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, a]
                ];
                break;
            case "ч":
                points = [
                    [0, 0],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height],
                    [width, height],
                    [width, 0],
                    [width - a, 0],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, 0]
                ];
                break;
            case "в":
                points = [
                    [0, height / 2 + a / 2],
                    [0, height],
                    [width - a, height],
                    [width, height - a],
                    [width, height / 2 + a / 2],
                    [width - a, height / 2],
                    [width, height / 2 - a / 2],
                    [width, a],
                    [width - a, 0],
                    [0, 0],
                    [0, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, a],
                    [width - a, a],
                    [width - a, height - a],
                    [a, height - a],
                    [a, height / 2 + a / 2]
                ];
                break;
            case "б":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, height / 2 - a / 2],
                    [a, height / 2 - a / 2],
                    [a, height / 2 + a / 2],
                    [width - a, height / 2 + a / 2],
                    [width - a, height - a],
                    [a, height - a],
                    [a, a],
                    [width, a],
                    [width, 0]
                ];
                break;
            case "#":
                points = [
                    [a, 0],
                    [width, 0],
                    [width, 0.25 * height],
                    [width + a, 0.25 * height],
                    [width + a, 0.75 * height],
                    [width, 0.75 * height],
                    [width, height],
                    [0, height],
                    [0, 0],
                    [a, 0],
                    [a, height - a],
                    [width - a, height - a],
                    [width - a, a],
                    [a, a],
                    [a, 0]
                ];
                break;
            case "*":
                points = [
                    [0, 0],
                    [0, height],
                    [width, height],
                    [width, 0]
                ];
                break;
            default:
                points = [];
        }

        return points;
    }

    function getAngledCharPoints(char as String, width as Numeric, height as Numeric, thickness as Numeric, alpha as Numeric) as Points {
        var alphaInRadian = ONE_DEGREE_IN_RADIAN * alpha; 
        var scaleCoef = 1 / Math.sin(alphaInRadian); // TODO cached
        var slideCoef = 1 / Math.tan(alphaInRadian);
        var points = getCharPoints(char, width, height / scaleCoef, thickness);

        for (var i = 0; i < points.size(); ++i) {
            points[i][1] = (points[i][1] - points[i][0] * slideCoef) * scaleCoef;
        }

        return points;
    }
}