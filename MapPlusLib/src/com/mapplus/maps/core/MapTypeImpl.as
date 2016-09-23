//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import flash.geom.*;

    public class MapTypeImpl extends WrappableEventDispatcher implements IMapType {

        public static const DEFAULT_TILE_SIZE:Number = 0x0100;
        private static const PIXEL_MARGIN:Number = 3;

        private static var defaultOptions:MapTypeOptions = new MapTypeOptions({
            shortName:new String(""),
            urlArg:new String("c"),
            tileSize:MapTypeImpl.DEFAULT_TILE_SIZE,
            textColor:Color.BLACK,
            linkColor:Color.DEFAULTLINK,
            errorMessage:new String("很抱歉，在这一缩放级别的地图上未找到此区域。"),
            alt:new String(""),
            radius:LatLng.EARTH_RADIUS
        });

        private var googleUrlArg:String;
        private var name:String;
        protected var tileLayers:Array;
        private var maxResolutionOverride:Number = 0;
        private var options:MapTypeOptions;
        private var projection:IProjection;
        private var _minTileResolution:Number;
        private var _maxTileResolution:Number;

        public function MapTypeImpl(param1:Array, param2:IProjection, param3:String, param4:MapTypeOptions=null){
            super();
            var _loc_5:ITileLayer;
            var _loc_6:ICopyrightCollection;
            this.maxResolutionOverride = 0;
            this.options = MapTypeOptions.merge([MapTypeImpl.getDefaultOptions(), param4]);
            this.tileLayers = param1;
            this.name = param3;
            this.projection = param2;
            this._maxTileResolution = 0;
            this._minTileResolution = PConstants.ZOOM_LEVEL_LIMIT;
            for each (_loc_5 in param1) {
                this._maxTileResolution = Math.max(this._maxTileResolution, _loc_5.getMaxResolution());
                this._minTileResolution = Math.min(this._minTileResolution, _loc_5.getMinResolution());
                if (!(Bootstrap.getBootstrap().isClientVersionAfter(9, "a"))){
                    _loc_5.setMapType(this);
                };
                _loc_6 = _loc_5.getCopyrightCollection();
                if (_loc_6){
                    _loc_6.addEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onUpdateCopyrights);
                };
            };
            if (isDefaultMapTypeCreationDone()){
                this.googleUrlArg = getGoogleUrlArg(param1, Bootstrap.getBootstrap());
            };
        }
        private static function isDefaultMapTypeCreationDone():Boolean{
            return (!((Bootstrap.getBootstrap().getDefaultMapTypes() == null)));
        }
        public static function getDefaultOptions():MapTypeOptions{
            return (MapTypeImpl.defaultOptions);
        }
        public static function isLayerMatch(param1:IMapType, param2:int, param3:ITileLayer):Boolean{
            var _loc_4:Array;
            if (!(param1)){
                return (false);
            };
            _loc_4 = param1.getTileLayers();
            if (param2 < _loc_4.length){
                return ((_loc_4[param2] == param3));
            };
            return (false);
        }
        public static function getGoogleUrlArg(param1:Array, param2:Object):String{
            var _loc_3:IMapType;
            var _loc_4:IMapType;
            var _loc_5:IMapType;
            var _loc_6:IMapType;
            var _loc_7:Boolean;
            var _loc_8:int;
            var _loc_9:ITileLayer;
            _loc_3 = param2.getNormalMapType();
            _loc_4 = param2.getSatelliteMapType();
            _loc_5 = param2 .getHybridMapType();
            _loc_6 = param2.getPhysicalMapType();
            _loc_7 = false;
            _loc_8 = (param1.length - 1);
            while (_loc_8 >= 0) {
                _loc_9 = param1[_loc_8];
                if (isLayerMatch(_loc_4, 0, _loc_9)){
                    return (_loc_7 ? _loc_5 : _loc_4).getUrlArg();
                };
                if (isLayerMatch(_loc_3, 0, _loc_9)){
                    return (param2.getNormalMapType().getUrlArg());
                };
                if (isLayerMatch(_loc_6, 0, _loc_9)){
                    return (param2.getPhysicalMapType().getUrlArg());
                };
                if (isLayerMatch(_loc_5, 1, _loc_9)){
                    _loc_7 = true;
                };
                _loc_8 = (_loc_8 - 1);
            };
            return ((_loc_7) ? param2.getNormalMapType().getUrlArg() : null);
        }
        public static function setDefaultOptions(param1:MapTypeOptions):void{
            MapTypeImpl.defaultOptions = MapTypeOptions.merge([MapTypeImpl.defaultOptions, param1]);
        }

        public function getCopyrights(param1:LatLngBounds, param2:Number):Array{
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:ICopyrightCollection;
            var _loc_6:CopyrightNotice;
            _loc_3 = [];
            _loc_4 = 0;
            while (_loc_4 < this.tileLayers.length) {
                _loc_5 = this.tileLayers[_loc_4].getCopyrightCollection();
                if (!(_loc_5)){
                } else {
                    _loc_6 = _loc_5.getCopyrightNotice(param1, param2);
                    if (_loc_6){
                        _loc_3.push(_loc_6);
                    };
                };
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_3);
        }
        override public function get interfaceChain():Array{
            return (["IMapType", "IWrappableEventDispatcher"]);
        }
        public function getSpanZoomLevel(param1:LatLng, param2:LatLng, param3:Point):Number{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Point;
            var _loc_12:LatLngBounds;
            var _loc_13:LatLng;
            _loc_4 = this.getMaximumResolution(param1);
            _loc_5 = this.getMinimumResolution(param1);
            _loc_6 = Math.round((param3.x / 2));
            _loc_7 = Math.round((param3.y / 2));
            _loc_8 = _loc_4;
            while (_loc_8 >= _loc_5) {
                _loc_9 = this.projection.fromLatLngToPixel(param1, _loc_8);
                _loc_10 = new Point(((_loc_9.x - _loc_6) - PIXEL_MARGIN), ((_loc_9.y + _loc_7) + PIXEL_MARGIN));
                _loc_11 = new Point(((_loc_10.x + param3.x) + PIXEL_MARGIN), ((_loc_10.y - param3.y) - PIXEL_MARGIN));
                _loc_12 = new LatLngBounds(this.projection.fromPixelToLatLng(_loc_10, _loc_8), this.projection.fromPixelToLatLng(_loc_11, _loc_8));
                _loc_13 = _loc_12.toSpan();
                if ((((_loc_13.lat() >= param2.lat())) && ((_loc_13.lng() >= param2.lng())))){
                    return (_loc_8);
                };
                _loc_8 = (_loc_8 - 1);
            };
            return (0);
        }
        public function getName(param1:Boolean=false):String{
            return ((param1) ? this.getShortName() : this.name);
        }
        public function getMinimumResolution(param1:LatLng=null):Number{
            return (this.clampedToOptionMinMaxResolution(this._minTileResolution));
        }
        public function getTileLayers():Array{
            return (this.tileLayers.slice());
        }
        private function clampedToOptionMinMaxResolution(param1:Number):Number{
            if (this.options.minResolution){
                param1 = Math.max(param1, (this.options.minResolution as Number));
            };
            if (this.options.maxResolution){
                param1 = Math.min(param1, (this.options.maxResolution as Number));
            };
            return (param1);
        }
        public function onUpdateCopyrights(event:Event):void{
            dispatchEvent(new MapEvent(MapEvent.COPYRIGHTS_UPDATED, this));
        }
        public function getRadius():Number{
            return ((this.options.radius as Number));
        }
        public function getTextColor():Number{
            return ((this.options.textColor as Number));
        }
        private function getCopyrightsAtPoint(param1:LatLng):Array{
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:ICopyrightCollection;
            var _loc_5:Array;
            var _loc_6:int;
            _loc_2 = [];
            _loc_3 = 0;
            while (_loc_3 < this.tileLayers.length) {
                _loc_4 = this.tileLayers[_loc_3].getCopyrightCollection();
                if (!(_loc_4)){
                } else {
                    _loc_5 = _loc_4.getCopyrightsAtLatLng(param1);
                    if (_loc_5){
                        _loc_6 = 0;
                        while (_loc_6 < _loc_5.length) {
                            _loc_2.push(_loc_5[_loc_6]);
                            _loc_6++;
                        };
                    };
                };
                _loc_3++;
            };
            return (_loc_2);
        }
        public function getMaximumResolution(param1:LatLng=null):Number{
            var _loc_2:Number = NaN;
            _loc_2 = (param1) ? this.getMaximumResolutionWithLatLng(param1) : this._maxTileResolution;
            return (this.clampedToOptionMinMaxResolution(_loc_2));
        }
        public function getMaximumResolutionWithLatLng(param1:LatLng):Number{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:int;
            _loc_2 = this.getCopyrightsAtPoint(param1);
            _loc_3 = 0;
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length) {
                if (_loc_2[_loc_4].getMaxZoom()){
                    _loc_3 = Math.max(_loc_3, _loc_2[_loc_4].getMaxZoom());
                };
                _loc_4++;
            };
            return (this.clampedToOptionMinMaxResolution(Math.max(this._maxTileResolution, Math.max(this.maxResolutionOverride, _loc_3))));
        }
        public function getProjection():IProjection{
            return (this.projection);
        }
        public function getLinkColor():Number{
            return ((this.options.linkColor as Number));
        }
        public function getErrorMessage():String{
            return (this.options.errorMessage);
        }
        public function getUrlArg():String{
            return ((this.googleUrlArg) ? this.googleUrlArg : this.options.urlArg);
        }
        public function setMaxResolutionOverride(param1:Number):void{
            this.maxResolutionOverride = param1;
        }
        public function getMaxResolutionOverride():Number{
            return (this.maxResolutionOverride);
        }
        public function getTileSize():Number{
            return ((this.options.tileSize as Number));
        }
        public function getBoundsZoomLevel(param1:LatLngBounds, param2:Point):Number{
            var _loc_3:IProjection;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:LatLng;
            var _loc_7:LatLng;
            var _loc_8:Number = NaN;
            var _loc_9:Point;
            var _loc_10:Point;
            _loc_3 = this.projection;
            _loc_4 = this.getMaximumResolution(param1.getCenter());
            _loc_5 = this.getMinimumResolution(param1.getCenter());
            _loc_6 = param1.getSouthWest();
            _loc_7 = param1.getNorthEast();
            _loc_8 = _loc_4;
            while (_loc_8 >= _loc_5) {
                _loc_9 = _loc_3.fromLatLngToPixel(_loc_6, _loc_8);
                _loc_10 = _loc_3.fromLatLngToPixel(_loc_7, _loc_8);
                if (_loc_9.x > _loc_10.x){
                    _loc_9.x = (_loc_9.x - _loc_3.getWrapWidth(_loc_8));
                };
                if ((((Math.abs((_loc_10.x - _loc_9.x)) <= param2.x)) && ((Math.abs((_loc_10.y - _loc_9.y)) <= param2.y)))){
                    return (_loc_8);
                };
                _loc_8 = (_loc_8 - 1);
            };
            return (0);
        }
        private function getShortName():String{
            if (((this.options.shortName) && (!((this.options.shortName.length == 0))))){
                return (this.options.shortName);
            };
            return (this.name);
        }
        public function getAlt():String{
            return (this.options.alt);
        }

    }
}//package com.mapplus.maps.core 
