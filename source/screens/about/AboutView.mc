import Toybox.Graphics;
import Toybox.WatchUi;

class AboutView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.AboutLayout(dc));
    }

    function onShow() as Void {}

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }
}
