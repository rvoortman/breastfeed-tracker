using Toybox.Application;
using Toybox.Communications;
import Toybox.Lang;
using Toybox.System;

(:glance)
class MobileSync {
    function initialize(callback as Communications.PhoneMessageCallback) {
        Communications.registerForPhoneAppMessages(callback);
    }

    function sendFeedingsToPhone() as Void {
        var helper = new BreastfeedTrackerHelper();
        var feedings = helper.getFeedings();
        
        var feedingMessage = "";
        for (var i = 0; i < feedings.size(); i++) {
            var feeding = feedings[i];
            var timestamp = feeding["timestamp"] as Number;
            var type = feeding["type"] as Char;

            feedingMessage += 
                "ADD_FEEDING," + 
                timestamp.toString() + "," + 
                type.toString() + "\n";            
        }

         Communications.transmit(
            feedingMessage,
            null,
            new Communications.ConnectionListener()
        );
    }
}
