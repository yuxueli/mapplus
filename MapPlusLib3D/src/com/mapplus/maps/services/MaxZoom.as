//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;
    import flash.net.*;

    public class MaxZoom extends WrappableEventDispatcher implements IMaxZoom {

        private static const VERSION_REGEXP:RegExp = /[&?\/](?:v|lyrs)=([^&]*)""[&?\/](?:v|lyrs)=([^&]*)/;
        private static const ZOOM_REGEXP:RegExp = /""?zoom""?:\s*(\d+)"""?zoom"?:\s*(\d+)/;
        static const MAXZOOM_MAXLEVEL:Number = 22;
        private static const MAXZOOM_PATH:String = "/mz";

        private var mapType:IMapType;

        public function MaxZoom(param1:IMapType){
            super();
            this.mapType = param1;
        }
        protected function dispatchMaxZoomRequest(param1:LatLng, param2:int, param3:int, param4:int, param5:String):void{
            var tileLayer:* = null;
            var domain:* = null;
            var url:* = null;
            var loader:* = null;
            var latLng:* = undefined;
            var param1:* = param1;
            var param2:* = param2;
            var param3:* = param3;
            var param4:* = param4;
            var param5:* = param5;
            latLng = param1;
            var x:* = param2;
            var y:* = param3;
            var zoom:* = param4;
            var version:* = param5;
            tileLayer = mapType.getTileLayers()[0];
            domain = tileLayer.getTileDomain(x, y, zoom);
            url = (((((((((((Util.isSsl()) ? "https" : "http" + domain) + MAXZOOM_PATH) + "?x=") + x) + "&y=") + y) + "&z=") + zoom) + "&v=") + version);
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function (event:Event):void{
                var _local2:Array;
                loader.removeEventListener(Event.COMPLETE, _local2.callee);
                _local2 = event.target.data.match(ZOOM_REGEXP);
                if (_local2){
                    dispatchEvent(new MaxZoomEvent(MaxZoomEvent.MAXZOOM_SUCCESS, latLng, _local2[1]));
                } else {
                    onIOError(null);
                };
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.load(new URLRequest(url));
        }
        private function onIOError(event:IOErrorEvent):void{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            dispatchEvent(new MaxZoomEvent(MaxZoomEvent.MAXZOOM_FAILURE, null, NaN));
        }
        private function getTileVersion(param1:int, param2:int, param3:int):String{
            var _loc_4:Object;
            var _loc_5:String;
            var _loc_6:Array;
            _loc_4 = mapType.getTileLayers()[0];
            _loc_5 = _loc_4.getTileBaseUrl(param1, param2, param3);
            _loc_6 = _loc_5.match(VERSION_REGEXP);
            return ((_loc_6) ? _loc_6[1] : "");
        }
        public function load(param1:LatLng, param2:Number=NaN):void{
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            var _loc_5:String;
            _loc_3 = (isNaN(param2)) ? MAXZOOM_MAXLEVEL : Util.bound(param2, 1, MAXZOOM_MAXLEVEL);
            _loc_4 = Util.getTileCoordinates(param1, _loc_3, mapType.getProjection(), mapType.getTileSize());
            _loc_5 = getTileVersion(_loc_4.x, _loc_4.y, _loc_3);
            dispatchMaxZoomRequest(param1, _loc_4.x, _loc_4.y, _loc_3, _loc_5);
        }

    }
}//package com.mapplus.maps.services 
