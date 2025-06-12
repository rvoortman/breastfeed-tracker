import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

import Toybox.Time;
import Toybox.Time.Gregorian;

class ListFeedingsItem extends WatchUi.CustomMenuItem {
    var feeding as Dictionary;
    var helper as BreastfeedTrackerHelper;

    function initialize(
        helper as BreastfeedTrackerHelper,
        feeding as Dictionary
    ) {
        CustomMenuItem.initialize(null, {});

        self.feeding = feeding;
        self.helper = helper;
    }

    function draw(dc as Graphics.Dc) as Void {
        var feedingstring = self.helper.formatFeeding(self.feeding);
        var y = 9;
        var widthPosition = dc.getWidth() / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            widthPosition,
            y,
            Graphics.FONT_TINY,
            feedingstring,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
