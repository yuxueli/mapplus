//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.*;

    public final class GeocodingEvent extends MapEvent {

        public static const GEOCODING_FAILURE:String = "geocodingfailure";
        public static const GEOCODING_SUCCESS:String = "geocodingsuccess";

        public var response:GeocodingResponse;
        public var status:Number;
        public var name:String;
        public var request:String;

        public function GeocodingEvent(param1:String, param2:Boolean=false, param3:Boolean=false){
            super(param1, null, param2, param3);
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):GeocodingEvent{
            var _loc_3:GeocodingEvent;
            _loc_3 = (event as GeocodingEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_3 = new GeocodingEvent(event.type, event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        override protected function copyEventData(event:Event, param2:Object):void{
            var _loc_3:Object;
            super.copyEventData(event, param2);
            _loc_3 = Object(event);
            this.name = (_loc_3.name as String);
            this.request = (_loc_3.request as String);
            this.status = (_loc_3.status as Number);
            this.response = Wrapper.instance().wrapGeocodingResponse(_loc_3.response);
        }
        override public function get eventClassChain():Array{
            return (["GeocodingEvent", "MapEvent"]);
        }

    }
}//package com.mapplus.maps.services 
