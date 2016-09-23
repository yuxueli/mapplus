//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;

    public class RectangleStyle {

        private var _strokeStyle:StrokeStyle = null;
        private var _fillStyle:FillStyle = null;

        public function RectangleStyle(param1:Object=null){
            super();
            _fillStyle = null;
            _strokeStyle = null;
            if (param1 != null){
                copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):RectangleStyle{
            var _loc_2:RectangleStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (RectangleStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function mergeStyles(param1:Array):RectangleStyle{
            return ((Wrapper.mergeStyles(RectangleStyle, param1) as RectangleStyle));
        }

        public function set strokeStyle(param1:StrokeStyle):void{
            this._strokeStyle = param1;
        }
        public function get strokeStyle():StrokeStyle{
            return (this._strokeStyle);
        }
        public function set fillStyle(param1:FillStyle):void{
            this._fillStyle = param1;
        }
        public function toString():String{
            return (((((("RectangleStyle: { " + "\n\tfillStyle: ") + this._fillStyle) + "\n\tstrokeStyle: ") + this._strokeStyle) + " } "));
        }
        public function get fillStyle():FillStyle{
            return (this._fillStyle);
        }
        public function copyFromObject(param1:Object):void{
            if (param1.strokeStyle != null){
                if (this.strokeStyle == null){
                    this.strokeStyle = new StrokeStyle();
                };
                this.strokeStyle.copyFromObject(param1.strokeStyle);
            };
            if (param1.fillStyle != null){
                if (this.fillStyle == null){
                    this.fillStyle = new FillStyle();
                };
                this.fillStyle.copyFromObject(param1.fillStyle);
            };
        }

    }
}//package com.mapplus.maps.styles 
