//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.window.*;

    public class MapsFactory extends WrapperBase implements IMapsFactory3D {

        public function MapsFactory(){
            super();
        }
        public function createClientGeocoder(param1:String=null, param2:LatLngBounds=null):Object{
            return (new ClientGeocoder(param1, param2));
        }
        public function createMarker(param1:LatLng, param2:MarkerOptions=null):Object{
            return (new Marker(param1, param2));
        }
        public function createZoomControl2(param1:ZoomControlOptions=null):Object{
            return (new ZoomControl(param1));
        }
        public function createPolygonFromEncoded(param1:Array, param2:PolygonOptions=null):Object{
            return (Polygon.fromEncoded(param1, param2));
        }
        public function createPolylineFromEncoded(param1:String, param2:Number, param3:String, param4:Number, param5:PolylineOptions=null):Object{
            return (Polyline.fromEncoded(param1, param2, param3, param4, param5));
        }
        public function setClientFactory(param1:IClientFactory):void{
            Bootstrap.getBootstrap().setClientFactory(param1);
        }
        override public function get interfaceChain():Array{
            return (["IMapsFactory3D", "IMapsFactory"]);
        }
        public function createPolygon(param1:Array, param2:PolygonOptions=null):Object{
            return (new Polygon(param1, param2));
        }
        public function createMapType(param1:Array, param2:IProjection, param3:String, param4:MapTypeOptions=null):Object{
            return (new MapTypeImpl(param1, param2, param3, param4));
        }
        public function createOverviewMapControl2(param1:OverviewMapControlOptions=null):Object{
            return (new OverviewMapControl(param1));
        }
        public function createClientGeocoder2(param1:ClientGeocoderOptions=null):Object{
            return (new ClientGeocoder(null, null, param1));
        }
        public function getDefaultMapType(param1:String):IMapType{
            return (Bootstrap.getBootstrap().getDefaultMapType(param1));
        }
        public function createGroundOverlay(param1:DisplayObject, param2:LatLngBounds, param3:GroundOverlayOptions=null):Object{
            return (new GroundOverlay(param1, param2, param3));
        }
        public function createMapTypeControl2(param1:MapTypeControlOptions=null):Object{
            return (new MapTypeControl(param1));
        }
        public function createCopyrightCollection(param1:String=null):Object{
            return (new CopyrightCollection(param1));
        }
        public function getDefaultPolylineOptions():PolylineOptions{
            return (Polyline.getDefaultOptions());
        }
        public function createMaxZoom(param1:IMapType):Object{
            return (new MaxZoom(param1));
        }
        public function getDefaultInfoWindowOptions():InfoWindowOptions{
            return (InfoWindow.getDefaultOptions());
        }
        public function createMap(param1:Sprite, param2:IEventDispatcher):Object{
            var _loc_3:MapImpl;
            _loc_3 = new MapImpl(UsageTracker.URL_ARGVAL_USAGETYPE_MAP);
            _loc_3.legacyInitialize(param1, param2);
            return (_loc_3);
        }
        public function createElevation():Object{
            return (new Elevation());
        }
        public function createScaleControl2(param1:ScaleControlOptions=null):Object{
            return (new ScaleControl(param1));
        }
        public function createNavigationControl2(param1:NavigationControlOptions=null):Object{
            return (new NavigationControl(param1));
        }
        public function setDefaultPolylineOptions(param1:PolylineOptions):void{
            Polyline.setDefaultOptions(param1);
        }
        public function reportMouseEvent(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        public function createTileLayerOverlay(param1:ITileLayer, param2:int=0x0100, param3:IProjection=null):Object{
            return (new TileLayerOverlay(param1, param2, param3));
        }
        public function getDefaultGroundOverlayOptions():GroundOverlayOptions{
            return (GroundOverlay.getDefaultOptions());
        }
        public function getDefaultMarkerOptions():MarkerOptions{
            return (Marker.getDefaultOptions());
        }
        public function setDefaultMarkerOptions(param1:MarkerOptions):void{
            Marker.setDefaultOptions(param1);
        }
        public function setDefaultGroundOverlayOptions(param1:GroundOverlayOptions):void{
            GroundOverlay.setDefaultOptions(param1);
        }
        public function createPolyline(param1:Array, param2:PolylineOptions=null):Object{
            return (new Polyline(param1, param2));
        }
        public function createPositionControl(param1:Sprite, param2:IEventDispatcher, param3:PositionControlOptions=null):Object{
            var _loc_4:PositionControl;
            _loc_4 = new PositionControl(param3);
            _loc_4.legacyInitialize(param1, param2);
            return (_loc_4);
        }
        public function createPositionControl2(param1:PositionControlOptions=null):Object{
            return (new PositionControl(param1));
        }
        public function createOverviewMapControl(param1:Sprite, param2:IEventDispatcher, param3:OverviewMapControlOptions=null):Object{
            var _loc_4:OverviewMapControl;
            _loc_4 = new OverviewMapControl(param3);
            _loc_4.legacyInitialize(param1, param2);
            return (_loc_4);
        }
        public function getDefaultMapTypesList():Array{
            return (Bootstrap.getBootstrap().getDefaultMapTypes());
        }
        public function setDefaultPolygonOptions(param1:PolygonOptions):void{
            Polygon.setDefaultOptions(param1);
        }
        public function setDefaultInfoWindowOptions(param1:InfoWindowOptions):void{
            InfoWindow.setDefaultOptions(param1);
        }
        public function getDefaultPolygonOptions():PolygonOptions{
            return (Polygon.getDefaultOptions());
        }
        public function createDirections(param1:DirectionsOptions=null):Object{
            return (new Directions(param1));
        }
        public function createMapTypeControl(param1:Sprite, param2:IEventDispatcher, param3:MapTypeControlOptions=null):Object{
            var _loc_4:MapTypeControl;
            _loc_4 = new MapTypeControl(param3);
            _loc_4.legacyInitialize(param1, param2);
            return (_loc_4);
        }
        public function getDefaultMapTypeOptions():MapTypeOptions{
            return (MapTypeImpl.getDefaultOptions());
        }
        public function createZoomControl(param1:Sprite, param2:IEventDispatcher, param3:ZoomControlOptions=null):Object{
            var _loc_4:ZoomControl;
            _loc_4 = new ZoomControl(param3);
            _loc_4.legacyInitialize(param1, param2);
            return (_loc_4);
        }
        public function setDefaultMapTypeOptions(param1:MapTypeOptions):void{
            MapTypeImpl.setDefaultOptions(param1);
        }
        public function createMap2(param1:MapOptions=null):Object{
            return (new MapImpl(UsageTracker.URL_ARGVAL_USAGETYPE_MAP, param1));
        }

    }
}//package com.mapplus.maps.core 
