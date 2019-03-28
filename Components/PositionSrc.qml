import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.3
import QtSensors 5.3

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1


//------------------------------------------------------------------------------

PositionSource {
    id: src
    updateInterval: 20000 //app.settings.value("interval") * 60000
    active: true
    
    onPositionChanged: {
        var coord = src.position.coordinate;

        positionLong = coord.longitude;
        positionLat = coord.latitude;

        console.log("from pos source component", positionLong, positionLat);
    }
}
