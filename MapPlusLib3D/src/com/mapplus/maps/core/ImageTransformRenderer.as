//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class ImageTransformRenderer {

        public static const MAX_RECURSION:int = 4;
        public static const MAX_SINGLE_QUAD_ERROR:Number = 3;
        public static const MAX_RECURSE_ERROR:Number = 10;

        private var maxRecursion:int;
        var viewport:Point;
        private var graphics:Graphics;
        private var transform:Function;
        private var pixels:BitmapData;
        private var maxRecurseError:Number;
        private var maxSingleQuadError:Number;
        private var splitUnidimensionallyIfAnisotropic:Boolean;
        private var overSample:Boolean;

        public function ImageTransformRenderer(){
            super();
        }
        static function bisect(param1:Point, param2:Point):Point{
            return (new Point((0.5 * (param1.x + param2.x)), (0.5 * (param1.y + param2.y))));
        }
        public static function render(param1:BitmapData, param2:Rectangle, param3:Function, param4:Graphics, param5:Point, param6:int=4, param7:Number=3, param8:Number=10, param9:Boolean=true, param10:Boolean=false):int{
            var _loc_11:ImageTransformRenderer;
            var _loc_12:Point;
            var _loc_13:Point;
            var _loc_14:Point;
            var _loc_15:Point;
            _loc_11 = new (ImageTransformRenderer)();
            _loc_11.pixels = param1;
            _loc_11.transform = param3;
            _loc_11.graphics = param4;
            _loc_11.viewport = param5;
            _loc_11.maxSingleQuadError = param7;
            _loc_11.maxRecurseError = param8;
            _loc_11.splitUnidimensionallyIfAnisotropic = param9;
            _loc_11.overSample = param10;
            _loc_12 = param3(param2.left, param2.top);
            _loc_13 = param3(param2.right, param2.top);
            _loc_14 = param3(param2.right, param2.bottom);
            _loc_15 = param3(param2.left, param2.bottom);
            return (_loc_11.renderBitmapFragment(param2, _loc_12, _loc_13, _loc_15, _loc_14, param6));
        }
        static function maxSqrDistToMidpoint(param1:Array):Number{
            var _loc_2:int;
            var _loc_3:Number = NaN;
            var _loc_4:int;
            var _loc_5:Number = NaN;
            _loc_2 = param1.length;
            _loc_3 = 0;
            _loc_4 = 0;
            while (_loc_4 < _loc_2) {
                _loc_5 = Util.sqrDistToMidpoint(param1[_loc_4], param1[(_loc_4 + 1)], param1[(_loc_4 + 2)]);
                if (_loc_5 > _loc_3){
                    _loc_3 = _loc_5;
                };
                _loc_4 = (_loc_4 + 3);
            };
            return (_loc_3);
        }

        function mayIntersectViewport(param1:Point, param2:Point, param3:Point, param4:Point):Boolean{
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            if ((((((((param1.x < 0)) && ((param2.x < 0)))) && ((param3.x < 0)))) && ((param4.x < 0)))){
                return (false);
            };
            if ((((((((param1.y < 0)) && ((param2.y < 0)))) && ((param3.y < 0)))) && ((param4.y < 0)))){
                return (false);
            };
            _loc_5 = viewport.x;
            if ((((((((param1.x > _loc_5)) && ((param2.x > _loc_5)))) && ((param3.x > _loc_5)))) && ((param4.x > _loc_5)))){
                return (false);
            };
            _loc_6 = viewport.y;
            if ((((((((param1.y > _loc_6)) && ((param2.y > _loc_6)))) && ((param3.y > _loc_6)))) && ((param4.y > _loc_6)))){
                return (false);
            };
            return (true);
        }
        private function renderBitmapFragment(param1:Rectangle, param2:Point, param3:Point, param4:Point, param5:Point, param6:int):int{
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Boolean;
            var _loc_10:int;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Point;
            var _loc_20:Point;
            var _loc_21:Point;
            var _loc_22:Point;
            var _loc_23:Point;
            var _loc_24:Array;
            var _loc_25:Number = NaN;
            var _loc_26:Number = NaN;
            var _loc_27:Number = NaN;
            var _loc_28:Number = NaN;
            var _loc_29:Number = NaN;
            var _loc_30:Point;
            var _loc_31:Point;
            var _loc_32:Point;
            var _loc_33:Point;
            var _loc_34:Point;
            var _loc_35:Number = NaN;
            var _loc_36:Rectangle;
            var _loc_37:Rectangle;
            var _loc_38:Rectangle;
            var _loc_39:Rectangle;
            var _loc_40:Rectangle;
            var _loc_41:Rectangle;
            var _loc_42:Rectangle;
            var _loc_43:Rectangle;
            var _loc_44:Point;
            var _loc_45:Matrix;
            var _loc_46:Matrix;
            if (!mayIntersectViewport(param2, param3, param4, param5)){
                return (0);
            };
            _loc_7 = Math.abs((param2.y - param5.y));
            _loc_8 = Math.abs((param3.y - param4.y));
            if (Math.max(_loc_7, _loc_8) < 1){
                return (0);
            };
            _loc_9 = !((param6 == 0));
            _loc_10 = (param6 - 1);
            _loc_11 = param1.width;
            _loc_12 = param1.height;
            _loc_13 = (0.5 * _loc_11);
            _loc_14 = (0.5 * _loc_12);
            _loc_15 = param1.left;
            _loc_16 = param1.top;
            _loc_17 = (_loc_15 + _loc_13);
            _loc_18 = (_loc_16 + _loc_14);
            if (_loc_9){
                _loc_19 = transform(_loc_17, _loc_16);
                _loc_20 = transform(_loc_15, _loc_18);
                _loc_21 = transform(param1.right, _loc_18);
                _loc_22 = transform(_loc_17, param1.bottom);
                _loc_23 = transform(_loc_17, _loc_18);
                _loc_24 = [_loc_23, param2, param5, _loc_19, param2, param3, _loc_20, param2, param4, _loc_21, param3, param5, _loc_22, param4, param5];
                if (overSample){
                    _loc_26 = (_loc_15 + (0.5 * _loc_13));
                    _loc_27 = (_loc_17 + (0.5 * _loc_13));
                    _loc_28 = (_loc_16 + (0.5 * _loc_14));
                    _loc_29 = (_loc_18 + (0.5 * _loc_14));
                    _loc_30 = transform(_loc_17, _loc_28);
                    _loc_31 = transform(_loc_26, _loc_18);
                    _loc_32 = transform(_loc_27, _loc_18);
                    _loc_33 = transform(_loc_17, _loc_29);
                    _loc_34 = bisect(param2, param5);
                    _loc_24.push(_loc_30, _loc_34, bisect(param2, param3), _loc_31, _loc_34, bisect(param2, param4), _loc_32, _loc_34, bisect(param3, param5), _loc_33, _loc_34, bisect(param4, param5));
                };
                _loc_25 = maxSqrDistToMidpoint(_loc_24);
                if (_loc_25 < maxSingleQuadError){
                    _loc_9 = false;
                };
                if (_loc_25 < maxRecurseError){
                    _loc_10 = 0;
                };
            };
            if (_loc_9){
                _loc_35 = (Util.sqrDist(param2, param3) / Util.sqrDist(param2, param4));
                if (((splitUnidimensionallyIfAnisotropic) && ((_loc_35 > 8)))){
                    _loc_36 = new Rectangle(_loc_15, _loc_16, _loc_13, _loc_12);
                    _loc_37 = new Rectangle(_loc_17, _loc_16, _loc_13, _loc_12);
                    return ((renderBitmapFragment(_loc_36, param2, _loc_19, param4, _loc_22, _loc_10) + renderBitmapFragment(_loc_37, _loc_19, param3, _loc_22, param5, _loc_10)));
                };
                if (((splitUnidimensionallyIfAnisotropic) && ((_loc_35 < 0.125)))){
                    _loc_38 = new Rectangle(_loc_15, _loc_16, _loc_11, _loc_14);
                    _loc_39 = new Rectangle(_loc_15, _loc_18, _loc_11, _loc_14);
                    return ((renderBitmapFragment(_loc_38, param2, param3, _loc_20, _loc_21, _loc_10) + renderBitmapFragment(_loc_39, _loc_20, _loc_21, param4, param5, _loc_10)));
                };
                _loc_40 = new Rectangle(_loc_15, _loc_16, _loc_13, _loc_14);
                _loc_41 = new Rectangle(_loc_17, _loc_16, _loc_13, _loc_14);
                _loc_42 = new Rectangle(_loc_15, _loc_18, _loc_13, _loc_14);
                _loc_43 = new Rectangle(_loc_17, _loc_18, _loc_13, _loc_14);
                return ((((renderBitmapFragment(_loc_40, param2, _loc_19, _loc_20, _loc_23, _loc_10) + renderBitmapFragment(_loc_41, _loc_19, param3, _loc_23, _loc_21, _loc_10)) + renderBitmapFragment(_loc_42, _loc_20, _loc_23, param4, _loc_22, _loc_10)) + renderBitmapFragment(_loc_43, _loc_23, _loc_21, _loc_22, param5, _loc_10)));
            };
            _loc_44 = Geometry.getFourthVertex(param3, param5, param4);
            _loc_45 = Geometry.getAffineForRect(param1, param2, param3, param4);
            _loc_46 = Geometry.getAffineForRect(param1, _loc_44, param3, param4);
            Render.drawBitmapTriangle(graphics, pixels, _loc_45, param2, param3, param4);
            Render.drawBitmapTriangle(graphics, pixels, _loc_46, param3, param5, param4);
            return (2);
        }

    }
}//package com.mapplus.maps.core 
