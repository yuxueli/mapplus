//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;

    public class WrappableSprite extends Sprite implements IWrappableSprite {

        private var listenerCache:WrappedListenerCache;
        protected var extWrapper:Object;
        protected var instance:Object;
        private var baseEventDispatcher:BaseEventDispatcher;

        public function WrappableSprite(){
            super();
            this.initializeEventDispatcher();
        }
        public function initializeWrapper(param1:Object, param2:Object):void{
            this.extWrapper = param2;
            this.wrapper = param1;
        }
        public function get interfaceChain():Array{
            return (["IWrappableSprite", "IWrappableEventDispatcher", "IEventDispatcher", "IWrappable"]);
        }
        public function set wrapper(param1:Object):void{
            if (this.instance == null){
                this.instance = param1;
                this.onAttached();
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
        override public function removeEventListener(param1:String, param2:Function, param3:Boolean=false):void{
            if (this.listenerCache != null){
                this.listenerCache.removeEventListener(param1, param2, param3);
            } else {
                super.removeEventListener(param1, param2, param3);
            };
        }
        override public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false):void{
            if (this.listenerCache != null){
                this.listenerCache.addEventListener(param1, param2, param3, param4, param5);
            } else {
                super.addEventListener(param1, param2, param3, param4, param5);
            };
        }
        public function getBaseEventDispatcher():Object{
            return (this.baseEventDispatcher);
        }
        protected function clearWrapper():void{
            this.listenerCache.clearEventCache();
            this.extWrapper = null;
            this.instance = null;
        }
        public function get wrapper():Object{
            return (this.instance);
        }
        public function getSprite():Sprite{
            return (this);
        }
        protected function onAttached():void{
        }

    }
}//package com.mapplus.maps.wrappers 
