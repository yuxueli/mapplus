//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.events.*;
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.interfaces.*;

    public class MapEvent extends Event {

        public static const OVERLAY_CHANGED:String = "mapevent_overlaychanged";
        public static const MAP_INITIALIZE_FAILED:String = "mapevent_mapinitializefailed";
        public static const MAP_PREINITIALIZE:String = "mapevent_mappreinitialize";
        public static const OVERLAY_ADDED:String = "mapevent_overlayadded";
        public static const TILES_LOADED:String = "mapevent_tilesloaded";
        public static const INFOWINDOW_OPENED:String = "mapevent_infowindowopened";
        public static const INFOWINDOW_CLOSED:String = "mapevent_infowindowclosed";
        public static const OVERLAY_REMOVED:String = "mapevent_overlayremoved";
        public static const OVERLAY_ANIMATE_END:String = "mapevent_overlayanimateend";
        public static const CONTROL_REMOVED:String = "mapevent_controlremoved";
        public static const MAP_READY:String = "mapevent_mapready";
        public static const OVERLAY_MOVED:String = "mapevent_overlaymoved";
        public static const DISPLAY_MESSAGE:String = "mapevent_displaymessage";
        public static const MAPTYPE_CHANGED:String = "maptypechanged";
        public static const COMPONENT_INITIALIZED:String = "mapevent_componentinitialized";
        public static const SIZE_CHANGED:String = "mapevent_sizechanged";
        public static const MAPTYPE_ADDED:String = "mapevent_maptypeadded";
        public static const MAP_READY_INTERNAL:String = "readyinternal";
        public static const MAPTYPE_STYLE_CHANGED:String = "mapevent_maptypestylechanged";
        public static const CONTROL_ADDED:String = "mapevent_controladded";
        public static const FLY_TO_DONE:String = "mapevent_flytodone";
        public static const TILES_LOADED_PENDING:String = "mapevent_tilesloadedpending";
        public static const VISIBILITY_CHANGED:String = "mapevent_visibilitychanged";
        public static const COPYRIGHTS_UPDATED:String = "mapevent_copyrightsupdated";
        public static const FLY_TO_CANCELED:String = "mapevent_flytocanceled";
        public static const INFOWINDOW_CLOSING:String = "mapevent_infowindowclosing";
        public static const OVERLAY_BEFORE_REMOVED:String = "mapevent_overlaybeforeremoved";
        public static const MAPTYPE_REMOVED:String = "mapevent_maptyperemoved";

        protected var crossDomainEvent:Event;
        private var localTarget:Object;
        private var eventFeature:Object;

        public function MapEvent(param1:String, param2:Object, param3:Boolean=false, param4:Boolean=false){
            super(param1, param3, param4);
            this.eventFeature = param2;
        }
        public static function fromCrossDomainEvent(event:Event, param2:Object):MapEvent{
            var _loc_3:MapEvent;
            _loc_3 = (event as MapEvent);
            if (((!((_loc_3 == null))) && ((param2 == _loc_3.target)))){
                return (_loc_3);
            };
            _loc_3 = new MapEvent(event.type, wrapFeature(getEventFeature(event)), event.bubbles, event.cancelable);
            _loc_3.copyEventData(event, param2);
            return (_loc_3);
        }
        static function wrapFeature(param1:Object):Object{
            return ((!((param1 == null))) ? Wrapper.instance().wrap(param1, null, IWrappable, Object) : null);
        }
        public static function getEventFeature(event:Event):Object{
            return (Object(event).feature);
        }

        override public function isDefaultPrevented():Boolean{
            return ((this.crossDomainEvent) ? this.crossDomainEvent.isDefaultPrevented() : super.isDefaultPrevented());
        }
        override public function get eventPhase():uint{
            return ((this.crossDomainEvent) ? this.crossDomainEvent.eventPhase : super.eventPhase);
        }
        override public function formatToString(param1:String, ... _args):String{
            return ((this.crossDomainEvent) ? this.crossDomainEvent.formatToString(param1, _args) : super.formatToString(param1, _args));
        }
        override public function preventDefault():void{
            if (this.crossDomainEvent){
                this.crossDomainEvent.preventDefault();
            } else {
                super.preventDefault();
            };
        }
        override public function get target():Object{
            return (this.currentTarget);
        }
        override public function get cancelable():Boolean{
            return ((this.crossDomainEvent) ? this.crossDomainEvent.cancelable : super.cancelable);
        }
        override public function clone():Event{
            return ((this.crossDomainEvent) ? fromCrossDomainEvent(this.crossDomainEvent.clone(), null) : new MapEvent(this.type, this.feature, this.bubbles, this.cancelable));
        }
        public function get eventClassChain():Array{
            return (["MapEvent"]);
        }
        override public function get bubbles():Boolean{
            return ((this.crossDomainEvent) ? this.crossDomainEvent.bubbles : super.bubbles);
        }
        override public function stopPropagation():void{
            if (this.crossDomainEvent){
                this.crossDomainEvent.stopPropagation();
            } else {
                super.stopPropagation();
            };
        }
        override public function toString():String{
            return ((((((((("[MapEvent type=" + this.type) + " feature=") + this.feature) + " bubbles=") + this.bubbles) + " cancelable=") + this.cancelable) + "]"));
        }
        protected function copyEventData(event:Event, param2:Object):void{
            this.crossDomainEvent = event;
            this.localTarget = param2;
        }
        override public function get currentTarget():Object{
            return ((this.localTarget) ? this.localTarget : super.target);
        }
        public function get feature():Object{
            return (this.eventFeature);
        }
        override public function get type():String{
            return ((this.crossDomainEvent) ? this.crossDomainEvent.type : super.type);
        }
        override public function stopImmediatePropagation():void{
            if (this.crossDomainEvent){
                this.crossDomainEvent.stopImmediatePropagation();
            } else {
                super.stopImmediatePropagation();
            };
        }

    }
}//package com.mapplus.maps 
