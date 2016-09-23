//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class VectorGraphics {

        private static const DOT_PARALLEL:Number = 1E-100;

        public function VectorGraphics(){
            super();
        }
        public static function computeMapDivBounds(param1:IMap):Rectangle{
            var _loc_2:Point;
            _loc_2 = param1.getSize();
            return (new Rectangle(0, 0, _loc_2.x, _loc_2.y));
        }
        public static function clipLineToPolyIndexed(param1:Array, param2:Array, param3:Array):void{
            var _loc_4:int;
            var _loc_5:Array;
            var _loc_6:Point;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Point;
            var _loc_12:Point;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Point;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            if (((!(param3)) || ((param3.length < 2)))){
                return;
            };
            _loc_4 = param3.length;
            _loc_5 = new Array(_loc_4);
            _loc_7 = 0;
            while (_loc_7 < _loc_4) {
                _loc_9 = param3[((_loc_7 + 1) % _loc_4)].subtract(param3[_loc_7]);
                _loc_6 = new Point(-(_loc_9.y), _loc_9.x);
                _loc_6.normalize(1);
                _loc_5[_loc_7] = _loc_6;
                _loc_7++;
            };
            _loc_8 = 0;
            while (_loc_8 < param2.length) {
                if (param2[_loc_8] < 0){
                } else {
                    _loc_10 = param1[param2[_loc_8]];
                    _loc_11 = param1[param2[(_loc_8 + 1)]];
                    _loc_12 = _loc_11.subtract(_loc_10);
                    _loc_13 = 0;
                    _loc_14 = 1;
                    _loc_7 = 0;
                    while (_loc_7 < _loc_4) {
                        _loc_6 = _loc_5[_loc_7];
                        _loc_15 = _loc_10.subtract(param3[_loc_7]);
                        _loc_16 = ((_loc_15.x * _loc_6.x) + (_loc_15.y * _loc_6.y));
                        _loc_17 = ((_loc_12.x * _loc_6.x) + (_loc_12.y * _loc_6.y));
                        if ((((_loc_17 < DOT_PARALLEL)) && ((_loc_17 > -(DOT_PARALLEL))))){
                            if (_loc_16 < 0){
                                _loc_14 = _loc_13;
                                break;
                            };
                        } else {
                            _loc_18 = (-(_loc_16) / _loc_17);
                            if (_loc_17 < 0){
                                if (_loc_18 < _loc_13){
                                    _loc_14 = _loc_13;
                                    break;
                                };
                                if (_loc_18 < _loc_14){
                                    _loc_14 = _loc_18;
                                };
                            } else {
                                if (_loc_18 > _loc_14){
                                    _loc_14 = _loc_13;
                                    break;
                                };
                                if (_loc_18 > _loc_13){
                                    _loc_13 = _loc_18;
                                };
                            };
                        };
                        _loc_7++;
                    };
                    if (_loc_13 < _loc_14){
                        if (_loc_13 > 0){
                            param2[_loc_8] = param1.length;
                            param1.push(new Point((_loc_10.x + (_loc_13 * _loc_12.x)), (_loc_10.y + (_loc_13 * _loc_12.y))));
                        };
                        if (_loc_14 < 1){
                            param2[(_loc_8 + 1)] = param1.length;
                            param1.push(new Point((_loc_10.x + (_loc_14 * _loc_12.x)), (_loc_10.y + (_loc_14 * _loc_12.y))));
                        };
                    } else {
                        param2[_loc_8] = -1;
                    };
                };
                _loc_8 = (_loc_8 + 2);
            };
        }
        public static function removeAllButNElements(param1:Array, param2:int):void{
            var _loc_3:int;
            _loc_3 = (param1.length - param2);
            if (_loc_3 > 0){
                param1.splice(param2, _loc_3);
            };
        }
        public static function clipToEdgeIndexed(param1:Array, param2:Array, param3:Number, param4:Number, param5:Number):void{
            var _loc_6:Point;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Boolean;
            var _loc_12:Boolean;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Point;
            _loc_6 = null;
            _loc_7 = -1;
            _loc_8 = 0;
            while (_loc_8 < param2.length) {
                if (param2[_loc_8] < 0){
                } else {
                    _loc_9 = param1[param2[_loc_8]];
                    _loc_10 = param1[param2[(_loc_8 + 1)]];
                    if ((((_loc_9.x == _loc_10.x)) && ((_loc_9.y == _loc_10.y)))){
                    } else {
                        _loc_11 = ((((param3 * _loc_9.x) + (param4 * _loc_9.y)) + param5) > 0);
                        _loc_12 = ((((param3 * _loc_10.x) + (param4 * _loc_10.y)) + param5) > 0);
                        if (((!(_loc_11)) && (!(_loc_12)))){
                            param2[_loc_8] = -1;
                        } else {
                            if (_loc_7 < 0){
                                _loc_7 = _loc_8;
                            };
                            if (((_loc_11) && (_loc_12))){
                            } else {
                                _loc_13 = (_loc_9.y - _loc_10.y);
                                _loc_14 = (_loc_10.x - _loc_9.x);
                                _loc_15 = ((_loc_9.x * _loc_10.y) - (_loc_9.y * _loc_10.x));
                                _loc_16 = ((_loc_14 * param5) - (_loc_15 * param4));
                                _loc_17 = ((_loc_15 * param3) - (_loc_13 * param5));
                                _loc_18 = ((_loc_13 * param4) - (_loc_14 * param3));
                                _loc_19 = new Point((_loc_16 / _loc_18), (_loc_17 / _loc_18));
                                if (_loc_11){
                                    param2[(_loc_8 + 1)] = param1.length;
                                    _loc_6 = _loc_19;
                                } else {
                                    if (_loc_12){
                                        if (_loc_6){
                                            param2.splice(_loc_8, 0, param1.length, (param1.length + 1));
                                            _loc_8 = (_loc_8 + 2);
                                            param1.push(_loc_6);
                                            param1.push(_loc_19);
                                            _loc_6 = null;
                                        };
                                        param2[_loc_8] = param1.length;
                                    };
                                };
                                param1.push(_loc_19);
                            };
                        };
                    };
                };
                _loc_8 = (_loc_8 + 2);
            };
            if (_loc_6){
                param2.push(param1.length, param2[_loc_7]);
                param1.push(_loc_6);
                _loc_6 = null;
            };
        }
        public static function clipToPolyIndexed(param1:Array, param2:Array, param3:Array):void{
            var _loc_4:Number = NaN;
            var _loc_5:int;
            var _loc_6:Point;
            var _loc_7:Point;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            if (((!(param3)) || ((param3.length < 2)))){
                return;
            };
            _loc_4 = 1E-100;
            _loc_5 = 0;
            while (_loc_5 < param3.length) {
                _loc_6 = param3[_loc_5];
                _loc_7 = param3[((_loc_5 + 1) % param3.length)];
                if (Point.distance(_loc_6, _loc_7) < _loc_4){
                } else {
                    _loc_8 = (_loc_6.y - _loc_7.y);
                    _loc_9 = (_loc_7.x - _loc_6.x);
                    _loc_10 = -(((_loc_8 * _loc_6.x) + (_loc_9 * _loc_6.y)));
                    clipToEdgeIndexed(param1, param2, _loc_8, _loc_9, _loc_10);
                };
                _loc_5++;
            };
        }
        public static function expandBounds(param1:Rectangle):Rectangle{
            var _loc_2:Rectangle;
            _loc_2 = param1.clone();
            _loc_2.inflate(0, 0);
            return (_loc_2);
        }

    }
}//package com.mapplus.maps.overlays 
