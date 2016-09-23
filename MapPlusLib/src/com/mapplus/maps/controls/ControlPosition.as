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
            this.internalPaddingX = param2;
            this.internalPaddingY = (isNaN(param3)) ? this.internalPaddingX : param3;
            this.internalAnchor = ((((((param1 == ANCHOR_TOP_LEFT)) || ((param1 == ANCHOR_BOTTOM_RIGHT)))) || ((param1 == ANCHOR_BOTTOM_LEFT)))) ? param1 : ANCHOR_TOP_RIGHT;
            this.internalAutoAlign = ((((param4 == AUTO_ALIGN_X)) || ((param4 == AUTO_ALIGN_Y)))) ? param4 : AUTO_ALIGN_NONE;
        }
        public static function fromObject(param1:Object):ControlPosition{
            var _loc_2:uint;
            _loc_2 = (param1.hasOwnProperty("getAutoAlign")) ? param1.getAutoAlign() : AUTO_ALIGN_NONE;
            return (new ControlPosition(param1.getAnchor(), param1.getOffsetX(), param1.getOffsetY(), _loc_2));
        }

        public function toString():String{
            return ((((((((("ControlPosition:\n\t{ anchor: " + this.internalAnchor) + "\n\t  paddingX: ") + this.internalPaddingX) + "\n\t  paddingY: ") + this.internalPaddingY) + "\n\t  autoAlign: ") + this.internalAutoAlign) + " }"));
        }
        public function getOffsetY():Number{
            return (this.internalPaddingY);
        }
        public function getOffsetX():Number{
            return (this.internalPaddingX);
        }
        public function getAutoAlign():uint{
            return (this.internalAutoAlign);
        }
        public function getAnchor():Number{
            return (this.internalAnchor);
        }
        public function equals(param1:ControlPosition):Boolean{
            return ((((((((this.internalAnchor == param1.internalAnchor)) && ((this.internalPaddingX == param1.internalPaddingX)))) && ((this.internalPaddingY == param1.internalPaddingY)))) && ((this.internalAutoAlign == param1.internalAutoAlign))));
        }

    }
}//package com.mapplus.maps.controls 
