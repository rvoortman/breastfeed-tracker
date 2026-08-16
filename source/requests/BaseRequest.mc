import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

// TODO: Make this an abstract class (for URL and stuff. )
// TODO: Make more requests to fetch feedings
// TODO: Make more requests to POST feedings
class BaseRequest {
    var baseUrl as String = "http://localhost:8000/api/";

    function doRequest(
        endpoint as String,
        params as Dictionary,
        method
    ) as Void {
        var url = baseUrl + endpoint;

        System.println("Requesting: " + url);

        var options = {
            :method => method,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
        };
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        System.println("Response: " + responseCode);
    }
}
