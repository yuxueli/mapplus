//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class LatLng {

        public static const EARTH_RADIUS:Number = 6378137;

        private var lngDegrees_:Number;
        private var latDegrees_:Number;

        public function LatLng(param1:Number, param2:Number, param3:Boolean=false){
            super();
            if (!param3){
                param1 = MapUtil.bound(param1, -90, 90);
                param2 = MapUtil.wrap(param2, -180, 180);
            };
            latDegrees_ = param1;
            lngDegrees_ = param2;
        }
        public static function wrapLatLng(param1:LatLng):LatLng{
            return (new LatLng(param1.lat(), param1.lng(), false));
        }
        private static function quantize(param1:Number, param2:Number):Number{
            var _loc_3:Number = NaN;
            _loc_3 = Math.pow(10, param2);
            return ((Math.round((param1 * _loc_3)) / _loc_3));
        }
        public static function fromRadians(param1:Number, param2:Number, param3:Boolean=false):LatLng{
            return (new LatLng(MapUtil.radiansToDegrees(param1), MapUtil.radiansToDegrees(param2), param3));
        }
        public static function fromObject(param1:Object):LatLng{
            return (((param1)!=null) ? new LatLng(param1.lat(), param1.lng(), true) : null);
        }
        public static function fromUrlValue(param1:String):LatLng{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_2 = param1.split(",");
            if (_loc_2.length < 2){
                return (null);
            };
            _loc_3 = parseFloat(_loc_2[0]);
            _loc_4 = parseFloat(_loc_2[1]);
            if (((isNaN(_loc_3)) || (isNaN(_loc_4)))){
                return (null);
            };
            return (new LatLng(_loc_3, _loc_4));
        }

        public function angleFrom(param1:LatLng):Number{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_2 = latRadians();
            _loc_3 = param1.latRadians();
            _loc_4 = (_loc_2 - _loc_3);
            _loc_5 = (lngRadians() - param1.lngRadians());
            return ((2 * Math.asin(Math.sqrt((Math.pow(Math.sin((_loc_4 / 2)), 2) + ((Math.cos(_loc_2) * Math.cos(_loc_3)) * Math.pow(Math.sin((_loc_5 / 2)), 2)))))));
        }
        public function lng():Number{
            return (lngDegrees_);
        }
        public function distanceFrom(param1:LatLng, param2:Number=6378137):Number{
            return ((angleFrom(param1) * param2));
        }
        public function clone():LatLng{
            return (new LatLng(lat(), lng(), true));
        }
        public function toString():String{
            return ((((("(" + this.lat()) + ", ") + this.lng()) + ")"));
        }
        public function lngRadians():Number{
            return (MapUtil.degreesToRadians(lngDegrees_));
        }
        public function equals(param1:LatLng):Boolean{
            if (!param1){
                return (false);
            };
            return (((MapUtil.approxEquals(lat(), param1.lat())) && (MapUtil.approxEquals(lng(), param1.lng()))));
        }
        public function latRadians():Number{
            return (MapUtil.degreesToRadians(latDegrees_));
        }
        public function toUrlValue(param1:Number=6):String{
            return (((quantize(lat(), param1) + ",") + quantize(lng(), param1)));
        }
        public function lat():Number{
            return (latDegrees_);
        }

    }
}//package com.mapplus.maps 
