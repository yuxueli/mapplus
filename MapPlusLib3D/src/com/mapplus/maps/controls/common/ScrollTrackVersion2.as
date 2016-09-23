//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class ScrollTrackVersion2 extends ScrollTrackBase {

        private static const LEVEL_HEIGHT:int = 8;

        private var sliderSegments:Array;
        private var trackBackground:Sprite;
		[Embed(source="/assets/images/ScrollTrackVersion2_ZoomSliderSegment.png")]
		private var ZoomSliderSegment:Class;
		[Embed(source="/assets/images/ScrollTrackVersion2_ZoomSlider.png")]
		private var ZoomSlider:Class;

        public function ScrollTrackVersion2(param1:Sprite){
//            ZoomSliderSegment = ScrollTrackVersion2_ZoomSliderSegment;
//            ZoomSlider = ScrollTrackVersion2_ZoomSlider;
            super(param1);
            sliderSegments = [];
        }
        public function initialize(param1:Number):void{
            var _loc_2:ISpriteFactory;
            var _loc_3:int;
            var _loc_4:ButtonBase;
            _loc_2 = Bootstrap.getSpriteFactory();
            this.trackBackground = _loc_2.createSprite().getSprite();
            _loc_3 = (LEVEL_HEIGHT / 2);
            setScrollTrackBackground(this.trackBackground, _loc_3, LEVEL_HEIGHT);
            _loc_4 = createScrollButton(_loc_2.createSprite().getSprite());
            setScrollButton(_loc_4, new Point(0, 0));
            this.maxZoomLevel = param1;
            updateControl();
        }
        override protected function draw():void{
            var _loc_1:Sprite;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:DisplayObject;
            _loc_1 = this.trackBackground;
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_3 <= (maxZoomLevel - minZoomLevel)) {
                _loc_4 = null;
                if (sliderSegments.length > _loc_3){
                    _loc_4 = sliderSegments[_loc_3];
                } else {
                    _loc_4 = new ZoomSliderSegment();
                    sliderSegments.push(_loc_4);
                    _loc_1.addChild(_loc_4);
                };
                _loc_4.visible = true;
                _loc_4.x = 0;
                _loc_4.y = _loc_2;
                _loc_2 = (_loc_2 + _loc_4.height);
                _loc_3++;
            };
            while (_loc_3 < sliderSegments.length) {
                sliderSegments[_loc_3].visible = false;
                sliderSegments[_loc_3].y = 0;
                _loc_3++;
            };
        }
        override protected function createScrollButton(param1:Sprite):ButtonBase{
            var _loc_2:DisplayObject;
            var _loc_3:ButtonBase;
            _loc_2 = new ZoomSlider();
            param1.addChild(_loc_2);
            _loc_3 = new ButtonBase(param1);
            return (_loc_3);
        }

    }
}//package com.mapplus.maps.controls.common 
