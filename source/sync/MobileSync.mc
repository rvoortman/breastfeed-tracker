using Toybox.Application;
using Toybox.Communications;
using Toybox.System;

(:glance)
class MobileSync {
    function initialize(callback) {
        Communications.registerForPhoneAppMessages(callback);
    }

    function sendFeedingsToPhone() as Void {
        var helper = new BreastfeedTrackerHelper();
        var feedings = helper.getFeedings();
        
        var feedingMessage = "";
        for (var i = 0; i < feedings.size(); i++) {
            var feeding = feedings[i];

            feedingMessage += 
            "ADD_FEEDING," + 
            feeding["timestamp"].toString() + "," + 
            feeding["type"]+ "\n";            
        }

         Communications.transmit(
            feedingMessage,
            null,
            new Communications.ConnectionListener()
        );
    }
}
