import Toybox.Graphics;
import Toybox.WatchUi;

class BreastfeedTrackerView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
        showFeedings();
    }

    function onUpdate(dc as Dc) as Void {
        showFeedings();

        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawLine(0, dc.getHeight() / 2, dc.getWidth(), dc.getHeight() / 2);
        dc.drawLine(0, dc.getHeight() * 0.27, dc.getWidth(), dc.getHeight() * 0.27);
        dc.drawLine(dc.getWidth() / 2, dc.getHeight() * 0.27, dc.getWidth() / 2, dc.getHeight() / 2);
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
