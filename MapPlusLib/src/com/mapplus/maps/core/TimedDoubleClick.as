//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.utils.*;

    public class TimedDoubleClick {

        private static const DOUBLE_CLICK_MS:int = 250;

        private var timerOnFirstClick:int;

        public function TimedDoubleClick(){
            super();
            this.reset();
        }
        public function isSet():Boolean{
            return ((this.timerOnFirstClick >= 0));
        }
        public function clickReturnTrueIfDoubleClick():Boolean{
            var _loc_1:int;
            _loc_1 = getTimer();
            if (((this.isSet()) && (((_loc_1 - this.timerOnFirstClick) < DOUBLE_CLICK_MS)))){
                this.reset();
                return (true);
            };
            this.timerOnFirstClick = _loc_1;
            return (false);
        }
        public function reset():void{
            this.timerOnFirstClick = -1;
        }

    }
}//package com.mapplus.maps.core 
