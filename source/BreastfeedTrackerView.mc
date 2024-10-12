import Toybox.Graphics;
import Toybox.WatchUi;

class BreastfeedTrackerView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        showFeedings();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        showFeedings();
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function showFeedings() as Void {
        var currentFeeding = Application.Storage.getValue("current_feeding");

        if(currentFeeding != null) {
            var feedingZero = self.findDrawableById("feedingZero") as WatchUi.Text;
            feedingZero.setText(currentFeeding);

            var feedingOneAgo = Application.Storage.getValue("feeding_one_ago");
            var feedingTwoAgo = Application.Storage.getValue("feeding_two_ago");

            var feedingOneLabel = self.findDrawableById("feedingOne") as WatchUi.Text;
            var feedingTwoLabel = self.findDrawableById("feedingTwo") as WatchUi.Text;

            if(feedingOneAgo != null) {
                feedingOneLabel.setText(feedingOneAgo);
            } else {
                feedingOneLabel.setText("");
            }

            if(feedingTwoAgo != null) {
                feedingTwoLabel.setText(feedingTwoAgo);
            } else {
                feedingTwoLabel.setText("");
            }
        }
    }
}
