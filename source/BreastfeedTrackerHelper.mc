import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BreastfeedTrackerHelper {
    // Called when a menu item is pressed
    function trackFeeding(left as Boolean) as Void {
        replaceFeedings();

        if (left == true) {
            Application.Storage.setValue("current_feeding", getCurrentTimeAsString() + " - " + Application.loadResource(Rez.Strings.left));
        } else {
            Application.Storage.setValue("current_feeding", getCurrentTimeAsString() + " - " + Application.loadResource(Rez.Strings.right));
        }
    }

    // Replace the feedings (current becomes 1, 1 becomes 2)
    function replaceFeedings() as Void {
        var feedingTwoAgo = Application.Storage.getValue("feeding_two_ago");
        var feedingOneAgo = Application.Storage.getValue("feeding_one_ago");
        var currentFeeding = Application.Storage.getValue("current_feeding");

        Application.Storage.setValue("feeding_three_ago", feedingTwoAgo);
        Application.Storage.setValue("feeding_two_ago", feedingOneAgo);
        Application.Storage.setValue("feeding_one_ago", currentFeeding);
    }

    function getCurrentTimeAsString() as String {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        
        // Add leading zero to minutes if needed
        var minutes = (today.min < 10) ? "0" + today.min : today.min;

        return Lang.format(
            "$1$:$2$",
            [
                today.hour,
                minutes
            ]
        );
    }
}