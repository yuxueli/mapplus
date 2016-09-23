//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class IOverviewMapControlWrapper extends IControlWrapper implements IOverviewMapControl {

        public function IOverviewMapControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IOverviewMapControl", "IControl"]);
        }
        public function setSize(param1:Point):void{
            Wrapper.checkValid(this.instance);
            this.instance.setSize(param1);
        }

    }
}//package com.mapplus.maps.wrappers 
