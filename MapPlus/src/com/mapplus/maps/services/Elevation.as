//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public final class Elevation extends IElevationWrapper implements IElevation, IEventDispatcher {

        public function Elevation(){
            super();
            var _loc_1:ClientBootstrap;
            var _loc_2:IMapsFactory;
            _loc_1 = ClientBootstrap.getInstance();
            _loc_2 = _loc_1.getMapsFactory();
            Wrapper.instance().wrap(_loc_2.createElevation(), this, IElevation, Elevation);
        }
    }
}//package com.mapplus.maps.services 
