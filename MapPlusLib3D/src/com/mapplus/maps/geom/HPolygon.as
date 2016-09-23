//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public class HPolygon {

        private var verts_:Array;

        public function HPolygon(param1:Array=null){
            super();
            if (param1 == null){
                this.verts_ = [];
            } else {
                this.verts_ = param1;
            };
        }
        public static function fromRect(param1:Rectangle):HPolygon{
            var _loc_2:HPolygon;
            _loc_2 = new (HPolygon)();
            _loc_2.add(new HPoint(param1.left, param1.top, 1));
            _loc_2.add(new HPoint(param1.right, param1.top, 1));
            _loc_2.add(new HPoint(param1.right, param1.bottom, 1));
            _loc_2.add(new HPoint(param1.left, param1.bottom, 1));
            return (_loc_2);
        }

        public function add(param1:HPoint):void{
            verts_.push(param1);
        }
        public function get verts():Array{
            return (verts_);
        }
        public function empty():Boolean{
            return ((verts_.length == 0));
        }
        public function getBreadth():Number{
            var _loc_1:Number = NaN;
            var _loc_2:int;
            var _loc_3:HPoint;
            var _loc_4:HPoint;
            var _loc_5:HPoint;
            var _loc_6:Number = NaN;
            var _loc_7:int;
            var _loc_8:Point;
            _loc_1 = Number.POSITIVE_INFINITY;
            _loc_2 = 0;
            while (_loc_2 < verts_.length) {
                _loc_3 = verts_[_loc_2];
                _loc_4 = verts_[((_loc_2 + 1) % verts_.length)];
                _loc_5 = HPoint.crossProduct(_loc_3, _loc_4);
                _loc_6 = Number.NEGATIVE_INFINITY;
                _loc_7 = 2;
                while (_loc_7 < verts_.length) {
                    _loc_8 = HPoint(verts_[((_loc_2 + _loc_7) % verts_.length)]).euclideanPoint();
                    _loc_6 = Math.max(_loc_6, Geometry.pointLineDist(_loc_8, _loc_5));
                    if (_loc_6 >= _loc_1){
                        break;
                    };
                    _loc_7++;
                };
                _loc_1 = Math.min(_loc_1, _loc_6);
                _loc_2++;
            };
            return (_loc_1);
        }
        public function size():int{
            return (verts_.length);
        }
        public function getConvexArea():Number{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:int;
            var _loc_5:Point;
            _loc_1 = 0;
            _loc_2 = HPoint(verts_[0]).euclideanPoint();
            _loc_3 = HPoint(verts_[1]).euclideanPoint();
            _loc_4 = 2;
            while (_loc_4 < verts_.length) {
                _loc_5 = HPoint(verts_[_loc_4]).euclideanPoint();
                _loc_1 = (_loc_1 + Geometry.getTriangleArea(_loc_2, _loc_3, _loc_5));
                _loc_3 = _loc_5;
                _loc_4++;
            };
            return (_loc_1);
        }
        public function normalize():void{
            var _loc_1:int;
            _loc_1 = 0;
            while (_loc_1 < verts_.length) {
                HPoint(verts_[_loc_1]).normalize();
                _loc_1++;
            };
        }

    }
}//package com.mapplus.maps.geom 
