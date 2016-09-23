//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.events.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.services.*;

    public interface IMapsFactory extends IWrappable {

        function createMap(param1:Sprite, param2:IEventDispatcher):Object;
        function createMaxZoom(param1:IMapType):Object;
        function createScaleControl2(param1:ScaleControlOptions=null):Object;
        function createZoomControl2(param1:ZoomControlOptions=null):Object;
        function createNavigationControl2(param1:NavigationControlOptions=null):Object;
        function createPolygonFromEncoded(param1:Array, param2:PolygonOptions=null):Object;
        function reportMouseEvent(event:MouseEvent):void;
        function setDefaultGroundOverlayOptions(param1:GroundOverlayOptions):void;
        function setDefaultMarkerOptions(param1:MarkerOptions):void;
        function createStyledMapType(param1:Array, param2:StyledMapTypeOptions=null):Object;
        function createElevation():Object;
        function createOverviewMapControl(param1:Sprite, param2:IEventDispatcher, param3:OverviewMapControlOptions=null):Object;
        function createClientGeocoder2(param1:ClientGeocoderOptions=null):Object;
        function createPositionControl(param1:Sprite, param2:IEventDispatcher, param3:PositionControlOptions=null):Object;
        function setDefaultInfoWindowOptions(param1:InfoWindowOptions):void;
        function createPositionControl2(param1:PositionControlOptions=null):Object;
        function createOverviewMapControl2(param1:OverviewMapControlOptions=null):Object;
        function createMarker(param1:LatLng, param2:MarkerOptions=null):Object;
        function createPolygon(param1:Array, param2:PolygonOptions=null):Object;
        function createPolygonShape(point:LatLng, r1:Number, r2:Number, r3:Number, r4:Number, rotation:Number, vertexCount:Number, opts:PolygonOptions=null, tilt:Boolean=false):Object;
        function createPolygonRegularPoly(point:LatLng, radius:Number, vertexCount:Number, rotation:Number, opts:PolygonOptions=null):Object;
        function createPolygonStar(point:LatLng, r1:Number, r2:Number, points:Number, rotation:Number, opts:PolygonOptions=null):Object;
        function createPolygonEllipse(point:LatLng, r1:Number, r2:Number, rotation:Number, opts:PolygonOptions=null):Object;
        function createPolygonSector(point:LatLng, radius:Number, sDegree:Number, eDegree:Number, opts:PolygonOptions=null):Object;
        function createPolylineFromEncoded(param1:String, param2:Number, param3:String, param4:Number, param5:PolylineOptions=null):Object;
        function createMapType(param1:Array, param2:IProjection, param3:String, param4:MapTypeOptions=null):Object;
        function getDefaultGroundOverlayOptions():GroundOverlayOptions;
        function createMapTypeControl(param1:Sprite, param2:IEventDispatcher, param3:MapTypeControlOptions=null):Object;
        function setDefaultMapTypeOptions(param1:MapTypeOptions):void;
        function createCopyrightCollection(param1:String=null):Object;
        function setDefaultPolygonOptions(param1:PolygonOptions):void;
        function getDefaultMapType(param1:String):IMapType;
        function getDefaultMapTypesList():Array;
        function createZoomControl(param1:Sprite, param2:IEventDispatcher, param3:ZoomControlOptions=null):Object;
        function createMapTypeControl2(param1:MapTypeControlOptions=null):Object;
        function createDirections(param1:DirectionsOptions=null):Object;
        function createMap2(param1:MapOptions=null):Object;
        function getDefaultMapTypeOptions():MapTypeOptions;
        function createGroundOverlay(param1:DisplayObject, param2:LatLngBounds, param3:GroundOverlayOptions=null):Object;
        function getDefaultInfoWindowOptions():InfoWindowOptions;
        function getDefaultPolygonOptions():PolygonOptions;
        function createTileLayerOverlay(param1:ITileLayer, param2:int=0x0100, param3:IProjection=null):Object;
        function getDefaultMarkerOptions():MarkerOptions;
        function getDefaultPolylineOptions():PolylineOptions;
        function createClientGeocoder(param1:String=null, param2:LatLngBounds=null):Object;
        function setClientFactory(param1:IClientFactory):void;
        function createPolyline(param1:Array, param2:PolylineOptions=null):Object;
        function createPolylineShape(point:LatLng, r1:Number, r2:Number, r3:Number, r4:Number, rotation:Number, vertexCount:Number, tilt:Boolean, opts:PolylineOptions=null):Object;
        function createPolylineCircle(point:LatLng, radius:Number, opts:PolylineOptions=null):Object;
        function createPolylineRegularPoly(point:LatLng, radius:Number, vertexCount:Number, rotation:Number, opts:PolylineOptions=null):Object;
        function createPolylineStar(point:LatLng, r1:Number, r2:Number, points:Number, rotation:Number, opts:PolylineOptions=null):Object;
        function createPolylineEllipse(point:LatLng, r1:Number, r2:Number, rotation:Number, opts:PolylineOptions=null):Object;
        function createPolylineSector(point:LatLng, radius:Number, sDegree:Number, eDegree:Number, opts:PolylineOptions=null):Object;
        function setDefaultPolylineOptions(param1:PolylineOptions):void;

    }
}//package com.mapplus.maps.interfaces 
