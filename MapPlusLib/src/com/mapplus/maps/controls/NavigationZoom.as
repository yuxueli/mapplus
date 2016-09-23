//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.display.*;
    import com.mapplus.maps.controls.common.*;
    import flash.utils.*;
    import flash.events.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import flash.geom.*;

    public class NavigationZoom extends ZoomControlBase {

		[Embed(source="/assets/images/NavigationZoom_ZoomInIcon.png")]
        private var ZoomInIcon:Class;
		[Embed(source="/assets/images/NavigationZoom_ZoomOutIcon.png")]
        private var ZoomOutIcon:Class;
        private var options:NavigationControlOptions;
        private var heldButtonTimer:int;
        private var heldButton:ButtonBase;

        public function NavigationZoom(param1:Sprite, param2:NavigationControlOptions){
            super();
//            this.ZoomInIcon = new ZoomInIcon();//NavigationZoom_ZoomInIcon;
//            this.ZoomOutIcon = new ZoomOutIcon();//NavigationZoom_ZoomOutIcon;
            this.options = param2;
            legacyInitialize(param1, param1);
        }
        override protected function hasScrollTrack():Boolean{
            return (this.options.hasScrollTrack);
        }
        private function zoomMap(param1:ButtonBase, param2:Number, param3:Boolean):void{
            var _loc_4:Number = NaN;
            _loc_4 = getZoomLevel();
            if (param1 == zoomInButton){
                _loc_4 = Math.min(getMaxZoomLevel(), (_loc_4 + param2));
            } else {
                if (param1 == zoomOutButton){
                    _loc_4 = Math.max(getMinZoomLevel(), (_loc_4 - param2));
                };
            };
            if (_loc_4 != getZoomLevel()){
                map.setZoom(_loc_4, param3);
            };
        }
        override protected function onButtonOut(event:Event):void{
            this.heldButton = null;
            this.heldButtonTimer = getTimer();
        }
        override protected function removeFromMap():void{
            super.removeFromMap();
            map.removeEventListener(MapZoomEvent.ZOOM_STEP, onMapZoomChanged);
        }
        private function onEnterFrame(event:Event):void{
            var _loc_2:int;
            var _loc_3:Number = NaN;
            _loc_2 = getTimer();
            if (((this.heldButton) && (this.continuousMove))){
                _loc_3 = Math.min(((1 * (_loc_2 - this.heldButtonTimer)) / 1000), 1);
                this.zoomMap(this.heldButton, _loc_3, false);
            };
            this.heldButtonTimer = _loc_2;
        }
        override public function setMap(param1:IControllableMap):void{
            if (this.map){
                this.map.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            };
            super.setMap(param1);
            if (param1){
                param1.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                param1.addEventListener(MapZoomEvent.ZOOM_STEP, onMapZoomChanged);
            };
            this.heldButton = null;
        }
        override protected function createZoomInButton(param1:Sprite):ButtonBase{
            var _loc_2:ButtonBase;
            param1.addChild(new this.ZoomInIcon());
            _loc_2 = new ButtonBase(param1);
            _loc_2.setButtonId(ZOOM_IN_BUTTON_HINT_ID);
            return (_loc_2);
        }
        override protected function onButtonReleased(event:Event):void{
            if (!(this.continuousMove)){
                super.onButtonReleased(event);
            };
            this.heldButton = null;
            this.heldButtonTimer = getTimer();
        }
        override protected function createScrollTrack(param1:Sprite):ScrollTrackBase{
            var _loc_2:ScrollTrackVersion2;
            _loc_2 = new ScrollTrackVersion2(param1);
            _loc_2.initialize(getMaxZoomLevel());
            return (_loc_2);
        }
        override protected function createZoomOutButton(param1:Sprite):ButtonBase{
            var _loc_2:ButtonBase;
            param1.addChild(new this.ZoomOutIcon());
            _loc_2 = new ButtonBase(param1);
            _loc_2.setButtonId(ZOOM_IN_BUTTON_HINT_ID);
            return (_loc_2);
        }
        private function get continuousMove():Boolean{
            return (map.getCamera().is3D);
        }
        override protected function onButtonPressed(event:Event):void{
            this.heldButton = getButton(event.target);
            this.heldButtonTimer = getTimer();
        }
        override protected function getButtonSpacing():Point{
            return (new Point(0, 0));
        }

    }
}//package com.mapplus.maps.controls 
