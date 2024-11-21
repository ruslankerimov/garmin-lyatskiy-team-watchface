import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

// TODO check supported list
// TODO go to module
const COLORS as Array<Graphics.ColorType> = [
    Graphics.COLOR_BLACK,
    Graphics.COLOR_WHITE,
    Graphics.COLOR_RED,
    0x730000,
    Graphics.COLOR_LT_GRAY, 
    Graphics.COLOR_DK_GRAY,
    Graphics.COLOR_BLUE,
    0x02084F,
    Graphics.COLOR_GREEN,
    0x004F15,
    0xAA00FF,
    Graphics.COLOR_PINK,
    Graphics.COLOR_ORANGE,
    Graphics.COLOR_YELLOW
];

class LyatskiyTeamWatchFaceView extends WatchUi.WatchFace {
    (:initialized) private var _screenWidth as Number;
    (:initialized) private var _screenHeight as Number; 
    (:initialized) private var _screenShape as Number;

    (:initialized) private var _logo as LyatskiyTeamWatchFaceLogo.Logo; // TODO get rid of LyatskiyTeamWatchFaceLogo namespace

    (:initialized) private var _backgroundColor as Graphics.ColorType;
    (:initialized) private var _primaryColor as Graphics.ColorType;
    (:initialized) private var _accentColor as Graphics.ColorType;
    (:initialized) private var _letterLColor as Graphics.ColorType;
    (:initialized) private var _letterTColor as Graphics.ColorType;
    (:initialized) private var _hoursColor  as Graphics.ColorType;
    (:initialized) private var _minutesColor  as Graphics.ColorType;
    (:initialized) private var _secondsColor  as Graphics.ColorType;

    (:initialized) private var _hoursBoxes as [ LyatskiyTeamWatchFaceLogo.AngledBox, LyatskiyTeamWatchFaceLogo.AngledBox ];
    (:initialized) private var _minutesBoxes as [ LyatskiyTeamWatchFaceLogo.AngledBox, LyatskiyTeamWatchFaceLogo.AngledBox ];
    (:initialized) private var _secondsBoxes as [ LyatskiyTeamWatchFaceLogo.AngledBox, LyatskiyTeamWatchFaceLogo.AngledBox ] or Null;

    (:initialized) private var _dateDayBoxes as [ LyatskiyTeamWatchFaceLogo.AngledBox, LyatskiyTeamWatchFaceLogo.AngledBox ];
    (:initialized) private var _dateDayOfWeekBoxes as [ LyatskiyTeamWatchFaceLogo.AngledBox, LyatskiyTeamWatchFaceLogo.AngledBox ];

    (:initialized) private var _batteryIndicatorBox as LyatskiyTeamWatchFaceLogo.AngledBox;

    function initialize() {
        WatchFace.initialize();
    }

    function handleSettingsChanged() as Void {
        _initialize();
    }

    function _getProp(key as  Application.PropertyKeyType) as Application.PropertyValueType {
        var getProp;

        // API Level 2.4.0
        if (Application has :Properties) {
            getProp = new Method(Application.Properties, :getValue);
        } else {
            getProp = new Method(Application.getApp(), :getProperty);
        }

        return getProp.invoke(key) as Application.PropertyValueType;
    }

    function _initialize() as Void {
        _logo = LyatskiyTeamWatchFaceLogo.createLogoOnScreen(
            {
                :k1 => _getProp("LogoParamK1") as Float,
                :k2 => _getProp("LogoParamK2") as Float,
                :k3 => _getProp("LogoParamK3") as Float,
                :k4 => _getProp("LogoParamK4") as Float
            },
            {
                :width => _screenWidth,
                :height => _screenHeight,
                :shape => _screenShape,
                :padding => _getProp("ScreenPadding") as Float
            });

        _initializeChars();
        _initializeColors();
        _initializeClockBoxes();
        _initializeDataBoxes();
        _initializeStatusBoxes();
    }

    function _initializeChars() as Void {

    }

