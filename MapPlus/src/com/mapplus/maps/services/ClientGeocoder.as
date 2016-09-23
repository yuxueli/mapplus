//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public final class ClientGeocoder extends IClientGeocoderWrapper implements IClientGeocoder, IEventDispatcher {

        public function ClientGeocoder(param1:ClientGeocoderOptions=null){
            super();
            var _loc_2:ClientBootstrap;
            var _loc_3:IMapsFactory;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_3 = _loc_2.getMapsFactory();
            Wrapper.instance().wrap(_loc_3.createClientGeocoder2(param1), this, IClientGeocoder, ClientGeocoder);
        }
    }
}//package com.mapplus.maps.services 
