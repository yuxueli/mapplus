//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;

    public class FillStyle {

        private var _color:Object;
        private var _gradient:GradientStyle;
        private var _alpha:Object;

        public function FillStyle(param1:Object=null){
            super();
            if (param1 != null){
                copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):FillStyle{
            var _loc_2:FillStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (FillStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function mergeStyles(param1:Array):FillStyle{
            return ((Wrapper.mergeStyles(FillStyle, param1) as FillStyle));
        }

        public function set gradient(param1:GradientStyle):void{
            this._gradient = param1;
        }
        public function get color():Object{
            return (this._color);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["color", "alpha"], Number);
            if (param1.gradient != null){
                this.gradient = GradientStyle.fromObject(param1.gradient);
            };
        }
        public function set color(param1:Object):void{
            this._color = (param1 as Number);
            if (this._color != null){
                this._gradient = null;
            };
        }
        public function toString():String{
            return (((((((("FillStyle: {" + "\n\tcolor: ") + this._color) + "\n\talpha: ") + this._alpha) + "\n\tgradient: ") + this._gradient) + "\n\t}"));
        }
        public function get gradient():GradientStyle{
            return (this._gradient);
        }
        public function get alpha():Object{
            return (this._alpha);
        }
        public function set alpha(param1:Object):void{
            this._alpha = (param1 as Number);
            if (this._alpha != null){
                this._gradient = null;
            };
        }

    }
}//package com.mapplus.maps.styles 
