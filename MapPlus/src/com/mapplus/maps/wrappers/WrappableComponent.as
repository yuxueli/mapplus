//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import mx.managers.*;
    import mx.core.*;

    public class WrappableComponent extends UIComponent implements IMapFocusableComponent, IFocusManagerComponent {

        protected var instance:Object;
        private var baseEventDispatcher:BaseEventDispatcher;
        private var isFocusable:Boolean;
        private var listenerCache:WrappedListenerCache;
        protected var extWrapper:Object;

        public function WrappableComponent(){
            super();
            initializeEventDispatcher();
            isFocusable = true;
            focusable = false;
        }
        public function grabFocus():void{
            if (focusManager){
                focusManager.setFocus(this);
                focusManager.showFocus();
                return;
            };
            try {
                if (stage){
                    stage.focus = this;
                };
            } catch(ex:Error) {
            };
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
        public function get interfaceChain():Array{
            return (["IMapFocusableComponent", "IWrappableSprite", "IWrappableEventDispatcher", "IEventDispatcher", "IWrappable"]);
        }
        public function releaseFocus():void{
            if (!(hasFocus())){
                return;
            };
            if (focusManager){
                focusManager.hideFocus();
                return;
            };
            try {
                if (stage){
                    stage.focus = null;
                };
            } catch(ex:Error) {
            };
        }
        public function get wrapper():Object{
            return (this.instance);
        }
        public function hasFocus():Boolean{
            if (focusManager){
                return ((focusManager.getFocus() == this));
            };
            if (stage){
                return ((stage.focus == this));
            };
            return (false);
        }
        public function getBaseEventDispatcher():Object{
            return (this.baseEventDispatcher);
        }
        protected function onAttached():void{
        }
        public function set wrapper(param1:Object):void{
            if (this.instance == null){
                this.instance = param1;
                this.onAttached();
            };
        }
        public function set focusable(param1:Boolean):void{
            tabEnabled = param1;
            focusEnabled = param1;
            mouseFocusEnabled = param1;
            isFocusable = param1;
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
        public function get focusable():Boolean{
            return (isFocusable);
        }
        public function getSprite():Sprite{
            return (this);
        }

    }
}//package com.mapplus.maps.wrappers 
