//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class MapUtil {

        public static const FLOAT_ERROR_MARGIN:Number = 1E-9;

        public function MapUtil(){
            super();
        }
        public static function calculateLatLngBounds(param1:Array):LatLngBounds{
            var _loc_2:LatLngBounds;
            var _loc_3:Number = NaN;
            if (((!((param1 == null))) && ((param1.length > 0)))){
                _loc_2 = new LatLngBounds();
                _loc_3 = 0;
                while (_loc_3 < param1.length) {
                    _loc_2.extend(param1[_loc_3]);
                    _loc_3 = (_loc_3 + 1);
                };
                return (_loc_2);
            };
            return (null);
        }
        public static function wrapHalfOpen(param1:Number, param2:Number, param3:Number):Number{
            while (param1 >= param3) {
                param1 = (param1 - (param3 - param2));
            };
            while (param1 < param2) {
                param1 = (param1 + (param3 - param2));
            };
            return (param1);
        }
        public static function wrap(param1:Number, param2:Number, param3:Number):Number{
            while (param1 > param3) {
                param1 = (param1 - (param3 - param2));
            };
            while (param1 < param2) {
                param1 = (param1 + (param3 - param2));
            };
            return (param1);
        }
        public static function wrapPeriod(param1:Number, param2:Number, param3:Number, param4:Number):Number{
            while (param1 > param3) {
                param1 = (param1 - param4);
            };
            while (param1 < param2) {
                param1 = (param1 + param4);
            };
            return (param1);
        }
        public static function getBooleanOrDefault(param1:Object, param2:String, param3:Boolean=false):Boolean{
            if (param1.hasOwnProperty(param2)){
                return ((param1[param2] as Boolean));
            };
            return (param3);
        }
        public static function hasNonNullProperty(param1:Object, param2:String):Boolean{
            if (param1.hasOwnProperty(param2)){
                return (!((param1[param2] == null)));
            };
            return (false);
        }
        public static function copyObject(param1:Object, param2:Object):void{
            var _loc_3:Object;
            for (_loc_3 in param2) {
                param1[_loc_3] = param2[_loc_3];
            };
        }
        public static function degreesToRadians(param1:Number):Number{
            return ((param1 * (Math.PI / 180)));
        }
        public static function approxEquals(param1:Number, param2:Number, param3:Number=1E-9):Boolean{
            return ((Math.abs((param1 - param2)) <= param3));
        }
        public static function radiansToDegrees(param1:Number):Number{
            return ((param1 / (Math.PI / 180)));
        }
        public static function cloneObject(param1:Object):Object{
            var _loc_2:Object;
            var _loc_3:Object;
            _loc_2 = new Object();
            for (_loc_3 in param1) {
                _loc_2[_loc_3] = param1[_loc_3];
            };
            return (_loc_2);
        }
        public static function bound(param1:Number, param2:Number=NaN, param3:Number=NaN):Number{
            if (!(isNaN(param2))){
                param1 = Math.max(param1, param2);
            };
            if (!(isNaN(param3))){
                param1 = Math.min(param1, param3);
            };
            return (param1);
        }

    }
}//package com.mapplus.maps 
