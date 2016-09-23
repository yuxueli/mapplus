//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;

    public class NavigationControlOptions {

        private var _position:ControlPosition;
        private var _hasScrollTrack:Object;

        public function NavigationControlOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):NavigationControlOptions{
            return ((Wrapper.mergeStyles(NavigationControlOptions, param1) as NavigationControlOptions));
        }
        public static function fromObject(param1:Object):NavigationControlOptions{
            var _loc_2:NavigationControlOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (NavigationControlOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function set position(param1:ControlPosition):void{
            this._position = param1;
        }
        public function get hasScrollTrack():Object{
            return (this._hasScrollTrack);
        }
        public function get position():ControlPosition{
            return (this._position);
        }
        public function toString():String{
            return (((((("NavigationControlOptions: {" + "\n  position: ") + this._position) + "\n  hasScrollTrack: ") + this._hasScrollTrack) + "\n}"));
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["hasScrollTrack"], Boolean, true);
            if (param1.hasOwnProperty("position")){
                param1.hasOwnProperty("position");
            };
            if (param1.position != null){
                this.position = ControlPosition.fromObject(param1.position);
            };
        }
        public function set hasScrollTrack(param1:Object):void{
            this._hasScrollTrack = (param1 as Boolean);
        }

    }
}//package com.mapplus.maps.controls 
