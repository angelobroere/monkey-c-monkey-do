import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;
import Toybox.Math;

class HelloWorldView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.WatchFace(dc));
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

        // Get current time
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        // Time float
        var timeFloat = now.hour + (now.min / 60.0);
        var brightness = 0.0;

        if (timeFloat < 6 || timeFloat > 21) {
            brightness = 0.0;
        } else if (timeFloat <= 12) {
            var t = (timeFloat - 6) / 6.0;
            brightness = Math.pow(t, 0.3);
        } else {
            var t = (21 - timeFloat) / 9.0;
            brightness = Math.pow(t, 0.3);
        }

        // The lowest brightness can go is 0.1
        brightness = brightness < 0.1 ? 0.1 : brightness;

        // Clear screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Interpolate day and night colours
        // Sky
        var nightR = 10;  var nightG = 10;  var nightB = 40;   // deep dark navy
        var noonR = 30;   var noonG = 160;  var noonB = 255;   // rich vivid blue

        // Ground
        var groundNightR = 10;  var groundNightG = 30;  var groundNightB = 10;  // dark forest green
        var groundNoonR = 60;   var groundNoonG = 180;  var groundNoonB = 60;   // lush bright green

        var r = Math.round(nightR + (noonR - nightR) * brightness).toNumber();
        var g = Math.round(nightG + (noonG - nightG) * brightness).toNumber();
        var b = Math.round(nightB + (noonB - nightB) * brightness).toNumber();

        var gr = Math.round(groundNightR + (groundNoonR - groundNightR) * brightness).toNumber();
        var gg = Math.round(groundNightG + (groundNoonG - groundNightG) * brightness).toNumber();
        var gb = Math.round(groundNightB + (groundNoonB - groundNightB) * brightness).toNumber();

        // Sunset/Sunrise Background
        //Sky
        dc.setColor(Graphics.createColor(255, r, g, b), Graphics.createColor(255, r, g, b));
        dc.fillRectangle(0, 0, screenWidth, screenHeight / 3 * 2);

        // Ground
        dc.setColor(Graphics.createColor(255, gr, gg, gb), Graphics.createColor(255, gr, gg, gb));
        dc.fillRectangle(0, screenHeight / 3 * 2, screenWidth, screenHeight / 3);

        // show the current time and date
        var timeString = Lang.format("$1$:$2$:$3$", [now.hour, now.min.format("%02d"), now.sec.format("%02d")]);

        var dateString = Lang.format("$1$/$2$/$3$", [now.day, now.month, now.year]);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(screenCenterX, screenHeight * 0.20, Graphics.FONT_MEDIUM, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(screenCenterX, screenHeight * 0.30, Graphics.FONT_SMALL, dateString, Graphics.TEXT_JUSTIFY_CENTER);

        // Show and update battery level or charging status
        var stats = System.getSystemStats();
        var chargingStrings = ["", ".", "..", "..."];

        if (stats.charging) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(screenWidth * 0.50, screenHeight * 0.85, Graphics.FONT_SMALL, chargingStrings[now.sec % 4], Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            var batteryLevel = stats.battery;
            var batteryString = Lang.format("$1$%", [batteryLevel.format("%d")]);

            if (batteryLevel < 20) {
                dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(screenWidth * 0.50, screenHeight * 0.85, Graphics.FONT_SMALL, batteryString, Graphics.TEXT_JUSTIFY_CENTER);
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
