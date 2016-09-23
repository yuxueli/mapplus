//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IZoomControlWrapper extends IControlWrapper implements IZoomControl {

        public function IZoomControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IZoomControl", "IControl"]);
        }

    }
}//package com.mapplus.maps.wrappers 
