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

import "../Components"

//------------------------------------------------------------------------------
ColumnLayout {
    id: recordingColumnLayout
    anchors.fill: parent

//    property alias speed: speedText.text
    property double direction: 0

    spacing: 3

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        color: "#00b894"

        RowLayout {
            id: rowLayout
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
            }

            Image {
                source: "../images/settings (2).png"
                enabled: !recordLocation
                Layout.preferredHeight:  parent.height * 0.75
                Layout.preferredWidth: parent.height * 0.75
                mipmap: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.push(settingsComponent)
                }
            }
            Item {
                Layout.fillWidth: true
            }
            Image {
               source: "../images/map-location.png"
               Layout.preferredHeight:  parent.height * 0.75
               Layout.preferredWidth: parent.height * 0.75
               mipmap: true

               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       var querystring = encodeURI( app.settings.value("username") )
                       var mapUrl;
                       console.log(querystring)
                       if(app.loginType ==="AGOL"){
                           mapUrl = "http://esriaus.maps.arcgis.com/apps/View/index.html?appid=1b2ee88b67ef4b16a282b03e5adacf32"
                       }
                       else {
                           mapUrl = "http://www.arcgis.com/apps/webappviewer/index.html?id=67192c1e37bb42f5b331f93eccde5f85&query=Tracklog_Public_3731%2CUsername%2C" + querystring
                       }
                       Qt.openUrlExternally(mapUrl);
                   }
               }
            }
            Item {
                Layout.fillWidth: true
            }
            Image {
                source: "../images/user (2).png"
                enabled: !recordLocation

                Layout.preferredHeight:  parent.height * 0.75
                Layout.preferredWidth: parent.height * 0.75
                mipmap: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        loginStackView.visible = true;
                        loginStackView.enabled = true;
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }


    Item {
        Layout.preferredHeight: 30
    }

    CompassComponent {
        Layout.preferredWidth:  parent.width *0.5
        Layout.preferredHeight: parent.width *0.5
        Layout.maximumWidth: 250
        Layout.maximumHeight: 250
        Layout.alignment: Qt.AlignHCenter
        bearing: direction
    }


    Item {
        Layout.fillHeight: true
    }
    
//    Label {
//        id: speedText
//        color: "#263238"
//        Layout.alignment: Qt.AlignCenter
//        font{
//            pixelSize: 100
//            family: robotoMedium.name
//        }
//        text: speed
//    }

    ColumnLayout {
        id: coordPanel

        Layout.alignment: Qt.AlignHCenter

        spacing: 5

        Text{
            text: convertToDms(src.position.coordinate.longitude.toFixed(6), true)
            font{
                pixelSize: 30
                family: robotoThin.name
            }
            Layout.alignment: Qt.AlignHCenter
            color: "#263238"
        }

        Text{
            text: convertToDms(src.position.coordinate.latitude.toFixed(6), false)
            font{
                pixelSize: 30
                family: robotoThin.name
            }
            Layout.alignment: Qt.AlignHCenter
            color: "#263238"
        }

    }


    Item {
        Layout.preferredHeight: 30
    }

    Button {
        id: captureButton
        width: 250
        height: 100
        Layout.alignment: Qt.AlignHCenter

        style: ButtonStyle{
            background: Image {
                source: recordLocation ? "../images/stop.png" : "../images/play-button.png"
            }
        }

        onClicked: {
            console.log("button clicked", recordLocation );

            startStopRecording();

        }
    }

    Item {
        Layout.fillHeight: true
    }
}
