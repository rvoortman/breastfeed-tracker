import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class FetchApiTokenRequest extends BaseRequest {
    var requestToken as String;
    function initialize(requestToken as String) {
        BaseRequest.initialize();
        self.requestToken = requestToken;
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            var apiToken = data.get("api_token") as String;
            Application.Storage.setValue("api_token", apiToken);

            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.showToast("Device paired!", {});
        }
    }

    function handle() as Void {
        var params = {
            "device_identifier" => System.getDeviceSettings().uniqueIdentifier,
            "request_token" => self.requestToken,
        };

        doRequest(
            "devices/pair/token",
            params,
            Communications.HTTP_REQUEST_METHOD_POST
        );
    }
}
