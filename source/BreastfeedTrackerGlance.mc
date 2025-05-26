import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time.Gregorian;
using Toybox.WatchUi;

(:glance)
class BreastfeedTrackerGlance extends WatchUi.GlanceView {
  function initialize() {
    GlanceView.initialize();
  }

  function onShow() {
    showFeedings();
  }

  function onLayout(dc as Graphics.Dc) as Void {
    setLayout(Rez.Layouts.GlanceLayout(dc));
  }

  function showFeedings() as Void {
    var feedings =
      Application.Storage.getValue("feedings") as Array<Dictionary>;

    if (feedings.size() > 0) {
      var currentFeeding = feedings[feedings.size() - 1];
      var secondFeeding =
        feedings.size() > 1 ? feedings[feedings.size() - 2] : null;

      var feedingOneLabel =
        self.findDrawableById("GlanceFeedingOne") as WatchUi.Text;
      var feedingTwoLabel =
        self.findDrawableById("GlanceFeedingTwo") as WatchUi.Text;

      feedingOneLabel.setText(formatFeeding(currentFeeding));
      feedingTwoLabel.setText(formatFeeding(secondFeeding));
    }
  }

  // This function is duplicated from BrestfeedTrackerHelper.mc because
  // the glance view cannot access the BreastfeedTrackerHelper class directly.
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
}
