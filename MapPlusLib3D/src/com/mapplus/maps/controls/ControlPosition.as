//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {

    public final class ControlPosition {

        public static const ANCHOR_TOP_RIGHT:Number = 1;
        public static const AUTO_ALIGN_X:uint = 1;
        public static const AUTO_ALIGN_Y:uint = 2;
        public static const ANCHOR_BOTTOM_LEFT:Number = 32;
        public static const ANCHOR_BOTTOM_RIGHT:Number = 33;
        public static const AUTO_ALIGN_NONE:uint = 0;
        public static const ANCHOR_TOP_LEFT:Number = 0;

        private var internalAutoAlign:uint;
        private var internalPaddingX:Number;
        private var internalPaddingY:Number;
        private var internalAnchor:Number;

        public function ControlPosition(param1:Number, param2:Number=0, param3:Number=NaN, param4:uint=0){
            super();
            internalPaddingX = param2;
            internalPaddingY = (isNaN(param3)) ? internalPaddingX : param3;
            internalAnchor = ((((((param1 == ANCHOR_TOP_LEFT)) || ((param1 == ANCHOR_BOTTOM_RIGHT)))) || ((param1 == ANCHOR_BOTTOM_LEFT)))) ? param1 : ANCHOR_TOP_RIGHT;
            internalAutoAlign = ((((param4 == AUTO_ALIGN_X)) || ((param4 == AUTO_ALIGN_Y)))) ? param4 : AUTO_ALIGN_NONE;
        }
        public static function fromObject(param1:Object):ControlPosition{
            var _loc_2:uint;
            _loc_2 = (param1.hasOwnProperty("getAutoAlign")) ? param1.getAutoAlign() : AUTO_ALIGN_NONE;
            return (new ControlPosition(param1.getAnchor(), param1.getOffsetX(), param1.getOffsetY(), _loc_2));
        }

        public function getAutoAlign():uint{
            return (internalAutoAlign);
        }
        public function toString():String{
            return ((((((((("ControlPosition:\n\t{ anchor: " + internalAnchor) + "\n\t  paddingX: ") + internalPaddingX) + "\n\t  paddingY: ") + internalPaddingY) + "\n\t  autoAlign: ") + internalAutoAlign) + " }"));
        }
        public function getOffsetX():Number{
            return (internalPaddingX);
        }
        public function getOffsetY():Number{
            return (internalPaddingY);
        }
        public function getAnchor():Number{
            return (internalAnchor);
        }
        public function equals(param1:ControlPosition):Boolean{
            return ((((((((internalAnchor == param1.internalAnchor)) && ((internalPaddingX == param1.internalPaddingX)))) && ((internalPaddingY == param1.internalPaddingY)))) && ((internalAutoAlign == param1.internalAutoAlign))));
        }

    }
}//package com.mapplus.maps.controls 
