import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;

class LyatskiyTeamWatchFaceView extends WatchUi.WatchFace {
    private var _logo;

    private var _backgroundColor;
    private var _foregroundColor;

    function initialize() {
        WatchFace.initialize();

        // API Level 2.4.0
        if (Application has :Properties) {
            _backgroundColor = Application.Properties.getValue("BackgroundColor");
        } else {
            _backgroundColor = Graphics.COLOR_WHITE;
        }

        _backgroundColor = (Application has :Properties) ? Application.Properties.getValue("BackgroundColor") : Graphics.COLOR_WHITE;
        _foregroundColor = _backgroundColor == Graphics.COLOR_WHITE ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE;
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
                :k3 => 0.1,
                :k4 => 0.1,
                :k5 => 0.4,
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

        drawLetters(dc);
        drawHoursAndMinutesDigits(dc);
        drawDataArea(dc);

        // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);
    }

    function drawLetters(dc) {
        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(_logo.getLetterLPoints());

        dc.setColor(Graphics.COLOR_RED, _backgroundColor);
        dc.fillPolygon(_logo.getLetterTPoints());
    }

    function drawHoursAndMinutesDigits(dc) {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var min = clockTime.min;
        
        if (!System.getDeviceSettings().is24Hour && hour > 12) {
            hour -= 12;
        }

        var hour2 = hour % 10;
        var hour1 = (hour - hour2) / 10;
        var min2 = min % 10;
        var min1 = (min - min2) / 10;

        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(_logo.getDigitPointsInClockArea(hour1, 1));
        dc.fillPolygon(_logo.getDigitPointsInClockArea(hour2, 2));
        dc.fillPolygon(_logo.getDigitPointsInClockArea(min1, 3));
        dc.fillPolygon(_logo.getDigitPointsInClockArea(min2, 4));
    }

    function drawDataArea(dc) {
        dc.setColor(_foregroundColor, _backgroundColor);
        dc.fillPolygon(_logo.getLetterPointsInDataArea("3", 1));
        dc.fillPolygon(_logo.getLetterPointsInDataArea("2", 2));
        dc.fillPolygon(_logo.getLetterPointsInDataArea("1", 3));
        dc.fillPolygon(_logo.getLetterPointsInDataArea("4", 4));
        dc.fillPolygon(_logo.getLetterPointsInDataArea("5", 5));
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