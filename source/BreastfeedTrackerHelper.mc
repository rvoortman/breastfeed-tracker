import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BreastfeedTrackerHelper {
    const STORAGE_KEY = "feedings";
    const STORAGE_KEY_DAILY_COUNTER = "daily_counter";
    const MAX_HISTORY = 30;
    const MAX_COUNTER_HISTORY = 7;

    function trackFeeding(what as Char) as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;
        var dailyCounter =
            Application.Storage.getValue(STORAGE_KEY_DAILY_COUNTER) as Array<Dictionary>?;

        if (feedings == null) {
            feedings = [] as Array<Dictionary>;
        }

        if (dailyCounter == null) {
            dailyCounter = [] as Array<Dictionary>;
        }

        // Update daily counter
        var today = new Time.Moment(Time.now().value());
        var timeInfo = Gregorian.info(today, Time.FORMAT_LONG);
        var todayKey = Lang.format("$1$ $2$", [timeInfo.day, timeInfo.month]);
        var found = false;
        for (var i = 0; i < dailyCounter.size(); i++) {
            if (dailyCounter[i]["date"].equals(todayKey)) {
                dailyCounter[i]["count"] += 1;
                found = true;
                break;
            }
        }

        if (!found) {
            dailyCounter.add({
                "date" => todayKey,
                "count" => 1,
            });
        }

        feedings.add({
            "timestamp" => Time.now().value(),
            "type" => what,
        });

        if( dailyCounter.size() > MAX_COUNTER_HISTORY) {
            // Remove oldest entry
            var newCounters = [];
            var startId = dailyCounter.size() - MAX_COUNTER_HISTORY;
            for (var i = startId; i < dailyCounter.size(); i++) {
                newCounters.add(dailyCounter[i]);
            }
            dailyCounter = newCounters;
        }

        if (feedings.size() > MAX_HISTORY) {
            var newFeedings = [];
            var startId = feedings.size() - MAX_HISTORY;
            for (var i = startId; i < feedings.size(); i++) {
                newFeedings.add(feedings[i]);
            }
            feedings = newFeedings;
        }

        Application.Storage.setValue(STORAGE_KEY, feedings);
        Application.Storage.setValue(STORAGE_KEY_DAILY_COUNTER, dailyCounter);
    }

    function undoFeeding() as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;
        var dailyCounter =
            Application.Storage.getValue(STORAGE_KEY_DAILY_COUNTER) as Array<Dictionary>?;

        if (feedings != null && feedings.size() > 0) {
            var newFeedings = [] as Array<Dictionary>;
            for (var i = 0; i < feedings.size() - 1; i++) {
                newFeedings.add(feedings[i]);
            }
            Application.Storage.setValue(STORAGE_KEY, newFeedings);
        }

        for (var i = 0; i < dailyCounter.size(); i++) {
            var today = new Time.Moment(Time.now().value());
            var timeInfo = Gregorian.info(today, Time.FORMAT_LONG);
            var todayKey = Lang.format("$1$ $2$", [timeInfo.day, timeInfo.month]);

            if (dailyCounter[i]["date"].equals(todayKey)) {
                dailyCounter[i]["count"] -= 1;
                break;
            }
        }

        Application.Storage.setValue(STORAGE_KEY_DAILY_COUNTER, dailyCounter);
    }

    function getFeedings() as Array<Dictionary> {
        var legacyFeeding =
            Application.Storage.getValue("current_feeding") as String?;

        if (legacyFeeding != null && legacyFeeding != "") {
            migrateFeedingsToNewFormat();
        }

        try {
            var feedings = Application.Storage.getValue(STORAGE_KEY);
            return (feedings != null ? feedings : []) as Array<Dictionary>;
        } catch (ex) {
            Application.Storage.setValue(STORAGE_KEY, []);
            return [];
        }
    }

    function getCountForDay(timeInfo as Gregorian.Info) as Number {
        var dailyCounter =
            Application.Storage.getValue(STORAGE_KEY_DAILY_COUNTER) as Array<Dictionary>?;

        if (dailyCounter == null) {
            return 0;
        }

        var day = Lang.format("$1$ $2$", [timeInfo.day, timeInfo.month]);
        
        for (var i = 0; i < dailyCounter.size(); i++) {
            if (dailyCounter[i]["date"].equals(day)) {
                return dailyCounter[i]["count"] as Number;
            }
        }

        return 0;
    }

    function formatFeeding(feeding as Dictionary?) as String {
        if (feeding == null) {
            return "";
        }

        var moment = new Time.Moment(feeding["timestamp"] as Number);
        var timeInfo = Gregorian.info(moment, Time.FORMAT_SHORT);
        var minutes = timeInfo.min < 10 ? "0" + timeInfo.min : timeInfo.min;
        var timeString = Lang.format("$1$:$2$", [timeInfo.hour, minutes]);

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

    function migrateFeedingsToNewFormat() as Void {
        var keys = [
            "feeding_three_ago",
            "feeding_two_ago",
            "feeding_one_ago",
            "current_feeding",
        ];

        var feedings = [] as Array<Dictionary>;

        for (var i = 0; i < keys.size(); i++) {
            var value = Application.Storage.getValue(keys[i]) as String?;
            if (value != null && value != "") {
                // value is like "12:34 - Left"
                var timeStr = value.substring(0, 5);
                var label = value.substring(8, null);

                var hour = timeStr.substring(0, 2).toNumber();
                var min = timeStr.substring(3, null).toNumber();

                // Use today's date for migration, as original date is not stored
                var now = Time.now();
                var today = Gregorian.info(now, Time.FORMAT_SHORT);

                var options = {
                    :year => today.year,
                    :month => today.month,
                    :day => today.day,
                    :hour => hour,
                    :min => min,
                };
                var migratedMoment = Gregorian.moment(options);

                // Map label to type
                var type = null;
                if (
                    label.equals(
                        Application.loadResource(Rez.Strings.left).toString()
                    )
                ) {
                    type = 'l';
                } else if (
                    label.equals(
                        Application.loadResource(Rez.Strings.right).toString()
                    )
                ) {
                    type = 'r';
                } else if (
                    label.equals(
                        Application.loadResource(Rez.Strings.bottle).toString()
                    )
                ) {
                    type = 'b';
                }
                if (type != null) {
                    var timezoneOffsetInSeconds =
                        System.getClockTime().timeZoneOffset;

                    feedings.add({
                        "timestamp" => migratedMoment.value() -
                        timezoneOffsetInSeconds,
                        "type" => type,
                    });
                }
            }
        }

        if (feedings.size() > 0) {
            Application.Storage.setValue(STORAGE_KEY, feedings);
        }

        for (var i = 0; i < keys.size(); i++) {
            Application.Storage.deleteValue(keys[i]);
        }
    }
}
