//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class R1Interval {

        public var hi:Number;
        public var lo:Number;

        public function R1Interval(param1:Number, param2:Number){
            super();
            this.lo = param1;
            this.hi = param2;
        }
        public static function fromObject(param1:Object):R1Interval{
            if (param1 == null){
                return (null);
            };
            return (new R1Interval(param1.lo, param1.hi));
        }

        public function containsInterval(param1:R1Interval):Boolean{
            if (param1.isEmpty()){
                return (true);
            };
            return ((((param1.lo >= this.lo)) && ((param1.hi <= this.hi))));
        }
        public function isEmpty():Boolean{
            return ((this.lo > this.hi));
        }
        public function equals(param1:R1Interval):Boolean{
            if (this.isEmpty()){
                return (this.isEmpty());
            };
            return (((Math.abs((param1.lo - this.lo)) + Math.abs((this.hi - param1.hi))) <= MapUtil.FLOAT_ERROR_MARGIN));
        }
        public function span():Number{
            return ((this.isEmpty()) ? 0 : (this.hi - this.lo));
        }
        public function intersects(param1:R1Interval):Boolean{
            if (this.lo <= param1.lo){
                return ((((param1.lo <= this.hi)) && ((param1.lo <= param1.hi))));
            };
            return ((((this.lo <= param1.hi)) && ((this.lo <= this.hi))));
        }
        public function center():Number{
            return (((this.hi + this.lo) / 2));
        }
        public function extend(param1:Number):void{
            if (this.isEmpty()){
                this.lo = param1;
                this.hi = param1;
            } else {
                if (param1 < this.lo){
                    this.lo = param1;
                } else {
                    if (param1 > this.hi){
                        this.hi = param1;
                    };
                };
            };
        }
        public function contains(param1:Number):Boolean{
            return ((((param1 >= this.lo)) && ((param1 <= this.hi))));
        }

    }
}//package com.mapplus.maps 
