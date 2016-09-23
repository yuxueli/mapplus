//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import flash.events.*;

    public final class MaxZoomEvent extends MapEvent {

        public static const MAXZOOM_FAILURE:String = "maxzoomfailure";
        public static const MAXZOOM_SUCCESS:String = "maxzoomsuccess";

        private var eventLatLng:LatLng;
        private var eventZoom:Number;

        public function MaxZoomEvent(param1:String, param2:LatLng, param3:Number, param4:Boolean=false, param5:Boolean=false){
            super(param1, null, param4, param5);
            eventLatLng = param2;
            eventZoom = param3;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):MaxZoomEvent{
            var _loc_3:MaxZoomEvent;
            var _loc_4:Object;
            var _loc_5:LatLng;
            _loc_3 = (event as MaxZoomEvent);
            if (_loc_3 != null){
            };
            if (param2 == _loc_3.target){
                return (_loc_3);
            };
            _loc_4 = Object(event).latLng;
            _loc_5 = new LatLng(_loc_4.lat(), _loc_4.lng());
            _loc_3 = new MaxZoomEvent(event.type, _loc_5, Object(event).zoom, event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        public function get zoom():Number{
            return (eventZoom);
        }
        override public function clone():Event{
            return ((crossDomainEvent) ? fromCrossDomainEvent(crossDomainEvent.clone(), null) : new MaxZoomEvent(type, latLng, zoom, bubbles, cancelable));
        }
        public function get latLng():LatLng{
            return (eventLatLng);
        }
        override public function get eventClassChain():Array{
            return (["MaxZoomEvent", "MapEvent"]);
        }
        override public function toString():String{
            return ((((((((((("[MaxZoomEvent type=" + type) + " latLng=") + latLng) + " zoom=") + zoom) + " bubbles=") + bubbles) + " cancelable=") + cancelable) + "]"));
        }

    }
}//package com.mapplus.maps.services 