    function _initializeColors() as Void {
        var backgroundColorInx = _getProp("BackgroundColor") as Number;
        var primaryColorInx = _getProp("PrimaryColor") as Number;
        var accentColorInx = _getProp("AccentColor") as Number;
        var letterLColorInx = _getProp("LetterLColor") as Number;
        var letterTColorInx = _getProp("LetterTColor") as Number;
        var hoursColorInx = _getProp("HoursColor") as Number;
        var minutesColorInx = _getProp("MinutesColor") as Number;
        var secondsColorInx = _getProp("SecondsColor") as Number;

        if (primaryColorInx == backgroundColorInx) {
            primaryColorInx = backgroundColorInx == 0 ? 1 : 0;
        }

        if (accentColorInx == -1 || accentColorInx == backgroundColorInx) {
            accentColorInx = primaryColorInx;
        }

        if (letterLColorInx == -1 || letterLColorInx == backgroundColorInx) {
            letterLColorInx = primaryColorInx;
        }

        if (letterTColorInx == -1 || letterTColorInx == backgroundColorInx) {
            letterTColorInx = primaryColorInx;
        }

        if (hoursColorInx == -1 || hoursColorInx == backgroundColorInx) {
            hoursColorInx = primaryColorInx;
        }

        if (minutesColorInx == -1 || minutesColorInx == backgroundColorInx) {
            minutesColorInx = primaryColorInx;
        }

        if (secondsColorInx == -1 || secondsColorInx == backgroundColorInx) {
            secondsColorInx = primaryColorInx;
        }

        _backgroundColor = COLORS[backgroundColorInx];
        _primaryColor = COLORS[primaryColorInx];
        _accentColor = COLORS[accentColorInx];
        _letterLColor = COLORS[letterLColorInx];
        _letterTColor = COLORS[letterTColorInx];
        _hoursColor = COLORS[hoursColorInx];
        _minutesColor = COLORS[minutesColorInx];
        _secondsColor = COLORS[secondsColorInx];
    }

