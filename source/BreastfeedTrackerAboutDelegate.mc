import Toybox.Lang;
import Toybox.WatchUi;

class BreastfeedTrackerAboutDelegate extends WatchUi.BehaviorDelegate {
  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() as Boolean {
    return true;
  }

  function onKey(keyEvent) as Boolean {
    if (keyEvent.getKey() == WatchUi.KEY_ESC) {
      WatchUi.popView(WatchUi.SLIDE_DOWN);
      return true;
    }

    return true;
  }

  function onTap(clickEvent) as Boolean {
    if (clickEvent.getType() == WatchUi.CLICK_TYPE_TAP) {
      WatchUi.popView(WatchUi.SLIDE_DOWN);
      return true;
    }

    return true;
  }
}
