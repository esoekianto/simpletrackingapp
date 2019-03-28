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

import Esri.ArcGISRuntime 100.1
import Esri.ArcGISRuntime.Toolkit.Dialogs 100.1

import "./controls"
import "./Components"
//------------------------------------------------------------------------------
Rectangle {
    property alias text: txt.text

    border.color: "#0D47A1"
    border.width: 3
    height: 50
    radius: 10
    width: 200

    Text {
        id: txt
        anchors.centerIn: parent
        //text: myUser.username > "" ? "Sign out" : "Connect account"
        font {
            pixelSize: 11 * app.scaleFactor
            family: "Aerial"
            bold: true
        }
    }

}
