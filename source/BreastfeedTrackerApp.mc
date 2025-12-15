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
        MobileSync.getInstance().sendFeedingsToPhone();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {}

    (:typecheck(false)) // The mainview and maindelegates are not in the glance
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var mainView = new MainView();
        var mainDelegate = new MainDelegate();
        
        return [mainView, mainDelegate];
    }

    function getGlanceView() {
        return [new Glance()];
    }
}

function getApp() as BreastfeedTrackerApp {
    return Application.getApp() as BreastfeedTrackerApp;
}
