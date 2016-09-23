//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.events.*;

    public class WrappedListenerCache {

        private var eventDispatcher:IEventDispatcher;
        private var target:Object;
        private var callbackMap:Object;

        public function WrappedListenerCache(param1:Object, param2:IEventDispatcher){
            super();
            this.callbackMap = {};
            this.target = param1;
            this.eventDispatcher = param2;
        }
        public function removeEventListener(param1:String, param2:Function, param3:Boolean=false):void{
            var _loc_4:Array;
            var _loc_5:int;
            if (!(Wrapper.instance().isLibraryEvent(param1))){
                this.eventDispatcher.removeEventListener(param1, param2, param3);
                return;
            };
            _loc_4 = this.callbackMap[param1];
            if (_loc_4){
                _loc_5 = (_loc_4.length - 1);
                while (_loc_5 >= 0) {
                    if ((((param2 == _loc_4[_loc_5].original)) && ((param3 == _loc_4[_loc_5].useCapture)))){
                        this.eventDispatcher.removeEventListener(param1, _loc_4[_loc_5].wrapped, param3);
                        _loc_4.splice(_loc_5, 1);
                        break;
                    };
                    _loc_5 = (_loc_5 - 1);
                };
            };
        }
        public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false):void{
            var _loc_6:Function;
            var _loc_7:Object;
            var _loc_8:Array;
            if (!(Wrapper.instance().isLibraryEvent(param1))){
                this.eventDispatcher.addEventListener(param1, param2, param3, param4, param5);
                return;
            };
            _loc_6 = Wrapper.instance().wrapEventHandler(param2, this.target);
            _loc_7 = {
                original:param2,
                wrapped:_loc_6,
                useCapture:param3
            };
            _loc_8 = this.callbackMap[param1];
            if (_loc_8 != null){
                _loc_8.push(_loc_7);
            } else {
                this.callbackMap[param1] = [_loc_7];
            };
            this.eventDispatcher.addEventListener(param1, _loc_6, param3, param4, param5);
        }
        public function clearEventCache():void{
            var _loc_1:String;
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:Object;
            for (_loc_1 in this.callbackMap) {
                _loc_2 = this.callbackMap[_loc_1];
                _loc_3 = 0;
                while (_loc_3 < _loc_2.length) {
                    _loc_4 = _loc_2[_loc_3];
                    this.eventDispatcher.removeEventListener(_loc_1, _loc_4.wrapped, _loc_4.useCapture);
                    _loc_3++;
                };
            };
            this.callbackMap = {};
        }

    }
}//package com.mapplus.maps.wrappers 
