//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.events.*;

    public class MapZoomEvent extends MapEvent {

        public static const ZOOM_CHANGED:String = "mapevent_zoomchanged";
        public static const CONTINUOUS_ZOOM_START:String = "mapevent_continuouszoomstart";
        public static const CONTINUOUS_ZOOM_STEP:String = "mapevent_continuouszoomstep";
        public static const ZOOM_RANGE_CHANGED:String = "mapevent_zoomrangechanged";
        public static const CONTINUOUS_ZOOM_END:String = "mapevent_continuouszoomend";
        public static const ZOOM_END:String = "mapevent_zoomend";
        public static const ZOOM_START:String = "mapevent_zoomstart";
        public static const ZOOM_STEP:String = "mapevent_zoomstep";

        private var eventZoomLevel:Number;

        public function MapZoomEvent(param1:String, param2:Number, param3:Boolean=false, param4:Boolean=false){
            super(param1, null, param3, param4);
            this.eventZoomLevel = param2;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):MapZoomEvent{
            var _loc_3:MapZoomEvent;
            _loc_3 = (event as MapZoomEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_3 = new MapZoomEvent(event.type, Object(event).zoomLevel, event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }

        public function get zoomLevel():Number{
            return (this.eventZoomLevel);
        }
        override public function get eventClassChain():Array{
            return (["MapZoomEvent", "MapEvent"]);
        }
        override public function toString():String{
            return ((((((((("[MapZoomEvent type=" + this.type) + " zoomLevel=") + this.zoomLevel) + " bubbles=") + this.bubbles) + " cancellable=") + this.cancelable) + "]"));
        }
        override public function clone():Event{
            return ((this.crossDomainEvent) ? fromCrossDomainEvent(crossDomainEvent.clone(), null) : new MapZoomEvent(this.type, this.zoomLevel, this.bubbles, this.cancelable));
        }

    }
}//package com.mapplus.maps 
