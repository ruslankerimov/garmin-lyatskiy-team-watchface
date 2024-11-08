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
                :k4 => 0.2,
                :k5 => 0.6,
                :k6 => 0.1,
                :alpha => 66
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
        _drawClockArea(dc);
        _drawDateArea(dc);

        // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);
    }

    private function _drawMainLetters(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(logo.getLetterLPoints());

        dc.setColor(Graphics.COLOR_RED, _backgroundColor);
        dc.fillPolygon(logo.getLetterTPoints());
    }

    private function _drawClockArea(dc as Graphics.Dc) as Void {
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
        dc.fillPolygon(logo.getDigitPointsInClockArea(hourFirstDigit, 1, 3));
        dc.fillPolygon(logo.getDigitPointsInClockArea(hourSecondDigit, 2, 3));
        dc.fillPolygon(logo.getDigitPointsInClockArea(minFirstDigit, 3, 5));
        dc.fillPolygon(logo.getDigitPointsInClockArea(minSecondDigit, 4, 5));
    }

    private function _drawDateArea(dc as Graphics.Dc) as Void {
        var logo = _logo as LyatskiyTeamWatchFaceLogo.Logo;

        var chars = [] as Array<[ Char, Numeric ]>;
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayChars = dateInfo.day.toString().toCharArray();

        for (var i = 0; i < dayChars.size(); ++i) {
            chars.add([ dayChars[i], 3.5 ]);
        }

        var dow = dateInfo.day_of_week;
        var dowChars;

        switch (dow) {
            case 1:
                dowChars = ['в', 'с'];
                break;
            case 2:
                dowChars = ['п', 'н'];
                break;
            case 3:
                dowChars = ['в', 'т'];
                break;
            case 4:
                dowChars = ['с', 'р'];
                break;
            case 5:
                dowChars = ['ч', 'т'];
                break;
            case 6:
                dowChars = ['п', 'т'];
                break;
            case 7:
                dowChars = ['с', 'б'];
                break;
            default:
                dowChars = ['п', 'н'];
                break;
        }

        for (var i = 0; i < dowChars.size(); ++i) {
            chars.add([ dowChars[i], 6 ]);
        }

        dc.setColor(_foregroundColor, _backgroundColor);
        for (var i = 0; i < chars.size(); ++i) {
            dc.fillPolygon(logo.getCharPointsInDateArea(chars[i][0], i + 1, chars[i][1]));
        }
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