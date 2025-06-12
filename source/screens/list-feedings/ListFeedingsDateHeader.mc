import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

import Toybox.Time;
import Toybox.Time.Gregorian;

class ListFeedingsDateHeader extends WatchUi.CustomMenuItem {
    var timestamp as Number;
    var feedings as Array<Dictionary>;
    var countForDay as Number;
    var firstHeader as Boolean;
    
    function initialize(timestamp as Number, feedings as Array<Dictionary>, countForDay as Number, firstHeader as Boolean) {
        CustomMenuItem.initialize(null, {});

        self.timestamp = timestamp;
        self.feedings = feedings;
        self.firstHeader = firstHeader;
        self.countForDay = countForDay;
    }

    function draw(dc as Graphics.Dc) as Void {
        var moment = new Time.Moment(self.timestamp);
        var timeInfo = Gregorian.info(moment, Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [timeInfo.day, timeInfo.month]) + 
                         " (" + Application.loadResource(Rez.Strings.list_feedings_total) + ": " + self.countForDay +")";

        var leftCount = 0;
        var rightCount = 0;
        var bottleCount = 0;

        for (var i = 0; i < self.feedings.size(); i++) {
            var feeding = self.feedings[i];
            var feedMoment = new Time.Moment(feeding["timestamp"]);
            var feedInfo = Gregorian.info(feedMoment, Time.FORMAT_MEDIUM);

            if (feedInfo.month.equals(timeInfo.month) && feedInfo.day == timeInfo.day) {
                var type = feeding["type"];
                if (type == 'l') {
                    leftCount++;
                } else if (type == 'r') {
                    rightCount++;
                } else if (type == 'b') {
                    bottleCount++;
                }
            }
        }

        var leftLabel = WatchUi.loadResource(Rez.Strings.left);
        var rightLabel = WatchUi.loadResource(Rez.Strings.right);
        var bottleLabel = WatchUi.loadResource(Rez.Strings.bottle);
        var summary = Lang.format("$1$: $2$ $3$: $4$ $5$: $6$", [leftLabel, leftCount, rightLabel, rightCount, bottleLabel, bottleCount]);

        var width = dc.getWidth();
        var y = 0;

        if(!self.firstHeader) {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(0, y, width, y);
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var dateWidth = dc.getTextWidthInPixels(dateString, Graphics.FONT_TINY);
        dc.drawText((width - dateWidth) / 2, y, Graphics.FONT_TINY, dateString, Graphics.TEXT_JUSTIFY_LEFT);

        // Draw summary below, smaller font
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        y += dc.getFontHeight(Graphics.FONT_TINY) + 1;
        var summaryWidth = dc.getTextWidthInPixels(summary, Graphics.FONT_XTINY);
        dc.drawText((width - summaryWidth) / 2, y, Graphics.FONT_XTINY, summary, Graphics.TEXT_JUSTIFY_LEFT);

        // Draw divider line at the bottom
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        y += dc.getFontHeight(Graphics.FONT_XTINY) + 6;
        dc.drawLine(10, y, width - 10, y);
    }
}