//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class WrapperBase implements IWrappable {

        protected var extWrapper:Object;
        protected var instance:Object;

        public function WrapperBase(){
            super();
        }
        protected function onAttached():void{
        }
        protected function clearWrapper():void{
            this.extWrapper = null;
            this.instance = null;
        }
        public function get interfaceChain():Array{
            return (null);
        }
        public function set wrapper(param1:Object):void{
            if (this.instance == null){
                this.instance = param1;
                this.onAttached();
            };
        }
        public function get wrapper():Object{
            return (this.instance);
        }
        public function initializeWrapper(param1:Object, param2:Object):void{
            this.extWrapper = param2;
            this.wrapper = param1;
        }

    }
}//package com.mapplus.maps.wrappers 
