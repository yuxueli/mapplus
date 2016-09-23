//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public final class PlateCarreeProjection implements IProjection {

        public static const ZOOM_ZERO_PIXEL_WIDTH:Number = 0x0100;

        private static var pixelWidths:Array = initializeZoomLevelPixelWidths();

        private var _wrapper:Object;

        public function PlateCarreeProjection(param1:Number){
            super();
        }
        private static function initializeZoomLevelPixelWidths():Array{
            var _loc_1:Array;
            var _loc_2:int;
            _loc_1 = new Array(32);
            _loc_2 = 0;
            while (_loc_2 < 32) {
                _loc_1[_loc_2] = (Math.pow(2, _loc_2) * ZOOM_ZERO_PIXEL_WIDTH);
                _loc_2++;
            };
            return (_loc_1);
        }

        public function fromLatLngToPixel(param1:LatLng, param2:Number):Point{
            var _loc_3:Number = NaN;
            _loc_3 = ((param1.lng() / 360) + 0.5);
            return (new Point((_loc_3 * pixelWidths[param2]), (((90 - param1.lat()) * pixelWidths[param2]) / 180)));
        }
        public function fromPixelToLatLng(param1:Point, param2:Number, param3:Boolean=false):LatLng{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = (param1.x / pixelWidths[param2]);
            _loc_5 = (param1.y / pixelWidths[param2]);
            return (new LatLng(((0.5 - _loc_5) * 180), ((_loc_4 - 0.5) * 360), param3));
        }
        public function tileCheckRange(param1:Point, param2:Number, param3:Number):Boolean{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = pixelWidths[param2];
            if ((((param1.y < 0)) || (((param1.y * param3) >= _loc_4)))){
                return (false);
            };
            if ((((param1.x < 0)) || (((param1.x * param3) >= _loc_4)))){
                _loc_5 = Math.floor((_loc_4 / param3));
                param1.x = (param1.x % _loc_5);
                if (param1.x < 0){
                    param1.x = (param1.x + _loc_5);
                };
            };
            return (true);
        }
        public function getWrapWidth(param1:Number):Number{
            return (pixelWidths[param1]);
        }
        public function get interfaceChain():Array{
            return (["IProjection"]);
        }
        public function set wrapper(param1:Object):void{
            this._wrapper = param1;
        }
        public function get wrapper():Object{
            return (this._wrapper);
        }

    }
}//package com.mapplus.maps.core 
