//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;
    import flash.net.*;

    public class Elevation extends WrappableEventDispatcher implements IElevation {

        private static const ELEVATION_PATH:String = "/maps/api/elevation/json";

        public function Elevation(){
            super();
        }
        private function onIOError(event:IOErrorEvent):void{
            if (event){
                event.target.removeEventListener(Event.COMPLETE, onComplete);
                event.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            };
            dispatchEvent(new ElevationEvent(ElevationEvent.ELEVATION_FAILURE, ServiceStatus.GEO_UNKNOWN_ERROR, null));
        }
        public function loadElevationForLocations(param1:Array):void{
            var _loc_2:Object;
            _loc_2 = createCommonParams();
            _loc_2["locations"] = getLocationsParamValue(param1);
            load(_loc_2);
        }
        private function createCommonParams():Object{
            var _loc_1:Object;
            _loc_1 = {};
            ServiceUtil.initializeCommonParameters(_loc_1);
            if (_loc_1.hasOwnProperty("client")){
                _loc_1.api_client = _loc_1.client;
                delete _loc_1.client;
            };
            return (_loc_1);
        }
        private function load(param1:Object):void{
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:URLLoader;
            _loc_2 = Bootstrap.getBootstrap().getMapsHost();
            if (!_loc_2){
                return;
            };
            _loc_3 = (((((Util.isSsl()) ? "https://" : "http://" + _loc_2) + ELEVATION_PATH) + "?") + Util.paramsToUrlString(param1));
            _loc_4 = new URLLoader();
            _loc_4.addEventListener(Event.COMPLETE, onComplete);
            _loc_4.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _loc_4.load(new URLRequest(_loc_3));
        }
        public function loadElevationForEncodedLocations(param1:EncodedPolylineData):void{
            var _loc_2:Object;
            _loc_2 = createCommonParams();
            _loc_2["locations"] = getEncodedLocationsParamValue(param1);
            load(_loc_2);
        }
        private function getEncodedLocationsParamValue(param1:EncodedPolylineData):String{
            while (param1.points.length > 0x0400) {
                param1 = PolylineCodec.simplifyPolylineData(param1);
            };
            return (("enc:" + param1.points));
        }
        private function decodeElevations(param1:Array):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:Object;
            _loc_2 = param1.length;
            _loc_3 = new Array(_loc_2);
            _loc_4 = 0;
            while (_loc_4 < _loc_2) {
                _loc_5 = param1[_loc_4];
                _loc_3[_loc_4] = new ElevationResponse(new LatLng(_loc_5.location.lat, _loc_5.location.lng), _loc_5.elevation);
                _loc_4++;
            };
            return (_loc_3);
        }
        public function loadElevationAlongPath(param1:Array, param2:int):void{
            var _loc_3:Object;
            _loc_3 = createCommonParams();
            _loc_3["path"] = getLocationsParamValue(param1);
            _loc_3["samples"] = param2;
            load(_loc_3);
        }
        public function loadElevationAlongEncodedPath(param1:EncodedPolylineData, param2:int):void{
            var _loc_3:Object;
            _loc_3 = createCommonParams();
            _loc_3["path"] = getEncodedLocationsParamValue(param1);
            _loc_3["samples"] = param2;
            load(_loc_3);
        }
        private function onComplete(event:Event):void{
            var reply:* = null;
            var statusCode:* = 0;
            var eventType:* = null;
            var elevations:* = null;
            var event:* = event;
            event = event;
            event.target.removeEventListener(Event.COMPLETE, onComplete);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            try {
                reply = Bootstrap.parseJson(event.target.data);
                statusCode = decodeStatusCode(reply.status);
                eventType = ((statusCode == ServiceStatus.GEO_SUCCESS)) ? ElevationEvent.ELEVATION_SUCCESS : ElevationEvent.ELEVATION_FAILURE;
                if (statusCode == ServiceStatus.GEO_SUCCESS){
                    elevations = decodeElevations(reply.results);
                };
                dispatchEvent(new ElevationEvent(eventType, statusCode, elevations));
            } catch(ex:Error) {
                onIOError(null);
            };
        }
        private function getLocationsParamValue(param1:Array):String{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:LatLng;
            _loc_2 = param1.length;
            _loc_3 = new Array(_loc_2);
            _loc_4 = 0;
            while (_loc_4 < _loc_2) {
                _loc_5 = param1[_loc_4];
                _loc_3[_loc_4] = ((_loc_5.lat().toFixed(6) + ",") + _loc_5.lng().toFixed(6));
                _loc_4++;
            };
            return (_loc_3.join("|"));
        }
        private function decodeStatusCode(param1:String):int{
            switch (param1){
                case "OK":
                    return (ServiceStatus.GEO_SUCCESS);
                case "INVALID_REQUEST":
                    return (ServiceStatus.GEO_BAD_REQUEST);
                case "OVER_QUERY_LIMIT":
                    return (ServiceStatus.GEO_TOO_MANY_QUERIES);
                case "REQUEST_DENIED":
                    return (ServiceStatus.GEO_REQUEST_DENIED);
                default:
                    return (ServiceStatus.GEO_UNKNOWN_ERROR);
            };
        }

    }
}//package com.mapplus.maps.services 
