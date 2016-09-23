//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public final class Directions extends IDirectionsWrapper implements IDirections, IEventDispatcher {

        public function Directions(param1:DirectionsOptions=null){
            super();
            var _loc_2:ClientBootstrap;
            var _loc_3:IMapsFactory;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_3 = _loc_2.getMapsFactory();
            Wrapper.instance().wrap(_loc_3.createDirections(param1), this, IDirections, Directions);
        }
        private static function waypointToString(param1:Object):String{
            var _loc_2:LatLng;
            var _loc_3:Placemark;
            if ((param1 is String)){
                return ((param1 as String));
            };
            if ((param1 is LatLng)){
                _loc_2 = (param1 as LatLng);
                return (_loc_2.toUrlValue());
            };
            if ((param1 is Placemark)){
                _loc_3 = (param1 as Placemark);
                return (((_loc_3.address + " @") + _loc_3.point.toUrlValue()));
            };
            return ("");
        }

        public function loadFromWaypoints(param1:Array):void{
            var _loc_2:String;
            var _loc_3:uint;
            _loc_2 = "";
            if (param1.length >= 2){
                _loc_2 = ("from:" + waypointToString(param1[0]));
                _loc_3 = 1;
                while (_loc_3 < param1.length) {
                    _loc_2 = (_loc_2 + (" to:" + waypointToString(param1[_loc_3])));
                    _loc_3 = (_loc_3 + 1);
                };
            };
            this.load(_loc_2);
        }

    }
}//package com.mapplus.maps.services 
