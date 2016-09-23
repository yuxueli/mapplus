//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;
    import flash.net.*;

    public class UsageTracker extends EventDispatcher {

        public static const URL_ARGVAL_USAGETYPE_OVERVIEW:String = "o";
        public static const URL_ARG_KEY:String = "key";
        public static const URL_ARG_EVENT:String = "ev";
        public static const URL_ARG_FLC:String = "flc";
        public static const URL_ARG_MAPCLIENT:String = "mapclient";
        public static const URL_ARG_USAGETYPE:String = "mapt";
        public static const URL_ARGVAL_USAGETYPE_POPUP:String = "p";
        public static const URL_ARG_URL:String = "url";
        public static const URL_ARG_TILEVERSION:String = "v";
        public static const URL_ARGVAL_EVENT_ZOOMIN:String = "zi";
        public static const URL_ARG_SPAN:String = "spn";
        public static const URL_ARG_CLIENT:String = "client";
        public static const URL_ARG_CHANNEL:String = "channel";
        public static const URL_ARG_VIEWPOINT:String = "vp";
        public static const URL_ARGVAL_USAGETYPE_MAP:String = "m";
        public static const URL_ARGVAL_EVENT_ZOOMOUT:String = "zo";
        public static const URL_ARGVAL_EVENT_PAN:String = "p";
        public static const URL_ARG_MAPTYPE:String = "t";

        private var referenceZoom:Number;
        private var referenceCenter:LatLng;
        private var eventArg:String;
        private var points:Object;
        private var referenceMapType:IMapType;
        private var map:MapImpl;
        private var usageType:String;

        public function UsageTracker(param1:MapImpl, param2:String){
            super();
            this.map = param1;
            this.usageType = ((((param2 == URL_ARGVAL_USAGETYPE_OVERVIEW)) || ((param2 == URL_ARGVAL_USAGETYPE_POPUP)))) ? param2 : URL_ARGVAL_USAGETYPE_MAP;
            param1.addEventListener(MapMoveEvent.MOVE_END, onMapMoveEnd);
            param1.addEventListener(MapEvent.SIZE_CHANGED, onMapResize);
            reset();
            addPoint(0, 0, true);
        }
        public static function encodedParams(param1:Object):String{
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:String;
            _loc_2 = "";
            _loc_3 = "";
            for (_loc_4 in param1) {
                _loc_2 = (_loc_2 + _loc_3);
                _loc_2 = (_loc_2 + _loc_4);
                _loc_2 = (_loc_2 + "=");
                _loc_2 = (_loc_2 + encodeURIComponent(param1[_loc_4]));
                _loc_3 = "&";
            };
            return (_loc_2);
        }

        private function loadCopyright(param1:String):void{
            var mapsHost:* = null;
            var rawUrl:* = null;
            var urlRequest:* = null;
            var urlLoader:* = null;
            var request:* = null;
            var loader:* = null;
            var info:* = null;
            var param1:* = param1;
            var query:* = param1;
            mapsHost = map.getMapsHost();
            if (!mapsHost){
                return;
            };
            rawUrl = (((((Util.isSsl()) ? "https://" : "http://" + mapsHost) + MapImpl.FLASH_MAPS_API_PATH) + "?") + query);
            if (Bootstrap.getBootstrap().useSwfResponse()){
                request = new URLRequest(rawUrl);
                loader = new Loader();
                info = loader.contentLoaderInfo;
                addEventListeners(info);
                try {
                    loader.load(request);
                } catch(error:Error) {
                    removeEventListeners(info);
                };
                return;
            };
            urlRequest = new URLRequest(rawUrl);
            urlLoader = new URLLoader();
            addEventListeners(urlLoader);
            try {
                urlLoader.load(urlRequest);
            } catch(error:Error) {
                removeEventListeners(urlLoader);
            };
        }
        private function onLoadFailed(event:Event):void{
            removeEventListeners(IEventDispatcher(event.target));
        }
        private function onMapMoveEnd(event:Event):void{
            var _loc_2:LatLng;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:LatLng;
            if (((!((referenceZoom == getRoundedZoom()))) || (!((referenceMapType == map.getCurrentMapType()))))){
                determineEvent();
                reset();
                addPoint(0, 0, true);
                return;
            };
            _loc_2 = map.getCenter();
            _loc_5 = map.getCamera().get2DLatLngBounds().toSpan();
            _loc_3 = Math.round(((_loc_2.lat() - referenceCenter.lat()) / _loc_5.lat()));
            _loc_4 = Math.round(((_loc_2.lng() - referenceCenter.lng()) / _loc_5.lng()));
            eventArg = URL_ARGVAL_EVENT_PAN;
            addPoint(_loc_3, _loc_4, true);
        }
        private function determineEvent():void{
            var _loc_1:Number = NaN;
            var _loc_2:String;
            var _loc_3:String;
            _loc_1 = getRoundedZoom();
            if (referenceZoom != _loc_1){
                eventArg = ((referenceZoom < _loc_1)) ? URL_ARGVAL_EVENT_ZOOMIN : URL_ARGVAL_EVENT_ZOOMOUT;
            };
            if (referenceMapType == null){
                return;
            };
            _loc_2 = map.getCurrentMapType().getUrlArg();
            _loc_3 = referenceMapType.getUrlArg();
            if (_loc_3 != _loc_2){
                eventArg = (_loc_3 + _loc_2);
            };
        }
        private function reset():void{
            referenceCenter = map.getCenter();
            referenceMapType = map.getCurrentMapType();
            referenceZoom = getRoundedZoom();
            points = {};
        }
        private function onMapResize(event:Event):void{
            reset();
            addPoint(0, 0, false);
        }
        private function addEventListeners(param1:IEventDispatcher):void{
            param1.addEventListener(Event.COMPLETE, onLoadComplete);
            param1.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
            param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFailed);
        }
        private function removeEventListeners(param1:IEventDispatcher):void{
            param1.removeEventListener(Event.COMPLETE, onLoadComplete);
            param1.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
            param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFailed);
        }
        private function getRoundedZoom():Number{
            return (Math.round(map.getZoom()));
        }
        private function addPoint(param1:Number, param2:Number, param3:Boolean):void{
            var _loc_4:String;
            var _loc_5:Bootstrap;
            var _loc_6:Object;
            var _loc_7:Object;
            var _loc_8:String;
            if (!map.isLoaded()){
                return;
            };
            _loc_4 = ((param1 + ",") + param2);
            if (points[_loc_4]){
                return;
            };
            points[_loc_4] = true;
            if (param3){
                _loc_5 = Bootstrap.getBootstrap();
                _loc_6 = {};
                _loc_6[URL_ARG_MAPCLIENT] = "flashapi";
                _loc_6[URL_ARG_VIEWPOINT] = map.getCenter().toUrlValue();
                _loc_6[URL_ARG_SPAN] = map.getCamera().get2DLatLngBounds().toSpan().toUrlValue();
                if (map.getCurrentMapType() != _loc_5.getNormalMapType()){
                    _loc_6[URL_ARG_MAPTYPE] = map.getCurrentMapType().getUrlArg();
                };
                _loc_6[URL_ARG_EVENT] = eventArg;
                _loc_6["z"] = getRoundedZoom();
                if (_loc_5.useSwfResponse()){
                    _loc_6["output"] = "swf";
                };
                _loc_7 = _loc_5.getClientConfiguration();
                if (_loc_7.hasOwnProperty("fliburl")){
                    _loc_8 = _loc_7.fliburl;
                    if (_loc_8){
                        _loc_6["fliburl"] = _loc_8;
                    };
                };
                Util.copyData(_loc_5.getClientConfiguration(), _loc_6, [URL_ARG_KEY, URL_ARG_CLIENT, URL_ARG_CHANNEL, URL_ARG_FLC, URL_ARG_URL], String);
                loadCopyright(encodedParams(_loc_6));
            };
        }
        private function onLoadComplete(event:Event):void{
            var urlLoader:* = null;
            var loader:* = null;
            var json:* = null;
            var event:* = event;
            var e:* = event;
            removeEventListeners(IEventDispatcher(e.target));
            if (Bootstrap.getBootstrap().useSwfResponse()){
                try {
                    loader = (e.target as LoaderInfo).loader;
                    json = (loader.content as Object).json;
                    map.getBootstrap().addCopyrightData(json);
                    loader.unload();
                } catch(ex) {
                    Log.log(((((((ex.name + ":") + ex.message) + ":") + ex.at) + ":") + ex.text));
                };
                return;
            };
            urlLoader = URLLoader(e.target);
            try {
                map.getBootstrap().addCopyrightData(urlLoader.data);
            } catch(ex) {
                Log.log(((((((ex.name + ":") + ex.message) + ":") + ex.at) + ":") + ex.text));
            };
        }
        public function unload():void{
            map.removeEventListener(MapMoveEvent.MOVE_END, onMapMoveEnd);
            map.removeEventListener(MapEvent.SIZE_CHANGED, onMapResize);
        }

    }
}//package com.mapplus.maps.core 
