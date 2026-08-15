import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class EnableSyncConfirmationDelegate extends WatchUi.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) as Boolean {
        if (response != WatchUi.CONFIRM_NO) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Pop the confirmation view
            
            var progressBar = new WatchUi.ProgressBar(
                "Get pairing code",
                null
            );
            
            WatchUi.pushView(
                progressBar,
                null,
                WatchUi.SLIDE_IMMEDIATE
            );

            new PairDeviceRequest().handle();
        }

        return false;
    }
}
