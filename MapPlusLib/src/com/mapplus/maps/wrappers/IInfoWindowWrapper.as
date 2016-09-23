//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IInfoWindowWrapper extends IOverlayWrapper implements IInfoWindow {

        public function IInfoWindowWrapper(){
            super();
        }
        public function isHidden():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isHidden());
        }
        public function show():void{
            Wrapper.checkValid(this.instance);
            this.instance.show();
        }
        override public function get interfaceChain():Array{
            return (["IInfoWindow", "IOverlay"]);
        }
        public function hide():void{
            Wrapper.checkValid(this.instance);
            this.instance.hide();
        }
        public function get removed():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.removed);
        }

    }
}//package com.mapplus.maps.wrappers 
