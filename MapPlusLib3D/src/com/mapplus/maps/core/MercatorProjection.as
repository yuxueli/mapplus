//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public final class MercatorProjection implements IProjection {

        public static const MERCATOR_ZOOM_LEVEL_ZERO_RANGE:Number = 0x0100;

        private var _wrapper:Object;
        private var pixelRange:Array;
        private var pixelsPerLonDegree:Array;
        private var pixelOrigo:Array;
        private var pixelsPerLonRadian:Array;

        public function MercatorProjection(param1:Number){
            super();
            var _loc_2:Number = NaN;
            var _loc_3:int;
            var _loc_4:Number = NaN;
            pixelsPerLonDegree = [];
            pixelsPerLonRadian = [];
            pixelOrigo = [];
            pixelRange = [];
            _loc_2 = MERCATOR_ZOOM_LEVEL_ZERO_RANGE;
            _loc_3 = 0;
            while (_loc_3 < param1) {
                _loc_4 = (_loc_2 / 2);
                pixelsPerLonDegree.push((_loc_2 / 360));
                pixelsPerLonRadian.push((_loc_2 / (2 * Math.PI)));
                pixelOrigo.push(new Point(_loc_4, _loc_4));
                pixelRange.push(_loc_2);
                _loc_2 = (_loc_2 * 2);
                _loc_3++;
            };
        }
        public function fromPixelToLatLng(param1:Point, param2:Number, param3:Boolean=false):LatLng{
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            _loc_4 = pixelOrigo[param2];
            _loc_5 = ((param1.x - _loc_4.x) / pixelsPerLonDegree[param2]);
            _loc_6 = ((param1.y - _loc_4.y) / -(pixelsPerLonRadian[param2]));
            _loc_7 = Util.radiansToDegrees(((2 * Math.atan(Math.exp(_loc_6))) - (Math.PI / 2)));
            return (new LatLng(_loc_7, _loc_5, param3));
        }
        public function get interfaceChain():Array{
            return (["IProjection"]);
        }
        public function get wrapper():Object{
            return (this._wrapper);
        }
        public function fromLatLngToPixel(param1:LatLng, param2:Number):Point{
            var _loc_3:Point;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            _loc_3 = pixelOrigo[param2];
            _loc_4 = (_loc_3.x + (param1.lng() * pixelsPerLonDegree[param2]));
            _loc_5 = Util.bound(Math.sin(Util.degreesToRadians(param1.lat())), -0.9999, 0.9999);
            _loc_6 = (_loc_3.y + ((0.5 * Math.log(((1 + _loc_5) / (1 - _loc_5)))) * -(pixelsPerLonRadian[param2])));
            return (new Point(_loc_4, _loc_6));
        }
        public function tileCheckRange(param1:Point, param2:Number, param3:Number):Boolean{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = pixelRange[param2];
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
            return (pixelRange[param1]);
        }
        public function set wrapper(param1:Object):void{
            this._wrapper = param1;
        }

    }
}//package com.mapplus.maps.core 
