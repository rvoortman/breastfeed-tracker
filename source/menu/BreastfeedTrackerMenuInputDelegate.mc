import Toybox.Lang;
import Toybox.WatchUi;

class BreastfeedTrackerMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var helper = new BreastfeedTrackerHelper();
        var id = item.getId() as Symbol;

        if (id == :left) {
            helper.trackFeeding('l');
        } else if (id == :right) {
            helper.trackFeeding('r');
        } else if (id == :bottle) {
            helper.trackFeeding('b');
        } else if (id == :undo) {
            helper.undoFeeding();
        }

        if (id == :about) {
            WatchUi.switchToView(
                new AboutView(),
                new AboutDelegate(),
                WatchUi.SLIDE_UP
            );
        } else if (id == :listFeedings) {
            var menu = ListFeedingsView.build(helper.getFeedings());

            WatchUi.switchToView(
                menu,
                new ListFeedingsDelegate(),
                WatchUi.SLIDE_UP
            );
        } else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}
