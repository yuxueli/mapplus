//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;

    public class MultiButtonControlBase extends IWrappableSpriteWrapper {

        protected var buttonsContainer:Sprite;
        protected var container:Sprite;
        protected var buttons:Array;
        protected var map:IControllableMap;
        private var currentHint:String;

        public function MultiButtonControlBase(){
            super();
        }
        protected function addButton(param1:ButtonBase):void{
            param1.addEventListener(ButtonConstants.EVENT_PRESSED, onButtonPressed);
            param1.addEventListener(ButtonConstants.EVENT_RELEASED, onButtonReleased);
            param1.addEventListener(ButtonConstants.EVENT_OUT, onButtonOut);
            param1.addEventListener(ButtonConstants.EVENT_DISPLAY_HINT, onDisplayButtonHint);
            param1.addEventListener(ButtonConstants.EVENT_HIDE_HINT, onHideButtonHint);
            buttons.push(param1);
        }
        private function onButtonReleased(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = getButton(event.target);
            _loc_3 = _loc_2.getButtonId();
            released(_loc_3);
            action(_loc_3);
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
                if (param1.isLoaded()){
                    initializeControl();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
                };
            };
        }
        private function onButtonOut(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = getButton(event.target);
            _loc_3 = _loc_2.getButtonId();
            released(_loc_3);
        }
        protected function pressed(param1:String):void{
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!container){
                container = getSprite();
            };
        }
        protected function createButtons():void{
        }
        private function onMapReady(event:Event):void{
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            initializeControl();
        }
        private function getButton(param1:Object):ButtonBase{
            return ((param1 as ButtonBase));
        }
        private function displayHint(param1:String):void{
            map.displayHint(param1);
        }
        private function onDisplayButtonHint(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = getButton(event.target);
            _loc_3 = _loc_2.getHintText();
            if (((!((_loc_3 == null))) && (!((currentHint == _loc_3))))){
                currentHint = _loc_3;
                displayHint(currentHint);
            };
        }
        private function initializeControl():void{
            if (buttonsContainer){
                container.removeChild(buttonsContainer);
                buttonsContainer = null;
            };
            buttonsContainer = Bootstrap.createChildSprite(container);
            buttons = [];
            createButtons();
        }
        protected function removeFromMap():void{
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            container.removeChild(buttonsContainer);
            buttonsContainer = null;
        }
        private function onButtonPressed(event:Event):void{
            var _loc_2:ButtonBase;
            var _loc_3:String;
            _loc_2 = getButton(event.target);
            _loc_3 = _loc_2.getButtonId();
            pressed(_loc_3);
        }
        protected function createButtonSprite():Sprite{
            return (Bootstrap.createChildSprite(buttonsContainer));
        }
        protected function action(param1:String):void{
        }
        public function getSize():Point{
            return ((buttonsContainer) ? new Point(buttonsContainer.width, buttonsContainer.height) : new Point(0, 0));
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        protected function released(param1:String):void{
        }

    }
}//package com.mapplus.maps.controls 
