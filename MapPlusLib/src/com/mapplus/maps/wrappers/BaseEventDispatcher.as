//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.events.*;

    public class BaseEventDispatcher extends WrapperBase implements IEventDispatcher {

        public var willTriggerMethod:Function;
        public var removeListenerMethod:Function;
        public var hasListenerMethod:Function;
        public var addListenerMethod:Function;
        public var dispatchMethod:Function;

        public function BaseEventDispatcher(){
            super();
        }
        public function dispatchEvent(event:Event):Boolean{
            return (this.dispatchMethod(event));
        }
        public function removeEventListener(param1:String, param2:Function, param3:Boolean=false):void{
            this.removeListenerMethod(param1, param2, param3);
        }
        public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false):void{
            this.addListenerMethod(param1, param2, param3, param4, param5);
        }
        public function willTrigger(param1:String):Boolean{
            return (this.willTriggerMethod(param1));
        }
        public function hasEventListener(param1:String):Boolean{
            return (this.hasListenerMethod(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
