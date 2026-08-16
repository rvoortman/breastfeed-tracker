import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:glance)
class BreastfeedTrackerHelper {
    const STORAGE_KEY = "feedings";
    const MAX_HISTORY = 30;

    function trackFeeding(what as Char) as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;

        if (feedings == null) {
            feedings = [] as Array<Dictionary>;
        }

        feedings.add({
            "timestamp" => Time.now().value(),
            "type" => what,
        });

        if (feedings.size() > MAX_HISTORY) {
            var newFeedings = [];
            var startId = feedings.size() - MAX_HISTORY;
            for (var i = startId; i < feedings.size(); i++) {
                newFeedings.add(feedings[i]);
            }
            feedings = newFeedings;
        }

        Application.Storage.setValue(STORAGE_KEY, feedings);
    }

    function undoFeeding() as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;

        if (feedings != null && feedings.size() > 0) {
            var newFeedings = [] as Array<Dictionary>;
            for (var i = 0; i < feedings.size() - 1; i++) {
                newFeedings.add(feedings[i]);
            }
            Application.Storage.setValue(STORAGE_KEY, newFeedings);
        }
    }

    function getFeedings() as Array<Dictionary> {
        try {
            var feedings = Application.Storage.getValue(STORAGE_KEY);
            return (feedings != null ? feedings : []) as Array<Dictionary>;
        } catch (ex) {
            Application.Storage.setValue(STORAGE_KEY, []);
            return [];
        }
    }

    function formatFeeding(feeding as Dictionary?) as String {
        if (feeding == null) {
            return "";
        }

        var moment = new Time.Moment(feeding["timestamp"] as Number);
        var timeInfo = Gregorian.info(moment, Time.FORMAT_SHORT);

        var deviceSettings = System.getDeviceSettings();
        var timeString;
        if (deviceSettings.is24Hour) {
            timeString = Lang.format("$1$:$2$", [
                timeInfo.hour.format("%02d"),
                timeInfo.min.format("%02d"),
            ]);
        } else {
            var hour = timeInfo.hour;
            var ampm = hour >= 12 ? "PM" : "AM";
            if (hour > 12) {
                hour = hour - 12;
            }
            timeString = Lang.format("$1$:$2$ $3$", [
                hour,
                timeInfo.min.format("%02d"),
                ampm,
            ]);
        }

        var type = feeding["type"] as Char;
        var label = "";
        if (type == 'l') {
            label = Application.loadResource(Rez.Strings.left);
        } else if (type == 'r') {
            label = Application.loadResource(Rez.Strings.right);
        } else if (type == 'b') {
            label = Application.loadResource(Rez.Strings.bottle);
        }

        return timeString + " - " + label;
    }
}
