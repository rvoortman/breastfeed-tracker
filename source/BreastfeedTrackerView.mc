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
        // Draw the horizontal line
        dc.drawLine(0, dc.getHeight() / 2, dc.getWidth(), dc.getHeight() / 2);

        // Draw the left diagonal line
        dc.drawLine(dc.getWidth() * 0.1, 0, dc.getWidth() / 2, dc.getHeight() / 2);

        // Draw the right diagonal line
        dc.drawLine(dc.getWidth() * 0.9, 0, dc.getWidth() / 2, dc.getHeight() / 2);


        var babyBottleBitmap = new WatchUi.Bitmap({
            :rezId => Rez.Drawables.BabyBottle,
        });

        var babyBottleWithCorrectLocation = new WatchUi.Bitmap({
            :rezId => Rez.Drawables.BabyBottle,
            :locX => dc.getWidth() / 2 - babyBottleBitmap.getDimensions()[0] / 2,
            :locY => dc.getHeight() * 0.13,
        });

        babyBottleWithCorrectLocation.draw( dc );
    }

    function showFeedings() as Void {
        try {
            var feedingHelper = new BreastfeedTrackerHelper();
            var feedings = feedingHelper.getFeedings();
            
            if(feedings.size() > 0) {
                var currentFeeding = feedings[feedings.size() - 1];
                var secondFeeding = feedings.size() > 1 ? feedings[feedings.size() - 2] : null;
                var thirdFeeding = feedings.size() > 2 ? feedings[feedings.size() - 3] : null;

                var feedingZero = self.findDrawableById("feedingZero") as WatchUi.Text;
                feedingZero.setText(feedingHelper.formatFeeding(currentFeeding));

                var feedingOneLabel = self.findDrawableById("feedingOne") as WatchUi.Text;
                var feedingTwoLabel = self.findDrawableById("feedingTwo") as WatchUi.Text;

                feedingOneLabel.setText(feedingHelper.formatFeeding(secondFeeding));
                feedingTwoLabel.setText(feedingHelper.formatFeeding(thirdFeeding));
            }
             
        } catch (ex) {
            Application.Storage.setValue("previousError", ex.getErrorMessage());
        }
    }
}
