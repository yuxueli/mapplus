//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;

    public dynamic class Placemark {

        public var point:LatLng;
        public var address:String;
        public var addressDetails:Object;

        public function Placemark(){
            super();
        }
        public static function fromObject(param1:Object):Placemark{
            var _loc_2:Placemark;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (Placemark)();
            _loc_2.point = LatLng.fromObject(param1.point);
            _loc_2.address = (param1.address as String);
            _loc_2.addressDetails = param1.addressDetails;
            Wrapper.copyObject(_loc_2, param1);
            return (_loc_2);
        }

        public function toString():String{
            return (((address + " @") + point.toString()));
        }

    }
}//package com.mapplus.maps.services 
