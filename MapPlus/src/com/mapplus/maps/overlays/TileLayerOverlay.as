//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public class TileLayerOverlay extends ITileLayerOverlayWrapper implements ITileLayerOverlay, IEventDispatcher {

        public function TileLayerOverlay(param1:ITileLayer, param2:int=0x0100, param3:IProjection=null){
            super();
            var _loc_4:ClientBootstrap;
            var _loc_5:IMapsFactory;
            _loc_4 = ClientBootstrap.getInstance();
            _loc_5 = _loc_4.getMapsFactory();
            Wrapper.instance().wrap(_loc_5.createTileLayerOverlay(param1, param2, param3), this, ITileLayerOverlay, TileLayerOverlay);
        }
        override public function set pane(param1:IPane):void{
        }
        override public function get pane():IPane{
            return (super.pane);
        }

    }
}//package com.mapplus.maps.overlays 
