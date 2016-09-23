//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.events.*;

    public class GroundOverlay extends IGroundOverlayWrapper implements IGroundOverlay, IEventDispatcher {

        public function GroundOverlay(param1:DisplayObject, param2:LatLngBounds, param3:GroundOverlayOptions=null){
            super();
            var _loc_4:ClientBootstrap;
            var _loc_5:IMapsFactory;
            _loc_4 = ClientBootstrap.getInstance();
            _loc_5 = _loc_4.getMapsFactory();
            Wrapper.instance().wrap(_loc_5.createGroundOverlay(param1, param2, param3), this, IGroundOverlay, GroundOverlay);
        }
        override public function set pane(param1:IPane):void{
        }
        override public function get pane():IPane{
            return (super.pane);
        }
        public function getDisplayObject():DisplayObject{
            return (this.foreground);
        }

    }
}//package com.mapplus.maps.overlays 
