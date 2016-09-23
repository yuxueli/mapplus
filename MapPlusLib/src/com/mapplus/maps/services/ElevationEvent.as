//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;
    import flash.events.*;

    public final class ElevationEvent extends MapEvent {

        public static const ELEVATION_FAILURE:String = "elevationfailure";
        public static const ELEVATION_SUCCESS:String = "elevationsuccess";

        private var eventElevations:Array;
        public var status:int;

        public function ElevationEvent(param1:String, param2:int, param3:Array, param4:Boolean=false, param5:Boolean=false){
            super(param1, null, param4, param5);
            this.status = param2;
            this.eventElevations = param3;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):ElevationEvent{
            var _loc_3:ElevationEvent;
            var _loc_4:Object;
            var _loc_5:Array;
            _loc_3 = (event as ElevationEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_4 = Object(event);
            _loc_5 = Wrapper.instance().wrapElevationResponseArray(_loc_4.elevations);
            _loc_3 = new ElevationEvent(event.type, _loc_4.status, _loc_5, event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        public function get elevations():Array{
            return (this.eventElevations);
        }
        override public function clone():Event{
            return ((crossDomainEvent) ? fromCrossDomainEvent(crossDomainEvent.clone(), null) : new ElevationEvent(type, this.status, this.elevations, bubbles, cancelable));
        }
        override public function get eventClassChain():Array{
            return (["ElevationEvent", "MapEvent"]);
        }

    }
}//package com.mapplus.maps.services 
