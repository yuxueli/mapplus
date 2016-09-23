//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public class Geometry {

        public function Geometry(){
            super();
        }
        public static function clipBelow(param1:HPolygon, param2:HPoint, param3:Number):HPolygon{
            var _loc_4:HPoint;
            _loc_4 = new HPoint(-(param2.x), -(param2.y), (-(param2.w) + param3));
            return (clipAgainstLine(param1, _loc_4));
        }
        public static function objectCrossesLine(param1:Array, param2:HPoint):Boolean{
            var _loc_3:int;
            var _loc_4:int;
            if (param1.length > 0){
                _loc_3 = pointLineTest(HPoint(param1[0]), param2);
                if (_loc_3 == 0){
                    return (true);
                };
                _loc_4 = 1;
                while (_loc_4 < param1.length) {
                    if (pointLineTest(HPoint(param1[_loc_4]), param2) != _loc_3){
                        return (true);
                    };
                    _loc_4++;
                };
            };
            return (false);
        }
        public static function clipAgainstLine(param1:HPolygon, param2:HPoint):HPolygon{
            var _loc_3:HPolygon;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:HPoint;
            var _loc_10:HPoint;
            _loc_3 = new HPolygon();
            if (param1.size() == 0){
                return (_loc_3);
            };
            _loc_4 = pointLineTest(param1.verts[0], param2);
            _loc_5 = 0;
            _loc_6 = param1.size();
            while (_loc_5 < _loc_6) {
                _loc_7 = ((_loc_5 + 1) % _loc_6);
                _loc_8 = _loc_4;
                _loc_4 = pointLineTest(param1.verts[_loc_7], param2);
                if (_loc_8 == -1){
                    _loc_3.add(param1.verts[_loc_5]);
                };
                if (_loc_8 != _loc_4){
                    _loc_9 = HPoint.crossProduct(param1.verts[_loc_5], param1.verts[_loc_7]);
                    _loc_10 = HPoint.crossProduct(_loc_9, param2);
                    _loc_10.normalize();
                    _loc_3.add(_loc_10);
                };
                _loc_5++;
            };
            return (_loc_3);
        }
        public static function convexPolyIntersects(param1:Array, param2:Rectangle, param3:Array):Boolean{
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:PolyAxis;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            _loc_6 = param1[0].x;
            _loc_7 = param1[0].y;
            _loc_8 = _loc_6;
            _loc_9 = _loc_7;
            _loc_4 = 1;
            while (_loc_4 < param1.length) {
                _loc_10 = param1[_loc_4].x;
                _loc_11 = param1[_loc_4].y;
                if (_loc_10 < _loc_6){
                    _loc_6 = _loc_10;
                };
                if (_loc_10 > _loc_8){
                    _loc_8 = _loc_10;
                };
                if (_loc_11 < _loc_7){
                    _loc_7 = _loc_11;
                };
                if (_loc_11 > _loc_9){
                    _loc_9 = _loc_11;
                };
                _loc_4++;
            };
            if ((((((((_loc_6 >= param2.right)) || ((_loc_8 <= param2.left)))) || ((_loc_7 >= param2.bottom)))) || ((_loc_9 <= param2.top)))){
                return (false);
            };
            _loc_4 = 0;
            while (_loc_4 < param3.length) {
                _loc_12 = param3[_loc_4];
                _loc_13 = ((_loc_12.x * param2.left) + (_loc_12.y * param2.top));
                _loc_14 = _loc_13;
                _loc_15 = ((_loc_12.x * param2.right) + (_loc_12.y * param2.top));
                if (_loc_15 < _loc_13){
                    _loc_13 = _loc_15;
                };
                if (_loc_15 > _loc_14){
                    _loc_14 = _loc_15;
                };
                _loc_15 = ((_loc_12.x * param2.right) + (_loc_12.y * param2.bottom));
                if (_loc_15 < _loc_13){
                    _loc_13 = _loc_15;
                };
                if (_loc_15 > _loc_14){
                    _loc_14 = _loc_15;
                };
                _loc_15 = ((_loc_12.x * param2.left) + (_loc_12.y * param2.bottom));
                if (_loc_15 < _loc_13){
                    _loc_13 = _loc_15;
                };
                if (_loc_15 > _loc_14){
                    _loc_14 = _loc_15;
                };
                if ((((_loc_14 <= _loc_12.min)) || ((_loc_13 >= _loc_12.max)))){
                    return (false);
                };
                _loc_4++;
            };
            return (true);
        }
        public static function pointLineDist(param1:Point, param2:HPoint):Number{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_3 = Math.abs((((param1.x * param2.x) + (param1.y * param2.y)) + param2.w));
            _loc_4 = Math.sqrt(((param2.x * param2.x) + (param2.y * param2.y)));
            return ((_loc_3 / _loc_4));
        }
        public static function getTriangleArea(param1:Point, param2:Point, param3:Point):Number{
            return ((Math.abs((((param3.x - param1.x) * (param2.y - param1.y)) - ((param2.x - param1.x) * (param3.y - param1.y)))) / 2));
        }
        public static function getUniqueAxes(param1:Array):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:Array;
            var _loc_6:Array;
            var _loc_7:int;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            _loc_2 = param1.length;
            _loc_3 = new Array(_loc_2);
            _loc_4 = 0;
            while (_loc_4 < _loc_2) {
                _loc_8 = Math.atan2(param1[_loc_4].y, param1[_loc_4].x);
                if (_loc_8 < 0){
                    _loc_8 = (_loc_8 + Math.PI);
                };
                _loc_3[_loc_4] = _loc_8;
                _loc_4++;
            };
            _loc_5 = _loc_3.sort(Array.RETURNINDEXEDARRAY);
            _loc_6 = [];
            _loc_7 = _loc_5[0];
            _loc_8 = _loc_3[_loc_7];
            _loc_6.push(param1[_loc_7]);
            _loc_4 = 1;
            while (_loc_4 < _loc_2) {
                _loc_7 = _loc_5[_loc_4];
                _loc_9 = _loc_3[_loc_7];
                if ((_loc_9 - _loc_8) > 1E-10){
                    _loc_6.push(param1[_loc_7]);
                    _loc_8 = _loc_9;
                };
                _loc_4++;
            };
            return (_loc_6);
        }
        public static function clipAbove(param1:HPolygon, param2:HPoint, param3:Number):HPolygon{
            var _loc_4:HPoint;
            _loc_4 = new HPoint(param2.x, param2.y, (param2.w + param3));
            return (clipAgainstLine(param1, _loc_4));
        }
        public static function getMatrixProduct(param1:Array, param2:Array):Array{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Array;
            var _loc_8:int;
            var _loc_9:int;
            var _loc_10:Number = NaN;
            var _loc_11:int;
            _loc_3 = param1.length;
            _loc_4 = param1[0].length;
            _loc_5 = param2.length;
            _loc_6 = param2[0].length;
            if (_loc_4 != _loc_5){
                return (null);
            };
            _loc_7 = new Array(_loc_3);
            _loc_8 = 0;
            while (_loc_8 < _loc_3) {
                _loc_7[_loc_8] = new Array(_loc_6);
                _loc_9 = 0;
                while (_loc_9 < _loc_6) {
                    _loc_10 = 0;
                    _loc_11 = 0;
                    while (_loc_11 < _loc_4) {
                        _loc_10 = (_loc_10 + (param1[_loc_8][_loc_11] * param2[_loc_11][_loc_9]));
                        _loc_11++;
                    };
                    _loc_7[_loc_8][_loc_9] = _loc_10;
                    _loc_9++;
                };
                _loc_8++;
            };
            return (_loc_7);
        }
        public static function getAffineForTriple(param1:Point, param2:Point, param3:Point):Matrix{
            return (new Matrix((param2.x - param1.x), (param2.y - param1.y), (param3.x - param1.x), (param3.y - param1.y), param1.x, param1.y));
        }
        public static function isAbove(param1:HPoint, param2:HPoint):Boolean{
            return ((pointLineTest(param1, param2) == -1));
        }
        public static function getFourthVertex(param1:Point, param2:Point, param3:Point):Point{
            return (new Point(((param3.x + param1.x) - param2.x), ((param3.y + param1.y) - param2.y)));
        }
        public static function clipAgainstRect(param1:HPolygon, param2:Rectangle):HPolygon{
            var _loc_3:HPolygon;
            _loc_3 = param1;
            _loc_3 = clipAgainstLine(_loc_3, new HPoint(-1, 0, param2.left));
            _loc_3 = clipAgainstLine(_loc_3, new HPoint(1, 0, -(param2.right)));
            _loc_3 = clipAgainstLine(_loc_3, new HPoint(0, -1, param2.top));
            _loc_3 = clipAgainstLine(_loc_3, new HPoint(0, 1, -(param2.bottom)));
            return (_loc_3);
        }
        public static function pointLineTest(param1:HPoint, param2:HPoint):int{
            return ((sign(HPoint.dotProduct(param1, param2)) * sign(param1.w)));
        }
        public static function transformPoly(param1:Array, param2:Matrix):Array{
            var _loc_3:Array;
            var _loc_4:int;
            if (!param1){
                return (null);
            };
            _loc_3 = new Array(param1.length);
            _loc_4 = 0;
            while (_loc_4 < param1.length) {
                _loc_3[_loc_4] = param2.transformPoint(param1[_loc_4]);
                _loc_4++;
            };
            return (_loc_3);
        }
        public static function computeSeparatingAxes(param1:Array):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:Point;
            var _loc_5:int;
            var _loc_6:Point;
            var _loc_7:Point;
            var _loc_8:Point;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:int;
            var _loc_12:Number = NaN;
            _loc_2 = param1.length;
            _loc_3 = [];
            if (_loc_2 == 0){
                return (_loc_3);
            };
            _loc_4 = param1[0];
            _loc_5 = 0;
            while (_loc_5 < _loc_2) {
                _loc_6 = param1[((_loc_5 + 1) % _loc_2)];
                _loc_7 = _loc_6.subtract(_loc_4);
                if (_loc_7.length < 1E-150){
                } else {
                    _loc_4 = _loc_6;
                    _loc_8 = new Point(-(_loc_7.y), _loc_7.x);
                    _loc_8.normalize(1);
                    _loc_9 = ((_loc_8.x * param1[0].x) + (_loc_8.y * param1[0].y));
                    _loc_10 = _loc_9;
                    _loc_11 = 1;
                    while (_loc_11 < _loc_2) {
                        _loc_12 = ((_loc_8.x * param1[_loc_11].x) + (_loc_8.y * param1[_loc_11].y));
                        if (_loc_12 < _loc_9){
                            _loc_9 = _loc_12;
                        };
                        if (_loc_12 > _loc_10){
                            _loc_10 = _loc_12;
                        };
                        _loc_11++;
                    };
                    _loc_3.push(new PolyAxis(_loc_8.x, _loc_8.y, _loc_9, _loc_10));
                };
                _loc_5++;
            };
            return (_loc_3);
        }
        public static function sign(param1:Number):int{
            if (Math.abs(param1) < 1E-307){
                return (0);
            };
            return (((param1 < 0)) ? -1 : 1);
        }
        public static function getAffineForRect(param1:Rectangle, param2:Point, param3:Point, param4:Point):Matrix{
            var _loc_5:Matrix;
            _loc_5 = new Matrix((1 / param1.width), 0, 0, (1 / param1.height), (-(param1.x) / param1.width), (-(param1.y) / param1.height));
            _loc_5.concat(getAffineForTriple(param2, param3, param4));
            return (_loc_5);
        }

    }
}//package com.mapplus.maps.geom 

class PolyAxis {

    public var min:Number;
    public var max:Number;
    public var y:Number;
    public var x:Number;

    public function PolyAxis(param1:Number, param2:Number, param3:Number, param4:Number){
        super();
        this.x = param1;
        this.y = param2;
        this.min = param3;
        this.max = param4;
    }
}
