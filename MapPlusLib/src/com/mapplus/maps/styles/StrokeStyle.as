//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;

    public class StrokeStyle {

        private var _color:Object;
        private var _pixelHinting:Object;
        private var _thickness:Object;
        private var _alpha:Object;

        public function StrokeStyle(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):StrokeStyle{
            var _loc_2:StrokeStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (StrokeStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function mergeStyles(param1:Array):StrokeStyle{
            return ((Wrapper.mergeStyles(StrokeStyle, param1) as StrokeStyle));
        }

        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["thickness", "color", "alpha"], Number);
            Wrapper.copyProperties(this, param1, ["pixelHinting"], Boolean, true);
        }
        public function get color():Object{
            return (this._color);
        }
        public function get alpha():Object{
            return (this._alpha);
        }
        public function set color(param1:Object):void{
            this._color = (param1 as Number);
        }
        public function toString():String{
            return (((((((((("StrokeStyle: {" + "\n\tthickness: ") + this._thickness) + "\n\tcolor: ") + this._color) + "\n\talpha: ") + this._alpha) + "\n\tpixelHinting: ") + this._pixelHinting) + "\n\t}"));
        }
        public function get pixelHinting():Object{
            return (this._pixelHinting);
        }
        public function set pixelHinting(param1:Object):void{
            this._pixelHinting = (param1 as Boolean);
        }
        public function set thickness(param1:Object):void{
            this._thickness = (param1 as Number);
        }
        public function get thickness():Object{
            return (this._thickness);
        }
        public function set alpha(param1:Object):void{
            this._alpha = (param1 as Number);
        }

    }
}//package com.mapplus.maps.styles 
