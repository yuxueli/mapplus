//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IMapTypeControlWrapper extends IControlWrapper implements IMapTypeControl {

        public function IMapTypeControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IMapTypeControl", "IControl"]);
        }

    }
}//package com.mapplus.maps.wrappers 
