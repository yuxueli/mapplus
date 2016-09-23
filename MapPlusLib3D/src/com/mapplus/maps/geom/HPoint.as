//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public class HPoint {

        public var y:Number;
        public var w:Number;
        public var x:Number;

        public function HPoint(param1:Number, param2:Number, param3:Number){
            super();
            this.x = param1;
            this.y = param2;
            this.w = param3;
        }
        public static function crossProduct(param1:HPoint, param2:HPoint):HPoint{
            return (new HPoint(((param1.y * param2.w) - (param1.w * param2.y)), ((param1.w * param2.x) - (param1.x * param2.w)), ((param1.x * param2.y) - (param1.y * param2.x))));
        }
        public static function fromEuclideanPoint(param1:Point):HPoint{
            return (new HPoint(param1.x, param1.y, 1));
        }
        public static function dotProduct(param1:HPoint, param2:HPoint):Number{
            return ((((param1.x * param2.x) + (param1.y * param2.y)) + (param1.w * param2.w)));
        }
        public static function getCartesianArray(param1:Array):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            _loc_2 = param1.length;
            if (_loc_2 <= 0){
                return (null);
            };
            _loc_3 = new Array(_loc_2);
            _loc_4 = 0;
            while (_loc_4 < _loc_2) {
                _loc_3[_loc_4] = param1[_loc_4].euclideanPoint();
                _loc_4++;
            };
            return (_loc_3);
        }

        public function isAtInfinity():Boolean{
            return ((Math.abs(w) < 1E-307));
        }
        public function toString():String{
            return ((((((("[" + x) + ", ") + y) + ", ") + w) + "]"));
        }
        public function normalize():void{
            x = (x / w);
            y = (y / w);
            w = 1;
        }
        public function euclideanPoint():Point{
            return (new Point(euclideanX(), euclideanY()));
        }
        public function euclideanX():Number{
            return ((x / w));
        }
        public function euclideanY():Number{
            return ((y / w));
        }
        public function clone():HPoint{
            return (new HPoint(x, y, w));
        }

    }
}//package com.mapplus.maps.geom 
