//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.core.*;
    import flash.events.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;

    public class NavigationControl extends IWrappableSpriteWrapper implements INavigationControl {

        private static const PADDING_POSITION:int = 5;
        private static const PADDING_ATTITUDE:int = 2;

        private static var defaultOptions:NavigationControlOptions = createDefaultOptions();

        private var zoomControl:NavigationZoom;
        private var container:Sprite;
        private var buttonsContainer:Sprite;
        private var options:NavigationControlOptions;
        private var map:IControllableMap;
        private var positionControl:NavigationPosition;

        public function NavigationControl(param1:NavigationControlOptions=null){
            super();
            this.options = NavigationControlOptions.merge([defaultOptions, param1]);
        }
        private static function createDefaultOptions():NavigationControlOptions{
            return (new NavigationControlOptions({
                position:new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 10),
                hasScrollTrack:true
            }));
        }

        override public function get interfaceChain():Array{
            return (["INavigationTypeControl", "IControl"]);
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!(this.container)){
                this.container = getSprite();
            };
        }
        public function removeFromMap():void{
            if (this.buttonsContainer){
                this.container.removeChild(this.buttonsContainer);
                this.buttonsContainer = null;
            };
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.initializeControl);
            if (this.positionControl){
                this.positionControl.setMap(null);
                this.positionControl = null;
            };
            if (this.zoomControl){
                this.zoomControl.setMap(null);
                this.zoomControl = null;
            };
        }
        private function initializeControl(event:Event=null):void{
            var _loc_2:DisplayObject;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Point;
            if (!(this.buttonsContainer)){
                this.buttonsContainer = Bootstrap.createChildSprite(this.container);
            };
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = null;
            if (!(this.positionControl)){
                this.positionControl = new NavigationPosition(Bootstrap.createChildSprite(this.buttonsContainer));
                this.positionControl.setMap(this.map);
            };
            _loc_2 = this.positionControl.getDisplayObject();
            _loc_5 = this.positionControl.getSize();
            if (_loc_5.x > _loc_3){
                _loc_3 = _loc_5.x;
            };
            _loc_2.x = Math.floor(((_loc_3 - _loc_5.x) / 2));
            _loc_2.y = _loc_4;
            _loc_4 = (_loc_4 + (_loc_5.y + PADDING_POSITION));
            if (!(this.zoomControl)){
                this.zoomControl = new NavigationZoom(Bootstrap.createChildSprite(this.buttonsContainer), this.options);
                this.zoomControl.setMap(this.map);
            };
            _loc_2 = this.zoomControl.getDisplayObject();
            _loc_5 = this.zoomControl.getSize();
            if (_loc_5.x > _loc_3){
                _loc_3 = _loc_5.x;
            };
            _loc_2.x = Math.floor(((_loc_3 - _loc_5.x) / 2));
            _loc_2.y = _loc_4;
        }
        function initControlWithMapInternal(param1:IControllableMap):void{
            if (this.map){
                this.removeFromMap();
            };
            this.map = param1;
            if (param1){
                if (param1.isLoaded()){
                    this.initializeControl();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, this.initializeControl);
                };
            };
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        public function initControlWithMap(param1:IMap):void{
            this.initControlWithMapInternal((param1 as IControllableMap));
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
        public function getSize():Point{
            return ((this.buttonsContainer) ? new Point(this.buttonsContainer.width, this.buttonsContainer.height) : new Point(0, 0));
        }

    }
}//package com.mapplus.maps.controls 
