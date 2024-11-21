import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

module LyatskiyTeamWatchFaceLogo {

    const ONE_DEGREE_IN_RADIAN = Math.PI / 180;

    typedef Point as [ Numeric, Numeric ];
    typedef Points as Array<Point>;
    typedef PointsSet as Array<Points>;

    class Logo {
        private var _points as Points;
        private var _paramA as Numeric;

        function initialize(params as Dictionary<Symbol, Numeric>) {
            var k1 = params[:k1] as Numeric;
            var k2 = params[:k2] as Numeric;
            var k3 = params[:k3] as Numeric;
            var k4 = params[:k4] as Numeric;
            var angle = params[:angle] as Numeric;
            var a = params[:a] as Numeric?;

            if (a == null) {
                a = 1.0;
            }

            _paramA = a;

            var angleInRadian = ONE_DEGREE_IN_RADIAN * angle;
            var ctanAngle = 1 / Math.tan(angleInRadian);

            var b = a * k1;
            var c = a * k2;
            var d = a * ctanAngle;
            var e =  a / Math.sin(angleInRadian);
            var f = (a + b) * ctanAngle;

            // TODO rename
            var l = b * ctanAngle;
            var g = a * k3;
            var s = a * k4;

            var h = c + f;
            var m = a + b;
            var w = 2 * m;

            var r = (0.5 * (1 + k1) * (1 + k1)) * a / (k2 + ctanAngle + ctanAngle * k1) +
                0.5 * a * (k2 + ctanAngle + ctanAngle * k1);
            
            // TODO rename
            var t = (Math.sqrt(r * r - (g + c - r) * (g + c - r) + r * r * ctanAngle * ctanAngle) - ctanAngle * (g + c - r)) / 
                (1 + ctanAngle * ctanAngle);
            var t1 = (Math.sqrt(r * r - (g + s + c - r) * (g + s + c - r) + r * r * ctanAngle * ctanAngle) - ctanAngle * (g + s + c - r)) / 
                (1 + ctanAngle * ctanAngle);

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
                    a,
                    d + 2 * l - g
                ],
                [                                                                               // P18
                    m + t, 
                    (m - t) * ctanAngle - g
                ],
                [                                                                               // P19
                    m + t, 
                    (m - t) * ctanAngle
                ],

                [                                                                               // P20
                    a,
                    d + 2 * l - g - s
                ],
                [                                                                               // P21
                    m + t1, 
                    (m - t1) * ctanAngle - g - s
                ],
                [                                                                               // P22
                    m + t1, 
                    (m - t1) * ctanAngle
                ],

