//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;

    public class OverviewMapControlOptions {

        private var _size:Point;
        private var _position:ControlPosition;
        private var _navigatorStyle:RectangleStyle;
        private var _controlStyle:BevelStyle;
        private var _padding:Point;

        public function OverviewMapControlOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):OverviewMapControlOptions{
            return ((Wrapper.mergeStyles(OverviewMapControlOptions, param1) as OverviewMapControlOptions));
        }
        public static function fromObject(param1:Object):OverviewMapControlOptions{
            var _loc_2:OverviewMapControlOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (OverviewMapControlOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function get size():Point{
            return (this._size);
        }
        public function set size(param1:Point):void{
            if (param1 != null){
                this._size = new Point(param1.x, param1.y);
            } else {
                this._size = null;
            };
        }
        public function get navigatorStyle():RectangleStyle{
            return (this._navigatorStyle);
        }
        public function set position(param1:ControlPosition):void{
            this._position = param1;
        }
        public function get position():ControlPosition{
            return (this._position);
        }
        public function toString():String{
            return (((((((((((("OverviewMapControlOptions: {" + "\n\tcontrolStyle: ") + this.controlStyle) + "\n\tsize: ") + this.size) + "\n\tpadding: ") + this.padding) + "\n\tnavigatorStyle: ") + this.navigatorStyle) + "\n\t  position: ") + this._position.toString()) + " }"));
        }
        public function set padding(param1:Point):void{
            if (param1 != null){
                this._padding = new Point(param1.x, param1.y);
            } else {
                this._padding = null;
            };
        }
        public function get controlStyle():BevelStyle{
            return (this._controlStyle);
        }
        public function set controlStyle(param1:BevelStyle):void{
            this._controlStyle = param1;
        }
        public function get padding():Point{
            return (this._padding);
        }
        public function set navigatorStyle(param1:RectangleStyle):void{
            this._navigatorStyle = param1;
        }
        public function copyFromObject(param1:Object):void{
            if (((param1.hasOwnProperty("position")) && (!((param1.position == null))))){
                this.position = ControlPosition.fromObject(param1.position);
            };
            if (param1.size != null){
                this.size = new Point(param1.size.x, param1.size.y);
            };
            if (param1.padding != null){
                this.padding = new Point(param1.padding.x, param1.padding.y);
            };
            if (param1.controlStyle != null){
                if (this.controlStyle == null){
                    this.controlStyle = new BevelStyle();
                };
                this.controlStyle.copyFromObject(param1.controlStyle);
            };
            if (param1.navigatorStyle != null){
                if (this.navigatorStyle == null){
                    this.navigatorStyle = new RectangleStyle();
                };
                this.navigatorStyle.copyFromObject(param1.navigatorStyle);
            };
        }

    }
}//package com.mapplus.maps.controls 
