using Toybox.Application;
using Toybox.Communications;
import Toybox.Lang;
using Toybox.System;

(:glance)
class MobileSync {
    private static var instance as MobileSync or Null = null;

    private function initialize() {
        Communications.registerForPhoneAppMessages(method(:handleMessageFromPhone));
    }

    static function getInstance() as MobileSync{
        if (instance == null) {
            instance = new MobileSync();
        }
        
        return instance;
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

    function handleMessageFromPhone(
        message as Communications.PhoneAppMessage
    ) as Void {
        var data = message.data as Dictionary<String, String>;
        var type = data["type"] as String or Null;
        var helper = new BreastfeedTrackerHelper();

        if(type == null) {
            return;
        }

        if(type.equals("ADD_FEEDING")) {
            var feedingType = data["feedingType"] as String;
            var feedingTypeChat = feedingType.toCharArray()[0];

            helper.trackFeeding(
                feedingTypeChat, 
                data["timestamp"] as Number
            );
        } else if(type.equals("CLEAR_FEEDINGS")) {
            helper.clearFeedings();
        } else if(type.equals("EDIT_FEEDING")) {
            var timestamp = data["previousTimestamp"] as Number;
            var newTimestamp = data["newTimestamp"] as Number;
            var feedingType = data["feedingType"] as String;

            helper.editFeeding(
                timestamp, 
                newTimestamp,
                feedingType.toCharArray()[0]
            );
        } else if(type.equals("DELETE_FEEDING")) {
            helper.deleteFeeding(
                data["timestamp"] as Number
            );
        }
    }
}
