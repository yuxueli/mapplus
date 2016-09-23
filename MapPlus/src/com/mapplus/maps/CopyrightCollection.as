//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public class CopyrightCollection extends ICopyrightCollectionWrapper implements ICopyrightCollection, IEventDispatcher {

        public function CopyrightCollection(param1:String=null){
            super();
            var _loc_2:ClientBootstrap;
            var _loc_3:IMapsFactory;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_3 = _loc_2.getMapsFactory();
            Wrapper.instance().wrap(_loc_3.createCopyrightCollection(param1), this, ICopyrightCollection, CopyrightCollection);
        }
    }
}//package com.mapplus.maps 
