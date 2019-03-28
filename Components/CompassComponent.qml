import QtQuick 2.0


Rectangle {
    id: rectangle1

   // height: width
    radius: width * 0.5

    color: "#00b894"

    property double bearing

    Rectangle {
        id: rectangle

        width: rectangle1.width * 0.875
        height: width
        color: "#dfe6e9"
        radius: width * 0.5
        anchors.centerIn: parent

        Image {
            id: image
            anchors.centerIn:parent
            height: parent.height * 0.875
            width: height * 0.25

            rotation: bearing
            source: "../images/compassneedle.png"
        }
    }
}
