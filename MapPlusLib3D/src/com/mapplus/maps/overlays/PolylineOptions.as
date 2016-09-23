//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.styles.*;

    public class PolylineOptions {

        public var strokeStyle:StrokeStyle;
        private var _geodesic:Object;

        public function PolylineOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):PolylineOptions{
            return ((Wrapper.mergeStyles(PolylineOptions, param1) as PolylineOptions));
        }
        public static function fromObject(param1:Object):PolylineOptions{
            var _loc_2:PolylineOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (PolylineOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function set geodesic(param1:Object):void{
            this._geodesic = (param1 as Boolean);
        }
        public function get geodesic():Object{
            return (this._geodesic);
        }
        public function toString():String{
            return (((("PolylineOptions:" + "\n\t{ strokeStyle: ") + this.strokeStyle) + " }"));
        }
        public function copyFromObject(param1:Object):void{
            if (param1.strokeStyle != null){
                if (this.strokeStyle == null){
                    this.strokeStyle = new StrokeStyle();
                };
                this.strokeStyle.copyFromObject(param1.strokeStyle);
            };
            Wrapper.copyProperties(this, param1, ["geodesic"], Boolean, true);
        }

    }
}//package com.mapplus.maps.overlays 
