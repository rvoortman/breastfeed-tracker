
import Toybox.Lang;
import Toybox.WatchUi;

class BreastfeedTrackerDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BreastfeedTrackerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onKey(keyEvent) as Boolean {
        if(keyEvent.getKey() == WatchUi.KEY_ENTER) {
            WatchUi.pushView(new Rez.Menus.MainMenu(), new BreastfeedTrackerMenuDelegate(), WatchUi.SLIDE_UP);
            return true;
        }

        if(keyEvent.getKey() == WatchUi.KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            return true;
        }

        return true;
    }

    function onTap(clickEvent) as Boolean {
        var deviceWidth = Rez.Styles.device_info.screenWidth; 
        var helper = new BreastfeedTrackerHelper();

        if(clickEvent.getType() == WatchUi.CLICK_TYPE_TAP) {
            var y = clickEvent.getCoordinates()[1];
            var x = clickEvent.getCoordinates()[0];
            if(y < deviceWidth / 2) {
                if(x < deviceWidth / 2) {
                    // left top
                   helper.trackFeeding(true);
                } else {
                    // right top
                    helper.trackFeeding(false);
                }
            }

            WatchUi.requestUpdate();
            return true;
        }

        return true;
    }
}