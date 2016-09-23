//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;

    public dynamic class GeocodingResponse {

        public var name:String;
        public var placemarks:Array;

        public function GeocodingResponse(){
            super();
        }
        public static function fromObject(param1:Object):GeocodingResponse{
            var _loc_2:GeocodingResponse;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (GeocodingResponse)();
            _loc_2.name = param1.name;
            _loc_2.placemarks = Wrapper.instance().wrapPlacemarkArray(param1.placemarks);
            Wrapper.copyObject(_loc_2, param1);
            return (_loc_2);
        }

    }
}//package com.mapplus.maps.services 
