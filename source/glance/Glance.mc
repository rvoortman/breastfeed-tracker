import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time.Gregorian;
using Toybox.WatchUi;

(:glance)
class Glance extends WatchUi.GlanceView {
    var helper as BreastfeedTrackerHelper = new BreastfeedTrackerHelper();

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
        var feedingOneLabel =
            self.findDrawableById("GlanceFeedingOne") as WatchUi.Text;
        var feedingTwoLabel =
            self.findDrawableById("GlanceFeedingTwo") as WatchUi.Text;

        var feedings = helper.getFeedings();

        if (feedings != null && feedings.size() > 0) {
            var currentFeeding = feedings[feedings.size() - 1];
            var secondFeeding =
                feedings.size() > 1 ? feedings[feedings.size() - 2] : null;

            feedingOneLabel.setText(helper.formatFeeding(currentFeeding));
            feedingTwoLabel.setText(helper.formatFeeding(secondFeeding));
        }
    }
}
