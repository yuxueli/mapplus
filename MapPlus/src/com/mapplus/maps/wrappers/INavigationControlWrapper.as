//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class INavigationControlWrapper extends IControlWrapper implements INavigationControl {

        public function INavigationControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["INavigationControl", "IControl"]);
        }

    }
}//package com.mapplus.maps.wrappers 
