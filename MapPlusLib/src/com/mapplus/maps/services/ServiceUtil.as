//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.wrappers.*;

    public class ServiceUtil {

        public function ServiceUtil(){
            super();
        }
        public static function parsePlacemarks(param1:Array):Array{
            var _loc_2:Number = NaN;
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:Placemark;
            var _loc_6:Object;
            _loc_2 = (param1) ? param1.length : 0;
            _loc_3 = [];
            _loc_4 = 0;
            while (_loc_4 != _loc_2) {
                _loc_5 = new Placemark();
                _loc_6 = param1[_loc_4];
                _loc_5.point = (_loc_6.hasOwnProperty(SConstants.PROP_POINT)) ? parsePoint(_loc_6[SConstants.PROP_POINT]) : null;
                _loc_5.address = DefaultVar.getString(_loc_6, SConstants.PROP_ADDRESS);
                _loc_5.addressDetails = (_loc_6.hasOwnProperty(SConstants.PROP_ADDRESS_DETAILS)) ? _loc_6[SConstants.PROP_ADDRESS_DETAILS] : null;
                Wrapper.copyObject(_loc_5, _loc_6);
                _loc_3.push(_loc_5);
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_3);
        }
        public static function waypointToString(param1:Object):String{
            var _loc_2:LatLng;
            var _loc_3:Placemark;
            if ((param1 is String)){
                return ((param1 as String));
            };
            if ((param1 is LatLng)){
                _loc_2 = (param1 as LatLng);
                return (_loc_2.toUrlValue());
            };
            if ((param1 is Placemark)){
                _loc_3 = (param1 as Placemark);
                return (((_loc_3.address + " @") + _loc_3.point.toUrlValue()));
            };
            return ("");
        }
        public static function initializeCommonParameters(param1:Object):void{
            var _loc_2:Object;
            var _loc_3:String;
            var _loc_4:RegExp;
            var _loc_5:Boolean;
            var _loc_6:String;
            param1[SConstants.URL_ARG_MAPCLIENT] = SConstants.URL_ARGVAL_MAPCLIENT;
            _loc_2 = Bootstrap.getBootstrap().getClientConfiguration();
            _loc_3 = Bootstrap.getBootstrap().getApiSiteUrl();
            _loc_4 = /^[a-z]+:\/\//;
            if (_loc_3 == "*"){
                param1[SConstants.URL_ARG_DOMAIN] = "file://*";
            } else {
                if (_loc_4.test(_loc_3)){
                    param1[SConstants.URL_ARG_DOMAIN] = _loc_3;
                } else {
                    _loc_5 = false;
                    if (((_loc_2.hasOwnProperty("url")) && ((_loc_2.url.search("https:") == 0)))){
                        _loc_5 = true;
                    };
                    param1[SConstants.URL_ARG_DOMAIN] = ((_loc_5) ? "https://" : "http://" + _loc_3);
                };
            };
            Util.copyData(_loc_2, param1, [SConstants.URL_ARG_KEY, SConstants.URL_ARG_CLIENT, SConstants.URL_ARG_CHANNEL, SConstants.URL_ARG_FLC, SConstants.URL_ARG_SENSOR], String);
            if (_loc_2.hasOwnProperty("fliburl")){
                _loc_6 = _loc_2.fliburl;
                if (_loc_6){
                    param1["fliburl"] = _loc_6;
                };
            };
        }
        public static function onLoadCompleted(param1:Object, param2:String, param3:Function, param4:Function):void{
            var reply:* = null;
            var query:* = undefined;
            var param1:* = param1;
            var param2:* = param2;
            var param3:* = param3;
            var param4:* = param4;
            var dataSwf:* = param1;
            query = param2;
            var processCallback:* = param3;
            var failureCallback:* = param4;
            try {
                reply = Bootstrap.parseJson(dataSwf.json);
                if (Util.checkDomain(reply)){
                    processCallback(reply, query);
                } else {
                    failureCallback(ServiceStatus.GEO_SERVER_ERROR, query);
                };
            } catch(ex) {
                failureCallback(ServiceStatus.GEO_SERVER_ERROR, query);
            };
        }
        public static function parseEncodedPolyline(param1:Object):EncodedPolylineData{
            var _loc_2:String;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            var _loc_5:Number = NaN;
            _loc_2 = DefaultVar.getString(param1, SConstants.PROP_POINTS);
            _loc_3 = DefaultVar.getNumber(param1, SConstants.PROP_ZOOM_FACTOR);
            _loc_4 = DefaultVar.getString(param1, SConstants.PROP_LEVELS);
            _loc_5 = DefaultVar.getNumber(param1, SConstants.PROP_NUM_LEVELS);
            return (new EncodedPolylineData(_loc_2, _loc_3, _loc_4, _loc_5));
        }
        public static function parsePoint(param1:Object):LatLng{
            var _loc_2:Array;
            _loc_2 = DefaultVar.getArray(param1, SConstants.PROP_COORDINATES);
            if (((!((_loc_2 == null))) && ((_loc_2.length >= 2)))){
                return (new LatLng(_loc_2[1], _loc_2[0]));
            };
            return (null);
        }

    }
}//package com.mapplus.maps.services 