    function _initializeClockBoxes() as Void {
        var clockBoxPadding = 0.15 * _logo.getParamA(); // TODO may be go to properties
        var clockDigitsPadding = clockBoxPadding;
        var clockDigitsPaddingHalf = clockDigitsPadding / 2;
        var clockBox = new LyatskiyTeamWatchFaceLogo.AngledBox({
            :rightTopPoint => _logo.getPoint(13),
            :leftTopPoint => _logo.getPoint(12),
            :leftBottomPoint => _logo.getPoint(11)
        }).addPaddingTop(clockBoxPadding).addPaddingLeft(clockBoxPadding);

        var showSeconds = _getProp("ShowSeconds") as Boolean;
        var secondsLayout = _getProp("SecondsLayout") as Number;

        if (showSeconds && (secondsLayout == 0 || secondsLayout == 1)) {
            var boxes = clockBox.splitHorizontal(secondsLayout == 0 ? 1.0 / 3 : 0.4);
            
            _hoursBoxes = boxes[0].addPaddingBottom(clockDigitsPaddingHalf).splitVertical(0.5);

            boxes = boxes[1].splitHorizontal(secondsLayout == 0 ? 0.5 : 2.0 / 3);
        
            _minutesBoxes = boxes[0].addPaddingTop(clockDigitsPaddingHalf).addPaddingBottom(clockDigitsPaddingHalf).splitVertical(0.5);
            
            var secondsBoxes = boxes[1].addPaddingTop(clockDigitsPaddingHalf).splitVertical(0.5);

            _hoursBoxes[0].addPaddingRight(clockDigitsPaddingHalf);
            _hoursBoxes[1].addPaddingLeft(clockDigitsPaddingHalf);

            _minutesBoxes[0].addPaddingRight(clockDigitsPaddingHalf);
            _minutesBoxes[1].addPaddingLeft(clockDigitsPaddingHalf);

            secondsBoxes[0].addPaddingRight(clockDigitsPaddingHalf);
            secondsBoxes[1].addPaddingLeft(clockDigitsPaddingHalf);
        
            _secondsBoxes = secondsBoxes;
        } else {
            var boxes = clockBox.splitHorizontal(0.5);
            
            _hoursBoxes = boxes[0].addPaddingBottom(clockDigitsPaddingHalf).splitVertical(0.5); // TODO 0.5 by
            _minutesBoxes = boxes[1].addPaddingTop(clockDigitsPaddingHalf).splitVertical(0.5);

            _hoursBoxes[0].addPaddingRight(clockDigitsPaddingHalf);
            _hoursBoxes[1].addPaddingLeft(clockDigitsPaddingHalf);

            _minutesBoxes[0].addPaddingRight(clockDigitsPaddingHalf);
            _minutesBoxes[1].addPaddingLeft(clockDigitsPaddingHalf);

            if (showSeconds) {
                var secondsBox;

                if (secondsLayout == 2) {
                    secondsBox = new LyatskiyTeamWatchFaceLogo.AngledBox({
                        :rightTopPoint => _logo.getPoint(9),
                        :leftTopPoint => _logo.getPoint(8),
                        :leftBottomPoint => _logo.getPoint(5)
                    }).addPaddingTop(clockBoxPadding).addPaddingLeft(clockBoxPadding).addPaddingRight(clockBoxPadding);

                    if (secondsBox.getHeight() > _hoursBoxes[0].getHeight()) {
                        secondsBox.addPaddingBottom(secondsBox.getHeight() - _hoursBoxes[0].getHeight());
                    }
                } else if (secondsLayout == 3) {
                    secondsBox = new LyatskiyTeamWatchFaceLogo.AngledBox({
                        :rightBottomPoint => _logo.getPoint(4),
                        :leftTopPoint => _logo.getPoint(8),
                        :leftBottomPoint => _logo.getPoint(5)
                    }).addPaddingBottom(clockBoxPadding).addPaddingLeft(clockBoxPadding).addPaddingRight(clockBoxPadding);

                    if (secondsBox.getHeight() > _hoursBoxes[0].getHeight()) {
                        secondsBox.addPaddingTop(secondsBox.getHeight() - _hoursBoxes[0].getHeight());
                    }
                } else {
                    secondsBox = new LyatskiyTeamWatchFaceLogo.AngledBox({
                        :rightTopPoint => _logo.getPoint(23),
                        :leftTopPoint => _logo.getPoint(8),
                        :leftBottomPoint => _logo.getPoint(5)
                    }).addPadding(clockBoxPadding);

                    if (secondsBox.getHeight() > _hoursBoxes[0].getHeight()) {
                        var delta = secondsBox.getHeight() - _hoursBoxes[0].getHeight();
                        
                        secondsBox.addPaddingTop(delta / 2).addPaddingBottom(delta / 2);
                    }
                }

                var secondsBoxes = secondsBox.splitVertical(0.5);

                secondsBoxes[0].addPaddingRight(clockDigitsPaddingHalf);
                secondsBoxes[1].addPaddingLeft(clockDigitsPaddingHalf);

                _secondsBoxes = secondsBoxes;
            } else {
                _secondsBoxes = null;
            }
        }
    }

    function _initializeDataBoxes() as Void {
        var dataBoxPadding = 0.15 * _logo.getParamA(); // TODO may be go to properties
        var dataBoxCharsPadding = dataBoxPadding / 2;
        var dataBoxCharsPaddingHalf = dataBoxCharsPadding / 2;
        var dataBox = new LyatskiyTeamWatchFaceLogo.AngledBox({
            :leftTopPoint => _logo.getPoint(17),
            :leftBottomPoint => _logo.getPoint(7),
            :rightTopPoint => _logo.getPoint(18)
        }).addPaddingLeft(dataBoxPadding).addPaddingBottom(dataBoxPadding);
        
        var boxes = dataBox.splitVertical(0.7);
        
        _batteryIndicatorBox = boxes[1];
        
        var dateBox = boxes[0];
        var dateBoxMaxWidth = 4 * dateBox.getHeight() + 2 * dataBoxCharsPadding + dataBoxPadding;
        var deltaWidth = dateBox.getWidth() - dateBoxMaxWidth;

        if (deltaWidth > 0) {
            dateBox.addPaddingRight(deltaWidth);
        }

        boxes = dateBox.splitVertical(0.5);

        _dateDayBoxes = boxes[0].addPaddingRight(dataBoxPadding).splitVertical(0.5);
        _dateDayBoxes[0].addPaddingRight(dataBoxCharsPaddingHalf);
        _dateDayBoxes[1].addPaddingLeft(dataBoxCharsPaddingHalf);

        _dateDayOfWeekBoxes = boxes[1].addPaddingRight(dataBoxPadding).splitVertical(0.5);
        _dateDayOfWeekBoxes[0].addPaddingRight(dataBoxCharsPaddingHalf);
        _dateDayOfWeekBoxes[1].addPaddingLeft(dataBoxCharsPaddingHalf);
    }

