import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.3
import QtSensors 5.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Sql 1.0
import ArcGIS.AppFramework.Notifications 1.0
import ArcGIS.AppFramework.Notifications.Local 1.0
import ArcGIS.AppFramework.SecureStorage 1.0

import Esri.ArcGISRuntime 100.1
import Esri.ArcGISRuntime.Toolkit.Dialogs 100.1

//------------------------------------------------------------------------------
Page {
    contentItem : Item {
        ColumnLayout {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: 20
                rightMargin: 20
            }

            Item {
                Layout.preferredHeight: 35
            }

            Label {
                id: messageLabel
                font{
                    pixelSize: 20
                    family: robotoThin.name
                }
                text: messageString
            }

            TextField {
                id: usernameText
                placeholderText: app.loginType === "AGOL" ? "ArcGIS Online Username" : "Enter a tag for your track"
                text: app.loginType === "PUBLIC" ? app.settings.value("username") : ""
                onTextChanged: {
                    messageString = "";
                    if(app.loginType === "PUBLIC" && text > "" )
                        messageString = checkTagRequest.submit(text);

                    if(text == "") {
                        messageString = "";
                    }
                }
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.maximumWidth: 450

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

                        BusyIndicator {
                            id:checkNameBusy
                            running: checkTagRequest.readyState == NetworkRequest.ReadyStateSending | checkTagRequest.readyState == NetworkRequest.ReadyStateProcessing
                            visible: running
                            width: 35
                            height: 35
                            anchors {
                                verticalCenter: parent.verticalCenter
                                rightMargin: 5
                                right: parent.right
                            }
                        }
                    }
                }

                Image {
                    source: "../images/ic_close_black_24dp.png"
                    width: 35
                    height: 35
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 5

                    }
                    MouseArea {
                        preventStealing: true
                        anchors.fill: parent
                        onClicked: usernameText.text = ""
                    }
                    z:5
                }
            }

            Item {
                Layout.preferredHeight: 30
            }

            TextField {
                id: passwordText
                placeholderText: "Password"
                echoMode: TextInput.Password
                enabled: app.loginType == "AGOL"
                visible: enabled
                onTextChanged: {
                    messageLabel.text = "";
                    body.password = text;
                }
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.maximumWidth: 450
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
            }

            Item {
                Layout.preferredHeight: 20
            }

            Button {
                text: "login"
                onClicked: {
                    if(app.loginType == "AGOL")
                        generateTokenRequest.submit(usernameText.text, passwordText.text);
                    else{
                        app.settings.setValue("username", usernameText.text);
                        loginStackView.pop();
                        loginStackView.visible = false;
                    }

                }
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.maximumWidth: 450

                enabled : usernameText.text > ""
                style: ButtonStyle {
                    background: Rectangle {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#00695C"
                        radius: 2
                        color: "#00b894"

                    }
                    label: Component {
                        Label {
                            text: app.settings.value("username") > "" ? "Let's track" : app.loginType === "AGOL" ? "Log in" : "Save"
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
                Layout.preferredHeight: 10
            }

            Button {
                onClicked: {
                    loginStackView.pop()
                }
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.maximumWidth: 450

                style: ButtonStyle {
                    background: Rectangle {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#00695C"
                        radius: 2
                        color: "#607D8B"
                    }
                    label: Component {
                        Label {
                            text: "Cancel"
                            clip: true
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.fill: parent
                            color: "white"
                            font{
                                pixelSize: 20
                                family: robotoThin.name
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicator
                running: generateTokenRequest.readyState == NetworkRequest.ReadyStateSending | generateTokenRequest.readyState == NetworkRequest.ReadyStateProcessing
                visible: running
            }
            Item {
                Layout.preferredHeight: 20
            }

            Text   {
                id: infoText
                text: app.loginType == "AGOL" ? "Data is written to a secured data layer" : "A local account will contribute your data to an open data service. \n\nIf you want to store your logs securely, press cancel to go back and sign in with an ArcGIS Online account."
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.maximumWidth: 450

                font{
                    pixelSize: 15
                    family: robotoThin.name
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }


}

