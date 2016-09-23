//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.events.*;
    import com.mapplus.maps.interfaces.*;

    public class WrappableEventDispatcher extends EventDispatcher implements IWrappableEventDispatcher {

        private var listenerCache:WrappedListenerCache;
        private var baseEventDispatcher:BaseEventDispatcher;
        protected var extWrapper:Object;
        protected var instance:Object;

        public function WrappableEventDispatcher(){
            super();
            initializeEventDispatcher();
        }
        public function getBaseEventDispatcher():Object{
            return (this.baseEventDispatcher);
        }
        public function initializeWrapper(param1:Object, param2:Object):void{
            this.extWrapper = param2;
            this.wrapper = param1;
        }
        protected function clearWrapper():void{
            this.listenerCache.clearEventCache();
            this.extWrapper = null;
            this.instance = null;
        }
        public function get interfaceChain():Array{
            return (["IWrappableEventDispatcher", "IEventDispatcher"]);
        }
        override public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false):void{
            if (this.listenerCache != null){
                this.listenerCache.addEventListener(param1, param2, param3, param4, param5);
            } else {
                super.addEventListener(param1, param2, param3, param4, param5);
            };
        }
        override public function removeEventListener(param1:String, param2:Function, param3:Boolean=false):void{
            if (this.listenerCache != null){
                this.listenerCache.removeEventListener(param1, param2, param3);
            } else {
                super.removeEventListener(param1, param2, param3);
            };
        }
        private function initializeEventDispatcher():void{
            var _loc_1:BaseEventDispatcher;
            _loc_1 = new BaseEventDispatcher();
            _loc_1.addListenerMethod = super.addEventListener;
            _loc_1.removeListenerMethod = super.removeEventListener;
            _loc_1.willTriggerMethod = super.willTrigger;
            _loc_1.hasListenerMethod = super.hasEventListener;
            _loc_1.dispatchMethod = super.dispatchEvent;
            this.listenerCache = new WrappedListenerCache(this, _loc_1);
            this.baseEventDispatcher = _loc_1;
        }
        public function get wrapper():Object{
            return (this.instance);
        }
        protected function onAttached():void{
        }
        public function set wrapper(param1:Object):void{
            if (this.instance == null){
                this.instance = param1;
                this.onAttached();
            };
        }

    }
}//package com.mapplus.maps.wrappers 
