//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.controls.common.*;
    import flash.events.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.wrappers.*;

    public class MultiButtonControlBase extends IWrappableSpriteWrapper {

        protected var container:Sprite;
        protected var buttonsContainer:Sprite;
        protected var buttons:Array;
        private var currentHint:String;
        protected var map:IControllableMap;

        public function MultiButtonControlBase(){
            super();
        }
        private function onDisplayButtonHint(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = this.getButton(event.target);
            _loc_3 = _loc_2.getHintText();
            if (((!((_loc_3 == null))) && (!((this.currentHint == _loc_3))))){
                this.currentHint = _loc_3;
                this.displayHint(this.currentHint);
            };
        }
        private function onButtonOut(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = this.getButton(event.target);
            _loc_3 = _loc_2.getButtonId();
            this.released(_loc_3);
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!(this.container)){
                this.container = getSprite();
            };
        }
        private function getButton(param1:Object):ButtonBase{
            return ((param1 as ButtonBase));
        }
        protected function pressed(param1:String):void{
        }
        protected function removeFromMap():void{
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            this.container.removeChild(this.buttonsContainer);
            this.buttonsContainer = null;
        }
        public function setMap(param1:IControllableMap):void{
            if (this.map){
                this.removeFromMap();
            };
            this.map = param1;
            if (param1){
                if (param1.isLoaded()){
                    this.initializeControl();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
                };
            };
        }
        private function initializeControl():void{
            if (this.buttonsContainer){
                this.container.removeChild(this.buttonsContainer);
                this.buttonsContainer = null;
            };
            this.buttonsContainer = Bootstrap.createChildSprite(this.container);
            this.buttons = [];
            this.createButtons();
        }
        private function onMapReady(event:Event):void{
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            this.initializeControl();
        }
        protected function action(param1:String):void{
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        protected function createButtonSprite():Sprite{
            return (Bootstrap.createChildSprite(this.buttonsContainer));
        }
        protected function released(param1:String):void{
        }
        protected function addButton(param1:ButtonBase):void{
            param1.addEventListener(ButtonConstants.EVENT_PRESSED, this.onButtonPressed);
            param1.addEventListener(ButtonConstants.EVENT_RELEASED, this.onButtonReleased);
            param1.addEventListener(ButtonConstants.EVENT_OUT, this.onButtonOut);
            param1.addEventListener(ButtonConstants.EVENT_DISPLAY_HINT, this.onDisplayButtonHint);
            param1.addEventListener(ButtonConstants.EVENT_HIDE_HINT, this.onHideButtonHint);
            this.buttons.push(param1);
        }
        private function onButtonReleased(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = this.getButton(event.target);
            _loc_3 = _loc_2.getButtonId();
            this.released(_loc_3);
            this.action(_loc_3);
        }
        protected function createButtons():void{
        }
        private function displayHint(param1:String):void{
            this.map.displayHint(param1);
        }
        private function onButtonPressed(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = this.getButton(event.target);
            _loc_3 = _loc_2.getButtonId();
            this.pressed(_loc_3);
        }
        public function getSize():Point{
            return ((this.buttonsContainer) ? new Point(this.buttonsContainer.width, this.buttonsContainer.height) : new Point(0, 0));
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
