//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.styles.*;

    public final class MapsClasses {

        public function MapsClasses(){
            super();
            getLibraryTypes();
        }
        private static function getLibraryTypes():Array{
            return ([Map3D, MapAttitudeEvent, View, Attitude, Alpha, ClassVector, Color, Copyright, CopyrightCollection, CopyrightNotice, LatLng, Map, MapAction, MapMouseEvent, MapMoveEvent, MapZoomEvent, MapEvent, MapType, MapUtil, MapsClientLibrary, PaneId, ProjectionBase, R1Interval, S1Interval, StyledMapType, TileLayerBase, ControlBase, ControlPosition, MapTypeControl, NavigationControl, OverviewMapControl, PositionControl, ScaleControl, ZoomControl, EncodedPolylineData, GroundOverlay, Marker, OverlayBase, Polygon, Polyline, TileLayerOverlay, ClientGeocoder, Directions, DirectionsEvent, Elevation, ElevationEvent, ElevationResponse, GeocodingEvent, GeocodingResponse, MaxZoom, MaxZoomEvent, Placemark, Route, ServiceStatus, Step, MapTypeStyle, MapTypeStyleElementType, MapTypeStyleFeatureType, MapTypeStyleRule]);
        }

    }
}//package com.mapplus.maps 
