/* Copyright 2017 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.3
import QtSensors 5.3

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Sql 1.0
import ArcGIS.AppFramework.Notifications 1.0
import ArcGIS.AppFramework.Notifications.Local 1.0
import ArcGIS.AppFramework.SecureStorage 1.0

//import Esri.ArcGISRuntime 100.2
//import Esri.ArcGISRuntime.Toolkit.Dialogs 100.2

import "./controls"
import "./Components"
//------------------------------------------------------------------------------
App {
    id: app
    width: 414
    height: 736

    property real scaleFactor: AppFramework.displayScaleFactor
    property bool autoRecord: app.info.propertyValue("autoRecord", false)
    property bool recordLocation: false
    property string unitsOfMeasure: "Metric"

    property int sqlTime1QueryProperty
    property int sqlTime2QueryProperty

    property string loginType: "AGOL"
    property string loggedInUser: ""

    property int timerInterval: app.settings.value("interval", 60000)
    property int timerInt: app.settings.value("interval") * 60

    property int distanceInterval: app.settings.value("distanceInterval", 10)
    property string progressColor: "yellow"


    property var body: {
        "f":"json",
                "referer" : "http://www.arcgis.com"
    }

    property var addFeatures: {
        "attributes" : {
        },
        "geometry" : {
            "spatialReference":{"latestWkid":4326,"wkid":4326},
            "x" : null,
            "y" : null
        }
    }

    property var addFeaturesArray : []

    ListModel {
    id: uploadModel
    ListElement {
        value: 60000
        textLabel: "1 minute"
    }
    ListElement {
        value: 120000
        textLabel: "2 minutes"
    }
    ListElement {
        value: 300000
        textLabel: "5 minutes"
    }
    ListElement {
        value: 600000
        textLabel: "10 minutes"
    }
    ListElement {
        value: 1800000
        textLabel: "30 minutes"
    }
    ListElement {
        value: 3600000
        textLabel: "1 hour"
    }
}


    FontLoader {
        id: robotoThin
        source: "./Roboto-Thin.ttf"
    }

    FontLoader {
        id: robotoMedium
        source: "./Roboto-Medium.ttf"
    }


    Timer {
        running: recordLocation
        interval: settings.value("uploadIntervalIndex", 60000)
        repeat: true

        onTriggered: {
            loader_addRequest.sourceComponent = component_addRequest;

            loader_addRequest.item.submit();
        }
    }

    //---------------------------POSITIONING SECTION------------------------//
    Compass {
        id: compass
        active: true
        property var myreading
        onReadingChanged: myreading = reading.azimuth
    }

    PositionSource {
        id: src
        active: true
        updateInterval: 5000

        onActiveChanged: notification.schedule("Postion Source", "active? " + active, 0)

        onSourceErrorChanged: {
            var errorString
            if(sourceError == PositionSource.AccessError){
                errorString = "AccessError - The connection setup to the remote positioning backend failed because the application lacked the required privileges";
            }
            else if (sourceError == PositionSource.ClosedError){
                errorString = "ClosedError - The positioning backend closed the connection, which happens for example in case the user is switching location services to off. As soon as the location service is re-enabled regular updates will resume."
            }
            else if (sourceError == PositionSource.UnknownSourceError){
                errorString = "UnknownSourceError - An unidentified error occurred."
            }
            else if (sourceError == PositionSource.UnknownSourceError){
                errorString = "SocketError - An error occurred while connecting to an nmea source using a socket."
            }

            notification.schedule("Source Error", errorString + " recordLocation? " + recordLocation + "\nGPS active: " + active + "\nRequest: " + loader_addRequest.status, 0)

            active = false;
            active = true;
        }

        property string dmsLon: ""
        property string dmsLat: ""

        onPositionChanged: {
            var device = AppFramework.device;
            var pos = src.position;
            var coord = pos.coordinate;

            //Set the compass reading
            if(compass.myreading === undefined)
                recordingPageContent.direction = 0;
            else
                recordingPageContent.direction = compass.myreading.toFixed(2);

            dmsLon = convertToDms(coord.longitude, true);
            dmsLat = convertToDms(coord.latitude, false);

            if(recordLocation == true){

                addFeatures.geometry.x = coord.longitude;
                addFeatures.geometry.y = coord.latitude;

                addFeatures.attributes.Longitude = coord.longitude;
                addFeatures.attributes.Latitude = coord.latitude;

                addFeatures.attributes.sog = recordingPageContent.speed;
                addFeatures.attributes.direction = recordingPageContent.direction;

                if (loginType == "AGOL") {
                    addFeatures.attributes.username = SecureStorage.value("username");
                }
                else if (loginType == "PUBLICSECURE"){
                    addFeatures.attributes.username = SecureStorage.value("username");
                }
                else {
                    addFeatures.attributes.username = app.settings.value("username");
                }

                addFeaturesArray.push(addFeatures)

                console.log(addFeaturesArray)

            }

        }

        function deg2rad(deg) {
            return deg * (Math.PI/180)
        }
    }

    function addService(position){
        if (position.latitudeValid && position.longitudeValid) {
            console.log(position.coordinate.longitude, loader_addRequest.readyState);

            if(loader_addRequest.readyState == 1 || loader_addRequest.readyState == 4) {
                console.log(loader_addRequest.readyState, "About to log");
                loader_addRequest.submit(position.coordinate);
            }
            else {
                console.log(loader_addRequest.readyState, "This won't get logged");
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Page {
            anchors.fill: parent

            contentItem: RecordingPageContent {
                id: recordingPageContent
                Rectangle {
                    color: "#ECEFF1"
                    z:-1
                }

                Rectangle {
                    visible: false
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right

                    }
                    color: "white"
                    height: app.height * 0.6



                    ListView {
                        id: listView
                        anchors.fill: parent

                        model: ListModel {
                            id: listModel
                        }

                        delegate: Text {
                            wrapMode: Text.WrapAnywhere
                            text: desc
                            anchors.left: parent.left
                            anchors.right: parent.right
                        }
                    }

                }
            }
        }

        Component {
            id: loginComponent
            LoginPageCompnent {
            }
        }

        Component {
            id: settingsComponent
            SettingsPageComponent {
            }
        }
    }

    StackView {
        id: loginStackView
        anchors.fill: parent

        initialItem: LoginStartPage {

        }
    }

    //----------------------------PORTAL SECTION-------------------------------//
    property string privateUrl: "https://services.arcgis.com/ZN2A4THMtsVQ15wW/ArcGIS/rest/services/Tracklog_Premium/FeatureServer/0/addFeatures"
    property string publicUrl: "https://services.arcgis.com/ZN2A4THMtsVQ15wW/ArcGIS/rest/services/Tracklog_Public/FeatureServer/0/addFeatures"

    // TODO: Move position bindings from the component to the Loader.
    //       Check all uses of 'parent' inside the root element of the component.
    //       Rename all outer uses of the id "addRequest" to "loader_addRequest.item".
    Component {
        id: component_addRequest
        AddRequest {
            id: addRequest
            url: loginType == "PUBLIC" ? publicUrl : privateUrl

            onReadyStateChanged: {
                if (readyState == NetworkRequest.DONE){
                    if (errorCode ===0) {
                        if (status == NetworkRequest.StatusCodeOK){
                            console.log(JSON.stringify(response))

                            if(response.hasOwnProperty("error")){
                                notification.schedule("Request error: " + response.error.code, response.error.details, 0)
                            }
                            else {
                                console.log("success! Object ID:", JSON.stringify(response));
                                addFeaturesArray = [];
                                loader_addRequest.sourceComponent = undefined;
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
        }

    }

    Loader {
        id: loader_addRequest

//        onProgressChanged: console.log("loader progress", progress)
    }

    property string messageString : ""

    NetworkRequest {
        id: checkTagRequest
        method: "POST"
        responseType: "JSON"
        url: "https://services.arcgis.com/ZN2A4THMtsVQ15wW/ArcGIS/rest/services/Tracklog_Public/FeatureServer/0/query"

        onReadyStateChanged: {
            if(readyState == NetworkRequest.DONE){
                if(status == 200){
                    console.log(response,"...")
                    var count = response.count;
                    if(count > 0)
                        messageString = count + " feature(s) already exist with tag.";
                    else {
                        messageString = "This tag has not been used."
                        messageLabel.color = "#00695C"
                    }
                }
            }
        }

        function submit(usernamevalue){
            var queryBody = {};
            queryBody.where = "username = '" + usernamevalue + "'";
            queryBody.returnCountOnly = true;
            queryBody.f = "json"
            console.log("queryBody", JSON.stringify(queryBody))
            send(queryBody);
        }
    }

    NetworkRequest {
        id: generateTokenRequest
        method: "POST"
        responseType: "JSON"
        url: "https://www.arcgis.com/sharing/rest/generateToken"

        property string usernameTxt
        property string passwordTxt

        onReadyStateChanged: {
            if(readyState == NetworkRequest.DONE){
                if(status == 200){
                    //                    var jsonObj = response;
                    //                    var jsonObj = JSON.parse(response);
                    var myKeys = Object.keys(response);

                    console.log("JSON REQUEST", JSON.stringify(response))

                    //If successful
                    if (myKeys.indexOf("token") !== -1){
                        app.settings.setValue("token", response.token);
                        app.settings.setValue("tokenExpiry", response.expires);

                        SecureStorage.setValue("username", usernameTxt);
                        SecureStorage.setValue("password", passwordTxt);

                        joinGroupRequest.submit(response.token);

                        getPortalUserInfoRequest.submit(usernameTxt, response.token);
                    }
                    //If not
                    else if(myKeys.indexOf("error") !== -1){
                        console.log(response.error.details[0])

                        messageString = response.error.details[0]
                    }
                }
            }
        }

        function submit(usernametxt, passtxt){
            body.username = usernametxt;
            usernameTxt  = usernametxt;
            passwordTxt = passtxt;
            console.log("agol send", JSON.stringify(body))
            send(body);
        }
    }

    NetworkRequest {
        id: joinGroupRequest
        method: "POST"
        responseType: "JSON"
        url: "https://www.arcgis.com/sharing/rest/community/groups/885e586bf74e42ac898570a27a5d2a19/join"

        onReadyStateChanged: {
            if(readyState == NetworkRequest.DONE){
                if(status == 200){
                    console.log(JSON.stringify(response))

                    var jsonObj = response;
                    var myKeys = Object.keys(jsonObj);

                    if (myKeys.indexOf("success") == -1){
                        console.log("Error...", response.error.messageCode)
                        ////Check the error as "errors ain't errors!

                        ////COM_0010 is the code for: user already exists in group
                        if (response.error.messageCode === "COM_0010" ){
                            loginStackView.pop();
                            loginStackView.visible = false;
                            loginStackView.enabled = false;
                        }

                        ////COM_1045 states the public account can't be added to an org's group
                        if (response.error.messageCode === "COM_1045"){
                            app.loginType = "PUBLICSECURE";
                            loginStackView.pop();
                            loginStackView.visible = false;
                            loginStackView.enabled = false;
                        }
                    }
                    else {
                        loginStackView.pop();
                        loginStackView.visible = false;
                        loginStackView.enabled = false;
                    }
                }
            }
        }

        function submit(token){
            body.token = token;
            console.log(JSON.stringify(body),"...Group")
            send(body);
        }
    }

    NetworkRequest {
        id: getPortalUserInfoRequest
        method: "POST"
        responseType: "JSON"
        ignoreSslErrors: true

        onReadyStateChanged: {
            if(readyState == NetworkRequest.DONE){

                console.log(response)
                if(status == 200){
                    console.log(JSON.stringify(response, undefined, 2));
                    addFeatures.attributes.orgId = response.orgId;
                    app.unitsOfMeasure = response.units
                }
            }

        }

        function submit(user, token){
            url = "http://www.arcgis.com/sharing/rest/community/users/" + user

            console.log(url)
            var infobody = {
                f: "json",
                token: token
            }

            console.log(JSON.stringify(infobody),"...Info")

            send(body);
        }
    }

    //----------------------------END PORTAL SECTION-------------------------------//

    //----------------------------END Local Notification SECTION-------------------------------//

    LocalNotification {
        id: notification
    }

    //----------------------------END Local Notification SECTION-------------------------------//

    Component.onCompleted: {

        console.log("update index",  settings.value("uploadIntervalIndex"))

        listModel.append({"desc": "Hello, component completed"})

        if(!app.settings.value("featureServiceURL"))
            app.settings.setValue("featureServiceURL", app.info.propertyValue("featureServiceURL"));

        if (!app.settings.value("interval"))
            app.settings.setValue("interval", 0.5);

        //timer.interval = app.settings.value("interval") * 60000

        console.log("onStartup", SecureStorage.value("username"))

        console.log(Date.now(), app.settings.value("tokenExpiry"))
        var tokenValid = false;
        if ( Date.now() < app.settings.value("tokenExpiry")){
            tokenValid = true;
        }

        console.log(tokenValid)
        if(SecureStorage.value("username") > "" && tokenValid){
            notification.schedule("Already logged in", "Let's start tracking.", 0)
            // generateTokenRequest();
            loginStackView.visible = false
        }

    }


    onOpenUrl: {
        var urlInfo = AppFramework.urlInfo(url); //refer to AppFramework documentation for all properties
        var openParameters = urlInfo.queryParameters;

        if (openParameters.hasOwnProperty("test")) {
            notification.schedule("urlscheme","property found: " + openParameters.test, 0)
            //do something with openParameters.latitude
        }
        else {
            notification.schedule("urlscheme","No property found", 0)
        }
    }

    function startStopRecording(){
        recordLocation = !recordLocation;

        if (recordLocation) {
            //timer.running = true;
            notification.schedule("Started", "You are now recording your location.", 100)
        }
        else {
            // timer.running = false;
            notification.schedule("Stopped", "You have stopped recording your location.", 100)
        }
    }

    function convertToDms(dd, isLng) {
        var dir = dd < 0 ? isLng ? 'W':'S' : isLng ? 'E' : 'N';

        if (dd < 0){
            dd = dd * -1
        }
        var frac = (dd - parseInt(dd));
        var min1 = frac * 60;
        var min2 = parseInt(min1);
        var sec = (min1 - min2)
        var sec2 = (sec * 60).toFixed(4)

        return parseInt(dd) + "° " + min2 + "' " + sec2 + '" ' + dir;
    }
}

//------------------------------------------------------------------------------
