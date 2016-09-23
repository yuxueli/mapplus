//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {

    public final class LoadingQueue {

        private var domain:String;
        private var activeRequests:Array;
        private var maxActiveRequests:int;
        private var isActive:Boolean;
        private var queue:Array;
        private var emptyCallback:Function;

        public function LoadingQueue(param1:String, param2:int){
            super();
            this.domain = param1;
            this.maxActiveRequests = param2;
            this.isActive = false;
            this.activeRequests = [];
            this.queue = [];
        }
        public function start():void{
            this.isActive = true;
            this.scheduleRequests();
        }
        public function toString():String{
            return (this.queue.join(","));
        }
        public function clear():void{
            this.isActive = false;
            this.queue = [];
        }
        public function setEmptyCallback(param1:Function):void{
            this.emptyCallback = param1;
        }
        public function insert(param1:ILoaderInfo):void{
            var _loc_2:int;
            var _loc_3:ILoaderInfo;
            _loc_2 = this.queue.length;
            while (_loc_2 > 0) {
                _loc_3 = this.queue[(_loc_2 - 1)];
                if (param1.priority >= _loc_3.priority){
                    break;
                };
                _loc_2 = (_loc_2 - 1);
            };
            this.queue.splice(_loc_2, 0, param1);
            this.scheduleRequests();
        }
        public function completed(param1:ILoaderInfo):void{
            var _loc_2:int;
            _loc_2 = this.activeRequests.indexOf(param1);
            if (_loc_2 >= 0){
                this.activeRequests.splice(_loc_2, 1);
            };
            this.scheduleRequests();
        }
        private function scheduleRequests():void{
            var _loc_1:ILoaderInfo;
            if (!(this.isActive)){
                return;
            };
            while ((((this.queue.length > 0)) && ((this.activeRequests.length < this.maxActiveRequests)))) {
                _loc_1 = this.queue.shift();
                this.activeRequests.push(_loc_1);
                _loc_1.onScheduled();
            };
            if (this.activeRequests.length == 0){
                this.emptyCallback(this);
            };
        }
        public function getDomain():String{
            return (this.domain);
        }

    }
}//package com.mapplus.maps.core 
