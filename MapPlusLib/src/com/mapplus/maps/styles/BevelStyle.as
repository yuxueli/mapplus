//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;

    public class BevelStyle extends RectangleStyle {

        public static const BEVEL_NONE:Number = 0;
        public static const BEVEL_LOWERED:Number = 2;
        public static const BEVEL_RAISED:Number = 1;

        private var _bevelAlpha:Object = null;
        private var _shadowColor:Object = null;
        private var _highlightColor:Object = null;
        private var _bevelStyle:Object = null;
        private var _bevelThickness:Object = null;

        public function BevelStyle(param1:Object=null){
            super();
            this._highlightColor = null;
            this._shadowColor = null;
            this._bevelAlpha = null;
            this._bevelStyle = null;
            this._bevelThickness = null;
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):BevelStyle{
            var _loc_2:BevelStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (BevelStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function mergeStyles(param1:Array):BevelStyle{
            return ((Wrapper.mergeStyles(BevelStyle, param1) as BevelStyle));
        }

        public function get bevelAlpha():Object{
            return (this._bevelAlpha);
        }
        public function set shadowColor(param1:Object):void{
            if (param1 != null){
                this._shadowColor = (param1 as Number);
            } else {
                this._shadowColor = null;
            };
        }
        public function get highlightColor():Object{
            return (this._highlightColor);
        }
        public function get bevelStyle():Object{
            return (this._bevelStyle);
        }
        public function get bevelThickness():Object{
            return (this._bevelThickness);
        }
        public function set highlightColor(param1:Object):void{
            if (param1 != null){
                this._highlightColor = (param1 as Number);
            } else {
                this._highlightColor = null;
            };
        }
        public function set bevelAlpha(param1:Object):void{
            if (param1 != null){
                this._bevelAlpha = (param1 as Number);
            } else {
                this._bevelAlpha = null;
            };
        }
        override public function copyFromObject(param1:Object):void{
            super.copyFromObject(param1);
            Wrapper.copyProperties(this, param1, ["bevelStyle", "highlightColor", "shadowColor", "bevelAlpha", "bevelThickness"], Number);
        }
        public function get shadowColor():Object{
            return (this._shadowColor);
        }
        override public function toString():String{
            return (((((((((((((("BevelStyle: { " + "\n\t") + super.toString()) + "\n\tbevelStyle: ") + this._bevelStyle) + "\n\tbevelThickness: ") + this._bevelThickness) + "\n\thighlightColor: ") + this._highlightColor) + "\n\tshadowColor: ") + this._shadowColor) + "\n\tbevelAlpha: ") + this._bevelAlpha) + " } "));
        }
        public function set bevelThickness(param1:Object):void{
            if (param1 != null){
                this._bevelThickness = (param1 as Number);
            } else {
                this._bevelThickness = null;
            };
        }
        public function set bevelStyle(param1:Object):void{
            if (param1 != null){
                this._bevelStyle = (param1 as Number);
            } else {
                this._bevelStyle = null;
            };
        }

    }
}//package com.mapplus.maps.styles 
