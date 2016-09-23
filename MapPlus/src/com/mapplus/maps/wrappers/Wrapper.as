﻿//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.styles.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public final class Wrapper {

        private static var nativeWrapper:Wrapper;

        private var wrappersMap:Object;
        private var eventClassMap:Object;
        private var eventNamesMap:Object;
        private var alienWrapper:Object;

        public function Wrapper(){
            super();
            var _loc_1:Object;
            _loc_1 = {};
            initializeEventNamesMap(_loc_1);
            eventNamesMap = _loc_1;
            _loc_1 = {};
            initializeEventClassMap(_loc_1);
            eventClassMap = _loc_1;
            _loc_1 = {};
            initializeWrappersMap(_loc_1);
            _loc_1["IWrappableEventDispatcher"] = EventDispatcherWrapper;
            wrappersMap = _loc_1;
        }
        public static function getLoaderInfoContent(param1:LoaderInfo):DisplayObject{
            return (param1.content);
        }
        public static function cloneArray(param1:Array, param2:Boolean=false):Array{
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:* = undefined;
            var _loc_6:Array;
            if (!(param2)){
                return ([].concat(param1));
            };
            _loc_3 = [];
            _loc_4 = 0;
            while (_loc_4 < param1.length) {
                _loc_5 = param1[_loc_4];
                _loc_6 = (_loc_5 as Array);
                if (_loc_6 != null){
                    _loc_3.push(cloneArray(_loc_6));
                } else {
                    _loc_3.push(_loc_5);
                };
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_3);
        }
		//2011.6.8 修正  by于学利
		public static function copyProperties(param1:Object, param2:Object, param3:Array, param4:Class=null, param5:Boolean=false):void{
			var _loc_6:Number = 0;
			var _loc_7:String;
			var _loc_8:* = undefined;
			var _loc_9:* = undefined;
			_loc_6 = 0;
			while (_loc_6 < param3.length) 
			{
				_loc_7 = param3[_loc_6];
				_loc_6 = (_loc_6 + 1);
				if (param5 && !param2.hasOwnProperty(_loc_7))
				{
					continue;
				} 
				_loc_8 = param2[_loc_7];
				if (param4 != null)
				{
					_loc_9 = (_loc_8 as param4);
					if (_loc_9 == null)
					{
						continue;
					}
				} 
				param1[_loc_7] = _loc_8;
			}
		}
        public static function copyPixelsToBitmap(param1:DisplayObject, param2:Point, param3:Matrix):DisplayObject{
            var _loc_4:BitmapData;
            _loc_4 = new BitmapData(param2.x, param2.y, true, Color.BLACK);
            _loc_4.draw(param1, param3);
            return (new Bitmap(_loc_4, "auto", false));
        }
        public static function copyRectangleProperties(param1:Rectangle, param2:Object):void{
            copyProperties(param1, param2, ["x", "y", "width", "height"], Number);
        }
        public static function copyPointProperties(param1:Point, param2:Object):void{
            copyProperties(param1, param2, ["x", "y"], Number);
        }
        public static function getLoaderContent(param1:Loader):DisplayObject{
            return (param1.content);
        }
        public static function copyTextFormatProperties(param1:TextFormat, param2:Object):void{
            copyProperties(param1, param2, ["align", "font", "target", "url"], String);
            copyProperties(param1, param2, ["bold", "bullet", "italic", "kerning", "underline"], Boolean);
            copyProperties(param1, param2, ["blockIndent", "color", "indent", "leading", "leftMargin", "letterSpacing", "rightMargin", "size"], Number);
            if (((!((param2.tabStops == null))) && ((param2.tabStops is Array)))){
                param1.tabStops = cloneArray(param2.tabStops);
            };
        }
        public static function checkValid(param1:Object):void{
            if (param1 == null){
                throw (new IllegalOperationError("Object not initialized"));
            };
        }
        public static function instance():Wrapper{
            if (Wrapper.nativeWrapper == null){
                Wrapper.nativeWrapper = new (Wrapper)();
            };
            return (Wrapper.nativeWrapper);
        }
        public static function copyStyleSheetProperties(param1:StyleSheet, param2:Object):void{
            var _loc_3:int;
            var _loc_4:String;
            if (param2.styleNames != null){
            };
            if ((param2.styleNames is Array)){
                _loc_3 = 0;
                while (_loc_3 < param2.styleNames.length) {
                    _loc_4 = param2.styleNames[_loc_3];
                    param1.setStyle(_loc_4, param2.getStyle(_loc_4));
                    _loc_3 = (_loc_3 + 1);
                };
            };
        }
        public static function mergeStyles(param1:Class, param2:Array):Object{
            var _loc_3:Object;
            var _loc_4:Boolean;
            var _loc_5:Number = NaN;
            if (param2 == null){
                return (null);
            };
            _loc_3 = new (param1)();
            _loc_4 = false;
            _loc_5 = 0;
            while (_loc_5 < param2.length) {
                if (param2[_loc_5] != null){
                    _loc_3.copyFromObject(param2[_loc_5]);
                    _loc_4 = true;
                };
                _loc_5 = (_loc_5 + 1);
            };
            return ((_loc_4) ? _loc_3 : null);
        }
        public static function copyObject(param1:Object, param2:Object):void{
            var _loc_3:String;
            for (_loc_3 in param2) {
                if (param1[_loc_3] == null){
                    param1[_loc_3] = param2[_loc_3];
                };
            };
        }
        public static function drawBitmapData(param1:BitmapData, param2:IBitmapDrawable, param3:Matrix=null, param4:ColorTransform=null, param5:String=null, param6:Rectangle=null, param7:Boolean=false):void{
            param1.draw(param2, param3, param4, param5, param6, param7);
        }

        public function wrapDirectionsOptions(param1:Object):DirectionsOptions{
            if (param1 == null){
                return (null);
            };
            return (DirectionsOptions.fromObject(param1));
        }
        public function wrapIPolygon(param1:Object, param2:IPolygonWrapper=null):IPolygon{
            return (IPolygon(wrap(param1, param2, IPolygon, IPolygonWrapper)));
        }
        public function wrapITileLayerArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapITileLayer(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapMapTypeStyle(param1:Object):MapTypeStyle{
            if (param1 == null){
                return (null);
            };
            return (MapTypeStyle.fromObject(param1));
        }
        public function wrapICopyrightCollection(param1:Object, param2:ICopyrightCollectionWrapper=null):ICopyrightCollection{
            return (ICopyrightCollection(wrap(param1, param2, ICopyrightCollection, ICopyrightCollectionWrapper)));
        }
        public function wrapIBitmapDrawable(param1:IBitmapDrawable):IBitmapDrawable{
            return (param1);
        }
        public function wrapEncodedPolylineData(param1:Object):EncodedPolylineData{
            if (param1 == null){
                return (null);
            };
            return (EncodedPolylineData.fromObject(param1));
        }
        public function wrapPolygonOptions(param1:Object):PolygonOptions{
            if (param1 == null){
                return (null);
            };
            return (PolygonOptions.fromObject(param1));
        }
        public function wrapIOverlay(param1:Object, param2:IOverlayWrapper=null):IOverlay{
            return (IOverlay(wrap(param1, param2, IOverlay, IOverlayWrapper)));
        }
        public function wrapPolylineOptions(param1:Object):PolylineOptions{
            if (param1 == null){
                return (null);
            };
            return (PolylineOptions.fromObject(param1));
        }
        public function wrapClientGeocoderOptions(param1:Object):ClientGeocoderOptions{
            if (param1 == null){
                return (null);
            };
            return (ClientGeocoderOptions.fromObject(param1));
        }
        public function wrapIMaxZoom(param1:Object, param2:IMaxZoomWrapper=null):IMaxZoom{
            return (IMaxZoom(wrap(param1, param2, IMaxZoom, IMaxZoomWrapper)));
        }
        public function wrapBitmap(param1:Bitmap):Bitmap{
            return (param1);
        }
        public function wrapAttitude(param1:Object):Attitude{
            if (param1 == null){
                return (null);
            };
            return (Attitude.fromObject(param1));
        }
        public function wrapIControl(param1:Object, param2:IControlWrapper=null):IControl{
            return (IControl(wrap(param1, param2, IControl, IControlWrapper)));
        }
        public function wrapNavigationControlOptions(param1:Object):NavigationControlOptions{
            if (param1 == null){
                return (null);
            };
            return (NavigationControlOptions.fromObject(param1));
        }
        public function wrapIMapTypeArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapIMapType(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapIMapsFactory3D(param1:Object, param2:IMapsFactory3DWrapper=null):IMapsFactory3D{
            return (IMapsFactory3D(wrap(param1, param2, IMapsFactory3D, IMapsFactory3DWrapper)));
        }
        public function wrapIPolyline(param1:Object, param2:IPolylineWrapper=null):IPolyline{
            return (IPolyline(wrap(param1, param2, IPolyline, IPolylineWrapper)));
        }
        public function wrapINavigationControl(param1:Object, param2:INavigationControlWrapper=null):INavigationControl{
            return (INavigationControl(wrap(param1, param2, INavigationControl, INavigationControlWrapper)));
        }
        public function wrapStyledMapTypeOptions(param1:Object):StyledMapTypeOptions{
            if (param1 == null){
                return (null);
            };
            return (StyledMapTypeOptions.fromObject(param1));
        }
        public function wrapZoomControlOptions(param1:Object):ZoomControlOptions{
            if (param1 == null){
                return (null);
            };
            return (ZoomControlOptions.fromObject(param1));
        }
        public function wrapRoute(param1:Object):Route{
            if (param1 == null){
                return (null);
            };
            return (Route.fromObject(param1));
        }
        public function wrapPlacemark(param1:Object):Placemark{
            if (param1 == null){
                return (null);
            };
            return (Placemark.fromObject(param1));
        }
        public function wrapGeocodingResponse(param1:Object):GeocodingResponse{
            if (param1 == null){
                return (null);
            };
            return (GeocodingResponse.fromObject(param1));
        }
        public function wrapElevationResponseArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapElevationResponse(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapStep(param1:Object):Step{
            if (param1 == null){
                return (null);
            };
            return (Step.fromObject(param1));
        }
        public function wrapGradientStyle(param1:Object):GradientStyle{
            if (param1 == null){
                return (null);
            };
            return (GradientStyle.fromObject(param1));
        }
        public function wrapColor(param1:Object):Color{
            if (param1 == null){
                return (null);
            };
            return (Color.fromObject(param1));
        }
        public function wrapColorTransform(param1:ColorTransform):ColorTransform{
            return (param1);
        }
        public function wrapBevelStyle(param1:Object):BevelStyle{
            if (param1 == null){
                return (null);
            };
            return (BevelStyle.fromObject(param1));
        }
        public function wrapICamera(param1:Object, param2:ICameraWrapper=null):ICamera{
            return (ICamera(wrap(param1, param2, ICamera, ICameraWrapper)));
        }
        public function wrapRectangle(param1:Rectangle):Rectangle{
            return (param1);
        }
        public function wrapIPane(param1:Object, param2:IPaneWrapper=null):IPane{
            return (IPane(wrap(param1, param2, IPane, IPaneWrapper)));
        }
        public function wrapLatLngArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapLatLng(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrap(param1:Object, param2:Object, param3:Class, param4:Class):Object{
            var _loc_5:Object;
            var _loc_6:Object;
            var _loc_7:Array;
            var _loc_8:Number = NaN;
            var _loc_9:String;
            var _loc_10:Class;
            if (param1 == null){
                return (null);
            };
            if (param2 == null){
                _loc_5 = (param1 as param3);
                if (_loc_5 != null){
                    return (_loc_5);
                };
                _loc_6 = (param1.wrapper as param3);
                if (_loc_6 != null){
                    return (_loc_6);
                };
                _loc_7 = param1.interfaceChain;
                if (_loc_7 != null){
                    _loc_8 = 0;
                    while (_loc_8 < _loc_7.length) {
                        _loc_9 = _loc_7[_loc_8];
                        _loc_10 = (wrappersMap[_loc_9] as Class);
                        if (_loc_10 != null){
                            param2 = (new (_loc_10)() as param3);
                        };
                        _loc_8 = (_loc_8 + 1);
                    };
                };
                if (param2 == null){
                    param2 = new (param4)();
                };
            };
            param2.initializeWrapper(param1, alienWrapper);
            param1.wrapper = param2;
            return (param2);
        }
        public function wrapIZoomControl(param1:Object, param2:IZoomControlWrapper=null):IZoomControl{
            return (IZoomControl(wrap(param1, param2, IZoomControl, IZoomControlWrapper)));
        }
        private function initializeWrappersMap(param1:Object):void{
            param1["IMap"] = IMapWrapper;
            param1["IMapsFactory"] = IMapsFactoryWrapper;
            param1["IControl"] = IControlWrapper;
            param1["IMapTypeControl"] = IMapTypeControlWrapper;
            param1["IOverviewMapControl"] = IOverviewMapControlWrapper;
            param1["IPositionControl"] = IPositionControlWrapper;
            param1["IScaleControl"] = IScaleControlWrapper;
            param1["IZoomControl"] = IZoomControlWrapper;
            param1["INavigationControl"] = INavigationControlWrapper;
            param1["IMap3D"] = IMap3DWrapper;
            param1["IMapsFactory3D"] = IMapsFactory3DWrapper;
            param1["ICopyrightCollection"] = ICopyrightCollectionWrapper;
            param1["IElevation"] = IElevationWrapper;
            param1["IGroundOverlay"] = IGroundOverlayWrapper;
            param1["IInfoWindow"] = IInfoWindowWrapper;
            param1["IMapType"] = IMapTypeWrapper;
            param1["IMarker"] = IMarkerWrapper;
            param1["IMaxZoom"] = IMaxZoomWrapper;
            param1["IOverlay"] = IOverlayWrapper;
            param1["IPane"] = IPaneWrapper;
            param1["IPaneManager"] = IPaneManagerWrapper;
            param1["IPolygon"] = IPolygonWrapper;
            param1["IPolyline"] = IPolylineWrapper;
            param1["IProjection"] = IProjectionWrapper;
            param1["IStyledMapType"] = IStyledMapTypeWrapper;
            param1["ITileLayer"] = ITileLayerWrapper;
            param1["ITileLayerOverlay"] = ITileLayerOverlayWrapper;
            param1["ICamera"] = ICameraWrapper;
            param1["IClientGeocoder"] = IClientGeocoderWrapper;
            param1["IDirections"] = IDirectionsWrapper;
        }
        public function clear():void{
            alienWrapper = null;
            Wrapper.nativeWrapper = null;
        }
        public function setAlienWrapper(param1:Object):void{
            if (this.alienWrapper == null){
                this.alienWrapper = param1;
                param1.setAlienWrapper(this);
            };
        }
        public function wrapPlacemarkArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapPlacemark(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapLoaderInfo(param1:LoaderInfo):LoaderInfo{
            return (param1);
        }
        public function wrapMapTypeStyleArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapMapTypeStyle(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapIStyledMapTypeArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapIStyledMapType(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapInfoWindowOptions(param1:Object):InfoWindowOptions{
            if (param1 == null){
                return (null);
            };
            return (InfoWindowOptions.fromObject(param1));
        }
        public function wrapPoint3D(param1:Object):Point3D{
            if (param1 == null){
                return (null);
            };
            return (Point3D.fromObject(param1));
        }
        public function wrapIMarker(param1:Object, param2:IMarkerWrapper=null):IMarker{
            return (IMarker(wrap(param1, param2, IMarker, IMarkerWrapper)));
        }
        public function wrapOverviewMapControlOptions(param1:Object):OverviewMapControlOptions{
            if (param1 == null){
                return (null);
            };
            return (OverviewMapControlOptions.fromObject(param1));
        }
        public function wrapIOverviewMapControl(param1:Object, param2:IOverviewMapControlWrapper=null):IOverviewMapControl{
            return (IOverviewMapControl(wrap(param1, param2, IOverviewMapControl, IOverviewMapControlWrapper)));
        }
        public function wrapBitmapData(param1:BitmapData):BitmapData{
            return (param1);
        }
        public function wrapIStyledMapType(param1:Object, param2:IStyledMapTypeWrapper=null):IStyledMapType{
            return (IStyledMapType(wrap(param1, param2, IStyledMapType, IStyledMapTypeWrapper)));
        }
        public function wrapIPaneManager(param1:Object, param2:IPaneManagerWrapper=null):IPaneManager{
            return (IPaneManager(wrap(param1, param2, IPaneManager, IPaneManagerWrapper)));
        }
        public function wrapIWrappableEventDispatcher(param1:Object, param2:EventDispatcherWrapper=null):IWrappableEventDispatcher{
            return (IWrappableEventDispatcher(wrap(param1, param2, IEventDispatcher, EventDispatcherWrapper)));
        }
        public function wrapRectangleStyle(param1:Object):RectangleStyle{
            if (param1 == null){
                return (null);
            };
            return (RectangleStyle.fromObject(param1));
        }
        private function wrapEvent(event:Event, param2:Object):Event{
            var _loc_3:Object;
            var _loc_4:Array;
            var _loc_5:Number = NaN;
            var _loc_6:String;
            var _loc_7:Class;
            _loc_3 = event;
            if (!(_loc_3.hasOwnProperty("eventClassChain"))){
                return (event);
            };
            _loc_4 = _loc_3.eventClassChain;
            if (_loc_4 != null){
                _loc_5 = 0;
                while (_loc_5 < _loc_4.length) {
                    _loc_6 = _loc_4[_loc_5];
                    _loc_7 = eventClassMap[_loc_6];
                    return (Object(_loc_7).fromCrossDomainEvent(event, param2));
                };
            };
            return (event);
        }
        public function wrapIDirections(param1:Object, param2:IDirectionsWrapper=null):IDirections{
            return (IDirections(wrap(param1, param2, IDirections, IDirectionsWrapper)));
        }
        public function wrapIMapType(param1:Object, param2:IMapTypeWrapper=null):IMapType{
            return (IMapType(wrap(param1, param2, IMapType, IMapTypeWrapper)));
        }
        public function wrapRouteArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapRoute(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapIClientGeocoder(param1:Object, param2:IClientGeocoderWrapper=null):IClientGeocoder{
            return (IClientGeocoder(wrap(param1, param2, IClientGeocoder, IClientGeocoderWrapper)));
        }
        public function wrapCopyrightNoticeArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapCopyrightNotice(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapTransformationGeometry(param1:Object):TransformationGeometry{
            if (param1 == null){
                return (null);
            };
            return (TransformationGeometry.fromObject(param1));
        }
        public function wrapMapOptions(param1:Object):MapOptions{
            if (param1 == null){
                return (null);
            };
            return (MapOptions.fromObject(param1));
        }
        public function wrapIScaleControl(param1:Object, param2:IScaleControlWrapper=null):IScaleControl{
            return (IScaleControl(wrap(param1, param2, IScaleControl, IScaleControlWrapper)));
        }
        public function wrapElevationResponse(param1:Object):ElevationResponse{
            if (param1 == null){
                return (null);
            };
            return (ElevationResponse.fromObject(param1));
        }
        public function wrapIMap(param1:Object, param2:IMapWrapper=null):IMap{
            return (IMap(wrap(param1, param2, IMap, IMapWrapper)));
        }
        public function wrapButtonFaceStyle(param1:Object):ButtonFaceStyle{
            if (param1 == null){
                return (null);
            };
            return (ButtonFaceStyle.fromObject(param1));
        }
        public function wrapIEventDispatcher(param1:Object, param2:EventDispatcherWrapper=null):IEventDispatcher{
            return (IEventDispatcher(wrap(param1, param2, IEventDispatcher, EventDispatcherWrapper)));
        }
        public function wrapTextField(param1:TextField):TextField{
            return (param1);
        }
        public function wrapCopyright(param1:Object):Copyright{
            if (param1 == null){
                return (null);
            };
            return (Copyright.fromObject(param1));
        }
        public function wrapMatrix(param1:Matrix):Matrix{
            return (param1);
        }
        public function wrapMapTypeControlOptions(param1:Object):MapTypeControlOptions{
            if (param1 == null){
                return (null);
            };
            return (MapTypeControlOptions.fromObject(param1));
        }
        public function wrapStrokeStyle(param1:Object):StrokeStyle{
            if (param1 == null){
                return (null);
            };
            return (StrokeStyle.fromObject(param1));
        }
        public function wrapIMapsFactory(param1:Object, param2:IMapsFactoryWrapper=null):IMapsFactory{
            return (IMapsFactory(wrap(param1, param2, IMapsFactory, IMapsFactoryWrapper)));
        }
        public function wrapIPositionControl(param1:Object, param2:IPositionControlWrapper=null):IPositionControl{
            return (IPositionControl(wrap(param1, param2, IPositionControl, IPositionControlWrapper)));
        }
        public function wrapEventHandler(param1:Function, param2:Object=null):Function{
            var target:* = undefined;
            var param1:* = param1;
            var param2 = param2;
            var handler:* = param1;
            target = param2;
            return (function (event:Event):void{
                handler(wrapEvent(event, (target) ? target : event.target));
            });
        }
        public function wrapCopyrightArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapCopyright(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapScaleControlOptions(param1:Object):ScaleControlOptions{
            if (param1 == null){
                return (null);
            };
            return (ScaleControlOptions.fromObject(param1));
        }
        public function wrapStepArray(param1:Object):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (param1 == null){
                return (null);
            };
            _loc_2 = [];
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3) {
                _loc_2.push(this.wrapStep(param1[_loc_4]));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_2);
        }
        public function wrapFillStyle(param1:Object):FillStyle{
            if (param1 == null){
                return (null);
            };
            return (FillStyle.fromObject(param1));
        }
        public function wrapLatLngBounds(param1:Object):LatLngBounds{
            if (param1 == null){
                return (null);
            };
            return (LatLngBounds.fromObject(param1));
        }
        public function wrapIGroundOverlay(param1:Object, param2:IGroundOverlayWrapper=null):IGroundOverlay{
            return (IGroundOverlay(wrap(param1, param2, IGroundOverlay, IGroundOverlayWrapper)));
        }
        public function wrapITileLayer(param1:Object, param2:ITileLayerWrapper=null):ITileLayer{
            return (ITileLayer(wrap(param1, param2, ITileLayer, ITileLayerWrapper)));
        }
        public function wrapIMap3D(param1:Object, param2:IMap3DWrapper=null):IMap3D{
            return (IMap3D(wrap(param1, param2, IMap3D, IMap3DWrapper)));
        }
        private function addEventNamesToMap(param1:Object, param2:Class):void{
            var _loc_3:XML;
            var _loc_4:XMLList;
            var _loc_5:int;
            var _loc_6:XML;
            _loc_3 = describeType(param2);
            _loc_4 = _loc_3.child("constant");
            _loc_5 = 0;
            while (_loc_5 < _loc_4.length()) {
                _loc_6 = _loc_4[_loc_5];
                if (_loc_6.@type == "String"){
                    param1[param2[_loc_6.@name]] = 1;
                };
                _loc_5 = (_loc_5 + 1);
            };
        }
        public function wrapCopyrightNotice(param1:Object):CopyrightNotice{
            if (param1 == null){
                return (null);
            };
            return (CopyrightNotice.fromObject(param1));
        }
        public function wrapMarkerOptions(param1:Object):MarkerOptions{
            if (param1 == null){
                return (null);
            };
            return (MarkerOptions.fromObject(param1));
        }
        public function wrapIInfoWindow(param1:Object, param2:IInfoWindowWrapper=null):IInfoWindow{
            return (IInfoWindow(wrap(param1, param2, IInfoWindow, IInfoWindowWrapper)));
        }
        public function wrapIElevation(param1:Object, param2:IElevationWrapper=null):IElevation{
            return (IElevation(wrap(param1, param2, IElevation, IElevationWrapper)));
        }
        public function wrapMouseEvent(event:MouseEvent):MouseEvent{
            return (event);
        }
        public function wrapIMapTypeControl(param1:Object, param2:IMapTypeControlWrapper=null):IMapTypeControl{
            return (IMapTypeControl(wrap(param1, param2, IMapTypeControl, IMapTypeControlWrapper)));
        }
        public function isLibraryEvent(param1:String):Boolean{
            return (!((eventNamesMap[param1] == null)));
        }
        public function wrapITileLayerOverlay(param1:Object, param2:ITileLayerOverlayWrapper=null):ITileLayerOverlay{
            return (ITileLayerOverlay(wrap(param1, param2, ITileLayerOverlay, ITileLayerOverlayWrapper)));
        }
        public function wrapS1Interval(param1:Object):S1Interval{
            if (param1 == null){
                return (null);
            };
            return (S1Interval.fromObject(param1));
        }
        public function wrapIProjection(param1:Object, param2:IProjectionWrapper=null):IProjection{
            return (IProjection(wrap(param1, param2, IProjection, IProjectionWrapper)));
        }
        private function initializeEventClassMap(param1:Object):void{
            param1["MapEvent"] = MapEvent;
            param1["MapMouseEvent"] = MapMouseEvent;
            param1["MapMoveEvent"] = MapMoveEvent;
            param1["MapZoomEvent"] = MapZoomEvent;
            param1["MapAttitudeEvent"] = MapAttitudeEvent;
            param1["DirectionsEvent"] = DirectionsEvent;
            param1["ElevationEvent"] = ElevationEvent;
            param1["GeocodingEvent"] = GeocodingEvent;
            param1["MaxZoomEvent"] = MaxZoomEvent;
        }
        public function wrapMapTypeOptions(param1:Object):MapTypeOptions{
            if (param1 == null){
                return (null);
            };
            return (MapTypeOptions.fromObject(param1));
        }
        public function wrapPositionControlOptions(param1:Object):PositionControlOptions{
            if (param1 == null){
                return (null);
            };
            return (PositionControlOptions.fromObject(param1));
        }
        public function wrapButtonStyle(param1:Object):ButtonStyle{
            if (param1 == null){
                return (null);
            };
            return (ButtonStyle.fromObject(param1));
        }
        public function wrapLatLng(param1:Object):LatLng{
            if (param1 == null){
                return (null);
            };
            return (LatLng.fromObject(param1));
        }
        public function wrapR1Interval(param1:Object):R1Interval{
            if (param1 == null){
                return (null);
            };
            return (R1Interval.fromObject(param1));
        }
        public function wrapControlPosition(param1:Object):ControlPosition{
            if (param1 == null){
                return (null);
            };
            return (ControlPosition.fromObject(param1));
        }
        public function wrapLoader(param1:Loader):Loader{
            return (param1);
        }
        private function initializeEventNamesMap(param1:Object):void{
            addEventNamesToMap(param1, MapEvent);
            addEventNamesToMap(param1, MapMouseEvent);
            addEventNamesToMap(param1, MapMoveEvent);
            addEventNamesToMap(param1, MapZoomEvent);
            addEventNamesToMap(param1, MapAttitudeEvent);
            addEventNamesToMap(param1, DirectionsEvent);
            addEventNamesToMap(param1, ElevationEvent);
            addEventNamesToMap(param1, GeocodingEvent);
            addEventNamesToMap(param1, MaxZoomEvent);
        }
        public function wrapGroundOverlayOptions(param1:Object):GroundOverlayOptions{
            if (param1 == null){
                return (null);
            };
            return (GroundOverlayOptions.fromObject(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
