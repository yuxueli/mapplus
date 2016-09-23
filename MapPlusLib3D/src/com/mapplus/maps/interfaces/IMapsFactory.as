//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;

    public interface IMapsFactory extends IWrappable {

        function createMap(_arg1:Sprite, _arg2:IEventDispatcher):Object;
        function createElevation():Object;
        function getDefaultPolylineOptions():PolylineOptions;
        function createScaleControl2(param1:ScaleControlOptions=null):Object;
        function createZoomControl2(param1:ZoomControlOptions=null):Object;
        function createNavigationControl2(param1:NavigationControlOptions=null):Object;
        function createPolygonFromEncoded(_arg1:Array, _arg2:PolygonOptions=null):Object;
        function getDefaultGroundOverlayOptions():GroundOverlayOptions;
        function setDefaultInfoWindowOptions(param1:InfoWindowOptions):void;
        function reportMouseEvent(param1:MouseEvent):void;
        function createClientGeocoder(_arg1:String=null, _arg2:LatLngBounds=null):Object;
        function setDefaultMarkerOptions(param1:MarkerOptions):void;
        function createPolylineFromEncoded(_arg1:String, _arg2:Number, _arg3:String, _arg4:Number, _arg5:PolylineOptions=null):Object;
        function createOverviewMapControl(_arg1:Sprite, _arg2:IEventDispatcher, _arg3:OverviewMapControlOptions=null):Object;
        function createClientGeocoder2(param1:ClientGeocoderOptions=null):Object;
        function createPositionControl(_arg1:Sprite, _arg2:IEventDispatcher, _arg3:PositionControlOptions=null):Object;
        function createMapType(_arg1:Array, _arg2:IProjection, _arg3:String, _arg4:MapTypeOptions=null):Object;
        function createOverviewMapControl2(param1:OverviewMapControlOptions=null):Object;
        function createMarker(_arg1:LatLng, _arg2:MarkerOptions=null):Object;
        function createPolygon(_arg1:Array, _arg2:PolygonOptions=null):Object;
        function createPositionControl2(param1:PositionControlOptions=null):Object;
        function createMapTypeControl(_arg1:Sprite, _arg2:IEventDispatcher, _arg3:MapTypeControlOptions=null):Object;
        function getDefaultMapTypesList():Array;
        function setDefaultMapTypeOptions(param1:MapTypeOptions):void;
        function createCopyrightCollection(param1:String=null):Object;
        function setDefaultPolygonOptions(param1:PolygonOptions):void;
        function getDefaultMapType(param1:String):IMapType;
        function createGroundOverlay(_arg1:DisplayObject, _arg2:LatLngBounds, _arg3:GroundOverlayOptions=null):Object;
        function createZoomControl(_arg1:Sprite, _arg2:IEventDispatcher, _arg3:ZoomControlOptions=null):Object;
        function createMapTypeControl2(param1:MapTypeControlOptions=null):Object;
        function createDirections(param1:DirectionsOptions=null):Object;
        function createMap2(param1:MapOptions=null):Object;
        function setDefaultGroundOverlayOptions(param1:GroundOverlayOptions):void;
        function getDefaultInfoWindowOptions():InfoWindowOptions;
        function getDefaultPolygonOptions():PolygonOptions;
        function createTileLayerOverlay(_arg1:ITileLayer, _arg2:int=0x0100, _arg3:IProjection=null):Object;
        function getDefaultMarkerOptions():MarkerOptions;
        function getDefaultMapTypeOptions():MapTypeOptions;
        function createMaxZoom(param1:IMapType):Object;
        function setClientFactory(param1:IClientFactory):void;
        function createPolyline(_arg1:Array, _arg2:PolylineOptions=null):Object;
        function setDefaultPolylineOptions(param1:PolylineOptions):void;

    }
}//package com.mapplus.maps.interfaces 
