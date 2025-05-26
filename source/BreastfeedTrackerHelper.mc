import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BreastfeedTrackerHelper {
  const STORAGE_KEY = "feedings";
  const MAX_HISTORY = 10;

  function trackFeeding(what as Char) as Void {
    var feedings =
      Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary>;

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
    var feedings = Application.Storage.getValue(STORAGE_KEY) as Array<Dictionary> or Null;

    if (feedings != null && feedings.size() > 0) {
      var newFeedings = [] as Array<Dictionary>;
      for (var i = 0; i < feedings.size() - 1; i++) {
        newFeedings.add(feedings[i]);
      }
      Application.Storage.setValue(STORAGE_KEY, newFeedings);
    }
  }

  function getFeedings() as Array<Dictionary> {
    var legacyFeeding = Application.Storage.getValue("current_feeding") as String or Null;

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
      var value = Application.Storage.getValue(keys[i]) as String or Null;
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
        if (label.equals(Application.loadResource(Rez.Strings.left).toString())) {
          type = 'l';
        } else if (label.equals(Application.loadResource(Rez.Strings.right).toString())) {
          type = 'r';
        } else if (label.equals(Application.loadResource(Rez.Strings.bottle).toString())) {
          type = 'b';
        }
        if (type != null) {
          var timezoneOffsetInSeconds = System.getClockTime().timeZoneOffset;

          feedings.add({
            "timestamp" => migratedMoment.value() + timezoneOffsetInSeconds,
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
