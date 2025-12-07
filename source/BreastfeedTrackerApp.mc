import Toybox.Application;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class BreastfeedTrackerApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onActive(state as Dictionary or Null) as Void {

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {  
        var mobileSync = new MobileSync(method(:addFeedingFromPhone));
        mobileSync.sendFeedingsToPhone();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {}

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new MainView(), new MainDelegate()];
    }

    function getGlanceView() {
        return [new Glance()];
    }

    function addFeedingFromPhone(
        message as Communications.PhoneAppMessage
    ) as Void {
        var data = message.data as Dictionary<String, String>;
        var type = data["type"] as String or Null;
        var helper = new BreastfeedTrackerHelper();

        if(type == null) {
            return;
        }

        if(type.equals("ADD_FEEDING")) {
            var feedingType = data["feedingType"] as String;
            var feedingTypeChat = feedingType.toCharArray()[0];

            helper.trackFeeding(
                feedingTypeChat, 
                data["timestamp"] as Number
            );
        } else if(type.equals("CLEAR_FEEDINGS")) {
            helper.clearFeedings();
        } else if(type.equals("EDIT_FEEDING")) {
            var timestamp = data["previousTimestamp"] as Number;
            var newTimestamp = data["newTimestamp"] as Number;
            var feedingType = data["feedingType"] as String;

            helper.editFeeding(
                timestamp, 
                newTimestamp,
                feedingType.toCharArray()[0]
            );
        } else if(type.equals("DELETE_FEEDING")) {
            helper.deleteFeeding(
                data["timestamp"] as Number
            );
        }
    }
}

function getApp() as BreastfeedTrackerApp {
    return Application.getApp() as BreastfeedTrackerApp;
}
