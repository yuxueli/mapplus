//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {

    public class GeocodeCache {

        private var _count:uint;
        private var cache:Object;

        public function GeocodeCache(){
            super();
            this.reset();
        }
        public function reset():void{
            this.cache = {};
            this._count = 0;
        }
        public function get count():uint{
            return (_count);
        }
        public function isCachable(param1:Object):Boolean{
            return (((param1) && (param1[SConstants.PROP_NAME])));
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
        public function get(param1:String):Object{
            var _loc_2:Object;
            _loc_2 = this.cache[this.toCanonical(param1)];
            return ((_loc_2) ? _loc_2 : null);
        }
        public function put(param1:String, param2:Object):Boolean{
            var _loc_4:*;
            var _loc_5:*;
            var _loc_3:String;
            if (((param1) && (this.isCachable(param2)))){
                _loc_3 = this.toCanonical(param1);
                if (!this.cache.hasOwnProperty(_loc_3)){
                    _loc_4 = this;
                    _loc_5 = (this._count + 1);
                    _loc_4._count = _loc_5;
                };
                this.cache[_loc_3] = param2;
                return (true);
            };
            return (false);
        }

    }
}//package com.mapplus.maps.services 
