import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class SyncView extends WatchUi.View {
    var pairingCode as String;

    function initialize(pairingCode as String) {
        self.pairingCode = pairingCode;

        View.initialize();

        (new DeviceIsPairedRequest()).handle();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.SyncLayout(dc));
    }

    function onShow() as Void {}

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var pairingCodeLabel =
            self.findDrawableById("PairingCode") as WatchUi.Text;

        pairingCodeLabel.setText(self.pairingCode);
    }
}
