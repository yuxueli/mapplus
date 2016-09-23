//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.events.*;

    public class MapMouseEvent extends MapEvent {

        public static const CLICK:String = "mapevent_click";
        public static const MOUSE_MOVE:String = "mapevent_mousemove";
        public static const ROLL_OUT:String = "mapevent_rollout";
        public static const DRAG_END:String = "mapevent_dragend";
        public static const MOUSE_UP:String = "mapevent_mouseup";
        public static const DRAG_START:String = "mapevent_dragstart";
        public static const DOUBLE_CLICK:String = "mapevent_doubleclick";
        public static const MOUSE_DOWN:String = "mapevent_mousedown";
        public static const ROLL_OVER:String = "mapevent_rollover";
        public static const DRAG_STEP:String = "mapevent_dragstep";

        private var eventLatLng:LatLng;
        private var eventAltKey:Boolean;
        private var eventShiftKey:Boolean;
        private var eventCtrlKey:Boolean;

        public function MapMouseEvent(param1:String, param2:Object, param3:LatLng, param4:Boolean=false, param5:Boolean=false, param6:Boolean=false, param7:Boolean=false, param8:Boolean=false){
            super(param1, param2, param4, param5);
            this.eventLatLng = param3;
            this.eventCtrlKey = param6;
            this.eventAltKey = param7;
            this.eventShiftKey = param8;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):MapMouseEvent{
            var _loc_3:MapMouseEvent;
            var _loc_4:Object;
            var _loc_5:Boolean;
            var _loc_6:Boolean;
            var _loc_7:Boolean;
            _loc_3 = (event as MapMouseEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_4 = Object(event);
            _loc_5 = MapUtil.getBooleanOrDefault(_loc_4, "ctrlKey");
            _loc_6 = MapUtil.getBooleanOrDefault(_loc_4, "altKey");
            _loc_7 = MapUtil.getBooleanOrDefault(_loc_4, "shiftKey");
            _loc_3 = new MapMouseEvent(event.type, wrapFeature(_loc_4.feature), LatLng.fromObject(_loc_4.latLng), event.bubbles, event.cancelable, _loc_5, _loc_6, _loc_7);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }
        public static function createFromMouseEvent(event:MouseEvent, param2:String, param3:Object, param4:LatLng, param5:Boolean=false, param6:Boolean=false):MapMouseEvent{
            if (event){
                return (new MapMouseEvent(param2, param3, param4, param5, param6, event.ctrlKey, event.altKey, event.shiftKey));
            };
            return (new MapMouseEvent(param2, param3, param4, param5, param6));
        }

        public function set shiftKey(param1:Boolean):void{
            this.eventShiftKey = param1;
        }
        override public function get eventClassChain():Array{
            return (["MapMouseEvent", "MapEvent"]);
        }
        override public function clone():Event{
            return ((this.crossDomainEvent) ? fromCrossDomainEvent(crossDomainEvent.clone(), null) : new MapMouseEvent(this.type, this.feature, this.latLng, this.bubbles, this.cancelable, this.ctrlKey, this.altKey, this.shiftKey));
        }
        public function get latLng():LatLng{
            return (this.eventLatLng);
        }
        public function set ctrlKey(param1:Boolean):void{
            this.eventCtrlKey = param1;
        }
        public function set altKey(param1:Boolean):void{
            this.eventAltKey = param1;
        }
        public function get ctrlKey():Boolean{
            return (this.eventCtrlKey);
        }
        public function get altKey():Boolean{
            return (this.eventAltKey);
        }
        override public function toString():String{
            return ((((((((((((((((("[MapMouseEvent type=" + this.type) + " feature=") + this.feature) + " latLng=") + this.latLng) + " bubbles=") + this.bubbles) + " cancellable=") + this.cancelable) + " ctrlKey=") + this.ctrlKey) + " altKey=") + this.altKey) + " shiftKey=") + this.shiftKey) + "]"));
        }
        public function get shiftKey():Boolean{
            return (this.eventShiftKey);
        }

    }
}//package com.mapplus.maps 
