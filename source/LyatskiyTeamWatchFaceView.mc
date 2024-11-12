import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

class LyatskiyTeamWatchFaceView extends WatchUi.WatchFace {
    private var _logo as LyatskiyTeamWatchFaceLogo.Logo?;

    private var _backgroundColor as Graphics.ColorType = Graphics.COLOR_WHITE;
    private var _foregroundColor as Graphics.ColorType = Graphics.COLOR_BLACK;
    private var _accentColor as Graphics.ColorType = Graphics.COLOR_RED;

    private var _batteryIndicatorWidthRatio as Float = 0.3;

    function initialize() {
        WatchFace.initialize();

        // API Level 2.4.0
        if (Application has :Properties) {
            _backgroundColor = Application.Properties.getValue("BackgroundColor") as Graphics.ColorType;

            if (_backgroundColor == Graphics.COLOR_BLACK) {
                _foregroundColor = Graphics.COLOR_WHITE;
            }
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        if (DEBUG) {
            System.println("deviceScreenWidth: " + dc.getWidth());
            System.println("deviceScreenHeight: " + dc.getHeight());
            System.println("deviceScreenShape: " + System.getDeviceSettings().screenShape);
        }

        _logo = LyatskiyTeamWatchFaceLogo.createLogoOnScreen(
            {
                :k1 => 1.5,
                :k2 => 4.5,
                :k3 => 0.15,
                :k4 => 0.15,
                :k5 => 0.5,
                :alpha => 66.0
            },
            {
                :width => dc.getWidth(),
                :height => dc.getHeight(),
                :shape => System.getDeviceSettings().screenShape, // API Level 1.2.0
                :padding => 0.05
            });

        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        onUpdate(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(_foregroundColor, _backgroundColor);
        dc.clear();

        _drawMainLetters(dc);

        // _drawDebugLines(dc);

        _drawClockBox(dc);
        _drawDateBox(dc);
        _drawBatteryIndicator(dc);
    }

    private function _drawMainLetters(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(logo.getLetterLPoints());

        dc.setColor(_accentColor, _backgroundColor);
        dc.fillPolygon(logo.getLetterTPoints());
    }

    private function _drawClockBox(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var min = clockTime.min;
        
        if (!System.getDeviceSettings().is24Hour && hour > 12) {
            hour -= 12;
        }

        var hourSecondDigit = hour % 10;
        var hourFirstDigit = (hour - hourSecondDigit) / 10;
        var minSecondDigit = min % 10;
        var minFirstDigit = (min - minSecondDigit) / 10;

        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(logo.getDigitPointsInClockArea(hourFirstDigit, 1, 3.5));
        dc.fillPolygon(logo.getDigitPointsInClockArea(hourSecondDigit, 2, 3.5));
        dc.fillPolygon(logo.getDigitPointsInClockArea(minFirstDigit, 3, 7.0));
        dc.fillPolygon(logo.getDigitPointsInClockArea(minSecondDigit, 4, 7.0));
    }

    private function _drawDateBox(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        var chars = [] as Array<String>;
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayStr = dateInfo.day.toString();

        if (dayStr.length() < 2) {
            dayStr = "0" + dayStr;
        }

        for (var i = 0; i < dayStr.length(); ++i) {
            chars.add(dayStr.substring(i, i + 1) as String);
            chars.add("");
        }

        chars.add("");

        var dow = dateInfo.day_of_week;
        var dowChars;

        switch (dow) {
            case 1:
                dowChars = ["в", "с"];
                break;
            case 2:
                dowChars = ["п", "н"];
                break;
            case 3:
                dowChars = ["в", "т"];
                break;
            case 4:
                dowChars = ["с", "р"];
                break;
            case 5:
                dowChars = ["ч", "т"];
                break;
            case 6:
                dowChars = ["п", "т"];
                break;
            case 7:
                dowChars = ["с", "б"];
                break;
            default:
                dowChars = ["п", "н"];
                break;
        }

        for (var i = 0; i < dowChars.size(); ++i) {
            chars.add("");
            chars.add(dowChars[i]);
        }

        var boxWidthRatio = 1 - _batteryIndicatorWidthRatio;
        var boxLeftTopPoint = logo.getPoint(21);
        var boxLeftBottomPoint = logo.getPoint(24);
        var point22 = logo.getPoint(22);
        var boxRightTopPoint = [
            boxLeftTopPoint[0] + boxWidthRatio * (point22[0] - boxLeftTopPoint[0]),
            boxLeftTopPoint[1] + boxWidthRatio * (point22[1] - boxLeftTopPoint[1])
        ];

        var boxWidth = boxRightTopPoint[0] - boxLeftTopPoint[0];
        var boxHeight = boxLeftBottomPoint[1] - boxLeftTopPoint[1];
        var boxTanAngle = (boxRightTopPoint[1] - boxLeftTopPoint[1]) / boxWidth;

        var gapWidth = boxWidth * 0.04;
        var charWidth = (boxWidth - 8 * gapWidth) / 4;
        var charHeight = boxHeight;
        var charThickness = charWidth / 5.0;
        
        var reperPoint = boxLeftTopPoint;

        for (var i = 0; i < chars.size(); ++i) {
            var char = chars[i];
            var width;

            if (char.equals("")) {
                width = gapWidth;
            } else {
                width = charWidth;
                _drawAngledChar(
                    dc,
                    chars[i],
                    charWidth,
                    charHeight,
                    charThickness,
                    reperPoint,
                    _foregroundColor
                );
            }
            
            reperPoint[0] += width;
            reperPoint[1] += width * boxTanAngle;
        }
    }

    private function _drawAngledChar(
        dc as Graphics.Dc,
        char as String,
        charWidth as Numeric, 
        charHeight as Numeric, 
        charThickness as Numeric, 
        reperPoint as LyatskiyTeamWatchFaceLogo.Point,
        color as Graphics.ColorType
    ) as Void {
            var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;
            var charPoints = LyatskiyTeamWatchFaceLogo.getAngledCharPoints(
                char,
                charWidth,
                charHeight,
                charThickness,
                logo.getParamAlpha());

            LyatskiyTeamWatchFaceLogo.shiftPointsByPoint(charPoints, reperPoint);
            
            dc.setColor(color, _backgroundColor);
            dc.fillPolygon(charPoints);
    }

    private function _drawBatteryIndicator(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        var areaLeftTopPoint = logo.getPoint(21);
        var areaRightTopPoint = logo.getPoint(22);
        var areaLeftBottomPoint = logo.getPoint(24);

        var areaWidth = areaRightTopPoint[0] - areaLeftTopPoint[0];
        var areaHeight = areaLeftBottomPoint[1] - areaLeftTopPoint[1];

        var indicatorWidth = areaWidth * _batteryIndicatorWidthRatio;
        var indicatorHeight = areaHeight;
        var indicatorThinkness = indicatorHeight / 8;

        var indicatorReperPoint = [
            areaLeftTopPoint[0] + (1 - _batteryIndicatorWidthRatio) * (areaRightTopPoint[0] - areaLeftTopPoint[0]),
            areaLeftTopPoint[1] + (1 - _batteryIndicatorWidthRatio) * (areaRightTopPoint[1] - areaLeftTopPoint[1])
        ];

        var batteryValue = System.getSystemStats().battery / 100.0;
        var fillIndicatorPoints = LyatskiyTeamWatchFaceLogo.getAngledCharPoints(
            "*",
            indicatorThinkness + (indicatorWidth - 2 * indicatorThinkness) * batteryValue,
            indicatorHeight,
            1,
            logo.getParamAlpha());
        var indicatorPoints = LyatskiyTeamWatchFaceLogo.getAngledCharPoints(
            "#",
            indicatorWidth,
            indicatorHeight,
            indicatorThinkness,
            logo.getParamAlpha());

        LyatskiyTeamWatchFaceLogo.shiftPoints(fillIndicatorPoints, indicatorReperPoint[0], indicatorReperPoint[1]);
        LyatskiyTeamWatchFaceLogo.shiftPoints(indicatorPoints, indicatorReperPoint[0], indicatorReperPoint[1]);

        dc.setColor(batteryValue < 0.1 ? _accentColor : _foregroundColor, _backgroundColor);
        dc.fillPolygon(fillIndicatorPoints);

        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(indicatorPoints);
    }

    private function _drawDebugLines(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        dc.setColor(_accentColor, _backgroundColor);
        dc.drawLine(logo.getPoint(21)[0], logo.getPoint(21)[1], logo.getPoint(22)[0], logo.getPoint(22)[1]);
        dc.drawLine(logo.getPoint(21)[0], logo.getPoint(21)[1], logo.getPoint(24)[0], logo.getPoint(24)[1]);
        dc.drawLine(logo.getPoint(24)[0], logo.getPoint(24)[1], logo.getPoint(23)[0], logo.getPoint(23)[1]);
        dc.drawLine(logo.getPoint(22)[0], logo.getPoint(22)[1], logo.getPoint(23)[0], logo.getPoint(23)[1]);
        dc.drawCircle(logo.getCircleCenterPoint()[0], logo.getCircleCenterPoint()[1], logo.getRadius());
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