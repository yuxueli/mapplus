//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;
    import flash.filters.*;

    public class DropShadow {

        private static const BLUR_X:Number = 3;
        private static const BLUR_Y:Number = 3;

        private var shadow:Bitmap;
        private var cacheShadow:Boolean;
        private var previousTarget:DisplayObject;
        private var bounds:Rectangle;
        private var mc:Sprite;

        public function DropShadow(param1:Sprite, param2:Boolean=false){
            super();
            this.mc = param1;
            this.cacheShadow = param2;
        }
        public static function shadowFilter():DropShadowFilter{
            return (new DropShadowFilter(0, 0, Color.BLACK, 0.6, BLUR_X, BLUR_Y, 1, 1, false, false, true));
        }
        public static function positionShadowObject(param1:DisplayObject, param2:Point, param3:Matrix, param4:Rectangle=null):void{
            var _loc_5:Point;
            var _loc_6:Point;
            if (!param1){
                return;
            };
            if (!param4){
                param4 = param1.getBounds(param1);
            };
            param1.transform.matrix = param3;
            _loc_5 = new Point((param4.size.x / 2), param4.size.y);
            if (param2){
                _loc_5.offset(-(param2.x), -(param2.y));
            };
            _loc_6 = param4.topLeft.add(_loc_5.subtract(param3.transformPoint(_loc_5)));
            param1.x = _loc_6.x;
            param1.y = _loc_6.y;
        }
        private static function copyToBitmap(param1:DisplayObject, param2:Point, param3:Matrix):Bitmap{
            return ((Bootstrap.copyToBitmap(param1, param2, param3) as Bitmap));
        }

        public function positionShadow(param1:Point, param2:Matrix):void{
            positionShadowObject(shadow, param1, param2, bounds);
        }
        public function remove():void{
            var _loc_1:ISpriteFactory;
            _loc_1 = Bootstrap.getSpriteFactory();
            if (shadow != null){
                _loc_1.removeChild(mc, shadow);
                shadow = null;
            };
        }
        public function draw(param1:DisplayObject):Boolean{
            var _loc_2:Matrix;
            bounds = param1.getBounds(param1);
            if (bounds.isEmpty()){
                remove();
                return (true);
            };
            if (((((!(shadow)) || (!(cacheShadow)))) || (!((param1 == previousTarget))))){
                remove();
                _loc_2 = new Matrix(1, 0, 0, 1, -(bounds.left), -(bounds.top));
                shadow = copyToBitmap(param1, bounds.size, _loc_2);
                if (!shadow){
                    return (false);
                };
                shadow.filters = [shadowFilter()];
                previousTarget = param1;
                Bootstrap.getSpriteFactory().addChild(mc, shadow);
            };
            return (true);
        }

    }
}//package com.mapplus.maps.overlays 
