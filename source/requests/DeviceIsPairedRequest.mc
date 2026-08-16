import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class DeviceIsPairedRequest extends BaseRequest {
    function initialize() {
        BaseRequest.initialize();
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            var isPaired = data.get("is_paired") as Boolean;

            if (isPaired) {
                var requestToken = data.get("request_token") as String;
                (new FetchApiTokenRequest(requestToken)).handle();
            } else {
                // Check again in 5 seconds if the device is not paired.
                var reschedulePairTimer = new Timer.Timer();
                reschedulePairTimer.start(method(:handle), 5000, false);
            }
        } else {
            // Check again in 15 seconds if there was an error.
            var reschedulePairTimer = new Timer.Timer();
            reschedulePairTimer.start(method(:handle), 15000, false);
        }
    }

    function handle() as Void {
        var params = {
            "device_identifier" => System.getDeviceSettings().uniqueIdentifier,
        };

        doRequest(
            "devices/pair",
            params,
            Communications.HTTP_REQUEST_METHOD_GET
        );
    }
}
