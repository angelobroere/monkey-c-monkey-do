import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class HelloWorldView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var screenCenterX = screenWidth / 2;

        // background
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        dc.clear();

        // Get and show the current time and date
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$:$3$", [now.hour, now.min.format("%02d"), now.sec.format("%02d")]);

        var dateString = Lang.format("$1$/$2$/$3$", [now.day, now.month, now.year]);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(screenCenterX, screenHeight * 0.20, Graphics.FONT_MEDIUM, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(screenCenterX, screenHeight * 0.30, Graphics.FONT_SMALL, dateString, Graphics.TEXT_JUSTIFY_CENTER);

        // Show and update battery level or charging status
        var stats = System.getSystemStats();
        var chargingStrings = ["charging", "charging .", "charging ..", "charging ..."];

        if (stats.charging) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(screenWidth * 0.30, screenHeight * 0.75, Graphics.FONT_SMALL, chargingStrings[now.sec % 4], Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            var batteryLevel = stats.battery;
            var batteryString = Lang.format("Battery: $1$%", [batteryLevel.format("%d")]);

            if (batteryLevel < 20) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(screenWidth * 0.30, screenHeight * 0.75, Graphics.FONT_SMALL, batteryString, Graphics.TEXT_JUSTIFY_LEFT);
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
