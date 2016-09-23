//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.wrappers.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class MapTypeControl extends IWrappableSpriteWrapper implements IMapTypeControl {

        private static var selectedMapType:String;
        private static var defaultOptions:MapTypeControlOptions = createInitialDefaultOptions();

        private var buttons:Array;
        private var buttonsContainer:Sprite;
        private var container:Sprite;
        private var currentHint:String;
        private var options:MapTypeControlOptions;
        private var map:IControllableMap;
        private var mapTypes:Array;

        public function MapTypeControl(param1:MapTypeControlOptions=null){
            super();
            this.options = MapTypeControlOptions.merge([defaultOptions, param1]);
            this.mapTypes = [];
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

        override public function get interfaceChain():Array{
            return (["IMapTypeControl", "IControl"]);
        }
        private function getButtonSpacing():Point{
			if (this.options.buttonSpacing==null)
			{
				this.options.buttonSpacing=new Point(5,5);
			}
            return this.options.buttonSpacing as Point;
        }
        private function onHideButtonHint(event:Event):void{
            var _loc_2:Button;
            _loc_2 = this.getButton(event.target);
            if (((!((_loc_2 == null))) && ((this.currentHint == _loc_2.getHintText())))){
                this.currentHint = null;
                this.displayHint(undefined);
            };
        }
        private function getButtonAlignment():Number{
            return ((this.options.buttonAlignment as Number));
        }
        private function onDisplayButtonHint(event:Event):void{
            var _loc_2:Button;
            var _loc_3:String;
            _loc_2 = this.getButton(event.target);
            if (_loc_2 == null){
                return;
            };
            _loc_3 = _loc_2.getHintText();
            if (((!((_loc_3 == null))) && (!((this.currentHint == _loc_3))))){
                this.currentHint = _loc_3;
                this.displayHint(this.currentHint);
            };
        }
        override protected function onAttached():void{
            super.onAttached();
            if (this.container == null){
                this.container = this.getSprite();
            };
        }
        private function getButton(param1:Object):Button{
            return ((param1 as Button));
        }
        public function removeFromMap():void{
            var _loc_1:int;
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            this.map.removeEventListener(MapEvent.MAPTYPE_CHANGED, this.onMapTypeChanged);
            this.map.removeEventListener(MapEvent.MAPTYPE_ADDED, this.onMapTypeListChanged);
            this.map.removeEventListener(MapEvent.MAPTYPE_REMOVED, this.onMapTypeListChanged);
            if (this.buttonsContainer != null){
                this.container.removeChild(this.buttonsContainer);
                this.buttonsContainer = null;
            };
            _loc_1 = 0;
            while (_loc_1 < this.buttons.length) {
                this.buttons[_loc_1].disableButton();
                _loc_1++;
            };
            this.buttons = [];
        }
        public function initControlWithMapInternal(param1:IControllableMap):void{
            if (this.map){
                this.removeFromMap();
            };
            this.map = param1;
            if (param1){
                param1.addEventListener(MapEvent.MAPTYPE_CHANGED, this.onMapTypeChanged);
                param1.addEventListener(MapEvent.MAPTYPE_ADDED, this.onMapTypeListChanged);
                param1.addEventListener(MapEvent.MAPTYPE_REMOVED, this.onMapTypeListChanged);
                if (param1.isLoaded()){
                    this.createTypeButtons();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
                };
            };
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        private function onMapReady(event:Event):void{
            this.createTypeButtons();
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
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
            if (!(this.map.isLoaded())){
                return;
            };
            if (this.buttonsContainer){
                this.container.removeChild(this.buttonsContainer);
                this.buttonsContainer = null;
            };
            _loc_1 = this.map.getMapTypes();
            _loc_2 = this.map.getCurrentMapType();
            this.mapTypes = [];
            this.buttons = [];
            this.buttonsContainer = Bootstrap.createChildSprite(this.container);
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = 0;
            while (_loc_5 < _loc_1.length) {
                _loc_6 = _loc_1[_loc_5];
                this.mapTypes.push(_loc_6);
                _loc_7 = this.getButtonIdForMapType(_loc_6);
                _loc_8 = new TextButton(Bootstrap.createChildSprite(this.buttonsContainer), _loc_6.getName(), true);
                _loc_8.x = _loc_3;
                _loc_8.y = _loc_4;
                _loc_8.initialize(_loc_7, this.getButtonSize(), this.getButtonStyle());
                if (_loc_2 == _loc_6){
                    _loc_8.setState(ButtonConstants.STATE_DOWN);
                };
                _loc_8.setHintText(_loc_6.getAlt());
				
				
                if (this.getButtonAlignment() == MapTypeControlOptions.ALIGN_VERTICALLY){
                    _loc_4 = (_loc_4 + (_loc_8.getButtonSize().y + this.getButtonSpacing().y));
                } else {
                    _loc_3 = (_loc_3 + (_loc_8.getButtonSize().x + this.getButtonSpacing().x));
                };
                _loc_8.addEventListener(ButtonConstants.EVENT_RELEASED, this.onButtonReleased);
                _loc_8.addEventListener(ButtonConstants.EVENT_DISPLAY_HINT, this.onDisplayButtonHint);
                _loc_8.addEventListener(ButtonConstants.EVENT_HIDE_HINT, this.onHideButtonHint);
                this.buttons.push(_loc_8);
                _loc_5 = (_loc_5 + 1);
            };
            this.map.placeControl(this, this.getControlPosition());
        }
        private function onButtonReleased(event:Event):void{
            var _loc_2:Button;
            var _loc_3:IMapType;
            _loc_2 = this.getButton(event.target);
            _loc_3 = this.getMapTypeFromButtonId(_loc_2.getButtonId());
            this.map.setMapType(_loc_3);
        }
        public function initControlWithMap(param1:IMap):void{
            this.initControlWithMapInternal((param1 as IControllableMap));
        }
        public function getMapTypeFromButtonId(param1:String):IMapType{
            var _loc_2:Number = NaN;
            _loc_2 = 0;
            while (_loc_2 < this.mapTypes.length) {
                if (this.mapTypes[_loc_2].getName(true) == param1){
                    return (this.mapTypes[_loc_2]);
                };
                _loc_2 = (_loc_2 + 1);
            };
            return (null);
        }
        private function getButtonSize():Point{
            return this.options.buttonSize as Point;
        }
        private function onMapTypeChanged(event:Event):void{
            var _loc_2:IMapType;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            if (this.buttons == null){
                return;
            };
            _loc_2 = this.map.getCurrentMapType();
            _loc_3 = 0;
            while (_loc_3 < this.buttons.length) {
                _loc_4 = this.buttons[_loc_3].getButtonId();
                if (this.getButtonIdForMapType(_loc_2) == _loc_4){
                    this.buttons[_loc_3].setState(ButtonConstants.STATE_DOWN);
                } else {
                    this.buttons[_loc_3].setState(ButtonConstants.STATE_UP);
                };
                _loc_3 = (_loc_3 + 1);
            };
        }
        private function onMapTypeListChanged(event:Event):void{
            this.createTypeButtons();
        }
        private function displayHint(param1:String):void{
            this.map.displayHint(param1);
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, this.getControlPosition());
            };
        }
        public function getControlPosition():ControlPosition{
            return ((this.options.position as ControlPosition));
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }
        private function getButtonStyle():ButtonStyle{
            return ((this.options.buttonStyle as ButtonStyle));
        }
        public function getSize():Point{
            return ((!((this.buttonsContainer == null))) ? new Point(this.buttonsContainer.width, this.buttonsContainer.height) : new Point(0, 0));
        }
        public function getButtonIdForMapType(param1:IMapType):String{
            return (param1.getName(true));
        }

    }
}//package com.mapplus.maps.controls 
