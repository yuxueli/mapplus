//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.utils.*;

    public class TimedDoubleClick {

        private static const DOUBLE_CLICK_MS:int = 250;

        private var timerOnFirstClick:int;

        public function TimedDoubleClick(){
            super();
            reset();
        }
        public function reset():void{
            timerOnFirstClick = -1;
        }
        public function clickReturnTrueIfDoubleClick():Boolean{
            var _loc_1:int;
            _loc_1 = getTimer();
            if (((isSet()) && (((_loc_1 - timerOnFirstClick) < DOUBLE_CLICK_MS)))){
                reset();
                return (true);
            };
            timerOnFirstClick = _loc_1;
            return (false);
        }
        public function isSet():Boolean{
            return ((timerOnFirstClick >= 0));
        }

    }
}//package com.mapplus.maps.core 