                [                                                                               // P23
                    m, 
                    d + 2 * l + e
                ],
                [                                                                               // P24
                    m, 
                    h - e - l
                ],
            ];
        }

        function getParamA() as Numeric {
            return _paramA;
        }

        function setParamA(value as Numeric) as Void {
            var scale = value / _paramA;

            _paramA = value;

            scalePoints(_points, scale, scale);
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
    }

    class AngledBox {
        private var _leftTopPoint as Point;
        private var _rightBottomPoint as Point;
        private var _leftBottomPoint as Point;
        private var _rightTopPoint as Point;

        private var _angle as Numeric?;

        private var _width as Numeric;
        private var _height as Numeric;
        
        private var _ctanAngle as Numeric;
        private var _sinAngle as Numeric;

        // new AngledBox({ :leftTopPoint, :rightBottomPoint, :angle })
        // new AngledBox({ :leftBottomPoint, :rightTopPoint, :angle })

        // new AngledBox({ :leftTopPoint, :rightBottomPoint, :ctanAngle, :sinAngle })
        // new AngledBox({ :leftBottomPoint, :rightTopPoint, :ctanAngle, :sinAngle })

        // new AngledBox({ :leftTopPoint, :rightBottomPoint, :rightTopPoint })
        // new AngledBox({ :leftTopPoint, :rightBottomPoint, :leftBottomPoint })

        // new AngledBox({ :leftBottomPoint, :rightTopPoint, :leftTopPoint })
        // new AngledBox({ :leftBottomPoint, :rightTopPoint, :rightBottomPoint })
        function initialize(
            params as {
                :leftTopPoint as Point?,
                :rightBottomPoint as Point?,
                :leftBottomPoint as Point?,
                :rightTopPoint as Point?,

                :angle as Numeric?,
                :ctanAngle as Numeric?,
                :sinAngle as Numeric?
            }
        ) {
            var leftTopPoint = params[:leftTopPoint];
            var rightTopPoint = params[:rightTopPoint];
            var rightBottomPoint = params[:rightBottomPoint];
            var leftBottomPoint = params[:leftBottomPoint];

            if (leftTopPoint != null && rightBottomPoint != null) {
                if (leftBottomPoint != null) {
                    rightTopPoint = [
                        rightBottomPoint[0],
                        rightBottomPoint[1] - leftBottomPoint[1] + leftTopPoint[1]
                    ];
                } else if (rightTopPoint != null) {
                    leftBottomPoint = [
                        leftTopPoint[0],
                        leftTopPoint[1] + rightBottomPoint[1] - rightTopPoint[1]
                    ];
                }
            } else if (leftBottomPoint != null && rightTopPoint != null) {
                if (leftTopPoint != null) {
                    rightBottomPoint = [
                        rightTopPoint[0],
                        rightTopPoint[1] + leftBottomPoint[1] - leftTopPoint[1]
                    ];
                } else if (rightBottomPoint != null) {
                    leftTopPoint = [
                        leftBottomPoint[0],
                        leftBottomPoint[1] - rightBottomPoint[1] + rightTopPoint[1]
                    ];
                }
            } else {
                // TODO throw en exception
                leftTopPoint = [0, 0];
                rightBottomPoint = [0, 0];
            }

            if (params[:angle] != null) {
                _angle = params[:angle] as Numeric;

                if (params[:ctanAngle] != null) {
                    _ctanAngle = params[:ctanAngle] as Numeric;
                } else {
                    _ctanAngle = 1 / Math.tan(ONE_DEGREE_IN_RADIAN * _angle as Numeric);
                }

                if (params[:sinAngle] != null) {
                    _sinAngle = params[:sinAngle] as Numeric;
                } else {
                    _sinAngle = Math.sin(ONE_DEGREE_IN_RADIAN * _angle as Numeric);
                }
            } else if (params[:ctanAngle] != null) {
                _ctanAngle = params[:ctanAngle] as Numeric;
                _sinAngle = params[:sinAngle] as Numeric;
            } else if (leftTopPoint != null && rightTopPoint != null) {
                var deltaX = rightTopPoint[0] - leftTopPoint[0];
                var deltaY = rightTopPoint[1] - leftTopPoint[1];

                _ctanAngle = deltaY / deltaX;
                _sinAngle = deltaX / Math.sqrt(deltaX * deltaX + deltaY * deltaY);
            } else {
                _angle = 90;
                _ctanAngle = 0;
                _sinAngle = 1;
            }

            if (leftTopPoint == null) {
                var lbPoint = leftBottomPoint as Point;
                var rtPoint = rightTopPoint as Point;

                leftTopPoint = [
                    lbPoint[0],
                    rtPoint[1] - (rtPoint[0] - lbPoint[0]) * _ctanAngle
                ];
                rightBottomPoint = [
                    rtPoint[0],
                    rtPoint[1] + lbPoint[1] - leftTopPoint[0]
                ];
            } else if (rightTopPoint == null) {
                var ltPoint = leftTopPoint as Point;
                var rbPoint = rightBottomPoint as Point;

                rightTopPoint = [
                    rbPoint[0],
                    ltPoint[1] + (rbPoint[0] - ltPoint[0]) * _ctanAngle
                ];
                leftBottomPoint = [
                    ltPoint[0],
                    ltPoint[1] + rbPoint[1] - rightTopPoint[1]
                ];
            }


            _leftTopPoint = copyPoint(leftTopPoint as Point);
            _rightTopPoint = copyPoint(rightTopPoint as Point);
            _rightBottomPoint = copyPoint(rightBottomPoint as Point);
            _leftBottomPoint = copyPoint(leftBottomPoint as Point);

            _width = _rightBottomPoint[0] - _leftTopPoint[0];
            _height = _rightBottomPoint[1] - _rightTopPoint[1];
        }

        function getWidth() as Numeric {
            return _width;
        }

        function getHeight() as Numeric {
            return _height;
        }

        function getPoints() as Points {
            return [ 
                copyPoint(_leftTopPoint), copyPoint(_rightTopPoint), 
                copyPoint(_rightBottomPoint), copyPoint(_leftBottomPoint) 
            ];
        }

        // TODO
        function getCharInBoxPoints(char as String or Symbol, charsLineThickness as Numeric) as Array<Points> {
            var charPoints = getAngledCharPoints(
                char, 
                _width,
                _height,
                charsLineThickness,
                null,
                -_ctanAngle,
                _sinAngle);

            for (var i = 0; i < charPoints.size(); ++i) {
                shiftPointsByPoint(charPoints[i], _leftTopPoint);
            }

            return charPoints;
        }

        function addPaddingLeft(padding as Numeric) as AngledBox {
            var deltaY = padding * _ctanAngle;

            _leftTopPoint[0] += padding;
            _leftTopPoint[1] += deltaY;

            _leftBottomPoint[0] += padding;
            _leftBottomPoint[1] += deltaY;

            _width -= padding;

            return self;
        }

        function addPaddingRight(padding as Numeric) as AngledBox {
            var deltaY = padding * _ctanAngle;

            _rightTopPoint[0] -= padding;
            _rightTopPoint[1] -= deltaY;

            _rightBottomPoint[0] -= padding;
            _rightBottomPoint[1] -= deltaY;

            _width -= padding;
        
            return self;
        }

        function addPaddingBottom(padding as Numeric) as AngledBox {
            var deltaY = padding / _sinAngle;
            
            _leftBottomPoint[1] -= deltaY;
            _rightBottomPoint[1] -= deltaY;

            _height -= deltaY;
        
            return self;
        }

        function addPaddingTop(padding as Numeric) as AngledBox {
            var deltaY = padding / _sinAngle;

            _leftTopPoint[1] += deltaY;
            _rightTopPoint[1] += deltaY;

            _height -= deltaY;
        
            return self;
        }

        function addPadding(padding as Numeric) as AngledBox {
            addPaddingTop(padding);
            addPaddingRight(padding);
            addPaddingBottom(padding);
            addPaddingLeft(padding);
        
            return self;
        }

        function splitVertical(k as Numeric) as [ AngledBox, AngledBox ] {
            var deltaX = _width *  k;
            var deltaY = deltaX * _ctanAngle;

            var point1 = [
                _leftBottomPoint[0] + deltaX,
                _leftBottomPoint[1] + deltaY
            ];
            var point2 = [
                _leftTopPoint[0] + deltaX,
                _leftTopPoint[1] + deltaY
            ];

            return [
                new AngledBox({
                    :leftTopPoint => _leftTopPoint,
                    :rightBottomPoint => point1,
                    :rightTopPoint => point2,
                    :leftBottomPoint => _leftBottomPoint,
                    :ctanAngle => _ctanAngle,
                    :sinAngle => _sinAngle
                }),
                new AngledBox({
                    :leftTopPoint => point2,
                    :rightBottomPoint => _rightBottomPoint,
                    :rightTopPoint => _rightTopPoint,
                    :leftBottomPoint => point1,
                    :ctanAngle => _ctanAngle,
                    :sinAngle => _sinAngle
                })
            ];
        }

        function splitHorizontal(k as Numeric) as [ AngledBox, AngledBox ] {
            var deltaY = _height *  k;

            var point1 = [
                _leftTopPoint[0],
                _leftTopPoint[1] + deltaY
            ];
            var point2 = [
                _rightTopPoint[0],
                _rightTopPoint[1] + deltaY
            ];

            return [
                new AngledBox({
                    :leftTopPoint => _leftTopPoint,
                    :rightBottomPoint => point2,
                    :rightTopPoint => _rightTopPoint,
                    :leftBottomPoint => point1,
                    :ctanAngle => _ctanAngle,
                    :sinAngle => _sinAngle
                }),
                new AngledBox({
                    :leftTopPoint => point1,
                    :rightBottomPoint => _rightBottomPoint,
                    :rightTopPoint => point2,
                    :leftBottomPoint => _leftBottomPoint,
                    :ctanAngle => _ctanAngle,
                    :sinAngle => _sinAngle
                })
            ];
        }
    }

    function calculeteLogoParamsInCircle(
        logoParams as { :angle as Numeric, :k1 as Numeric } or  // TODO get rid of Null
            { :angle as Numeric, :k2 as Numeric } or
            { :k1 as Numeric, :k2 as Numeric }
    ) as { :angle as Numeric, :k1 as Numeric, :k2 as Numeric } {
        var angle;
        var k1;
        var k2;
        
        if (logoParams[:k2] == null) {
            angle = logoParams[:angle] as Numeric;
            k1 = logoParams[:k1] as Numeric;

            k2 = (1 + k1) * (-2) / Math.tan(2 * ONE_DEGREE_IN_RADIAN * angle);
        } else if (logoParams[:k1] == null) {
            angle = logoParams[:angle] as Numeric;
            k2 = logoParams[:k2] as Numeric;
            
            k1 = k2 / ((-2) / Math.tan(2 * ONE_DEGREE_IN_RADIAN * angle)) - 1;
        } else {
            k1 = logoParams[:k1] as Numeric;
            k2 = logoParams[:k2] as Numeric;

            angle = (Math.atan((-2) * (1.0 + k1) / k2) + Math.PI) / 2 / ONE_DEGREE_IN_RADIAN;
        }

        logoParams[:k1] = k1 as Numeric;
        logoParams[:k2] = k2 as Numeric;
        logoParams[:angle] = angle as Numeric;

        return logoParams;
    }

    function createLogoOnScreen(
            logoParams as { :k1 as Numeric, :k2 as Numeric, :k3 as Numeric, :k4 as Numeric }, 
            screenParams as Dictionary<Symbol, Numeric>
    ) as Logo {
        var deviceScreenWidth = screenParams[:width] as Number;
        var deviceScreenHeight = screenParams[:height] as Number;
        var deviceScreenShape = screenParams[:shape] as Number;
        var deviceScreenPadding = screenParams[:padding] as Float;

        var logo;
        
        var screenWidth = deviceScreenWidth * (1 - deviceScreenPadding);
        var screenHeight = deviceScreenHeight * (1 - deviceScreenPadding);

        if (deviceScreenShape == System.SCREEN_SHAPE_ROUND) { // API Level 1.2.0
            logo = new Logo(calculeteLogoParamsInCircle(logoParams)); 
            
            var currentParamA = logo.getParamA();
            var logoCenterPointByParamA = logo.getCircleCenterPoint();
            var logoRadiusByParamA = logo.getRadius() / currentParamA;

            var logoParamA = screenWidth / (2 * logoRadiusByParamA);
            var offsetX = deviceScreenWidth / 2 - logoCenterPointByParamA[0] / currentParamA * logoParamA;
            var offsetY = deviceScreenWidth / 2 - logoCenterPointByParamA[1] / currentParamA * logoParamA;

            logo.setParamA(logoParamA);
            logo.setOffset(offsetX, offsetY);
        } else {
            // TODO 
            logoParams[:angle] = 60;

            logo = new Logo(logoParams); 
            
            var currentParamA = logo.getParamA();
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

            var logoParamA = logoWidth / logoWidthByParamA;
            var offsetX = (deviceScreenWidth - logoWidth) / 2;
            var offsetY = (deviceScreenHeight - logoHeight) / 2;

            logo.setParamA(logoParamA);
            logo.setOffset(offsetX, offsetY);
        }

        return logo;
    }

    function copyPoint(point as Point) as Point {
        return [
            point[0],
            point[1]
        ];
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

    function getCharPoints(char as String or Symbol, width as Numeric, height as Numeric, thickness as Numeric) as PointsSet {
        var points = null;
        var pointsSet = null;
        var a = width * thickness;

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
            case "1":
                points = [
                    [width / 4 - a / 4, 0],
                    [width / 4 - a / 4, a],
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
            case :п:
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
            case :н:
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
            case :т:
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
            case :с:
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
            case :р:
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
            case :ч:
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
            case :в:
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
            case :б:
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
            case :batteryIndicator:
                a = height * 0.1;
                
                var offset = 2 * a;
                var indicatorWidth = (width - 2 * offset) * thickness;
                
                pointsSet = [
                    [
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
                    ],
                    [
                        [offset, offset ],
                        [offset, height - offset],
                        [offset + indicatorWidth, height - offset],
                        [offset + indicatorWidth, offset]
                    ]
                ];
                break;
            default:
                pointsSet = [];
        }

        if (pointsSet == null) {
            pointsSet = points != null ? [points] : [];
        }

        return pointsSet as PointsSet;
    }

    function getAngledCharPoints(
        char as String or Symbol, 
        width as Numeric, 
        height as Numeric, 
        thickness as Numeric, 
        angle as Numeric?,
        ctanAngle as Numeric?,
        sinAngle as Numeric?
    ) as PointsSet {
        if (angle == null) {
            if (sinAngle == null || ctanAngle == null) {
                ctanAngle = 0;
                sinAngle = 0;
            }
        } else {
            var angleInRadian = ONE_DEGREE_IN_RADIAN * angle;
            
            ctanAngle = 1 / Math.tan(angleInRadian);
            sinAngle = Math.sin(angleInRadian);
        }

        var scaleCoef = 1 / sinAngle;
        var slideCoef = ctanAngle;
        var pointsSet = getCharPoints(char, width, height / scaleCoef, thickness);

        for (var i = 0; i < pointsSet.size(); ++i) {
            var points = pointsSet[i];

            for (var j = 0; j < points.size(); ++j) {
                points[j][1] = points[j][1] * scaleCoef - points[j][0] * slideCoef;
            }
        }

        return pointsSet;
    }
}