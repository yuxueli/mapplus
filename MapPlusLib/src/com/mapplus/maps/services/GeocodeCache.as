//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {

    public class GeocodeCache {

        private var cache:Object;
        private var _count:uint;

        public function GeocodeCache(){
            super();
            this.reset();
        }
        public function isCachable(param1:Object):Boolean{
            return (((param1) && (param1[SConstants.PROP_NAME])));
        }
        public function get count():uint{
            return (this._count);
        }
        public function get(param1:String):Object{
            var _loc_2:Object;
            _loc_2 = this.cache[this.toCanonical(param1)];
            return ((_loc_2) ? _loc_2 : null);
        }
        private function toCanonical(param1:String):String{
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:String;
            var _loc_5:String;
            _loc_2 = param1.split(",").join(" ");
            _loc_3 = _loc_2.split("\t").join(" ");
            _loc_4 = _loc_3.toLowerCase();
            _loc_5 = "";
            while (_loc_5.length != _loc_4.length) {
                _loc_5 = _loc_4;
                _loc_4 = _loc_4.split("  ").join(" ");
            };
            return (_loc_5);
        }
        public function put(param1:String, param2:Object):Boolean{
            var _loc_3:String;
            if (((param1) && (this.isCachable(param2)))){
                _loc_3 = this.toCanonical(param1);
                if (!(this.cache.hasOwnProperty(_loc_3))){
                    this._count = (this._count + 1);
                };
                this.cache[_loc_3] = param2;
                return (true);
            };
            return (false);
        }
        public function reset():void{
            this.cache = {};
            this._count = 0;
        }

    }
}//package com.mapplus.maps.services 