    function _initializeStatusBoxes() as Void {
        // var statusBox = new LyatskiyTeamWatchFaceLogo.AngledBox({
        //     :leftTopPoint => _logo.getPoint(10),
        //     :leftBottomPoint => _logo.getPoint(17),
        //     :rightTopPoint => _logo.getPoint(21)
        // });
    }

    // Load your resources here
    function onLayout(dc as Graphics.Dc) as Void {
        if (DEBUG) { // TODO to function
            System.println(System.getDeviceSettings().monkeyVersion);
            System.println("deviceScreenWidth: " + dc.getWidth());
            System.println("deviceScreenHeight: " + dc.getHeight());
            System.println("deviceScreenShape: " + System.getDeviceSettings().screenShape);
        }

        _screenWidth = dc.getWidth();
        _screenHeight = dc.getHeight();
        _screenShape = System.getDeviceSettings().screenShape; // API Level 1.2.0

        _initialize();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    // TODO some redraw is not necessary
    function onUpdate(dc as Graphics.Dc) as Void {
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        dc.setColor(_primaryColor, _backgroundColor);
        dc.clear();

        _drawMainLetters(dc);
        _drawClock(dc);
        _drawDataBox(dc);
        _drawStatusBox(dc);

        if (DEBUG) {
            // _debugDrawLines(dc);
        }
    }

    private function _drawMainLetters(dc as Graphics.Dc) as Void {
        dc.setColor(_letterLColor, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(_logo.getLetterLPoints());

        dc.setColor(_letterTColor, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(_logo.getLetterTPoints());
    }

    private function _drawClock(dc as Graphics.Dc) as Void {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        
        if (!System.getDeviceSettings().is24Hour && hour > 12) {
            hour -= 12;
        }

        _drawCharsInBoxes(dc, hour.format("%02d"), _getProp("HoursCharThickness") as Float, _hoursBoxes, _hoursColor);
        _drawCharsInBoxes(dc, clockTime.min.format("%02d"), _getProp("MinutesCharThickness") as Float, _minutesBoxes, _minutesColor);

        var secondsBoxes = _secondsBoxes;
        
        if (secondsBoxes != null) {
            _drawCharsInBoxes(dc, clockTime.sec.format("%02d"), _getProp("SecondsCharThickness") as Float, secondsBoxes, _secondsColor);
        }
    }

    private function _drawDataBox(dc as Graphics.Dc) as Void {
        _drawDate(dc);
        _drawBatteryIndicator(dc);
    }

    private function _drawStatusBox(dc as Graphics.Dc) as Void {

    }

    private function _drawCharInBox(
        dc as Graphics.Dc, 
        char as String or Symbol, 
        charThickness as Numeric, 
        box as LyatskiyTeamWatchFaceLogo.AngledBox,
        color as Graphics.ColorType
    ) as Void {
        var pointsSet = box.getCharInBoxPoints(char, charThickness);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < pointsSet.size(); ++i) {
            dc.fillPolygon(pointsSet[i]);
        }
    }

    private function _drawCharsInBoxes(
        dc as Graphics.Dc, 
        chars as String or Array<Symbol>, 
        charThickness as Numeric, 
        boxes as Array<LyatskiyTeamWatchFaceLogo.AngledBox>,
        color as Graphics.ColorType
    ) as Void {
        if (chars instanceof String) {
            for (var i = 0; i < chars.length(); ++i) {
                _drawCharInBox(
                    dc,
                    chars.substring(i, i + 1) as String,
                    charThickness,
                    boxes[i],
                    color
                );
            }
        } else {
            for (var i = 0; i < chars.size(); ++i) {
                _drawCharInBox(
                    dc,
                    chars[i],
                    charThickness,
                    boxes[i],
                    color
                );
            }
        }
    }

    private function _drawDate(dc as Graphics.Dc) as Void {
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayStr = dateInfo.day.toString();
        var dayOfWeek = dateInfo.day_of_week;
        var dayOfWeekChars;

        if (dayStr.length() < 2) {
            dayStr = "0" + dayStr;
        }

        switch (dayOfWeek) {
            case 1:
                dayOfWeekChars = [:в, :с];
                break;
            case 2:
                dayOfWeekChars = [:п, :н];
                break;
            case 3:
                dayOfWeekChars = [:в, :т];
                break;
            case 4:
                dayOfWeekChars = [:с, :р];
                break;
            case 5:
                dayOfWeekChars = [:ч, :т];
                break;
            case 6:
                dayOfWeekChars = [:п, :т];
                break;
            case 7:
                dayOfWeekChars = [:с, :б];
                break;
            default:
                dayOfWeekChars = [:п, :н];
                break;
        }

        _drawCharsInBoxes(dc, dayStr, 0.28, _dateDayBoxes, _primaryColor);
        _drawCharsInBoxes(dc, dayOfWeekChars, 0.28, _dateDayOfWeekBoxes, _primaryColor);
    }

    private function _drawBatteryIndicator(dc as Graphics.Dc) as Void {
        var value = System.getSystemStats().battery / 100;

        _drawCharInBox(dc, :batteryIndicator, value, _batteryIndicatorBox, value < 0.1 ? _accentColor : _primaryColor);
    }

    (:debug) private function _debugDrawLines(dc as Graphics.Dc) as Void {
        dc.setColor(_accentColor, _backgroundColor);
        dc.drawLine(_logo.getPoint(21)[0], _logo.getPoint(21)[1], _logo.getPoint(22)[0], _logo.getPoint(22)[1]);
        dc.drawLine(_logo.getPoint(21)[0], _logo.getPoint(21)[1], _logo.getPoint(24)[0], _logo.getPoint(24)[1]);
        dc.drawLine(_logo.getPoint(24)[0], _logo.getPoint(24)[1], _logo.getPoint(23)[0], _logo.getPoint(23)[1]);
        dc.drawLine(_logo.getPoint(22)[0], _logo.getPoint(22)[1], _logo.getPoint(23)[0], _logo.getPoint(23)[1]);

        dc.drawLine(_logo.getPoint(17)[0], _logo.getPoint(17)[1], _logo.getPoint(18)[0], _logo.getPoint(18)[1]);
        dc.drawLine(_logo.getPoint(19)[0], _logo.getPoint(19)[1], _logo.getPoint(20)[0], _logo.getPoint(20)[1]);

        dc.drawCircle(_logo.getCircleCenterPoint()[0], _logo.getCircleCenterPoint()[1], _logo.getRadius());
    }

    (:debug) private function _debugHighlightBox(dc as Graphics.Dc, box as LyatskiyTeamWatchFaceLogo.AngledBox) as Void {
        var boxPoints = box.getPoints();

        dc.setColor(_accentColor, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(boxPoints[0][0], boxPoints[0][1], boxPoints[1][0], boxPoints[1][1]);
        dc.drawLine(boxPoints[1][0], boxPoints[1][1], boxPoints[2][0], boxPoints[2][1]);
        dc.drawLine(boxPoints[2][0], boxPoints[2][1], boxPoints[3][0], boxPoints[3][1]);
        dc.drawLine(boxPoints[3][0], boxPoints[3][1], boxPoints[0][0], boxPoints[0][1]);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}