//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.styles.*;

    public class PolygonOptions {

        private var toolTip:String;
        public var strokeStyle:StrokeStyle;
        public var fillStyle:FillStyle;

        public function PolygonOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):PolygonOptions{
            return ((Wrapper.mergeStyles(PolygonOptions, param1) as PolygonOptions));
        }
        public static function fromObject(param1:Object):PolygonOptions{
            var _loc_2:PolygonOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (PolygonOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function getDefaultOptions():PolygonOptions{
            var _loc_1:ClientBootstrap;
            _loc_1 = ClientBootstrap.getInstance();
            return (_loc_1.getMapsFactory().getDefaultPolygonOptions());
        }
        public static function setDefaultOptions(param1:PolygonOptions):void{
            var _loc_2:ClientBootstrap;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_2.getMapsFactory().setDefaultPolygonOptions(param1);
        }

        public function toString():String{
            return ((((((("PolygonOptions: { strokeStyle: " + this.strokeStyle) + " fillStyle: ") + this.fillStyle) + " toolTip: ") + this.toolTip) + "}"));
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
            Wrapper.copyProperties(this, param1, ["tooltip"], String, true);
        }
        public function get tooltip():String{
            return (this.toolTip);
        }
        public function set tooltip(param1:String):void{
            this.toolTip = param1;
        }

    }
}//package com.mapplus.maps.overlays 
