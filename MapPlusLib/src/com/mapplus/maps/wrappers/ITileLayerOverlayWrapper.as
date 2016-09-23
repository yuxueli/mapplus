//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class ITileLayerOverlayWrapper extends IOverlayWrapper implements ITileLayerOverlay {

        public function ITileLayerOverlayWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["ITileLayerOverlay", "IOverlay"]);
        }
        public function get projection():IProjection{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIProjection(this.instance.projection));
        }
        public function get tileSize():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.tileSize);
        }
        public function get tileLayer():ITileLayer{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapITileLayer(this.instance.tileLayer));
        }
        public function refresh():void{
            Wrapper.checkValid(this.instance);
            this.instance.refresh();
        }

    }
}//package com.mapplus.maps.wrappers 
