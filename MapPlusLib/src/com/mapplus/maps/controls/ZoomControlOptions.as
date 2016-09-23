//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;

    public class ZoomControlOptions {

        private var _position:ControlPosition;
        private var _buttonStyle:ButtonStyle;
        private var _hasScrollTrack:Object;
        private var _buttonSize:Point;
        private var _buttonSpacing:Point;

        public function ZoomControlOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):ZoomControlOptions{
            return ((Wrapper.mergeStyles(ZoomControlOptions, param1) as ZoomControlOptions));
        }
        public static function fromObject(param1:Object):ZoomControlOptions{
            var _loc_2:ZoomControlOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (ZoomControlOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function get hasScrollTrack():Object{
            return (this._hasScrollTrack);
        }
        public function set position(param1:ControlPosition):void{
            this._position = param1;
        }
        public function get buttonSize():Point{
            return (this._buttonSize);
        }
        public function set hasScrollTrack(param1:Object):void{
            this._hasScrollTrack = (param1 as Boolean);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["buttonSize", "buttonSpacing"], Point);
            Wrapper.copyProperties(this, param1, ["hasScrollTrack"], Boolean);
            if (((param1.hasOwnProperty("position")) && (!((param1.position == null))))){
                this.position = ControlPosition.fromObject(param1.position);
            };
            if (param1.buttonStyle != null){
                if (this.buttonStyle == null){
                    this.buttonStyle = new ButtonStyle();
                };
                this.buttonStyle.copyFromObject(param1.buttonStyle);
            };
        }
        public function get buttonStyle():ButtonStyle{
            return (this._buttonStyle);
        }
        public function set buttonSpacing(param1:Point):void{
            this._buttonSpacing = param1;
        }
        public function set buttonSize(param1:Point):void{
            this._buttonSize = param1;
        }
        public function get position():ControlPosition{
            return (this._position);
        }
        public function toString():String{
            return ((((((((((("ZoomControlOptions:\n\t{ buttonSize: " + this._buttonSize) + "\n\t  buttonStyle: ") + this._buttonStyle) + "\n\t  buttonSpacing: ") + this._buttonSpacing) + "\n\t  hasScrollTrack: ") + this._hasScrollTrack) + "\n\t  position: ") + this._position.toString()) + " }"));
        }
        public function get buttonSpacing():Point{
            return (this._buttonSpacing);
        }
        public function set buttonStyle(param1:ButtonStyle):void{
            this._buttonStyle = param1;
        }

    }
}//package com.mapplus.maps.controls 
