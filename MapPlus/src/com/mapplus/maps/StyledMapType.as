//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public class StyledMapType extends IStyledMapTypeWrapper implements IStyledMapType, IEventDispatcher {

        public function StyledMapType(param1:Array, param2:StyledMapTypeOptions=null){
            super();
            var _loc_3:ClientBootstrap;
            var _loc_4:IMapsFactory;
            _loc_3 = ClientBootstrap.getInstance();
            _loc_4 = _loc_3.getMapsFactory();
            Wrapper.instance().wrap(_loc_4.createStyledMapType(param1, param2), this, IStyledMapType, StyledMapType);
        }
    }
}//package com.mapplus.maps 
