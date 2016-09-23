//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.interfaces.*;

    public class IGroundOverlayWrapper extends IOverlayWrapper implements IGroundOverlay {

        public function IGroundOverlayWrapper(){
            super();
        }
        public function hide():void{
            Wrapper.checkValid(this.instance);
            this.instance.hide();
        }
        public function show():void{
            Wrapper.checkValid(this.instance);
            this.instance.show();
        }
        public function getOptions():GroundOverlayOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapGroundOverlayOptions(this.instance.getOptions()));
        }
        public function isHidden():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isHidden());
        }
        override public function get interfaceChain():Array{
            return (["IGroundOverlay", "IOverlay"]);
        }
        public function setOptions(param1:GroundOverlayOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setOptions(this.extWrapper.wrapGroundOverlayOptions(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
