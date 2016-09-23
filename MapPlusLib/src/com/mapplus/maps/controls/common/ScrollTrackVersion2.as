//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.display.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import flash.geom.*;

    public class ScrollTrackVersion2 extends ScrollTrackBase {

        private static const LEVEL_HEIGHT:int = 8;

        private var sliderSegments:Array;
        private var trackBackground:Sprite;
		[Embed(source="/assets/images/ScrollTrackVersion2_ZoomSliderSegment.png")]
        private var ZoomSliderSegment:Class;
		[Embed(source="/assets/images/ScrollTrackVersion2_ZoomSlider.png")]
        private var ZoomSlider:Class;

        public function ScrollTrackVersion2(param1:Sprite){
            //this.ZoomSliderSegment = new ZoomSliderSegment();//ScrollTrackVersion2_ZoomSliderSegment;
            //this.ZoomSlider = new ZoomSlider();//ScrollTrackVersion2_ZoomSlider;
            super(param1);
            this.sliderSegments = [];
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
                if (this.sliderSegments.length > _loc_3){
                    _loc_4 = this.sliderSegments[_loc_3];
                } else {
                    _loc_4 = new this.ZoomSliderSegment();
                    this.sliderSegments.push(_loc_4);
                    _loc_1.addChild(_loc_4);
                };
                _loc_4.visible = true;
                _loc_4.x = 0;
                _loc_4.y = _loc_2;
                _loc_2 = (_loc_2 + _loc_4.height);
                _loc_3++;
            };
            while (_loc_3 < this.sliderSegments.length) {
                this.sliderSegments[_loc_3].visible = false;
                this.sliderSegments[_loc_3].y = 0;
                _loc_3++;
            };
        }
        public function initialize(param1:Number):void{
            var _loc_2:ISpriteFactory;
            var _loc_3:int;
            var _loc_4:ButtonBase;
            _loc_2 = Bootstrap.getSpriteFactory();
            this.trackBackground = _loc_2.createSprite().getSprite();
            _loc_3 = (LEVEL_HEIGHT / 2);
            setScrollTrackBackground(this.trackBackground, _loc_3, LEVEL_HEIGHT);
            _loc_4 = this.createScrollButton(_loc_2.createSprite().getSprite());
            setScrollButton(_loc_4, new Point(0, 0));
            this.maxZoomLevel = param1;
            updateControl();
        }
        override protected function createScrollButton(param1:Sprite):ButtonBase{
            var _loc_2:DisplayObject;
            var _loc_3:ButtonBase;
            _loc_2 = new this.ZoomSlider();
            param1.addChild(_loc_2);
            _loc_3 = new ButtonBase(param1);
            return (_loc_3);
        }

    }
}//package com.mapplus.maps.controls.common 
