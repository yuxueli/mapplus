//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IScaleControlWrapper extends IControlWrapper implements IScaleControl {

        public function IScaleControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IScaleControl", "IControl"]);
        }

    }
}//package com.mapplus.maps.wrappers 
