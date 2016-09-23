//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class NavigationControl extends IWrappableSpriteWrapper implements INavigationControl {

        private static const PADDING_POSITION:int = 5;
        private static const PADDING_ATTITUDE:int = 2;

        private static var defaultOptions:NavigationControlOptions = createDefaultOptions();

        private var buttonsContainer:Sprite;
        private var container:Sprite;
        private var zoomControl:NavigationZoom;
        private var attitudeControl:NavigationAttitude;
        private var map:IControllableMap;
        private var options:NavigationControlOptions;
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
        public function initControlWithMap(param1:IMap):void{
            initControlWithMapInternal((param1 as IControllableMap));
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!container){
                container = getSprite();
            };
        }
        public function setControlPosition(param1:ControlPosition):void{
            options.position = param1;
            if (map){
                map.placeControl(this, getControlPosition());
            };
        }
        private function displayHint(param1:String):void{
            map.displayHint(param1);
        }
        private function initializeControl(event:Event=null):void{
            var _loc_2:DisplayObject;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Point;
            if (!buttonsContainer){
                buttonsContainer = Bootstrap.createChildSprite(container);
            };
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = null;
            if (!attitudeControl){
                attitudeControl = new NavigationAttitude(Bootstrap.createChildSprite(buttonsContainer));
                attitudeControl.setMap(map);
            };
            _loc_2 = attitudeControl.getDisplayObject();
            _loc_2.visible = map.getCamera().is3D;
            if (attitudeControl.getSize()){
                _loc_5 = attitudeControl.getSize();
                _loc_3 = _loc_5.x;
                _loc_4 = (_loc_5.y + PADDING_ATTITUDE);
            };
            if (!positionControl){
                positionControl = new NavigationPosition(Bootstrap.createChildSprite(buttonsContainer));
                positionControl.setMap(map);
            };
            _loc_2 = positionControl.getDisplayObject();
            _loc_5 = positionControl.getSize();
            if (_loc_5.x > _loc_3){
                _loc_3 = _loc_5.x;
            };
            _loc_2.x = Math.floor(((_loc_3 - _loc_5.x) / 2));
            _loc_2.y = _loc_4;
            _loc_4 = (_loc_4 + (_loc_5.y + PADDING_POSITION));
            if (!zoomControl){
                zoomControl = new NavigationZoom(Bootstrap.createChildSprite(buttonsContainer), options);
                zoomControl.setMap(map);
            };
            _loc_2 = zoomControl.getDisplayObject();
            _loc_5 = zoomControl.getSize();
            if (_loc_5.x > _loc_3){
                _loc_3 = _loc_5.x;
            };
            _loc_2.x = Math.floor(((_loc_3 - _loc_5.x) / 2));
            _loc_2.y = _loc_4;
        }
        public function removeFromMap():void{
            if (buttonsContainer){
                container.removeChild(buttonsContainer);
                buttonsContainer = null;
            };
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, initializeControl);
            map.removeEventListener(MapEvent.VIEW_CHANGED, initializeControl);
            if (attitudeControl){
                attitudeControl.setMap(null);
                attitudeControl = null;
            };
            if (positionControl){
                positionControl.setMap(null);
                positionControl = null;
            };
            if (zoomControl){
                zoomControl.setMap(null);
                zoomControl = null;
            };
        }
        public function getControlPosition():ControlPosition{
            return ((options.position as ControlPosition));
        }
        public function getDisplayObject():DisplayObject{
            return (container);
        }
        private function initControlWithMapInternal(param1:IControllableMap):void{
            if (this.map){
                removeFromMap();
            };
            this.map = param1;
            if (param1){
                param1.addEventListener(MapEvent.VIEW_CHANGED, initializeControl);
                if (param1.isLoaded()){
                    initializeControl();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, initializeControl);
                };
            };
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        public function getSize():Point{
            return ((buttonsContainer) ? new Point(buttonsContainer.width, buttonsContainer.height) : new Point(0, 0));
        }

    }
}//package com.mapplus.maps.controls 
