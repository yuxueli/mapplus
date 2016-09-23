//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public class Homography {

        private var m:Array;

        public function Homography(param1:Array=null){
            super();
            if (param1 == null){
                m = [1, 0, 0, 0, 1, 0, 0, 0, 1];
            } else {
                if (param1.length == 9){
                    m = param1;
                } else {
                    throw (new Error("Homography must be given an array of length 9."));
                };
            };
        }
        public static function multiply(param1:Homography, param2:Homography):Homography{
            var _loc_3:Homography;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            _loc_3 = new Homography([0, 0, 0, 0, 0, 0, 0, 0, 0]);
            _loc_4 = 0;
            while (_loc_4 < 3) {
                _loc_5 = 0;
                while (_loc_5 < 3) {
                    _loc_6 = 0;
                    while (_loc_6 < 3) {
                        _loc_3.m[((_loc_4 * 3) + _loc_5)] = (_loc_3.m[((_loc_4 * 3) + _loc_5)] + (param1.m[((_loc_4 * 3) + _loc_6)] * param2.m[((_loc_6 * 3) + _loc_5)]));
                        _loc_6++;
                    };
                    _loc_5++;
                };
                _loc_4++;
            };
            return (_loc_3);
        }
        public static function createFromRowArray(param1:Array):Homography{
            var _loc_2:Homography;
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:int;
            if (((!(param1)) || (!((param1.length == 3))))){
                throw (new Error("Homography.createFromRowArray must be given an array of 3 rows."));
            };
            _loc_2 = new (Homography)();
            _loc_3 = _loc_2.m;
            _loc_4 = 0;
            while (_loc_4 < 3) {
                if (((!(param1[_loc_4])) || (!((param1[_loc_4].length == 3))))){
                    throw (new Error(("In Homography.createFromRowArray, " + "each row must contain 3 elements.")));
                };
                _loc_5 = 0;
                while (_loc_5 < 3) {
                    _loc_3[((_loc_4 * 3) + _loc_5)] = param1[_loc_4][_loc_5];
                    _loc_5++;
                };
                _loc_4++;
            };
            return (_loc_2);
        }

        public function get contents():Array{
            return (m);
        }
        public function projectUnitX(param1:Point):Point{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = (((param1.x * m[6]) + (param1.y * m[7])) + m[8]);
            _loc_3 = (1 / (_loc_2 * _loc_2));
            return (new Point((((((m[0] * m[7]) - (m[1] * m[6])) * param1.y) + ((m[0] * m[8]) - (m[2] * m[6]))) * _loc_3), (((((m[3] * m[7]) - (m[4] * m[6])) * param1.y) + ((m[3] * m[8]) - (m[5] * m[6]))) * _loc_3)));
        }
        public function postMultiply(param1:Homography):void{
            this.m = multiply(this, param1).m;
        }
        public function projectEuclidean(param1:Number, param2:Number):Point{
            var _loc_3:Number = NaN;
            _loc_3 = (((param1 * m[6]) + (param2 * m[7])) + m[8]);
            return (new Point(((((param1 * m[0]) + (param2 * m[1])) + m[2]) / _loc_3), ((((param1 * m[3]) + (param2 * m[4])) + m[5]) / _loc_3)));
        }
        public function getDeterminant():Number{
            return ((((((((m[0] * m[4]) * m[8]) - ((m[0] * m[5]) * m[7])) - ((m[1] * m[3]) * m[8])) + ((m[1] * m[5]) * m[6])) + ((m[2] * m[3]) * m[7])) - ((m[2] * m[4]) * m[6])));
        }
        public function preMultiply(param1:Homography):void{
            this.m = multiply(param1, this).m;
        }
        public function projectInPlace(param1:HPoint):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_2 = (((param1.x * m[0]) + (param1.y * m[1])) + (param1.w * m[2]));
            _loc_3 = (((param1.x * m[3]) + (param1.y * m[4])) + (param1.w * m[5]));
            _loc_4 = (((param1.x * m[6]) + (param1.y * m[7])) + (param1.w * m[8]));
            param1.x = _loc_2;
            param1.y = _loc_3;
            param1.w = _loc_4;
        }
        public function projectHPolygon(param1:HPolygon):HPolygon{
            var _loc_2:HPolygon;
            var _loc_3:int;
            _loc_2 = new HPolygon();
            _loc_3 = 0;
            while (_loc_3 < param1.size()) {
                _loc_2.add(project(param1.verts[_loc_3]));
                _loc_3++;
            };
            return (_loc_2);
        }
        public function getVanishingLine():HPoint{
            var _loc_1:HPoint;
            var _loc_2:HPoint;
            _loc_1 = new HPoint(m[0], m[3], m[6]);
            _loc_2 = new HPoint(m[1], m[4], m[7]);
            return (HPoint.crossProduct(_loc_1, _loc_2));
        }
        public function orthogonalDistance(param1:Point):Number{
            return (-((((param1.x * m[6]) + (param1.y * m[7])) + m[8])));
        }
        public function getAdjoint():Homography{
            var _loc_1:Homography;
            var _loc_2:int;
            var _loc_3:int;
            _loc_1 = new Homography();
            _loc_2 = 0;
            while (_loc_2 < 3) {
                _loc_3 = 0;
                while (_loc_3 < 3) {
                    _loc_1.m[((_loc_3 * 3) + _loc_2)] = getMinor(_loc_2, _loc_3);
                    _loc_3++;
                };
                _loc_2++;
            };
            return (_loc_1);
        }
        public function getInverse():Homography{
            var _loc_1:Number = NaN;
            var _loc_2:Homography;
            var _loc_3:int;
            _loc_1 = getDeterminant();
            _loc_2 = getAdjoint();
            _loc_3 = 0;
            while (_loc_3 < 9) {
                _loc_2.m[_loc_3] = (_loc_2.m[_loc_3] / _loc_1);
                _loc_3++;
            };
            return (_loc_2);
        }
        public function projectHPolygonInPlace(param1:HPolygon):void{
            var _loc_2:int;
            _loc_2 = 0;
            while (_loc_2 < param1.size()) {
                projectInPlace(param1.verts[_loc_2]);
                _loc_2++;
            };
        }
        public function project(param1:HPoint):HPoint{
            return (new HPoint((((param1.x * m[0]) + (param1.y * m[1])) + (param1.w * m[2])), (((param1.x * m[3]) + (param1.y * m[4])) + (param1.w * m[5])), (((param1.x * m[6]) + (param1.y * m[7])) + (param1.w * m[8]))));
        }
        public function toString():String{
            var _loc_1:String;
            var _loc_2:int;
            var _loc_3:int;
            _loc_1 = "";
            _loc_2 = 0;
            while (_loc_2 < 3) {
                _loc_1 = (_loc_1 + "[ ");
                _loc_3 = 0;
                while (_loc_3 < 3) {
                    _loc_1 = (_loc_1 + (m[((_loc_2 * 3) + _loc_3)] + " "));
                    _loc_3++;
                };
                _loc_1 = (_loc_1 + ((_loc_2 < 2)) ? "]\n" : "]");
                _loc_2++;
            };
            return (_loc_1);
        }
        public function projectUnitY(param1:Point):Point{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = (((param1.x * m[6]) + (param1.y * m[7])) + m[8]);
            _loc_3 = (1 / (_loc_2 * _loc_2));
            return (new Point((((((m[1] * m[6]) - (m[0] * m[7])) * param1.x) + ((m[1] * m[8]) - (m[2] * m[7]))) * _loc_3), (((((m[4] * m[6]) - (m[3] * m[7])) * param1.x) + ((m[4] * m[8]) - (m[5] * m[7]))) * _loc_3)));
        }
        public function clone():Homography{
            var _loc_1:Homography;
            _loc_1 = new Homography();
            _loc_1.m = m.slice();
            return (_loc_1);
        }
        public function getMinor(param1:int, param2:int):Number{
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            _loc_3 = ((param1 + 1) % 3);
            _loc_4 = ((param1 + 2) % 3);
            _loc_5 = ((param2 + 1) % 3);
            _loc_6 = ((param2 + 2) % 3);
            return (((m[((_loc_3 * 3) + _loc_5)] * m[((_loc_4 * 3) + _loc_6)]) - (m[((_loc_3 * 3) + _loc_6)] * m[((_loc_4 * 3) + _loc_5)])));
        }

    }
}//package com.mapplus.maps.geom 
