import QtQuick 2.0

Item {
    id: item1
    Rectangle {
        id: rectangle
        x: 243
        y: 82
        width: 200
        height: 200
        color: "#ffffff"
        transformOrigin: Item.Bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 198
    }

}
