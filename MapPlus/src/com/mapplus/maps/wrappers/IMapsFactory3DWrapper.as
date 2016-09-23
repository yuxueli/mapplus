//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IMapsFactory3DWrapper extends IMapsFactoryWrapper implements IMapsFactory3D {

        public function IMapsFactory3DWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IMapsFactory3D", "IMapsFactory"]);
        }

    }
}//package com.mapplus.maps.wrappers 
