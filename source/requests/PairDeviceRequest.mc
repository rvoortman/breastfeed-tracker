import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class PairDeviceRequest extends BaseRequest {
    function initialize() {
        BaseRequest.initialize();
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        if (responseCode == 200) {
            var pairingCode = data.get("pairing_code") as String;
            WatchUi.pushView(new SyncView(pairingCode), new SyncDelegate(), WatchUi.SLIDE_UP);
        } else {
            // TODO: Handle error case with a message to the user
        }
    }

    function handle() as Void {
        var progressBar = new WatchUi.ProgressBar(
            "Get pairing code",
            null
        );
        
        WatchUi.pushView(
            progressBar,
            null,
            WatchUi.SLIDE_IMMEDIATE
        );

        var params = {
            "name" => System.getDeviceSettings().partNumber,
            "manufacturer" => "Garmin",
            "model" => System.getDeviceSettings().partNumber,
            "device_identifier" => System.getDeviceSettings().uniqueIdentifier,
            "device_app_version" => WatchUi.loadResource(Rez.Strings.AppVersion),
            "device_os_version" => Lang.format("$1$.$2$", System.getDeviceSettings().firmwareVersion),
        };

        doRequest("devices/pair", params, Communications.HTTP_REQUEST_METHOD_POST);
    }
}
