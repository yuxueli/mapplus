//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public class HPoint {

        public var w:Number;
        public var x:Number;
        public var y:Number;

        public function HPoint(param1:Number, param2:Number, param3:Number){
            super();
            this.x = param1;
            this.y = param2;
            this.w = param3;
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
        public static function fromEuclideanPoint(param1:Point):HPoint{
            return (new HPoint(param1.x, param1.y, 1));
        }
        public static function dotProduct(param1:HPoint, param2:HPoint):Number{
            return ((((param1.x * param2.x) + (param1.y * param2.y)) + (param1.w * param2.w)));
        }
        public static function crossProduct(param1:HPoint, param2:HPoint):HPoint{
            return (new HPoint(((param1.y * param2.w) - (param1.w * param2.y)), ((param1.w * param2.x) - (param1.x * param2.w)), ((param1.x * param2.y) - (param1.y * param2.x))));
        }

        public function isAtInfinity():Boolean{
            return ((Math.abs(this.w) < 1E-307));
        }
        public function euclideanPoint():Point{
            return (new Point(this.euclideanX(), this.euclideanY()));
        }
        public function toString():String{
            return ((((((("[" + this.x) + ", ") + this.y) + ", ") + this.w) + "]"));
        }
        public function normalize():void{
            this.x = (this.x / this.w);
            this.y = (this.y / this.w);
            this.w = 1;
        }
        public function euclideanX():Number{
            return ((this.x / this.w));
        }
        public function euclideanY():Number{
            return ((this.y / this.w));
        }
        public function clone():HPoint{
            return (new HPoint(this.x, this.y, this.w));
        }

    }
}//package com.mapplus.maps.geom 
