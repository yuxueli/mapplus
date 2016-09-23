//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;

    public class TileCoord {

        private var y_:int;
        private var x_:int;
        private var zoom_:int;
        private var quadTreePath_:String;
        private var size_:Number;

        public function TileCoord(param1:int, param2:int, param3:int, param4:Number){
            super();
            this.x_ = param1;
            this.y_ = param2;
            this.zoom_ = param3;
            this.size_ = param4;
            this.quadTreePath_ = null;
        }
        public function getQuadTreePath():String{
            var _loc_1:int;
            var _loc_2:String;
            var _loc_3:int;
            var _loc_4:int;
            if (this.quadTreePath_ == null){
                _loc_1 = this.wrappedX;
                _loc_2 = "qtrs";
                this.quadTreePath_ = "t";
                _loc_3 = 0;
                while (_loc_3 < zoom) {
                    _loc_4 = ((zoom - _loc_3) - 1);
                    this.quadTreePath_ = (this.quadTreePath_ + _loc_2.charAt(((((_loc_1 >> _loc_4) & 1) << 1) | ((y >> _loc_4) & 1))));
                    _loc_3++;
                };
            };
            return (this.quadTreePath_);
        }
        public function get size():Number{
            return (this.size_);
        }
        public function get wrappedX():int{
            var _loc_1:int;
            _loc_1 = (1 << zoom_);
            return (((x_ >= 0)) ? (x_ % _loc_1) : ((_loc_1 - 1) - (((_loc_1 - 1) - x_) % _loc_1)));
        }
        public function toString():String{
            return ((((((("[X=" + x) + " Y=") + y) + " Zoom=") + zoom) + "]"));
        }
        public function getChild(param1:int, param2:int):TileCoord{
            return (new TileCoord(((2 * x_) + param1), ((2 * y_) + param2), (zoom_ + 1), size_));
        }
        public function getParent():TileCoord{
            if (zoom_ == 0){
                return (null);
            };
            return (new TileCoord(Math.floor((x_ / 2)), Math.floor((y_ / 2)), (zoom_ - 1), size_));
        }
        public function getWorldBounds():Rectangle{
            var _loc_1:Number = NaN;
            _loc_1 = (size_ * Math.pow(2, -(zoom_)));
            return (new Rectangle((x_ * _loc_1), (y_ * _loc_1), _loc_1, _loc_1));
        }
        public function wrapToSameWorld(param1:TileCoord):TileCoord{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_2 = (1 << zoom_);
            _loc_3 = (x_ >> zoom_);
            _loc_4 = (param1.x_ >> param1.zoom_);
            return (new TileCoord((x_ + (_loc_2 * (_loc_4 - _loc_3))), y_, zoom_, size_));
        }
        public function equals(param1:TileCoord):Boolean{
            return ((((((((x_ == param1.x_)) && ((y_ == param1.y_)))) && ((zoom_ == param1.zoom_)))) && ((size_ == param1.size_))));
        }
        public function get y():int{
            return (this.y_);
        }
        public function get zoom():int{
            return (this.zoom_);
        }
        public function get x():int{
            return (this.x_);
        }

    }
}//package com.mapplus.maps.core 
