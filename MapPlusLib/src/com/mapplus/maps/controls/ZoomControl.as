//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.styles.*;
    import flash.display.*;

    public class ZoomControl extends ZoomControlBase implements IZoomControl {

        private static var defaultOptions:ZoomControlOptions = createInitialDefaultOptions();

		[Embed(source="/assets/images/ZoomControl_ZoomInIcon.png")]
        private var ZoomOutIcon:Class;
		[Embed(source="/assets/images/ZoomControl_ZoomOutIcon.png")]
        private var ZoomInIcon:Class;
        private var options:ZoomControlOptions;
        private var scrollTrackStyle:Object;

        public function ZoomControl(param1:ZoomControlOptions=null){
            super();
            var _loc_2:Object;
            this.ZoomInIcon = ZoomControl_ZoomInIcon;
            this.ZoomOutIcon = ZoomControl_ZoomOutIcon;
            _loc_2 = {};
            this.options = ZoomControlOptions.merge([defaultOptions, param1]);
            this.scrollTrackStyle = null;
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
        override public function get interfaceChain():Array{
            return (["IZoomControl", "IControl"]);
        }
        private function getButtonStyle():ButtonStyle{
            return (this.options.buttonStyle);
        }
        override protected function createZoomInButton(param1:Sprite):ButtonBase{
            var _loc_2:IconButton;
            _loc_2 = new IconButton(param1);
            _loc_2.initialize(ZOOM_IN_BUTTON_HINT_ID, this.getButtonSize(), this.getButtonStyle());
            _loc_2.setIcon(new this.ZoomInIcon());
            return (_loc_2);
        }
        function initControlWithMapInternal(param1:IControllableMap):void{
            setMap(param1);
        }
        public function initControlWithMap(param1:IMap):void{
            this.initControlWithMapInternal((param1 as IControllableMap));
        }
        private function getButtonSize():Point{
            return ((this.options.buttonSize as Point));
        }
        override protected function createScrollTrack(param1:Sprite):ScrollTrackBase{
            var _loc_2:ScrollTrackVersion1;
            _loc_2 = new ScrollTrackVersion1(param1);
            _loc_2.initialize(getMaxZoomLevel());
            return (_loc_2);
        }
        override protected function createZoomOutButton(param1:Sprite):ButtonBase{
            var _loc_2:IconButton;
            _loc_2 = new IconButton(param1);
            _loc_2.initialize(ZOOM_OUT_BUTTON_HINT_ID, this.getButtonSize(), this.getButtonStyle());
            _loc_2.setIcon(new this.ZoomOutIcon());
            return (_loc_2);
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, this.getControlPosition());
            };
        }
        override protected function getButtonSpacing():Point{
            return ((this.options.buttonSpacing as Point));
        }
        public function getControlPosition():ControlPosition{
            return (this.options.position);
        }

    }
}//package com.mapplus.maps.controls 
