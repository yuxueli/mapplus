//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;

    public class ClientGeocoderOptions {

        static const DEFAULT_OPTIONS:ClientGeocoderOptions = new ClientGeocoderOptions({
            language:null,
            countryCode:null,
            viewport:null
        });
;

        private var _countryCode:String;
        private var _viewport:LatLngBounds;
        private var _language:String;

        public function ClientGeocoderOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):ClientGeocoderOptions{
            var _loc_2:ClientGeocoderOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (ClientGeocoderOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function merge(param1:Array):ClientGeocoderOptions{
            return ((Wrapper.mergeStyles(ClientGeocoderOptions, param1) as ClientGeocoderOptions));
        }

        public function get countryCode():String{
            return (this._countryCode);
        }
        public function set countryCode(param1:String):void{
            this._countryCode = param1;
        }
        public function set viewport(param1:LatLngBounds):void{
            this._viewport = param1;
        }
        public function get viewport():LatLngBounds{
            return (this._viewport);
        }
        public function set language(param1:String):void{
            this._language = param1;
        }
        public function get language():String{
            return (this._language);
        }
        public function toString():String{
            return (((((((("ClientGeocoderOptions: {" + "\n\tlanguage: ") + this.language) + "\n\tcountryCode: ") + this.countryCode) + "\n\tviewport: ") + this.viewport) + "\n\t}"));
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["language"], String);
            Wrapper.copyProperties(this, param1, ["countryCode"], String);
            if (param1.viewport != null){
                this.viewport = LatLngBounds.fromObject(param1.viewport);
            };
        }

    }
}//package com.mapplus.maps.services 
