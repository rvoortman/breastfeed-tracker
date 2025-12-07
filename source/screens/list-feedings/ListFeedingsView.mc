import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class ListFeedingsView {
    static function build(
        feedingsList as Array<Dictionary>
    ) as WatchUi.CustomMenu {
        var deviceSettings = System.getDeviceSettings();
        var menuHeight = 85 as Number;
        if (deviceSettings.screenHeight < 250) {
            menuHeight = deviceSettings.screenHeight / 4;
        } else {
            menuHeight = deviceSettings.screenHeight / 5;
        }

        var menu = new WatchUi.CustomMenu(menuHeight, Graphics.COLOR_BLACK, {});
        var helper = new BreastfeedTrackerHelper();
        var feedings = feedingsList.reverse(); // Reverse to show most recent feedings first

        var previousDay = 0;

        for (var i = 0; i < feedings.size(); i++) {
            var feeding = feedings[i];
            var timestamp = feeding["timestamp"] as Number;

            var moment = new Time.Moment(timestamp as Number);
            var timeInfo = Gregorian.info(moment, Time.FORMAT_LONG);
            var currentDay = timeInfo.day;

            if (currentDay != previousDay) {
                var firstHeader = previousDay == 0;
                menu.addItem(
                    new ListFeedingsDateHeader(timestamp, feedings, firstHeader)
                );
                previousDay = currentDay;
            }

            menu.addItem(new ListFeedingsItem(helper, feeding));
        }

        return menu;
    }
}
