//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.events.*;
    import com.mapplus.maps.interfaces.*;

    public class EventDispatcherWrapper extends WrapperBase implements IWrappableEventDispatcher {

        private var listenerCache:WrappedListenerCache;
        private var baseEventDispatcher:Object;

        public function EventDispatcherWrapper(){
            super();
        }
        public function dispatchEvent(event:Event):Boolean{
            return (baseEventDispatcher.dispatchEvent(event));
        }
        override protected function onAttached():void{
            super.onAttached();
            initializeEventDispatcher(this.instance);
        }
        override protected function clearWrapper():void{
            this.listenerCache.clearEventCache();
            super.clearWrapper();
        }
        public function removeEventListener(param1:String, param2:Function, param3:Boolean=false):void{
            listenerCache.removeEventListener(param1, param2, param3);
        }
        public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false):void{
            listenerCache.addEventListener(param1, param2, param3, param4, param5);
        }
        public function willTrigger(param1:String):Boolean{
            return (baseEventDispatcher.willTrigger(param1));
        }
        public function initializeEventDispatcher(param1:Object):void{
            var _loc_2:Object;
            var _loc_3:BaseEventDispatcher;
            if (this.listenerCache != null){
                return;
            };
            _loc_2 = param1;
            if (param1.hasOwnProperty("getBaseEventDispatcher")){
                _loc_2 = param1.getBaseEventDispatcher();
            };
            _loc_3 = new BaseEventDispatcher();
            _loc_3.addListenerMethod = _loc_2.addEventListener;
            _loc_3.removeListenerMethod = _loc_2.removeEventListener;
            _loc_3.willTriggerMethod = _loc_2.willTrigger;
            _loc_3.hasListenerMethod = _loc_2.hasEventListener;
            _loc_3.dispatchMethod = _loc_2.dispatchEvent;
            this.listenerCache = new WrappedListenerCache(this, _loc_3);
            this.baseEventDispatcher = _loc_2;
        }
        public function getBaseEventDispatcher():Object{
            return (this.baseEventDispatcher);
        }
        public function hasEventListener(param1:String):Boolean{
            return (baseEventDispatcher.hasEventListener(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
