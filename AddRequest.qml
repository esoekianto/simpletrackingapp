import QtQuick 2.7
import ArcGIS.AppFramework 1.0

//import Esri.ArcGISRuntime 100.2
//import Esri.ArcGISRuntime.Toolkit.Dialogs 100.2

import "./controls"
import "./Components"
//------------------------------------------------------------------------------
NetworkRequest {
    id: addRequest
    
    responseType: "JSON"
    method: "POST"
    
    onReadyStateChanged: {
        if (readyState == NetworkRequest.DONE){
            if (errorCode ===0) {
                if (status == NetworkRequest.StatusCodeOK){
                    console.log(JSON.stringify(response))
                    
                    if(response.hasOwnProperty("error")){
                        notification.schedule("Request error: " + response.error.code, response.error.details, 0)
                    }
                    else {
                        console.log("success! Object ID:", JSON.stringify(response))
                        addFeaturesArray = [];

                    }
                }
                else {
                    console.log("Responded but status code =", status);
                    notification.schedule("REQUEST DONE...", JSON.stringify(response), 0)
                }
            }
        }
    }
    
    onError: {
        notification.schedule("ERROR", errorCode + ": " + errorText, 0)
        console.log("ERROR:", errorCode, errorText)
    }
    
    onErrorTextChanged: console.log("ErrorText", errorCode + ": " + errorText, status, readyState)
    
    onStatusChanged: {
        if(status != 0 && status !== NetworkRequest.StatusCodeOK){
            console.log("STATUS:", status);
            notification.schedule("BAD STATUS". status, 0);
        }
    }
    
    function submit(){
        var body = {
            f: "json"
        }
        
        if (loginType == "AGOL") {
            body.token = app.settings.value("token");
        }
        else if (loginType == "PUBLICSECURE"){
            body.token = app.settings.value("token");
        }
        
        body.features = JSON.stringify(addFeaturesArray);
        
        console.log(JSON.stringify(body), "....PublicBody", loginType)
        send(body);
    }

    Component.onCompleted: console.log("In the dynamic requester")
}
