//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.services.*;
    import flash.display.*;
    import flash.events.*;

    public class IMapsFactoryWrapper extends WrapperBase implements IMapsFactory {

        public function IMapsFactoryWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IMapsFactory"]);
        }
        public function createPolygonRegularPoly(point:LatLng, radius:Number, vertexCount:Number, rotation:Number, opts:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonRegularPoly(this.extWrapper.wrapLatLng(point), radius, vertexCount, rotation, this.extWrapper.wrapPolygonOptions(opts)));
        }
        public function createPolylineRegularPoly(point:LatLng, radius:Number, vertexCount:Number, rotation:Number, opts:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineRegularPoly(this.extWrapper.wrapLatLng(point), radius, vertexCount, rotation, this.extWrapper.wrapPolylineOptions(opts)));
        }
        public function createPolygonCircle(point:LatLng, radius:Number, opts:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonCircle(this.extWrapper.wrapLatLng(point), radius, this.extWrapper.wrapPolygonOptions(opts)));
        }
        public function createPolygonStar(point:LatLng, r1:Number, r2:Number, points:Number, rotation:Number, opts:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonStar(this.extWrapper.wrapLatLng(point), r1, r2, points, rotation, this.extWrapper.wrapPolygonOptions(opts)));
        }
        public function createClientGeocoder2(param1:ClientGeocoderOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createClientGeocoder2(this.extWrapper.wrapClientGeocoderOptions(param1)));
        }
        public function createMapType(param1:Array, param2:IProjection, param3:String, param4:MapTypeOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMapType(this.extWrapper.wrapITileLayerArray(param1), this.extWrapper.wrapIProjection(param2), param3, this.extWrapper.wrapMapTypeOptions(param4)));
        }
        public function createOverviewMapControl2(param1:OverviewMapControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createOverviewMapControl2(this.extWrapper.wrapOverviewMapControlOptions(param1)));
        }
        public function createPolylineShape(point:LatLng, r1:Number, r2:Number, r3:Number, r4:Number, rotation:Number, vertexCount:Number, tilt:Boolean, opts:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineShape(this.extWrapper.wrapLatLng(point), r1, r2, r3, r4, rotation, vertexCount, tilt, this.extWrapper.wrapPolylineOptions(opts)));
        }
        public function getDefaultMapType(param1:String):IMapType{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIMapType(this.instance.getDefaultMapType(param1)));
        }
        public function createGroundOverlay(param1:DisplayObject, param2:LatLngBounds, param3:GroundOverlayOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createGroundOverlay(param1, this.extWrapper.wrapLatLngBounds(param2), this.extWrapper.wrapGroundOverlayOptions(param3)));
        }
        public function createCopyrightCollection(param1:String=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createCopyrightCollection(param1));
        }
        public function getDefaultPolylineOptions():PolylineOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapPolylineOptions(this.instance.getDefaultPolylineOptions()));
        }
        public function setDefaultPolylineOptions(param1:PolylineOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDefaultPolylineOptions(this.extWrapper.wrapPolylineOptions(param1));
        }
        public function getDefaultGroundOverlayOptions():GroundOverlayOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapGroundOverlayOptions(this.instance.getDefaultGroundOverlayOptions()));
        }
        public function createScaleControl2(param1:ScaleControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createScaleControl2(this.extWrapper.wrapScaleControlOptions(param1)));
        }
        public function createPolylineStar(point:LatLng, r1:Number, r2:Number, points:Number, rotation:Number, opts:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineStar(this.extWrapper.wrapLatLng(point), r1, r2, points, rotation, this.extWrapper.wrapPolylineOptions(opts)));
        }
        public function reportMouseEvent(event:MouseEvent):void{
            Wrapper.checkValid(this.instance);
            this.instance.reportMouseEvent(this.extWrapper.wrapMouseEvent(event));
        }
        public function createMarker(param1:LatLng, param2:MarkerOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMarker(this.extWrapper.wrapLatLng(param1), this.extWrapper.wrapMarkerOptions(param2)));
        }
        public function createPositionControl(param1:Sprite, param2:IEventDispatcher, param3:PositionControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPositionControl(param1, this.extWrapper.wrapIEventDispatcher(param2), this.extWrapper.wrapPositionControlOptions(param3)));
        }
        public function createPolygonEllipse(point:LatLng, r1:Number, r2:Number, rotation:Number, opts:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonEllipse(this.extWrapper.wrapLatLng(point), r1, r2, rotation, this.extWrapper.wrapPolygonOptions(opts)));
        }
        public function createPolylineEllipse(point:LatLng, r1:Number, r2:Number, rotation:Number, opts:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineEllipse(this.extWrapper.wrapLatLng(point), r1, r2, rotation, this.extWrapper.wrapPolylineOptions(opts)));
        }
        public function setDefaultPolygonOptions(param1:PolygonOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDefaultPolygonOptions(this.extWrapper.wrapPolygonOptions(param1));
        }
        public function getDefaultMapTypesList():Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIMapTypeArray(this.instance.getDefaultMapTypesList()));
        }
        public function setDefaultMapTypeOptions(param1:MapTypeOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDefaultMapTypeOptions(this.extWrapper.wrapMapTypeOptions(param1));
        }
        public function createPolylineSector(point:LatLng, radius:Number, sDegree:Number, eDegree:Number, opts:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineSector(this.extWrapper.wrapLatLng(point), radius, sDegree, eDegree, this.extWrapper.wrapPolylineOptions(opts)));
        }
        public function createZoomControl(param1:Sprite, param2:IEventDispatcher, param3:ZoomControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createZoomControl(param1, this.extWrapper.wrapIEventDispatcher(param2), this.extWrapper.wrapZoomControlOptions(param3)));
        }
        public function createMap2(param1:MapOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMap2(this.extWrapper.wrapMapOptions(param1)));
        }
        public function createClientGeocoder(param1:String=null, param2:LatLngBounds=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createClientGeocoder(param1, this.extWrapper.wrapLatLngBounds(param2)));
        }
        public function createZoomControl2(param1:ZoomControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createZoomControl2(this.extWrapper.wrapZoomControlOptions(param1)));
        }
        public function createPolygonFromEncoded(param1:Array, param2:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonFromEncoded(param1, this.extWrapper.wrapPolygonOptions(param2)));
        }
        public function setClientFactory(param1:IClientFactory):void{
            Wrapper.checkValid(this.instance);
            this.instance.setClientFactory(this.extWrapper.wrapIClientFactory(param1));
        }
        public function createPolylineFromEncoded(param1:String, param2:Number, param3:String, param4:Number, param5:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineFromEncoded(param1, param2, param3, param4, this.extWrapper.wrapPolylineOptions(param5)));
        }
        public function createPolygon(param1:Array, param2:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygon(this.extWrapper.wrapLatLngArray(param1), this.extWrapper.wrapPolygonOptions(param2)));
        }
        public function createPolygonShape(point:LatLng, r1:Number, r2:Number, r3:Number, r4:Number, rotation:Number, vertexCount:Number, opts:PolygonOptions=null, tilt:Boolean=false):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonShape(this.extWrapper.wrapLatLng(point), r1, r2, r3, r4, rotation, vertexCount, this.extWrapper.wrapPolygonOptions(opts), tilt));
        }
        public function createPolygonSector(point:LatLng, radius:Number, sDegree:Number, eDegree:Number, opts:PolygonOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolygonSector(this.extWrapper.wrapLatLng(point), radius, sDegree, eDegree, this.extWrapper.wrapPolygonOptions(opts)));
        }
        public function createTileLayerOverlay(param1:ITileLayer, param2:int=0x0100, param3:IProjection=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createTileLayerOverlay(this.extWrapper.wrapITileLayer(param1), param2, this.extWrapper.wrapIProjection(param3)));
        }
        public function createMapTypeControl2(param1:MapTypeControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMapTypeControl2(this.extWrapper.wrapMapTypeControlOptions(param1)));
        }
        public function setDefaultGroundOverlayOptions(param1:GroundOverlayOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDefaultGroundOverlayOptions(this.extWrapper.wrapGroundOverlayOptions(param1));
        }
        public function getDefaultInfoWindowOptions():InfoWindowOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapInfoWindowOptions(this.instance.getDefaultInfoWindowOptions()));
        }
        public function getDefaultMarkerOptions():MarkerOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapMarkerOptions(this.instance.getDefaultMarkerOptions()));
        }
        public function createMaxZoom(param1:IMapType):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMaxZoom(this.extWrapper.wrapIMapType(param1)));
        }
        public function setDefaultInfoWindowOptions(param1:InfoWindowOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDefaultInfoWindowOptions(this.extWrapper.wrapInfoWindowOptions(param1));
        }
        public function createStyledMapType(param1:Array, param2:StyledMapTypeOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createStyledMapType(this.extWrapper.wrapMapTypeStyleArray(param1), this.extWrapper.wrapStyledMapTypeOptions(param2)));
        }
        public function createNavigationControl2(param1:NavigationControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createNavigationControl2(this.extWrapper.wrapNavigationControlOptions(param1)));
        }
        public function createMap(param1:Sprite, param2:IEventDispatcher):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMap(param1, this.extWrapper.wrapIEventDispatcher(param2)));
        }
        public function createElevation():Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createElevation());
        }
        public function createPolylineCircle(point:LatLng, radius:Number, opts:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolylineCircle(this.extWrapper.wrapLatLng(point), radius, this.extWrapper.wrapPolylineOptions(opts)));
        }
        public function createOverviewMapControl(param1:Sprite, param2:IEventDispatcher, param3:OverviewMapControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createOverviewMapControl(param1, this.extWrapper.wrapIEventDispatcher(param2), this.extWrapper.wrapOverviewMapControlOptions(param3)));
        }
        public function createPositionControl2(param1:PositionControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPositionControl2(this.extWrapper.wrapPositionControlOptions(param1)));
        }
        public function createPolyline(param1:Array, param2:PolylineOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createPolyline(this.extWrapper.wrapLatLngArray(param1), this.extWrapper.wrapPolylineOptions(param2)));
        }
        public function setDefaultMarkerOptions(param1:MarkerOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDefaultMarkerOptions(this.extWrapper.wrapMarkerOptions(param1));
        }
        public function createMapTypeControl(param1:Sprite, param2:IEventDispatcher, param3:MapTypeControlOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createMapTypeControl(param1, this.extWrapper.wrapIEventDispatcher(param2), this.extWrapper.wrapMapTypeControlOptions(param3)));
        }
        public function getDefaultPolygonOptions():PolygonOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapPolygonOptions(this.instance.getDefaultPolygonOptions()));
        }
        public function createDirections(param1:DirectionsOptions=null):Object{
            Wrapper.checkValid(this.instance);
            return (this.instance.createDirections(this.extWrapper.wrapDirectionsOptions(param1)));
        }
        public function getDefaultMapTypeOptions():MapTypeOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapMapTypeOptions(this.instance.getDefaultMapTypeOptions()));
        }

    }
}//package com.mapplus.maps.wrappers 
