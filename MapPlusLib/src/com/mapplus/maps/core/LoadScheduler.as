//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;

    public final class LoadScheduler extends EventDispatcher {

        private static const MAX_SIMULTANEOUS_REQUESTS_PER_DOMAIN:int = 4;

        var domainQueues:Object;

        public function LoadScheduler(){
            super();
            this.domainQueues = {};
        }
        private function onQueueEmpty(param1:LoadingQueue):void{
            delete this.domainQueues[param1.getDomain()];
        }
        public function start():void{
            var _loc_1:LoadingQueue;
            for each (_loc_1 in this.domainQueues) {
                _loc_1.start();
            };
        }
        public function completed(param1:ILoaderInfo):void{
            var _loc_2:LoadingQueue;
            _loc_2 = this.domainQueues[param1.domain];
            _loc_2.completed(param1);
            dispatchEvent(new Event(Event.COMPLETE));
        }
        public function clear():void{
            var _loc_1:LoadingQueue;
            for each (_loc_1 in this.domainQueues) {
                _loc_1.clear();
            };
        }
        public function queue(param1:ILoaderInfo):void{
            var _loc_2:String;
            var _loc_3:LoadingQueue;
            _loc_2 = param1.domain;
            _loc_3 = this.domainQueues[_loc_2];
            if (!(_loc_3)){
                _loc_3 = new LoadingQueue(_loc_2, MAX_SIMULTANEOUS_REQUESTS_PER_DOMAIN);
                _loc_3.setEmptyCallback(this.onQueueEmpty);
                this.domainQueues[_loc_2] = _loc_3;
            };
            _loc_3.insert(param1);
        }

    }
}//package com.mapplus.maps.core 
