//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.wrappers.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;

    public class GroundOverlayOptions {

        private var _renderContent:Object;
        private var _rotationContentCenter:Point;
        private var _strokeStyle:StrokeStyle;
        private var _rotation:Object;
        private var _applyProjection:Object;

        public function GroundOverlayOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):GroundOverlayOptions{
            return ((Wrapper.mergeStyles(GroundOverlayOptions, param1) as GroundOverlayOptions));
        }
        public static function fromObject(param1:Object):GroundOverlayOptions{
            var _loc_2:GroundOverlayOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (GroundOverlayOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function get renderContent():Object{
            return (this._renderContent);
        }
        public function set renderContent(param1:Object):void{
            this._renderContent = (param1 as Boolean);
        }
        public function get rotationContentCenter():Point{
            return (this._rotationContentCenter);
        }
        public function get strokeStyle():StrokeStyle{
            return (this._strokeStyle);
        }
        public function get applyProjection():Object{
            return (this._applyProjection);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["rotation"], Number);
            Wrapper.copyProperties(this, param1, ["applyProjection"], Boolean, true);
            this.renderContent = (param1.hasOwnProperty("renderContent")) ? (param1["renderContent"] as Boolean) : true;
            if (param1.strokeStyle != null){
                if (this.strokeStyle == null){
                    this.strokeStyle = new StrokeStyle();
                };
                this.strokeStyle.copyFromObject(param1.strokeStyle);
            };
            if (MapUtil.hasNonNullProperty(param1, "rotationContentCenter")){
                if (this.rotationContentCenter == null){
                    this.rotationContentCenter = new Point();
                };
                Wrapper.copyPointProperties(this.rotationContentCenter, param1.rotationContentCenter);
            };
        }
        public function set rotationContentCenter(param1:Point):void{
            this._rotationContentCenter = (!((param1 == null))) ? new Point(param1.x, param1.y) : null;
        }
        public function toString():String{
            return (((((((((((("GroundOverlayOptions:" + "\n\t{ strokeStyle: ") + this._strokeStyle) + "\n\t  rotation: ") + this._rotation) + "\n\t  rotationContentCenter: ") + this._rotationContentCenter) + "\n\t  applyProjection: ") + this._applyProjection) + "\n\t  renderContent: ") + this._renderContent) + " }"));
        }
        public function set strokeStyle(param1:StrokeStyle):void{
            this._strokeStyle = param1;
        }
        public function set applyProjection(param1:Object):void{
            this._applyProjection = (param1 as Boolean);
        }
        public function set rotation(param1:Object):void{
            this._rotation = (param1 as Number);
        }
        public function get rotation():Object{
            return (this._rotation);
        }

    }
}//package com.mapplus.maps.overlays 
