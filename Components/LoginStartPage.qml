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
Page {
    contentItem: Rectangle {
        color: "#ECEFF1"

        ColumnLayout {
            anchors.fill: parent

            Rectangle {
                width: 100
                height: width
                radius: width * 0.5
                Layout.alignment: Qt.AlignHCenter
                color: "#00FFFFFF" //"#607D8B"

                Label {
                    anchors.centerIn: parent
                    color: "#607D8B" // "white"
                    font{
                        pixelSize: 30
                        family: robotoThin.name
                    }
                    text: "Sign in to start tracking"
                }
            }

            Item {
                Layout.preferredHeight: 100
            }

            Button {
                text: "ArcGIS Online"
                onClicked: {
                    app.loginType = "AGOL";
                    loginStackView.push({item: loginComponent});

                }
                Layout.preferredWidth: 350
                Layout.preferredHeight: 50
                Layout.maximumWidth: 450
                Layout.alignment: Qt.AlignHCenter

                style: ButtonStyle {
                    background: Rectangle {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#00695C"
                        radius: 2
                        color: "#00b894"

                    }
                    label: Component {
                        Label {
                            text: "ArcGIS Online"
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                            color: "white"
                            font{
                                pixelSize: 20
                                family: robotoMedium.name
                            }
                        }
                    }
                }

            }

            
            Item {

                Layout.preferredHeight: 35
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                color: "#607D8B" // "white"
                font{
                    pixelSize: 30
                    family: robotoThin.name
                }
                text: "Or"
            }

            Item {

                Layout.preferredHeight: 35
            }
            
            Button {
                onClicked: {
                    app.loginType = "PUBLIC";
                    loginStackView.push({item: loginComponent});
                }
                Layout.preferredWidth: 350
                Layout.preferredHeight: 50
                Layout.maximumWidth: 450
                Layout.alignment: Qt.AlignHCenter

                style: ButtonStyle {
                    background: Rectangle {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#00695C"
                        radius: 2
                        color: "#00b894"

                    }
                    label: Component {
                        Label {
                            text: "Use the free version. Yes, FREE!"
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                            color: "white"
                            font{
                                pixelSize: 20
                                family: robotoMedium.name
                            }
                        }
                    }
                }

            }
            
            Item {
                Layout.preferredHeight: 100
            }

            Label {
                text: "Want an ArcGIS account?"
                color: "#263238"
                wrapMode: Text.WordWrap
                font{
                    pixelSize: 30
                    family: robotoThin.name
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        Qt.openUrlExternally("https://www.arcgis.com/features/free-trial.html")
                    }
                }

                Layout.alignment: Qt.AlignHCenter
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
