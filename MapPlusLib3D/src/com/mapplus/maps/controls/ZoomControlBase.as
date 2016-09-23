//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;

    public class ZoomControlBase extends IWrappableSpriteWrapper implements IScrollTrackListener {

        static const ZOOM_OUT_BUTTON_HINT_ID:String = "zoom_out";
        static const ZOOM_IN_BUTTON_HINT_ID:String = "zoom_in";
        private static const CONTINUOUS_ZOOM_FRACTIONS:Number = 4;
        static const SCROLL_BUTTON_HINT_ID:String = "drag";

        protected var buttonsContainer:Sprite;
        private var container:Sprite;
        private var buttons:Array;
        protected var zoomOutButton:ButtonBase;
        private var currentHint:String;
        protected var zoomInButton:ButtonBase;
        protected var map:IControllableMap;
        private var scrollTrack:ScrollTrackBase;

        public function ZoomControlBase(){
            super();
            buttons = [];
        }
        public function getDisplayObject():DisplayObject{
            return (container);
        }
        protected function hasScrollTrack():Boolean{
            return (true);
        }
        protected function createZoomInButton(param1:Sprite):ButtonBase{
            return (null);
        }
        protected function getZoomLevel():Number{
            return (map.getZoom());
        }
        protected function onButtonReleased(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_2 = getButton(event.target);
            _loc_3 = getZoomLevel();
            _loc_4 = _loc_3;
            if (_loc_2 == zoomInButton){
                _loc_4 = Math.min(getMaxZoomLevel(), Math.floor((_loc_3 + 1)));
            } else {
                if (_loc_2 == zoomOutButton){
                    _loc_4 = Math.max(getMinZoomLevel(), Math.ceil((_loc_3 - 1)));
                };
            };
            if (_loc_3 != _loc_4){
                map.setZoom(_loc_4, true);
            };
        }
        protected function createControls():void{
            var _loc_1:Sprite;
            if (!buttonsContainer){
                buttonsContainer = Bootstrap.createChildSprite(container);
            };
            if (!zoomInButton){
                zoomInButton = createZoomInButton(Bootstrap.createChildSprite(buttonsContainer));
                zoomInButton.setHintText(map.loadResourceString(ZOOM_IN_BUTTON_HINT_ID));
                addButton(zoomInButton);
            };
            if (!zoomOutButton){
                zoomOutButton = createZoomOutButton(Bootstrap.createChildSprite(buttonsContainer));
                zoomOutButton.setHintText(map.loadResourceString(ZOOM_OUT_BUTTON_HINT_ID));
                addButton(zoomOutButton);
                buttons.push(zoomOutButton);
            };
            if (((hasScrollTrack()) && (!(scrollTrack)))){
                _loc_1 = Bootstrap.createChildSprite(buttonsContainer);
                scrollTrack = createScrollTrack(_loc_1);
                scrollTrack.setHintText(map.loadResourceString(SCROLL_BUTTON_HINT_ID));
                scrollTrack.setListener(this);
            };
            if (((!(hasScrollTrack())) && (scrollTrack))){
                buttonsContainer.removeChild(scrollTrack.mc);
                scrollTrack = null;
            };
        }
        protected function onButtonPressed(event:Event):void{
        }
        protected function setControlPositions():void{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            if (scrollTrack){
                scrollTrack.minZoomLevel = getMinZoomLevel();
                scrollTrack.maxZoomLevel = getMaxZoomLevel();
                scrollTrack.zoomLevel = getZoomLevel();
            };
            _loc_1 = Math.max(zoomInButton.width, zoomOutButton.width);
            if (scrollTrack){
                _loc_1 = Math.max(_loc_1, scrollTrack.width);
            };
            _loc_2 = getButtonSpacing();
            zoomInButton.x = Math.floor(((_loc_1 - zoomInButton.width) / 2));
            zoomOutButton.x = Math.floor(((_loc_1 - zoomOutButton.width) / 2));
            if (scrollTrack){
                scrollTrack.x = Math.floor(((_loc_1 - scrollTrack.width) / 2));
            };
            _loc_3 = 0;
            zoomInButton.y = _loc_3;
            _loc_3 = (_loc_3 + (zoomInButton.height + _loc_2.y));
            if (scrollTrack){
                scrollTrack.y = _loc_3;
                _loc_3 = (_loc_3 + (scrollTrack.height + _loc_2.y));
            };
            zoomOutButton.y = _loc_3;
        }
        private function onDisplayButtonHint(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = getButton(event.target);
            _loc_3 = _loc_2.getHintText();
            if (((_loc_3) && (!((currentHint == _loc_3))))){
                currentHint = _loc_3;
                displayHint(currentHint);
            };
        }
        protected function onButtonOut(event:Event):void{
        }
        private function onMapZoomRangeChanged(event:Event):void{
            initControl();
        }
        public function changeZoomLevel(param1:ScrollTrackBase, param2:Number, param3:Boolean):Number{
            var _loc_4:Number = NaN;
            _loc_4 = Math.round(param2);
            map.setZoom(_loc_4, param3);
            return (_loc_4);
        }
        protected function createScrollTrack(param1:Sprite):ScrollTrackBase{
            return (null);
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!container){
                container = getSprite();
            };
        }
        protected function onMapZoomChanged(event:Event):void{
            if (scrollTrack){
                scrollTrack.zoomLevel = getZoomLevel();
            };
        }
        private function onMapReady(event:Event):void{
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            if (scrollTrack){
                scrollTrack.zoomLevel = getZoomLevel();
            };
            initControl();
        }
        private function onHideButtonHint(event:Event):void{
            var _loc_2:ButtonBase;
            _loc_2 = getButton(event.target);
            if (currentHint == _loc_2.getHintText()){
                currentHint = null;
                displayHint(undefined);
            };
        }
        public function setMap(param1:IControllableMap):void{
            if (this.map){
                removeFromMap();
            };
            this.map = param1;
            if (param1){
                if (this.map.isLoaded()){
                    initControl();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
                };
                param1.addEventListener(MapZoomEvent.ZOOM_CHANGED, onMapZoomChanged);
                param1.addEventListener(MapZoomEvent.ZOOM_RANGE_CHANGED, onMapZoomRangeChanged);
            };
        }
        private function initControl():void{
            if (!map.isLoaded()){
                return;
            };
            createControls();
            setControlPositions();
        }
        protected function removeFromMap():void{
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, onMapZoomChanged);
            map.removeEventListener(MapZoomEvent.ZOOM_RANGE_CHANGED, onMapZoomRangeChanged);
            zoomInButton.disableButton();
            zoomOutButton.disableButton();
            if (scrollTrack){
                scrollTrack.setListener(null);
            };
            zoomInButton = null;
            zoomOutButton = null;
            scrollTrack = null;
            if (buttonsContainer){
                container.removeChild(buttonsContainer);
                buttonsContainer = null;
            };
        }
        protected function getButton(param1:Object):ButtonBase{
            return ((param1 as ButtonBase));
        }
        public function displayHint(param1:String):void{
            map.displayHint(param1);
        }
        protected function createZoomOutButton(param1:Sprite):ButtonBase{
            return (null);
        }
        protected function getMaxZoomLevel():Number{
            return (map.getMaxZoomLevel());
        }
        protected function getMinZoomLevel():Number{
            return (map.getMinZoomLevel());
        }
        public function getSize():Point{
            return ((buttonsContainer) ? new Point(buttonsContainer.width, buttonsContainer.height) : new Point(0, 0));
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        protected function addButton(param1:ButtonBase):void{
            param1.addEventListener(ButtonConstants.EVENT_PRESSED, onButtonPressed);
            param1.addEventListener(ButtonConstants.EVENT_RELEASED, onButtonReleased);
            param1.addEventListener(ButtonConstants.EVENT_OUT, onButtonOut);
            param1.addEventListener(ButtonConstants.EVENT_DISPLAY_HINT, onDisplayButtonHint);
            param1.addEventListener(ButtonConstants.EVENT_HIDE_HINT, onHideButtonHint);
            buttons.push(param1);
        }
        protected function getButtonSpacing():Point{
            return (new Point(0, 0));
        }

    }
}//package com.mapplus.maps.controls 
