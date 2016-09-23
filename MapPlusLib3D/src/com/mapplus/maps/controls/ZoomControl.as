//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;

    public class ZoomControl extends ZoomControlBase implements IZoomControl {

        private static var defaultOptions:ZoomControlOptions = createInitialDefaultOptions();

        private var ZoomInIcon:Class;
        private var scrollTrackStyle:Object;
        private var options:ZoomControlOptions;
        private var ZoomOutIcon:Class;

        public function ZoomControl(param1:ZoomControlOptions=null){
            super();
            var _loc_2:Object;
            ZoomInIcon = ZoomControl_ZoomInIcon;
            ZoomOutIcon = ZoomControl_ZoomOutIcon;
            _loc_2 = {};
            this.options = ZoomControlOptions.merge([defaultOptions, param1]);
            scrollTrackStyle = null;
            if (_loc_2 != null){
                if ((_loc_2.scrollTrackStyle is Object)){
                    this.scrollTrackStyle = _loc_2.scrollTrackStyle;
                };
            };
        }
        private static function createInitialDefaultOptions():ZoomControlOptions{
            return (new ZoomControlOptions({
                buttonSize:new Point(17, 17),
                buttonStyle:Util.getDefaultButtonStyle(),
                buttonSpacing:new Point(4, 4),
                hasScrollTrack:true,
                position:new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 31, 76)
            }));
        }

        override protected function hasScrollTrack():Boolean{
            return ((this.options.hasScrollTrack as Boolean));
        }
        override protected function createZoomInButton(param1:Sprite):ButtonBase{
            var _loc_2:IconButton;
            _loc_2 = new IconButton(param1);
            _loc_2.initialize(ZOOM_IN_BUTTON_HINT_ID, getButtonSize(), getButtonStyle());
            _loc_2.setIcon(new ZoomInIcon());
            return (_loc_2);
        }
        private function getButtonSize():Point{
            return ((this.options.buttonSize as Point));
        }
        override public function get interfaceChain():Array{
            return (["IZoomControl", "IControl"]);
        }
        public function initControlWithMap(param1:IMap):void{
            initControlWithMapInternal((param1 as IControllableMap));
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, getControlPosition());
            };
        }
        private function getButtonStyle():ButtonStyle{
            return (this.options.buttonStyle);
        }
        function initControlWithMapInternal(param1:IControllableMap):void{
            setMap(param1);
        }
        public function getControlPosition():ControlPosition{
            return (this.options.position);
        }
        override protected function createZoomOutButton(param1:Sprite):ButtonBase{
            var _loc_2:IconButton;
            _loc_2 = new IconButton(param1);
            _loc_2.initialize(ZOOM_OUT_BUTTON_HINT_ID, getButtonSize(), getButtonStyle());
            _loc_2.setIcon(new ZoomOutIcon());
            return (_loc_2);
        }
        override protected function createScrollTrack(param1:Sprite):ScrollTrackBase{
            var _loc_2:ScrollTrackVersion1;
            _loc_2 = new ScrollTrackVersion1(param1);
            _loc_2.initialize(getMaxZoomLevel());
            return (_loc_2);
        }
        override protected function getButtonSpacing():Point{
            return ((this.options.buttonSpacing as Point));
        }

    }
}//package com.mapplus.maps.controls 
