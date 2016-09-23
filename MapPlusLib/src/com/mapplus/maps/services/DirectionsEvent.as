//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.*;

    public final class DirectionsEvent extends MapEvent {

        public static const DIRECTIONS_ABORTED:String = "directionsaborted";
        public static const DIRECTIONS_SUCCESS:String = "directionssuccess";
        public static const DIRECTIONS_FAILURE:String = "directionsfailure";

        public var name:String;
        public var status:Number;
        public var request:String;

        public function DirectionsEvent(param1:String, param2:IDirections, param3:Boolean=false, param4:Boolean=false){
            super(param1, param2, param3, param4);
        }
        static function wrapDirections(param1:Object):IDirections{
            return (IDirections(Wrapper.instance().wrap(param1, null, IDirections, null)));
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):DirectionsEvent{
            var _loc_3:DirectionsEvent;
            _loc_3 = (event as DirectionsEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_3 = new DirectionsEvent(event.type, wrapDirections(getEventFeature(event)), event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        public function get directions():IDirections{
            return ((this.feature as IDirections));
        }
        override public function get eventClassChain():Array{
            return (["DirectionsEvent", "MapEvent"]);
        }
        override protected function copyEventData(event:Event, param2:Object):void{
            var _loc_3:Object;
            super.copyEventData(event, param2);
            _loc_3 = Object(event);
            this.name = (_loc_3.name as String);
            this.request = (_loc_3.request as String);
            this.status = (_loc_3.status as Number);
        }

    }
}//package com.mapplus.maps.services 
