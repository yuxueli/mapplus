//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class R1Interval {

        public var hi:Number;
        public var lo:Number;

        public function R1Interval(param1:Number, param2:Number){
            super();
            lo = param1;
            hi = param2;
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
            if (param1.lo >= lo){
            };
            return ((param1.hi <= hi));
        }
        public function span():Number{
            return ((isEmpty()) ? 0 : (hi - lo));
        }
        public function contains(param1:Number):Boolean{
            if (param1 >= lo){
            };
            return ((param1 <= hi));
        }
        public function isEmpty():Boolean{
            return ((lo > hi));
        }
        public function intersects(param1:R1Interval):Boolean{
            if (lo <= param1.lo){
                if (param1.lo <= hi){
                };
                return ((param1.lo <= param1.hi));
            };
            if (lo <= param1.hi){
            };
            return ((lo <= hi));
        }
        public function center():Number{
            return (((hi + lo) / 2));
        }
        public function extend(param1:Number):void{
            if (isEmpty()){
                lo = param1;
                hi = param1;
            } else {
                if (param1 < lo){
                    lo = param1;
                } else {
                    if (param1 > hi){
                        hi = param1;
                    };
                };
            };
        }
        public function equals(param1:R1Interval):Boolean{
            if (isEmpty()){
                return (isEmpty());
            };
            return (((Math.abs((param1.lo - lo)) + Math.abs((hi - param1.hi))) <= MapUtil.FLOAT_ERROR_MARGIN));
        }

    }
}//package com.mapplus.maps 
