//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.events.*;

    public class MapMoveEvent extends MapEvent {

        public static const MOVE_STEP:String = "mapevent_movestep";
        public static const MOVE_START:String = "mapevent_movestart";
        public static const MOVE_END:String = "mapevent_moveend";

        private var eventLatLng:LatLng;

        public function MapMoveEvent(param1:String, param2:LatLng, param3:Boolean=false, param4:Boolean=false){
            super(param1, null, param3, param4);
            eventLatLng = param2;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):MapMoveEvent{
            var _loc_3:MapMoveEvent;
            _loc_3 = (event as MapMoveEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_3 = new MapMoveEvent(event.type, LatLng.fromObject(Object(event).latLng), event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        override public function get eventClassChain():Array{
            return (["MapMoveEvent", "MapEvent"]);
        }
        public function get latLng():LatLng{
            return (eventLatLng);
        }
        override public function toString():String{
            return ((((((((("[MapMoveEvent type=" + type) + " latLng=") + latLng) + " bubbles=") + bubbles) + " cancellable=") + cancelable) + "]"));
        }
        override public function clone():Event{
            return ((crossDomainEvent) ? fromCrossDomainEvent(crossDomainEvent.clone(), null) : new MapMoveEvent(type, latLng, bubbles, cancelable));
        }

    }
}//package com.mapplus.maps 
