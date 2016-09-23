//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class S1Interval {

        public var hi:Number;
        public var lo:Number;

        public function S1Interval(param1:Number, param2:Number){
            super();
            if ((((param1 == -(Math.PI))) && (!((param2 == Math.PI))))){
                this.lo = Math.PI;
            };
            if ((((param2 == -(Math.PI))) && (!((param1 == Math.PI))))){
                this.hi = Math.PI;
            };
            this.lo = param1;
            this.hi = param2;
        }
        public static function fromObject(param1:Object):S1Interval{
            if (param1 == null){
                return (null);
            };
            return (new S1Interval(param1.lo, param1.hi));
        }
        public static function distance(param1:Number, param2:Number):Number{
            var _loc_3:Number = NaN;
            _loc_3 = (param2 - param1);
            if (_loc_3 >= 0){
                return (_loc_3);
            };
            return (((param2 + Math.PI) - (param1 - Math.PI)));
        }

        public function containsInterval(param1:S1Interval):Boolean{
            if (this.isInverted()){
                if (param1.isInverted()){
                    return ((((param1.lo >= this.lo)) && ((param1.hi <= this.hi))));
                };
                return ((((((param1.lo >= this.lo)) || ((param1.hi <= this.hi)))) && (!(this.isEmpty()))));
            };
            if (param1.isInverted()){
                return (((this.isFull()) || (param1.isEmpty())));
            };
            return ((((param1.lo >= this.lo)) && ((param1.hi <= this.hi))));
        }
        public function isEmpty():Boolean{
            return (((this.lo - this.hi) == (2 * Math.PI)));
        }
        public function contains(param1:Number):Boolean{
            if (param1 == -(Math.PI)){
                param1 = Math.PI;
            };
            if (this.isInverted()){
                return ((((((param1 >= this.lo)) || ((param1 <= this.hi)))) && (!(this.isEmpty()))));
            };
            return ((((param1 >= this.lo)) && ((param1 <= this.hi))));
        }
        public function span():Number{
            if (this.isEmpty()){
                return (0);
            };
            if (this.isInverted()){
                return (((2 * Math.PI) - (this.lo - this.hi)));
            };
            return ((this.hi - this.lo));
        }
        public function intersects(param1:S1Interval):Boolean{
            if (((this.isEmpty()) || (param1.isEmpty()))){
                return (false);
            };
            if (this.isInverted()){
                return (((((param1.isInverted()) || ((param1.lo <= this.hi)))) || ((param1.hi >= this.lo))));
            };
            if (param1.isInverted()){
                return ((((param1.lo <= this.hi)) || ((param1.hi >= this.lo))));
            };
            return ((((param1.lo <= this.hi)) && ((param1.hi >= this.lo))));
        }
        public function center():Number{
            var _loc_1:Number = NaN;
            _loc_1 = ((this.lo + this.hi) / 2);
            if (this.isInverted()){
                _loc_1 = (_loc_1 + Math.PI);
                _loc_1 = MapUtil.wrap(_loc_1, -(Math.PI), Math.PI);
            };
            return (_loc_1);
        }
        public function equals(param1:S1Interval):Boolean{
            if (this.isEmpty()){
                return (param1.isEmpty());
            };
            return (((((Math.abs((param1.lo - this.lo)) % 2) * Math.PI) + ((Math.abs((param1.hi - this.hi)) % 2) * Math.PI)) <= MapUtil.FLOAT_ERROR_MARGIN));
        }
        public function isFull():Boolean{
            return (((this.hi - this.lo) == (2 * Math.PI)));
        }
        public function extend(param1:Number):void{
            if (this.contains(param1)){
                return;
            };
            if (this.isEmpty()){
                this.hi = param1;
                this.lo = param1;
            } else {
                if (distance(param1, this.lo) < distance(this.hi, param1)){
                    this.lo = param1;
                } else {
                    this.hi = param1;
                };
            };
        }
        public function isInverted():Boolean{
            return ((this.lo > this.hi));
        }

    }
}//package com.mapplus.maps 
