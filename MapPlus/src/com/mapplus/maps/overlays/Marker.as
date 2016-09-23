//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.events.*;

    public class Marker extends IMarkerWrapper implements IMarker, IEventDispatcher {

        public function Marker(latLng:LatLng, options:MarkerOptions=null){
            super();
            var _loc_3:ClientBootstrap;
            var _loc_4:IMapsFactory;
            _loc_3 = ClientBootstrap.getInstance();
            _loc_4 = _loc_3.getMapsFactory();
            Wrapper.instance().wrap(_loc_4.createMarker(latLng, options), this, IMarker, Marker);
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
