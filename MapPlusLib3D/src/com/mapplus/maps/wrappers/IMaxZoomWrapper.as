//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class IMaxZoomWrapper extends EventDispatcherWrapper implements IMaxZoom {

        public function IMaxZoomWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IMaxZoom"]);
        }
        public function load(param1:LatLng, param2:Number=NaN):void{
            Wrapper.checkValid(this.instance);
            this.instance.load(this.extWrapper.wrapLatLng(param1), param2);
        }

    }
}//package com.mapplus.maps.wrappers 
