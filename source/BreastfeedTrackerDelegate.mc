
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
        // Top left menu button
        if(keyEvent.getKey() == WatchUi.KEY_ENTER) {
            WatchUi.pushView(new Rez.Menus.MainMenu(), new BreastfeedTrackerMenuDelegate(), WatchUi.SLIDE_UP);
        }

        return true;
    }
}