//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.events.*;
    import com.mapplus.maps.geom.*;

    public class MapAttitudeEvent extends MapEvent {

        public static const ATTITUDE_CHANGE_END:String = "mapevent_attitudechangeend";
        public static const ATTITUDE_CHANGE_STEP:String = "mapevent_attitudechangestep";
        public static const ATTITUDE_CHANGE_START:String = "mapevent_attitudechangestart";

        private var eventAttitude:Attitude;

        public function MapAttitudeEvent(param1:String, param2:Attitude, param3:Boolean=false, param4:Boolean=false){
            super(param1, null, param3, param4);
            this.eventAttitude = param2;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):MapAttitudeEvent{
            var _loc_3:MapAttitudeEvent;
            _loc_3 = (event as MapAttitudeEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_3 = new MapAttitudeEvent(event.type, Attitude.fromObject(Object(event).attitude), event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        override public function get eventClassChain():Array{
            return (["MapAttitudeEvent", "MapEvent"]);
        }
        public function get attitude():Attitude{
            return (this.eventAttitude);
        }
        override public function toString():String{
            return ((((((((("[MapMoveEvent type=" + this.type) + " attitude=") + this.attitude) + " bubbles=") + this.bubbles) + " cancellable=") + this.cancelable) + "]"));
        }
        override public function clone():Event{
            return ((this.crossDomainEvent) ? fromCrossDomainEvent(crossDomainEvent.clone(), null) : new MapAttitudeEvent(this.type, this.attitude, this.bubbles, this.cancelable));
        }

    }
}//package com.mapplus.maps 
