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

import "../controls"
//------------------------------------------------------------------------------
Page {
    contentItem: Rectangle {
        color: "#CFD8DC"

        Rectangle {
            id: toolbar
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            color: "#607D8B"

            Image {
                source: "../images/ic_close_black_24dp.png"
                anchors.right: parent.right
                anchors.rightMargin: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.pop()
                }
            }
        }
        
        ColumnLayout {
            spacing:0
            anchors {
                top: toolbar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            Item {
                Layout.preferredHeight: 30
            }

            Label {
                text: "Feature Service URL"
                Layout.fillWidth: true
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                font{
                    pixelSize: 20
                    family: robotoThin.name
                }
                visible: app.loginType == "AGOL"
            }
            TextField {
                id: fsurlText
                text: app.settings.value("featureServiceURL", app.info.propertyValue("featureServiceURL"))
                enabled: app.loginType === "AGOL"
                visible: enabled

                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                font{
                    pixelSize: 20
                    family: robotoThin.name
                }
                style: TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        radius: 2
                        implicitWidth: 100
                        implicitHeight: 40
                        border.color: "#333"
                        border.width: 1
                    }
                }
                onTextChanged: {
                    app.settings.setValue("featureServiceURL", text)
                }
            }

            Item {
                Layout.preferredHeight: 30
            }

            
            Label {
                text: "Distance interval (metres)"
                Layout.fillWidth: true
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                font{
                    pixelSize: 20
                    family: robotoThin.name
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.rightMargin: 10
                Layout.leftMargin: 10

                TextField {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50

                    text: app.settings.value("distanceInterval", 10)
                    inputMethodHints: Qt.ImhDigitsOnly

                    font{
                        pixelSize: 20
                        family: robotoThin.name
                    }
                    style: TextFieldStyle {
                        textColor: "black"
                        background: Rectangle {
                            radius: 2
                            implicitWidth: 100
                            implicitHeight: 40
                            border.color: "#333"
                            border.width: 1
                        }
                    }

                    onTextChanged: app.settings.setValue("distanceInterval",(Number(text)))
                }
                Item {
                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.fillHeight: true
            }

            GridView {
                Layout.fillWidth: true
                Layout.maximumWidth: 400
                Layout.preferredHeight: 800
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.alignment: Qt.AlignHCenter

                cellHeight: 100
                cellWidth:  100
                model: uploadModel

                delegate: Button {
                    width: 75
                    height: 50
                    text: textLabel

                }


            }
        }
    }
}
