//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import flash.geom.*;
    import com.mapplus.maps.*;

    public class Geodesic {

        private var latBounds:R1Interval;
        private var bounds:LatLngBounds;
        private var lngBounds:S1Interval;
        private var projector:Function;
        private var tolerance:Number;

        public function Geodesic(param1:Function, param2:Number, param3:LatLngBounds=null){
            super();
            var _loc_4:Point;
            var _loc_5:Point;
            this.projector = param1;
            this.tolerance = param2;
            this.bounds = param3;
            if (param3){
                lngBounds = new S1Interval(Util.degreesToRadians(this.bounds.getWest()), Util.degreesToRadians(this.bounds.getEast()));
                _loc_4 = param1(this.bounds.getSouthWest());
                _loc_5 = param1(this.bounds.getNorthEast());
                latBounds = new R1Interval(_loc_5.y, _loc_4.y);
            };
        }
        public static function geodesicBounds(param1:LatLng, param2:LatLng):LatLngBounds{
            var _loc_3:LatLng;
            var _loc_4:R1Interval;
            var _loc_5:S1Interval;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            _loc_3 = arcToLatExtremum_(param1, param2);
            _loc_4 = new R1Interval(param1.latRadians(), param1.latRadians());
            _loc_5 = new S1Interval(param1.lngRadians(), param1.lngRadians());
            _loc_4.extend(param2.latRadians());
            _loc_5.extend(param2.lngRadians());
            _loc_6 = Util.degreesToRadians(_loc_3.lng());
            _loc_7 = Util.degreesToRadians(_loc_3.lat());
            if (_loc_5.contains(_loc_6)){
                _loc_4.extend(_loc_7);
            };
            if (((_loc_5.contains((_loc_6 + Math.PI))) || (_loc_5.contains((_loc_6 - Math.PI))))){
                _loc_4.extend(-(_loc_7));
            };
            return (new LatLngBounds(new LatLng(Util.radiansToDegrees(_loc_4.lo), Util.radiansToDegrees(_loc_5.lo)), new LatLng(Util.radiansToDegrees(_loc_4.hi), Util.radiansToDegrees(_loc_5.hi))));
        }
        public static function fromLatLngToR3(param1:LatLng, param2:Array):void{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_3 = param1.latRadians();
            _loc_4 = param1.lngRadians();
            _loc_5 = Math.cos(_loc_3);
            param2[0] = (Math.cos(_loc_4) * _loc_5);
            param2[1] = (Math.sin(_loc_4) * _loc_5);
            param2[2] = Math.sin(_loc_3);
        }
        private static function arcToLatExtremum_(param1:LatLng, param2:LatLng):LatLng{
            var _loc_3:Array;
            var _loc_4:Array;
            var _loc_5:Array;
            var _loc_6:Array;
            var _loc_7:Array;
            var _loc_8:Array;
            var _loc_9:LatLng;
            var _loc_10:Number = NaN;
            _loc_3 = new Array(3);
            _loc_4 = new Array(3);
            fromLatLngToR3(param1, _loc_3);
            fromLatLngToR3(param2, _loc_4);
            _loc_5 = new Array(3);
            _loc_6 = [0, 0, 1];
            _loc_7 = new Array(3);
            _loc_8 = new Array(3);
            _loc_10 = (((_loc_8[0] * _loc_8[0]) + (_loc_8[1] * _loc_8[1])) + (_loc_8[2] * _loc_8[2]));
            if (_loc_10 > 1E-12){
                _loc_9 = fromR3ToLatLng(_loc_8);
            } else {
                Log.log("arcToLatExtremum: degenerate case, falling back");
                _loc_9 = new LatLng(param1.lat(), param1.lng());
            };
            return (_loc_9);
        }
        public static function arcToGeodesic(param1:LatLng, param2:LatLng, param3:Function, param4:Number=NaN, param5:LatLngBounds=null):Array{
            var _loc_6:Array;
            var _loc_7:Array;
            var _loc_8:Array;
            var _loc_9:int;
            var _loc_10:Geodesic;
            _loc_6 = [new Array(3), new Array(3)];
            _loc_7 = [param1, param2];
            _loc_8 = new Array(2);
            _loc_9 = 0;
            while (_loc_9 < 2) {
                fromLatLngToR3(_loc_7[_loc_9], _loc_6[_loc_9]);
                _loc_8[_loc_9] = param3(_loc_7[_loc_9]);
                _loc_9++;
            };
            _loc_10 = new Geodesic(param3, param4, param5);
            return (_loc_10.arcToGeodesicImpl(_loc_6, _loc_7, _loc_8, param3, 0, 1, 0));
        }
        private static function bifurcate(param1:Array, param2:Array, param3:Array, param4:Function, param5:int, param6:int):int{
            var _loc_7:int;
            var _loc_8:Array;
            var _loc_9:Array;
            var _loc_10:Array;
            var _loc_11:LatLng;
            var _loc_12:Point;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            _loc_7 = param1.length;
            _loc_8 = new Array(3);
            param1.push(_loc_8);
            _loc_9 = param1[param5];
            _loc_10 = param1[param6];
            _loc_8[0] = ((_loc_9[0] + _loc_10[0]) / 2);
            _loc_8[1] = ((_loc_9[1] + _loc_10[1]) / 2);
            _loc_8[2] = ((_loc_9[2] + _loc_10[2]) / 2);
            normalizeR3(_loc_8);
            _loc_11 = fromR3ToLatLng(_loc_8);
            param2.push(_loc_11);
            _loc_12 = param4(_loc_11);
            _loc_13 = param3[param5].x;
            _loc_14 = param3[param6].x;
            _loc_12.x = MapUtil.wrapPeriod(_loc_12.x, Math.min(_loc_13, _loc_14), Math.max(_loc_13, _loc_14), 0x0100);
            param3.push(_loc_12);
            return (_loc_7);
        }
        public static function fromR3ToLatLng(param1:Array):LatLng{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = Math.atan2(param1[2], Math.sqrt(((param1[0] * param1[0]) + (param1[1] * param1[1]))));
            _loc_3 = Math.atan2(param1[1], param1[0]);
            return (new LatLng(Util.radiansToDegrees(_loc_2), Util.radiansToDegrees(_loc_3), true));
        }
        public static function normalizeR3(param1:Array):void{
            var _loc_2:Number = NaN;
            _loc_2 = Math.sqrt((((param1[0] * param1[0]) + (param1[1] * param1[1])) + (param1[2] * param1[2])));
            param1[0] = (param1[0] / _loc_2);
            param1[1] = (param1[1] / _loc_2);
            param1[2] = (param1[2] / _loc_2);
        }

        public function arcToGeodesicImpl(param1:Array, param2:Array, param3:Array, param4:Function, param5:int, param6:int, param7:int, param8:int=-1):Array{
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:int;
            var _loc_12:int;
            var _loc_13:int;
            var _loc_14:Point;
            var _loc_15:Point;
            var _loc_16:Point;
            var _loc_17:Point;
            var _loc_18:Point;
            var _loc_19:Point;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:S1Interval;
            var _loc_23:R1Interval;
            var _loc_24:Array;
            var _loc_25:Array;
            _loc_9 = param3[param5];
            _loc_10 = param3[param6];
            if (param7 > 8){
                Log.log("Recursed too far, bailing out gracefully");
                return ([_loc_9, _loc_10]);
            };
            if (this.lngBounds){
                _loc_20 = ((Math.PI * MapUtil.wrap((_loc_9.x - 128), -128, 128)) / 128);
                _loc_21 = ((Math.PI * MapUtil.wrap((_loc_10.x - 128), -128, 128)) / 128);
                _loc_22 = new S1Interval(_loc_20, _loc_20);
                _loc_22.extend(_loc_21);
                if (!lngBounds.intersects(_loc_22)){
                    return ([_loc_9, _loc_10]);
                };
            };
            _loc_11 = ((param8 >= 0)) ? param8 : bifurcate(param1, param2, param3, param4, param5, param6);
            _loc_12 = bifurcate(param1, param2, param3, param4, param5, _loc_11);
            _loc_13 = bifurcate(param1, param2, param3, param4, _loc_11, param6);
            _loc_14 = param3[_loc_12];
            _loc_15 = param3[_loc_11];
            _loc_16 = param3[_loc_13];
            _loc_17 = Point.interpolate(_loc_9, _loc_10, 0.5);
            _loc_18 = Point.interpolate(_loc_9, _loc_17, 0.5);
            _loc_19 = Point.interpolate(_loc_17, _loc_10, 0.5);
            if (this.latBounds){
                _loc_23 = new R1Interval(_loc_9.y, _loc_9.y);
                _loc_23.extend(_loc_10.y);
                _loc_23.extend(_loc_14.y);
                _loc_23.extend(_loc_15.y);
                _loc_23.extend(_loc_16.y);
                if (!latBounds.intersects(_loc_23)){
                    return ([_loc_9, _loc_10]);
                };
            };
            if ((((((((((((Math.abs((_loc_14.x - _loc_18.x)) > this.tolerance)) || ((Math.abs((_loc_14.y - _loc_18.y)) > this.tolerance)))) || ((Math.abs((_loc_15.x - _loc_17.x)) > this.tolerance)))) || ((Math.abs((_loc_15.y - _loc_17.y)) > this.tolerance)))) || ((Math.abs((_loc_16.x - _loc_19.x)) > this.tolerance)))) || ((Math.abs((_loc_16.y - _loc_19.y)) > this.tolerance)))){
                _loc_24 = arcToGeodesicImpl(param1, param2, param3, param4, param5, _loc_11, (param7 + 1), _loc_12);
                _loc_25 = arcToGeodesicImpl(param1, param2, param3, param4, _loc_11, param6, (param7 + 1), _loc_13);
                _loc_24.pop();
                return (_loc_24.concat(_loc_25));
            };
            return ([_loc_9, _loc_14, _loc_15, _loc_16, _loc_10]);
        }

    }
}//package com.mapplus.maps.overlays 
