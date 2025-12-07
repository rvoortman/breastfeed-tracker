import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:glance)
class BreastfeedTrackerHelper {
    const STORAGE_KEY = "feedings";
    const MAX_HISTORY = 30;

    function trackFeeding(what as Char, timestamp as Number or Null) as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;

        if (feedings == null) {
            feedings = [] as Array<Dictionary>;
        }

        var feedingTime = timestamp != null ? timestamp : Time.now().value();

        feedings.add({
            "timestamp" => feedingTime,
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

        Application.Storage.setValue(STORAGE_KEY, feedings as Application.PropertyValueType);
        WatchUi.requestUpdate();
    }

    function undoFeeding() as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;

        if (feedings != null && feedings.size() > 0) {
            var newFeedings = [] as Array<Dictionary>;
            for (var i = 0; i < feedings.size() - 1; i++) {
                newFeedings.add(feedings[i]);
            }
            Application.Storage.setValue(STORAGE_KEY, newFeedings as Application.PropertyValueType);
        }
    }

    function editFeeding(timestamp as Number, newTimestamp as Number, feedingType as Char) as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;

        if (feedings != null) {
            for (var i = 0; i < feedings.size(); i++) {
                var feeding = feedings[i] as Dictionary;
                if (feeding["timestamp"] == timestamp) {
                    feeding["timestamp"] = newTimestamp;
                    feeding["type"] = feedingType;
                    break;
                }
            }
            Application.Storage.setValue(STORAGE_KEY, feedings as Application.PropertyValueType);
            WatchUi.requestUpdate();
        }
    }

    function deleteFeeding(timestamp as Number) as Void {
        var feedings =
            Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>?;

        if (feedings != null) {
            var newFeedings = [] as Array<Dictionary>;
            for (var i = 0; i < feedings.size(); i++) {
                var feeding = feedings[i] as Dictionary;
                if (feeding["timestamp"] != timestamp) {
                    newFeedings.add(feeding);
                }
            }
            Application.Storage.setValue(STORAGE_KEY, newFeedings as Application.PropertyValueType);
            WatchUi.requestUpdate();
        }
    }

    function clearFeedings() as Void {
        Application.Storage.setValue(STORAGE_KEY, [] as Application.PropertyValueType);
        WatchUi.requestUpdate();
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

                if(timeStr == null || label == null) {
                    continue;
                }

                var hourString = timeStr.substring(0, 2);
                var minString = timeStr.substring(3, null);

                if(hourString == null || minString == null) {
                    continue;
                }

                var hour = hourString.toNumber();
                var min = minString.toNumber();

                // Use today's date for migration, as original date is not stored
                var now = Time.now();
                var today = Gregorian.info(now, Time.FORMAT_SHORT);

                var options = {
                    :year => today.year as Number,
                    :month => today.month  as Number,
                    :day => today.day  as Number,
                    :hour => hour  as Number,
                    :min => min as Number,
                };
                var migratedMoment = Gregorian.moment(options );

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
            Application.Storage.setValue(STORAGE_KEY, feedings as Application.PropertyValueType);
        }

        for (var i = 0; i < keys.size(); i++) {
            Application.Storage.deleteValue(keys[i]);
        }
    }
}
