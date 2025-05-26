import Toybox.Lang;
import Toybox.WatchUi;

class BreastfeedTrackerDelegate extends WatchUi.BehaviorDelegate {
  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() as Boolean {
    WatchUi.pushView(
      new Rez.Menus.MainMenu(),
      new BreastfeedTrackerMenuDelegate(),
      WatchUi.SLIDE_UP
    );
    return true;
  }

  function onKey(keyEvent) as Boolean {
    if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
      WatchUi.pushView(
        new Rez.Menus.MainMenu(),
        new BreastfeedTrackerMenuDelegate(),
        WatchUi.SLIDE_UP
      );
      return true;
    }

    if (keyEvent.getKey() == WatchUi.KEY_ESC) {
      WatchUi.popView(WatchUi.SLIDE_DOWN);
      return true;
    }

    return true;
  }

  function onTap(clickEvent) as Boolean {
    var deviceWidth = System.getDeviceSettings().screenWidth;
    var deviceHeight = System.getDeviceSettings().screenHeight;
    var helper = new BreastfeedTrackerHelper();

    if (clickEvent.getType() == WatchUi.CLICK_TYPE_TAP) {
      var x = clickEvent.getCoordinates()[0];
      var y = clickEvent.getCoordinates()[1];

      // Ignore bottom half of the screen
      if (y > deviceHeight / 2) {
        return true;
      }

      // We can imagine a triangle from the topleft, to the centerright, to the bottomleft.
      // We need to determine for Left and Right if it's in the triangle or not.
      // If it's not in the triangle, it's a bottle.
      // One exception: the triangle starts at 10% and 90% of the screen width
      // This is however part for left/right, so we need to check for that first.
      if (
        x < deviceWidth * 0.1 ||
        PointInTriangle(
          x,
          y,
          deviceWidth * 0.1,
          0,
          deviceWidth / 2,
          deviceHeight / 2,
          deviceWidth * 0.1,
          deviceHeight / 2
        )
      ) {
        helper.trackFeeding('l');
      } else if (
        x > deviceWidth * 0.9 ||
        PointInTriangle(
          x,
          y,
          deviceWidth * 0.9,
          0,
          deviceWidth / 2,
          deviceHeight / 2,
          deviceWidth * 0.9,
          deviceHeight / 2
        )
      ) {
        helper.trackFeeding('r');
      } else {
        helper.trackFeeding('b');
      }

      WatchUi.requestUpdate();
      return true;
    }

    return true;
  }

  // https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
  function sign(x1, y1, x2, y2, x3, y3) {
    return (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3);
  }

  function PointInTriangle(tapx, tapy, x1, y1, x2, y2, x3, y3) {
    var d1 = sign(tapx, tapy, x1, y1, x2, y2);
    var d2 = sign(tapx, tapy, x2, y2, x3, y3);
    var d3 = sign(tapx, tapy, x3, y3, x1, y1);

    var has_neg = d1 < 0 || d2 < 0 || d3 < 0;
    var has_pos = d1 > 0 || d2 > 0 || d3 > 0;

    return !(has_neg && has_pos);
  }
}
