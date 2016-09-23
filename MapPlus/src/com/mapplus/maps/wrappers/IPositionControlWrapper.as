//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IPositionControlWrapper extends IControlWrapper implements IPositionControl {

        public function IPositionControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IPositionControl", "IControl"]);
        }

    }
}//package com.mapplus.maps.wrappers 
