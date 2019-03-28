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

MapView {
    id:mapView
    
    property real initialMapRotation: 0
    
    anchors {
        left: parent.left
        right: parent.right
        top: titleRect.bottom
        bottom: parent.bottom
    }
    
    rotationByPinchingEnabled: true
    zoomByPinchingEnabled: true
    
    locationDisplay {
        positionSource: PositionSource {
            id: src
            updateInterval: 1000
            active: true

            onPositionChanged: {
                var coord = src.position.coordinate;

                if (!mapView.locationDisplay.started) {
                    mapView.locationDisplay.start()
                    mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter
                }
                positionLong = coord.longitude;
                positionLat = coord.latitude;
            }
        }
    }

    // add a basemap
    Map{
        id:map

        initialViewpoint: ViewpointCenter {
            id:initialViewpoint
            center: Point {
                x: -11e6
                y: 6e6
                spatialReference: SpatialReference {wkid: 102100}
            }
            targetScale: 9e7
        }


        BasemapTopographic{}

        GraphicsLayer{id: graphicsLayer}
    }
}
