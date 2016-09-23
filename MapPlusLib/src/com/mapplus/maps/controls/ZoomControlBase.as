//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.wrappers.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class ZoomControlBase extends IWrappableSpriteWrapper implements IScrollTrackListener {

        static const ZOOM_OUT_BUTTON_HINT_ID:String = "zoom_out";
        static const ZOOM_IN_BUTTON_HINT_ID:String = "zoom_in";
        private static const CONTINUOUS_ZOOM_FRACTIONS:Number = 4;
        static const SCROLL_BUTTON_HINT_ID:String = "drag";

        private var container:Sprite;
        protected var zoomOutButton:ButtonBase;
        protected var buttonsContainer:Sprite;
        private var buttons:Array;
        private var currentHint:String;
        protected var zoomInButton:ButtonBase;
        protected var map:IControllableMap;
        private var scrollTrack:ScrollTrackBase;

        public function ZoomControlBase(){
            super();
            this.buttons = [];
        }
        protected function hasScrollTrack():Boolean{
            return true;
        }
        protected function getButtonSpacing():Point{
            return (new Point(0, 0));
        }
        protected function setControlPositions():void{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            if (this.scrollTrack){
                this.scrollTrack.minZoomLevel = this.getMinZoomLevel();
                this.scrollTrack.maxZoomLevel = this.getMaxZoomLevel();
                this.scrollTrack.zoomLevel = this.getZoomLevel();
            };
            _loc_1 = Math.max(this.zoomInButton.width, this.zoomOutButton.width);
            if (this.scrollTrack){
                _loc_1 = Math.max(_loc_1, this.scrollTrack.width);
            };
            _loc_2 = this.getButtonSpacing();
            this.zoomInButton.x = Math.floor(((_loc_1 - this.zoomInButton.width) / 2));
            this.zoomOutButton.x = Math.floor(((_loc_1 - this.zoomOutButton.width) / 2));
            if (this.scrollTrack){
                this.scrollTrack.x = Math.floor(((_loc_1 - this.scrollTrack.width) / 2));
            };
            _loc_3 = 0;
            this.zoomInButton.y = _loc_3;
            _loc_3 = (_loc_3 + (this.zoomInButton.height + _loc_2.y));
            if (this.scrollTrack){
                this.scrollTrack.y = _loc_3;
                _loc_3 = (_loc_3 + (this.scrollTrack.height + _loc_2.y));
            };
            this.zoomOutButton.y = _loc_3;
        }
        private function onDisplayButtonHint(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = this.getButton(event.target);
            _loc_3 = _loc_2.getHintText();
            if (((_loc_3) && (!((this.currentHint == _loc_3))))){
                this.currentHint = _loc_3;
                this.displayHint(this.currentHint);
            };
        }
        protected function onButtonOut(event:Event):void{
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!(this.container)){
                this.container = getSprite();
            };
        }
        protected function onMapZoomChanged(event:Event):void{
            if (this.scrollTrack){
                this.scrollTrack.zoomLevel = this.getZoomLevel();
            };
        }
        public function changeZoomLevel(param1:ScrollTrackBase, param2:Number, param3:Boolean):Number{
            var _loc_4:Number = NaN;
            _loc_4 = Math.round(param2);
            this.map.setZoom(_loc_4, param3);
            return (_loc_4);
        }
        protected function removeFromMap():void{
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            this.map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, this.onMapZoomChanged);
            this.map.removeEventListener(MapZoomEvent.ZOOM_RANGE_CHANGED, this.onMapZoomRangeChanged);
            this.zoomInButton.disableButton();
            this.zoomOutButton.disableButton();
            if (this.scrollTrack){
                this.scrollTrack.setListener(null);
            };
            this.zoomInButton = null;
            this.zoomOutButton = null;
            this.scrollTrack = null;
            if (this.buttonsContainer){
                this.container.removeChild(this.buttonsContainer);
                this.buttonsContainer = null;
            };
        }
        protected function getButton(param1:Object):ButtonBase{
            return ((param1 as ButtonBase));
        }
        public function setMap(param1:IControllableMap):void{
            if (this.map){
                this.removeFromMap();
            };
            this.map = param1;
            if (param1){
                if (this.map.isLoaded()){
                    this.initControl();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
                };
                param1.addEventListener(MapZoomEvent.ZOOM_CHANGED, this.onMapZoomChanged);
                param1.addEventListener(MapZoomEvent.ZOOM_RANGE_CHANGED, this.onMapZoomRangeChanged);
            };
        }
        private function initControl():void{
            if (!(this.map.isLoaded())){
                return;
            };
            this.createControls();
            this.setControlPositions();
        }
        private function onMapReady(event:Event):void{
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            if (this.scrollTrack){
                this.scrollTrack.zoomLevel = this.getZoomLevel();
            };
            this.initControl();
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        protected function getMinZoomLevel():Number{
            return (this.map.getMinZoomLevel());
        }
        protected function createZoomInButton(param1:Sprite):ButtonBase{
            return (null);
        }
        protected function addButton(param1:ButtonBase):void{
            param1.addEventListener(ButtonConstants.EVENT_PRESSED, this.onButtonPressed);
            param1.addEventListener(ButtonConstants.EVENT_RELEASED, this.onButtonReleased);
            param1.addEventListener(ButtonConstants.EVENT_OUT, this.onButtonOut);
            param1.addEventListener(ButtonConstants.EVENT_DISPLAY_HINT, this.onDisplayButtonHint);
            param1.addEventListener(ButtonConstants.EVENT_HIDE_HINT, this.onHideButtonHint);
            this.buttons.push(param1);
        }
        protected function onButtonReleased(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_2 = this.getButton(event.target);
            _loc_3 = this.getZoomLevel();
            _loc_4 = _loc_3;
            if (_loc_2 == this.zoomInButton){
                _loc_4 = Math.min(this.getMaxZoomLevel(), Math.floor((_loc_3 + 1)));
            } else {
                if (_loc_2 == this.zoomOutButton){
                    _loc_4 = Math.max(this.getMinZoomLevel(), Math.ceil((_loc_3 - 1)));
                };
            };
            if (_loc_3 != _loc_4){
                this.map.setZoom(_loc_4, true);
            };
        }
        protected function createControls():void{
            var _loc_1:Sprite;
            if (!(this.buttonsContainer)){
                this.buttonsContainer = Bootstrap.createChildSprite(this.container);
            };
            if (!(this.zoomInButton)){
                this.zoomInButton = this.createZoomInButton(Bootstrap.createChildSprite(this.buttonsContainer));
                this.zoomInButton.setHintText(this.map.loadResourceString(ZOOM_IN_BUTTON_HINT_ID));
                this.addButton(this.zoomInButton);
            };
            if (!(this.zoomOutButton)){
                this.zoomOutButton = this.createZoomOutButton(Bootstrap.createChildSprite(this.buttonsContainer));
                this.zoomOutButton.setHintText(this.map.loadResourceString(ZOOM_OUT_BUTTON_HINT_ID));
                this.addButton(this.zoomOutButton);
                this.buttons.push(this.zoomOutButton);
            };
			//疑问代码 原：
			if (hasScrollTrack() && !scrollTrack)//if (!hasScrollTrack() && !scrollTrack)
			{
                _loc_1 = Bootstrap.createChildSprite(this.buttonsContainer);
                this.scrollTrack = this.createScrollTrack(_loc_1);//？
                this.scrollTrack.setHintText(this.map.loadResourceString(SCROLL_BUTTON_HINT_ID));
                this.scrollTrack.setListener(this);
            }
			//疑问代码 原：if (!hasScrollTrack() && scrollTrack)
			if (!hasScrollTrack() && scrollTrack)//if (hasScrollTrack() && scrollTrack)
			{
                this.buttonsContainer.removeChild(this.scrollTrack.mc);
                this.scrollTrack = null;
            };
        }
        protected function getZoomLevel():Number{
            return (this.map.getZoom());
        }
        private function onMapZoomRangeChanged(event:Event):void{
            this.initControl();
        }
        protected function createScrollTrack(param1:Sprite):ScrollTrackBase{
            return (null);
        }
        public function displayHint(param1:String):void{
            this.map.displayHint(param1);
        }
        protected function getMaxZoomLevel():Number{
            return (this.map.getMaxZoomLevel());
        }
        protected function createZoomOutButton(param1:Sprite):ButtonBase{
            return (null);
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }
        public function getSize():Point{
            return ((this.buttonsContainer) ? new Point(this.buttonsContainer.width, this.buttonsContainer.height) : new Point(0, 0));
        }
        protected function onButtonPressed(event:Event):void{
        }
        private function onHideButtonHint(event:Event):void{
            var _loc_2:ButtonBase;
            _loc_2 = this.getButton(event.target);
            if (this.currentHint == _loc_2.getHintText()){
                this.currentHint = null;
                this.displayHint(undefined);
            };
        }

    }
}//package com.mapplus.maps.controls 
