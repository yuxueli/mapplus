//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;

    public class PolylineCodec {

        public function PolylineCodec(){
            super();
        }
        public static function indexLevels(param1:Array, param2:Number):Array{
            var _loc_3:Number = NaN;
            var _loc_4:Array;
            var _loc_5:Array;
            var _loc_6:Number = NaN;
            var _loc_7:Array;
            var _loc_8:Array;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            _loc_3 = param1.length;
            _loc_4 = new Array(_loc_3);
            _loc_5 = _loc_4;
            _loc_7 = new Array(param2);
            _loc_8 = _loc_7;
            _loc_6 = 0;
            while (_loc_6 < param2) {
                _loc_8[_loc_6] = _loc_3;
                _loc_6 = (_loc_6 + 1);
            };
            _loc_6 = (_loc_3 - 1);
            while (_loc_6 >= 0) {
                _loc_9 = param1[_loc_6];
                _loc_10 = _loc_3;
                _loc_11 = (_loc_9 + 1);
                while (_loc_11 < param2) {
                    if (_loc_10 > _loc_8[_loc_11]){
                        _loc_10 = _loc_8[_loc_11];
                    };
                    _loc_11 = (_loc_11 + 1);
                };
                _loc_5[_loc_6] = _loc_10;
                _loc_8[_loc_9] = _loc_6;
                _loc_6 = (_loc_6 - 1);
            };
            return (_loc_5);
        }
        public static function decodeLine(param1:String, param2:Number=0):Array{
            var _loc_3:Number = NaN;
            var _loc_4:Array;
            var _loc_5:Array;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            _loc_3 = param1.length;
            _loc_4 = new Array(param2);
            _loc_5 = _loc_4;
            _loc_6 = 0;
            _loc_7 = 0;
            _loc_8 = 0;
            _loc_9 = 0;
            while (_loc_6 < _loc_3) {
                _loc_10 = 1;
                _loc_11 = 0;
                do  {
                    var _temp1 = _loc_6;
                    _loc_6 = (_loc_6 + 1);
                    _loc_12 = ((param1.charCodeAt(_temp1) - 63) - 1);
                    _loc_10 = (_loc_10 + (_loc_12 << _loc_11));
                    _loc_11 = (_loc_11 + 5);
                } while (_loc_12 >= 31);
                _loc_7 = (_loc_7 + ((_loc_10 & 1)) ? ~((_loc_10 >> 1)) : (_loc_10 >> 1));
                _loc_10 = 1;
                _loc_11 = 0;
                do  {
                    var _temp2 = _loc_6;
                    _loc_6 = (_loc_6 + 1);
                    _loc_12 = ((param1.charCodeAt(_temp2) - 63) - 1);
                    _loc_10 = (_loc_10 + (_loc_12 << _loc_11));
                    _loc_11 = (_loc_11 + 5);
                } while (_loc_12 >= 31);
                _loc_8 = (_loc_8 + ((_loc_10 & 1)) ? ~((_loc_10 >> 1)) : (_loc_10 >> 1));
                _loc_5[_loc_9] = new LatLng((_loc_7 * 1E-5), (_loc_8 * 1E-5), true);
                _loc_9 = (_loc_9 + 1);
            };
            return (_loc_5);
        }
        public static function simplifyPolylineData(param1:EncodedPolylineData):EncodedPolylineData{
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:String;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:Array;
            var _loc_10:Array;
            var _loc_11:int;
            var _loc_12:String;
            _loc_2 = new Array(16);
            _loc_3 = 0;
            while (_loc_3 < 16) {
                _loc_2[_loc_3] = 0;
                _loc_3++;
            };
            _loc_5 = param1.levels;
            _loc_6 = "?".charCodeAt(0);
            _loc_3 = 0;
            while (_loc_3 < _loc_5.length) {
                _loc_4 = (_loc_5.charCodeAt(_loc_3) - _loc_6);
                if ((((_loc_4 >= 0)) && ((_loc_4 < 16)))){
                    _loc_13 = _loc_2;
                    _loc_14 = _loc_4;
                    _loc_15 = (_loc_2[_loc_4] + 1);
                    _loc_13[_loc_14] = _loc_15;
                };
                _loc_3++;
            };
            _loc_7 = 0;
            while (_loc_7 < 16) {
                if (_loc_2[_loc_7] > 0){
                    _loc_7++;
                    break;
                };
                _loc_7++;
            };
            _loc_8 = 0;
            _loc_3 = _loc_7;
            while (_loc_3 < 16) {
                _loc_8 = (_loc_8 + _loc_2[_loc_3]);
                _loc_3++;
            };
            _loc_9 = PolylineCodec.decodeLine(param1.points);
            _loc_10 = new Array(_loc_8);
            _loc_11 = 0;
            _loc_12 = "";
            _loc_3 = 0;
            while (_loc_3 < _loc_5.length) {
                _loc_4 = (_loc_5.charCodeAt(_loc_3) - _loc_6);
                if (_loc_4 >= _loc_7){
                    ++_loc_11;
                    var _local16 = _loc_11;
                    _loc_10[_local16] = _loc_9[_loc_3];
                    _loc_12 = (_loc_12 + _loc_5.charAt(_loc_3));
                };
                _loc_3++;
            };
            return (new EncodedPolylineData(PolylineCodec.encodeLine(_loc_10), param1.zoomFactor, _loc_12, param1.numLevels));
        }
        static function encodeSigned(param1:Number, param2:Array):Array{
            return (encodeUnsigned(((param1 < 0)) ? ~((param1 << 1)) : (param1 << 1), param2));
        }
        public static function encodeLevels(param1:Array):String{
            var _loc_2:Array;
            var _loc_3:int;
            _loc_2 = [];
            _loc_3 = 0;
            while (_loc_3 < param1.length) {
                encodeUnsigned(param1[_loc_3], _loc_2);
                _loc_3++;
            };
            return (_loc_2.join(""));
        }
        public static function latlngToFixedPoint(param1:LatLng):Array{
            return ([Math.round((param1.lat() * 100000)), Math.round((param1.lng() * 100000))]);
        }
        public static function encodeLine(param1:Array):String{
            var v:Array;
            var i:Number;
            var I:Number;
            var start:Array;
            var end:Array;
            var array:* = param1;
            I = array.length;
            while (i < I) {
                end = latlngToFixedPoint(array[i]);
                encodeSigned((end[0] - start[0]), v);
                encodeSigned((end[1] - start[1]), v);
                start = end;
                i = (i + 1);
            };
            return (v.join(""));
        }
        static function encodeUnsigned(param1:Number, param2:Array):Array{
            while (param1 >= 32) {
                param2.push(String.fromCharCode(((32 | (param1 & 31)) + 63)));
                param1 = (param1 >> 5);
            };
            param2.push(String.fromCharCode((param1 + 63)));
            return (param2);
        }
        public static function decodeLevels(param1:String, param2:Number):Array{
            var _loc_3:Array;
            var _loc_4:Array;
            var _loc_5:Number = NaN;
            _loc_3 = new Array(param2);
            _loc_4 = _loc_3;
            _loc_5 = 0;
            while (_loc_5 < param2) {
                _loc_4[_loc_5] = (param1.charCodeAt(_loc_5) - 63);
                _loc_5 = (_loc_5 + 1);
            };
            return (_loc_4);
        }

    }
}//package com.mapplus.maps.overlays 
