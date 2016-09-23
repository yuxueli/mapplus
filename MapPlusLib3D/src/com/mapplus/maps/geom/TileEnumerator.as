//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import com.mapplus.maps.core.*;
    import flash.geom.*;

    public class TileEnumerator {

        private var breadthThresh:Number;
        private var areaThresh:Number;
        private var zNearDist:Number;
        private var maxZoom:Number;
        private var tileSize_:Number;

        public function TileEnumerator(param1:Number, param2:Number, param3:Number, param4:Number):void{
            super();
            this.tileSize_ = param1;
            this.areaThresh = param2;
            this.breadthThresh = param3;
            this.maxZoom = param4;
        }
        private static function pointLineTest(param1:Number, param2:Number, param3:HPoint):int{
            var _loc_4:Number = NaN;
            _loc_4 = (((param1 * param3.x) + (param2 * param3.y)) + param3.w);
            return (((_loc_4 > 1E-307)) ? 1 : ((_loc_4 < -1E-307)) ? -1 : 0);
        }
        private static function rectCrossesLine(param1:Rectangle, param2:HPoint):Boolean{
            var _loc_3:int;
            _loc_3 = pointLineTest(param1.left, param1.top, param2);
            if (((((!((_loc_3 == pointLineTest(param1.right, param1.top, param2)))) || (!((_loc_3 == pointLineTest(param1.right, param1.bottom, param2)))))) || (!((_loc_3 == pointLineTest(param1.left, param1.bottom, param2)))))){
                return (true);
            };
            return (false);
        }

        public function enumerateTiles(param1:Rectangle, param2:Rectangle, param3:Camera):Array{
            var _loc_4:Array;
            var _loc_5:Array;
            var _loc_6:Array;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:Array;
            var _loc_10:TileCoord;
            var _loc_11:Rectangle;
            var _loc_12:int;
            var _loc_13:int;
            _loc_4 = param3.getWorldViewPolygon();
            _loc_5 = new Array();
            _loc_6 = [];
            _loc_7 = 0;
            _loc_8 = Math.floor((param2.left / tileSize_));
            while ((_loc_8 * tileSize_) < param2.right) {
                _loc_6.push(new TileCoord(_loc_8, 0, 0, tileSize_));
                _loc_8++;
            };
            _loc_9 = Geometry.getUniqueAxes(Geometry.computeSeparatingAxes(_loc_4));
            while (_loc_6.length) {
                _loc_10 = _loc_6.pop();
                _loc_11 = _loc_10.getWorldBounds();
                if (!Geometry.convexPolyIntersects(_loc_4, _loc_11, _loc_9)){
                } else {
                    if ((((_loc_10.zoom < maxZoom)) && (shouldSplit(_loc_11, param1, param3)))){
                        _loc_12 = 0;
                        while (_loc_12 < 2) {
                            _loc_13 = 0;
                            while (_loc_13 < 2) {
                                _loc_6.push(_loc_10.getChild(_loc_12, _loc_13));
                                _loc_13++;
                            };
                            _loc_12++;
                        };
                    } else {
                        _loc_5.push(_loc_10);
                    };
                };
            };
            return (_loc_5);
        }
        public function shouldSplit(param1:Rectangle, param2:Rectangle, param3:Camera):Boolean{
            var _loc_4:HPolygon;
            if (rectCrossesLine(param1, param3.focalLine)){
                return (true);
            };
            _loc_4 = HPolygon.fromRect(param1);
            param3.mapWorldToViewport.projectHPolygonInPlace(_loc_4);
            if (_loc_4.getConvexArea() < areaThresh){
                return (false);
            };
            if (_loc_4.getBreadth() < breadthThresh){
                return (false);
            };
            return (true);
        }
        public function get tileSize():int{
            return (tileSize_);
        }
        public function setMaxZoom(param1:int):void{
            this.maxZoom = param1;
        }

    }
}//package com.mapplus.maps.geom 
