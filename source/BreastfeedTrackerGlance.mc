import Toybox.Graphics;
using Toybox.WatchUi;

(:glance)
class BreastfeedTrackerGlance extends WatchUi.GlanceView {
	
    function initialize() {
      GlanceView.initialize();
    }

    // onShow() is called when this View is brought to the foreground
    function onShow() {
        showFeedings();
    }

    // onUpdate() is called periodically to update the View
    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.GlanceLayout(dc));
    }

    // onHide() is called when this View is removed from the screen
    function onHide() {
    }


    function showFeedings() as Void {
        var currentFeeding = Application.Storage.getValue("current_feeding");

        if(currentFeeding != null) {
            var feedingZero = self.findDrawableById("GlanceFeedingOne") as WatchUi.Text;
            feedingZero.setText(currentFeeding);

            var feedingOneAgo = Application.Storage.getValue("feeding_one_ago");
            var feedingOneLabel = self.findDrawableById("GlanceFeedingTwo") as WatchUi.Text;

            if(feedingOneAgo != null) {
                feedingOneLabel.setText(feedingOneAgo);
            } else {
                feedingOneLabel.setText("");
            }
        }
    }
}