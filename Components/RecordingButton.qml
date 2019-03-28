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


//------------------------------------------------------------------------------
Rectangle {
    id: recordingButton

    width: 50
    height: width
    radius: width * 0.5
    color: "white"
    anchors{
        left: parent.left
        top: parent.top
        leftMargin: 10
        topMargin: 10
    }
    Rectangle {
        width: 46
        height: width
        radius: width * 0.5
        color: "#d32f2f"
        anchors.centerIn: parent
    }
    SequentialAnimation {
        loops: Animation.Infinite
        alwaysRunToEnd: true
        running: true

        ScaleAnimator {
            target: recordingButton
            from: 0.75;
            to: 1;
            duration: 1000
        }
        
        ScaleAnimator {
            target: recordingButton
            from: 1;
            to: 0.75;
            duration: 1000
        }
    }
}
