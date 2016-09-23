//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {

    public class FactualGeocodeCache extends GeocodeCache {

        public function FactualGeocodeCache(){
            super();
        }
        override public function isCachable(param1:Object):Boolean{
            var _loc_2:Number = NaN;
            if (!super.isCachable(param1)){
                return (false);
            };
            _loc_2 = ServiceStatus.GEO_SERVER_ERROR;
            if (((param1[SConstants.PROP_STATUS]) && (param1[SConstants.PROP_STATUS][SConstants.PROP_CODE]))){
                _loc_2 = param1[SConstants.PROP_STATUS][SConstants.PROP_CODE];
            };
            return ((((_loc_2 == ServiceStatus.GEO_SUCCESS)) || ((_loc_2 >= ServiceStatus.GEO_BAD_STATUS_START))));
        }

    }
}//package com.mapplus.maps.services 
