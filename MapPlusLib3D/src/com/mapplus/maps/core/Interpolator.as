//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {

    public class Interpolator {

        private var times:Array;
        private var coordSplines:Array;
        private var numDimensions:int;

        public function Interpolator(param1:int){
            super();
            this.numDimensions = param1;
            clear();
        }
        public function evaluateAt(param1:Number, param2:Boolean=false):Array{
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:Array;
            var _loc_6:int;
            var _loc_7:Number = NaN;
            _loc_3 = new Array(numDimensions);
            _loc_4 = getSplineIndex(param1);
            if (_loc_4 < 0){
                return (null);
            };
            _loc_5 = coordSplines[_loc_4];
            if (_loc_4 == (numSegments() - 1)){
                _loc_6 = 0;
                while (_loc_6 < numDimensions) {
                    _loc_3[_loc_6] = _loc_5[_loc_6].a;
                    _loc_6++;
                };
            } else {
                _loc_7 = (param1 - times[_loc_4]);
                _loc_6 = 0;
                while (_loc_6 < numDimensions) {
                    _loc_3[_loc_6] = _loc_5[_loc_6].evaluate(_loc_7);
                    _loc_6++;
                };
            };
            if (((param2) && ((_loc_4 > 0)))){
                times.splice(0, _loc_4);
                coordSplines.splice(0, _loc_4);
                if (times.length == 1){
                    times.shift();
                    coordSplines.shift();
                };
            };
            return (_loc_3);
        }
        function getSplineIndex(param1:Number):int{
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            _loc_2 = times.length;
            _loc_3 = 0;
            while (_loc_2 > 0) {
                _loc_4 = (_loc_2 >> 1);
                _loc_5 = (_loc_3 + _loc_4);
                if (param1 >= times[_loc_5]){
                    _loc_3 = (_loc_5 + 1);
                    _loc_2 = (_loc_2 - (_loc_4 + 1));
                } else {
                    _loc_2 = _loc_4;
                };
            };
            return ((_loc_3 - 1));
        }
        public function toString():String{
            var _loc_1:String;
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            _loc_1 = "Interpolator";
            _loc_2 = 0;
            while (_loc_2 < times.length) {
                _loc_1 = (_loc_1 + ("\n  time " + times[_loc_2]));
                _loc_3 = coordSplines[_loc_2];
                _loc_4 = 0;
                while (_loc_4 < numDimensions) {
                    _loc_1 = (_loc_1 + ("\n    " + _loc_3[_loc_4]));
                    _loc_4++;
                };
                _loc_2++;
            };
            return (_loc_1);
        }
        function appendRawSegments(param1:Array, param2:Array, param3:int):int{
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:Array;
            var _loc_9:Spline;
            _loc_4 = times.length;
            param3 = Math.min(param3, _loc_4);
            _loc_5 = ((_loc_4 - 1) - param3);
            while (_loc_5 < (_loc_4 - 1)) {
                _loc_8 = coordSplines[_loc_5];
                _loc_6 = 0;
                while (_loc_6 < numDimensions) {
                    _loc_9 = _loc_8[_loc_6];
                    _loc_9.b = 0;
                    _loc_9.c = 0;
                    _loc_9.d = 0;
                    _loc_6++;
                };
                _loc_5++;
            };
            _loc_7 = param1.length;
            times = times.concat(param1);
            coordSplines = coordSplines.concat(new Array(_loc_7));
            _loc_5 = 0;
            while (_loc_5 < _loc_7) {
                _loc_8 = new Array(numDimensions);
                coordSplines[(_loc_4 + _loc_5)] = _loc_8;
                _loc_6 = 0;
                while (_loc_6 < numDimensions) {
                    _loc_8[_loc_6] = new Spline(param2[_loc_5][_loc_6], 0, 0, 0);
                    _loc_6++;
                };
                _loc_5++;
            };
            return (Math.max(0, ((_loc_4 - 1) - param3)));
        }
        private function clipBefore(param1:Number):Array{
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:Number = NaN;
            var _loc_5:Spline;
            _loc_2 = new Array(numDimensions);
            _loc_3 = 0;
            while (_loc_3 < numDimensions) {
                _loc_2[_loc_3] = 0;
                _loc_3++;
            };
            discardBefore(param1);
            if (times.length > 1){
                _loc_4 = (param1 - times[0]);
                _loc_3 = 0;
                while (_loc_3 < numDimensions) {
                    _loc_5 = coordSplines[0][_loc_3];
                    _loc_2[_loc_3] = _loc_5.evaluateGradient(_loc_4);
                    _loc_5.a = _loc_5.evaluate(_loc_4);
                    _loc_3++;
                };
                times[0] = param1;
            };
            return (_loc_2);
        }
        public function appendSegmentsCubic(param1:Number, param2:Array, param3:Array):void{
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:Array;
            var _loc_9:int;
            var _loc_10:Number = NaN;
            var _loc_11:Array;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Array;
            var _loc_17:Array;
            var _loc_18:Array;
            var _loc_19:int;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:Number = NaN;
            var _loc_23:Spline;
            var _loc_24:Spline;
            _loc_4 = clipBefore(param1);
            appendRawSegments(param2, param3, 0);
            _loc_5 = 0;
            _loc_7 = ((times.length - _loc_5) - 1);
            _loc_8 = new Array(_loc_7);
            _loc_6 = 0;
            while (_loc_6 < _loc_7) {
                _loc_8[_loc_6] = (times[((_loc_5 + _loc_6) + 1)] - times[(_loc_5 + _loc_6)]);
                _loc_6++;
            };
            _loc_9 = 0;
            while (_loc_9 < numDimensions) {
                _loc_10 = 0;
                _loc_11 = new Array((_loc_7 + 1));
                _loc_12 = coordSplines[(_loc_5 + 0)][_loc_9].a;
                _loc_13 = coordSplines[(_loc_5 + 1)][_loc_9].a;
                _loc_11[0] = (3 * (((_loc_13 - _loc_12) / _loc_8[0]) - _loc_4[_loc_9]));
                _loc_14 = coordSplines[(_loc_5 + _loc_7)][_loc_9].a;
                _loc_15 = coordSplines[((_loc_5 + _loc_7) - 1)][_loc_9].a;
                _loc_11[_loc_7] = (3 * (_loc_10 - ((_loc_14 - _loc_15) / _loc_8[(_loc_7 - 1)])));
                _loc_6 = 1;
                while (_loc_6 < _loc_7) {
                    _loc_20 = coordSplines[((_loc_5 + _loc_6) + 1)][_loc_9].a;
                    _loc_21 = coordSplines[(_loc_5 + _loc_6)][_loc_9].a;
                    _loc_22 = coordSplines[((_loc_5 + _loc_6) - 1)][_loc_9].a;
                    _loc_11[_loc_6] = (3 * (((_loc_20 - _loc_21) / _loc_8[_loc_6]) - ((_loc_21 - _loc_22) / _loc_8[(_loc_6 - 1)])));
                    _loc_6++;
                };
                _loc_16 = new Array((_loc_7 + 1));
                _loc_17 = new Array((_loc_7 + 1));
                _loc_18 = new Array((_loc_7 + 1));
                _loc_16[0] = (2 * _loc_8[0]);
                _loc_17[0] = 0.5;
                _loc_18[0] = (_loc_11[0] / _loc_16[0]);
                _loc_6 = 1;
                while (_loc_6 < _loc_7) {
                    _loc_16[_loc_6] = ((2 * (times[((_loc_5 + _loc_6) + 1)] - times[((_loc_5 + _loc_6) - 1)])) - (_loc_8[(_loc_6 - 1)] * _loc_17[(_loc_6 - 1)]));
                    _loc_17[_loc_6] = (_loc_8[_loc_6] / _loc_16[_loc_6]);
                    _loc_18[_loc_6] = ((_loc_11[_loc_6] - (_loc_8[(_loc_6 - 1)] * _loc_18[(_loc_6 - 1)])) / _loc_16[_loc_6]);
                    _loc_6++;
                };
                _loc_16[_loc_7] = (_loc_8[(_loc_7 - 1)] * (2 - _loc_17[(_loc_7 - 1)]));
                _loc_18[_loc_7] = ((_loc_11[_loc_7] - (_loc_8[(_loc_7 - 1)] * _loc_18[(_loc_7 - 1)])) / _loc_16[_loc_7]);
                coordSplines[(_loc_5 + _loc_7)][_loc_9].c = _loc_18[_loc_7];
                _loc_19 = (_loc_7 - 1);
                while (_loc_19 >= 0) {
                    _loc_23 = coordSplines[(_loc_5 + _loc_19)][_loc_9];
                    _loc_24 = coordSplines[((_loc_5 + _loc_19) + 1)][_loc_9];
                    _loc_23.c = (_loc_18[_loc_19] - (_loc_17[_loc_19] * _loc_24.c));
                    _loc_23.b = (((_loc_24.a - _loc_23.a) / _loc_8[_loc_19]) - ((_loc_8[_loc_19] * (_loc_24.c + (2 * _loc_23.c))) / 3));
                    _loc_23.d = ((_loc_24.c - _loc_23.c) / (3 * _loc_8[_loc_19]));
                    _loc_19--;
                };
                _loc_9++;
            };
        }
        public function getEndTime():int{
            return (times[(times.length - 1)]);
        }
        public function numSegments():int{
            return (times.length);
        }
        public function restartFrom(param1:Number, param2:Array):void{
            var _loc_3:int;
            var _loc_4:Array;
            var _loc_5:int;
            discardBefore(param1);
            _loc_3 = numSegments();
            if (_loc_3 < 2){
                return;
            };
            times[0] = param1;
            _loc_4 = coordSplines[0];
            _loc_5 = 0;
            while (_loc_5 < numDimensions) {
                _loc_4[_loc_5].a = param2[_loc_5];
                _loc_5++;
            };
            appendSegmentsCubic(param1, [], []);
        }
        public function clear():void{
            times = [];
            coordSplines = [];
        }
        public function discardBefore(param1:Number):void{
            var _loc_2:int;
            _loc_2 = getSplineIndex(param1);
            if (_loc_2 > 0){
                times.splice(0, _loc_2);
                coordSplines.splice(0, _loc_2);
                if (times.length == 1){
                    times.shift();
                    coordSplines.shift();
                };
            };
        }

    }
}//package com.mapplus.maps.core 

class Spline {

    public var a:Number;
    public var c:Number;
    public var d:Number;
    public var b:Number;

    public function Spline(param1:Number, param2:Number, param3:Number, param4:Number){
        super();
        this.a = param1;
        this.b = param2;
        this.c = param3;
        this.d = param4;
    }
    public function evaluateGradient(param1:Number):Number{
        return ((((((3 * d) * param1) + (2 * c)) * param1) + b));
    }
    public function toString():String{
        return ((("[" + [a, b, c, d].join(",")) + "]"));
    }
    public function evaluate(param1:Number):Number{
        return (((((((d * param1) + c) * param1) + b) * param1) + a));
    }

}
