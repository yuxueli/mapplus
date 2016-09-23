//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.utils.*;

    public class DelayHandler {

        private static var instance:DelayHandler = null;

        private var nextFrameList:Array;
        private var timer:Timer;

        public function DelayHandler(){
            super();
            this.timer = new Timer(1);
            this.nextFrameList = [];
            this.timer.addEventListener(TimerEvent.TIMER, timerCallback);
        }
        public static function delayCall(param1:Function):void{
            if (instance == null){
                instance = new (DelayHandler)();
            };
            instance.nextFrameList.push(param1);
            if (!instance.timer.running){
                instance.timer.start();
            };
        }
        public static function release():void{
            var _loc_1:DelayHandler;
            _loc_1 = instance;
            if (((!((_loc_1 == null))) && (!((_loc_1.timer == null))))){
                _loc_1.timer.stop();
                _loc_1.timer.removeEventListener(TimerEvent.TIMER, _loc_1.timerCallback);
            };
            instance = null;
        }

        private function timerCallback(event:Event):void{
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:Function;
            _loc_2 = this.nextFrameList;
            this.nextFrameList = [];
            this.timer.stop();
            _loc_3 = 0;
            while (_loc_3 < _loc_2.length) {
                _loc_4 = _loc_2[_loc_3];
                _loc_4();
                _loc_3++;
            };
        }

    }
}//package com.mapplus.maps.core 
