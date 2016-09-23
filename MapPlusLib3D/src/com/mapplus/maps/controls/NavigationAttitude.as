//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.attitude.*;

    public class NavigationAttitude {

        private static const RADIUS:int = 42;

        private var yawIndicator:YawIndicator;
        private var container:Sprite;
        private var buttonsContainer:Sprite;
        private var map:IControllableMap;
        private var anglesControl:AttitudeAnglesControl;

        public function NavigationAttitude(param1:Sprite){
            super();
            this.container = param1;
        }
        public function setMap(param1:IControllableMap):void{
            if (this.map){
                removeFromMap();
            };
            this.map = param1;
            if (this.map != null){
                if (this.buttonsContainer == null){
                    this.buttonsContainer = Bootstrap.createChildSprite(this.container);
                    this.buttonsContainer.x = RADIUS;
                    this.buttonsContainer.y = RADIUS;
                    initializeControl();
                };
                this.buttonsContainer.visible = isControlEnabled();
                this.map.addEventListener(MapEvent.VIEW_CHANGED, onMapViewChanged);
            };
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }
        private function removeFromMap():void{
            var _loc_1:ISpriteFactory;
            this.map.removeEventListener(MapEvent.VIEW_CHANGED, onMapViewChanged);
            if (this.buttonsContainer != null){
                _loc_1 = Bootstrap.getSpriteFactory();
                _loc_1.removeChild(this.container, this.buttonsContainer);
            };
            if (this.yawIndicator != null){
                this.yawIndicator.setMap(null);
            };
            if (this.anglesControl != null){
                this.anglesControl.setMap(null);
            };
        }
        private function onMapViewChanged(event:Event):void{
            if (isControlEnabled()){
                this.buttonsContainer.visible = true;
            } else {
                this.buttonsContainer.visible = false;
            };
        }
        private function initializeControl():void{
            var _loc_1:Sprite;
            _loc_1 = Bootstrap.createChildSprite(buttonsContainer);
            this.yawIndicator = new YawIndicator(_loc_1, RADIUS);
            this.yawIndicator.setMap(this.map);
            _loc_1 = Bootstrap.createChildSprite(buttonsContainer);
            this.anglesControl = new AttitudeAnglesControl(_loc_1, AttitudeAnglesControl.ANGLES_CAMERA_TILT);
            this.anglesControl.setMap(this.map);
        }
        private function isControlEnabled():Boolean{
            return (map.getCamera().is3D);
        }
        public function getSize():Point{
            return ((isControlEnabled()) ? new Point((RADIUS * 2), (RADIUS * 2)) : null);
        }

    }
}//package com.mapplus.maps.controls 
