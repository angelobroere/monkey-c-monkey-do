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
        // Get and show the current time and date
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$:$3$", [now.hour, now.min.format("%02d"), now.sec.format("%02d")]);

        var dateString = Lang.format("$1$/$2$/$3$", [now.day, now.month, now.year]);
        
        var timeView = View.findDrawableById("TimeLabel") as Text;
        timeView.setText(timeString);

        var dateView = View.findDrawableById("DateLabel") as Text;
        dateView.setText(dateString);

        // Show and update battery level or charging status
        var batteryView = View.findDrawableById("BatteryLabel") as Text;
        var chargingStrings = ["charging", "charging .", "charging ..", "charging ..."];
        if (System.getSystemStats().charging) {
            batteryView.setText(chargingStrings[now.sec % 4]);
        } else {
            var batteryLevel = System.getSystemStats().battery;
            batteryView.setText(Lang.format("Battery: $1$%", [batteryLevel.format("%d")]));

            // Set text color conditionally
            if (batteryLevel < 20) {
                batteryView.setColor(Graphics.COLOR_RED);
            } else {
                batteryView.setColor(Graphics.COLOR_WHITE);
            }
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
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
