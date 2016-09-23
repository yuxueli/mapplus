//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;

    public class ElevationResponse {

        public var location:LatLng;
        public var elevation:Number;

        public function ElevationResponse(param1:LatLng, param2:Number){
            super();
            this.location = param1;
            this.elevation = param2;
        }
        public static function fromObject(param1:Object):ElevationResponse{
            if (param1 == null){
                return (null);
            };
            return (new ElevationResponse(LatLng.fromObject(param1.location), param1.elevation));
        }

    }
}//package com.mapplus.maps.services 
