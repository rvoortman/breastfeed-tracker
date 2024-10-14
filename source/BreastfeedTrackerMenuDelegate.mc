import Toybox.Lang;
import Toybox.WatchUi;

class BreastfeedTrackerMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    // Called when a menu item is pressed
    function onMenuItem(item as Symbol) as Void {
        var helper = new BreastfeedTrackerHelper();

        if (item == :left) {
            helper.trackFeeding(true);
        } else if (item == :right) {
            helper.trackFeeding(false);
        } else if (item == :undo) {
            helper.undoFeeding();
        } else if (item == :about) {
            WatchUi.switchToView(new BreastfeedTrackerAboutView(),  new BreastfeedTrackerAboutDelegate(), WatchUi.SLIDE_UP);
        }
    }
}
