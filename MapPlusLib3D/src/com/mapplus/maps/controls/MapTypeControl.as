//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;

    public class MapTypeControl extends IWrappableSpriteWrapper implements IMapTypeControl {

        private static var selectedMapType:String;
        private static var defaultOptions:MapTypeControlOptions = createInitialDefaultOptions();

        private var buttonsContainer:Sprite;
        private var buttons:Array;
        private var container:Sprite;
        private var options:MapTypeControlOptions;
        private var currentHint:String;
        private var map:IControllableMap;
        private var mapTypes:Array;

        public function MapTypeControl(param1:MapTypeControlOptions=null){
            super();
            this.options = MapTypeControlOptions.merge([defaultOptions, param1]);
            mapTypes = [];
        }
        private static function createInitialDefaultOptions():MapTypeControlOptions{
            return (new MapTypeControlOptions({
                buttonSize:new Point(67, 19),
                buttonStyle:Util.getDefaultButtonStyle(),
                buttonSpacing:new Point(0, 0),
                buttonAlignment:MapTypeControlOptions.ALIGN_HORIZONTALLY,
                position:new ControlPosition(ControlPosition.ANCHOR_TOP_RIGHT, 10)
            }));
        }

        private function createTypeButtons():void{
            var _loc_1:Array;
            var _loc_2:IMapType;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:IMapType;
            var _loc_7:String;
            var _loc_8:TextButton;
            if (!map.isLoaded()){
                return;
            };
            if (buttonsContainer){
                this.container.removeChild(buttonsContainer);
                buttonsContainer = null;
            };
            _loc_1 = map.getMapTypes();
            _loc_2 = map.getCurrentMapType();
            mapTypes = [];
            buttons = [];
            buttonsContainer = Bootstrap.createChildSprite(this.container);
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = 0;
            while (_loc_5 < _loc_1.length) {
                _loc_6 = _loc_1[_loc_5];
                mapTypes.push(_loc_6);
                _loc_7 = getButtonIdForMapType(_loc_6);
                _loc_8 = new TextButton(Bootstrap.createChildSprite(this.buttonsContainer), _loc_6.getName(), true);
                _loc_8.x = _loc_3;
                _loc_8.y = _loc_4;
                _loc_8.initialize(_loc_7, getButtonSize(), getButtonStyle());
                if (_loc_2 == _loc_6){
                    _loc_8.setState(ButtonConstants.STATE_DOWN);
                };
                _loc_8.setHintText(_loc_6.getAlt());
                if (getButtonAlignment() == MapTypeControlOptions.ALIGN_VERTICALLY){
                    _loc_4 = (_loc_4 + (_loc_8.getButtonSize().y + getButtonSpacing().y));
                } else {
                    _loc_3 = (_loc_3 + (_loc_8.getButtonSize().x + getButtonSpacing().x));
                };
                _loc_8.addEventListener(ButtonConstants.EVENT_RELEASED, this.onButtonReleased);
                _loc_8.addEventListener(ButtonConstants.EVENT_DISPLAY_HINT, this.onDisplayButtonHint);
                _loc_8.addEventListener(ButtonConstants.EVENT_HIDE_HINT, this.onHideButtonHint);
                buttons.push(_loc_8);
                _loc_5 = (_loc_5 + 1);
            };
            this.map.placeControl(this, getControlPosition());
        }
        private function onButtonReleased(event:Event):void{
            var _loc_2:Button;
            var _loc_3:IMapType;
            _loc_2 = getButton(event.target);
            _loc_3 = getMapTypeFromButtonId(_loc_2.getButtonId());
            map.setMapType(_loc_3);
        }
        public function initControlWithMap(param1:IMap):void{
            initControlWithMapInternal((param1 as IControllableMap));
        }
        private function getButtonStyle():ButtonStyle{
            return ((this.options.buttonStyle as ButtonStyle));
        }
        override public function get interfaceChain():Array{
            return (["IMapTypeControl", "IControl"]);
        }
        private function getButtonAlignment():Number{
            return ((this.options.buttonAlignment as Number));
        }
        private function onDisplayButtonHint(event:Event):void{
            var _loc_2:Button;
            var _loc_3:String;
            _loc_2 = getButton(event.target);
            if (_loc_2 == null){
                return;
            };
            _loc_3 = _loc_2.getHintText();
            if (((!((_loc_3 == null))) && (!((currentHint == _loc_3))))){
                currentHint = _loc_3;
                displayHint(currentHint);
            };
        }
        private function onMapTypeChanged(event:Event):void{
            var _loc_2:IMapType;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            if (this.buttons == null){
                return;
            };
            _loc_2 = map.getCurrentMapType();
            _loc_3 = 0;
            while (_loc_3 < buttons.length) {
                _loc_4 = this.buttons[_loc_3].getButtonId();
                if (getButtonIdForMapType(_loc_2) == _loc_4){
                    this.buttons[_loc_3].setState(ButtonConstants.STATE_DOWN);
                } else {
                    this.buttons[_loc_3].setState(ButtonConstants.STATE_UP);
                };
                _loc_3 = (_loc_3 + 1);
            };
        }
        private function onMapTypeListChanged(event:Event):void{
            createTypeButtons();
        }
        override protected function onAttached():void{
            super.onAttached();
            if (this.container == null){
                this.container = this.getSprite();
            };
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, getControlPosition());
            };
        }
        public function initControlWithMapInternal(param1:IControllableMap):void{
            if (this.map){
                removeFromMap();
            };
            this.map = param1;
            if (param1){
                param1.addEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
                param1.addEventListener(MapEvent.MAPTYPE_ADDED, onMapTypeListChanged);
                param1.addEventListener(MapEvent.MAPTYPE_REMOVED, onMapTypeListChanged);
                if (param1.isLoaded()){
                    createTypeButtons();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
                };
            };
        }
        private function getButton(param1:Object):Button{
            return ((param1 as Button));
        }
        private function displayHint(param1:String):void{
            map.displayHint(param1);
        }
        private function onMapReady(event:Event):void{
            createTypeButtons();
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
        }
        public function removeFromMap():void{
            var _loc_1:int;
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            map.removeEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
            map.removeEventListener(MapEvent.MAPTYPE_ADDED, onMapTypeListChanged);
            map.removeEventListener(MapEvent.MAPTYPE_REMOVED, onMapTypeListChanged);
            if (this.buttonsContainer != null){
                this.container.removeChild(this.buttonsContainer);
                this.buttonsContainer = null;
            };
            _loc_1 = 0;
            while (_loc_1 < buttons.length) {
                buttons[_loc_1].disableButton();
                _loc_1++;
            };
            buttons = [];
        }
        public function getMapTypeFromButtonId(param1:String):IMapType{
            var _loc_2:Number = NaN;
            _loc_2 = 0;
            while (_loc_2 < mapTypes.length) {
                if (mapTypes[_loc_2].getName(true) == param1){
                    return (mapTypes[_loc_2]);
                };
                _loc_2 = (_loc_2 + 1);
            };
            return (null);
        }
        public function getControlPosition():ControlPosition{
            return ((this.options.position as ControlPosition));
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }
        private function getButtonSize():Point{
            return ((this.options.buttonSize as Point));
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        private function onHideButtonHint(event:Event):void{
            var _loc_2:Button;
            _loc_2 = getButton(event.target);
            if (((!((_loc_2 == null))) && ((currentHint == _loc_2.getHintText())))){
                currentHint = null;
                displayHint(undefined);
            };
        }
        private function getButtonSpacing():Point{
            return ((this.options.buttonSpacing as Point));
        }
        public function getSize():Point{
            return (((this.buttonsContainer)!=null) ? new Point(this.buttonsContainer.width, this.buttonsContainer.height) : new Point(0, 0));
        }
        public function getButtonIdForMapType(param1:IMapType):String{
            return (param1.getName(true));
        }

    }
}//package com.mapplus.maps.controls 
