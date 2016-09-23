//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;

    public class DirectionsOptions {

        public static const TRAVEL_MODE_DRIVING:uint = 0;
        public static const TRAVEL_MODE_WALKING:uint = 1;
        static const DEFAULT_OPTIONS:DirectionsOptions = new DirectionsOptions({locale:null});
;

        private var _travelMode:Object;
        private var _locale:String;
        private var _avoidHighways:Object;

        public function DirectionsOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):DirectionsOptions{
            var _loc_2:DirectionsOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (DirectionsOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function merge(param1:Array):DirectionsOptions{
            return ((Wrapper.mergeStyles(DirectionsOptions, param1) as DirectionsOptions));
        }

        public function set countryCode(param1:String):void{
            var _loc_2:String;
            _loc_2 = this.language;
            this._locale = (_loc_2) ? ((_loc_2 + "_") + param1) : ("_" + param1);
        }
        public function set travelMode(param1:Object):void{
            this._travelMode = (param1 as uint);
        }
        public function get countryCode():String{
            var _loc_1:int;
            if (this._locale){
                _loc_1 = this._locale.indexOf("_");
                if (_loc_1 >= 0){
                    return (this._locale.substring((_loc_1 + 1)));
                };
            };
            return (null);
        }
        public function toString():String{
            return (((((((((("DirectionsOptions: {" + "\n\tlanguage: ") + this.language) + "\n\tcountryCode: ") + this.countryCode) + "\n\ttravelMode: ") + this.travelMode) + "\n\tavoidHighways: ") + this.avoidHighways) + "\n\t}"));
        }
        public function set locale(param1:String):void{
            this._locale = param1;
        }
        public function set avoidHighways(param1:Object):void{
            this._avoidHighways = (param1 as Boolean);
        }
        public function set language(param1:String):void{
            var _loc_2:String;
            _loc_2 = this.countryCode;
            this._locale = (_loc_2) ? ((param1 + "_") + _loc_2) : param1;
        }
        public function get locale():String{
            return (this._locale);
        }
        public function get avoidHighways():Object{
            return (this._avoidHighways);
        }
        public function get travelMode():Object{
            return (this._travelMode);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["travelMode"], uint, true);
            Wrapper.copyProperties(this, param1, ["avoidHighways"], Boolean);
            Wrapper.copyProperties(this, param1, ["locale"], String);
            Wrapper.copyProperties(this, param1, ["language"], String, true);
            Wrapper.copyProperties(this, param1, ["countryCode"], String, true);
        }
        public function get language():String{
            var _loc_1:int;
            if (this._locale){
                _loc_1 = this._locale.indexOf("_");
                if (_loc_1 != 0){
                    return (((_loc_1 > 0)) ? this._locale.substring(0, _loc_1) : this._locale);
                };
            };
            return (null);
        }

    }
}//package com.mapplus.maps.services 
