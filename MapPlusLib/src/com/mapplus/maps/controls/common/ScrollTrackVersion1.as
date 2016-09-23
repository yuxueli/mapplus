//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import com.mapplus.maps.*;
    import flash.display.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.styles.*;
    import flash.geom.*;

    public class ScrollTrackVersion1 extends ScrollTrackBase {

        private var scrollButtonSize:Point;
		[Embed(source="/assets/images/ScrollTrackVersion1_ScrollWidgetIcon.png")]
        private var ScrollWidgetIcon:Class;
        private var trackMc:Sprite;
        private var scrollTrackStyle:Object;
        private var buttonStyle:ButtonStyle;

        public function ScrollTrackVersion1(param1:Sprite){
            //this.ScrollWidgetIcon = new  ScrollWidgetIcon();//ScrollTrackVersion1_ScrollWidgetIcon;
            super(param1);
        }
        private static function getDefaultStyle():Object{
            return ({
                w:17,
                hh:8,
                tickWidth:15,
                tickHeight:3,
                padding:3,
                trackWidth:5,
                buttonWidth:17,
                buttonHeight:9,
                fill:true,
                fillRGB:Color.WHITE,
                fillAlpha:Alpha.OPAQUE,
                stroke:true,
                strokeRGB:Color.BLACK,
                bevel:"up",
                bevelRGB:Color.WHITE,
                bevelAlpha:Alpha.PERCENT_30
            });
        }

        override protected function draw():void{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Object;
            var _loc_8:Number = NaN;
            var _loc_9:Object;
            _loc_1 = ((2 * this.scrollTrackStyle.padding) + (((maxZoomLevel - minZoomLevel) + 1) * this.getLevelHeight()));
            _loc_2 = this.scrollTrackStyle.w;
            this.trackMc.graphics.clear();
            Render.drawRect(this.trackMc, new Rectangle(0, 0, _loc_2, _loc_1), Color.BLUE, Alpha.UNSEEN, Color.BLACK, Alpha.UNSEEN);
            _loc_3 = Math.floor(((this.scrollTrackStyle.w - this.scrollTrackStyle.tickWidth) / 2));
            _loc_4 = (this.getScrollTrackBaseY() - Math.floor((this.scrollTrackStyle.tickHeight / 2)));
            _loc_5 = this.scrollTrackStyle.tickWidth;
            _loc_6 = this.scrollTrackStyle.tickHeight;
            _loc_7 = {
                cutCorner:true,
                noClear:true,
                fill:this.scrollTrackStyle.fill,
                fillRGB:this.scrollTrackStyle.fillRGB,
                fillAlpha:this.scrollTrackStyle.fillAlpha,
                stroke:this.scrollTrackStyle.stroke,
                strokeRGB:this.scrollTrackStyle.strokeRGB
            };
            _loc_8 = minZoomLevel;
            while (_loc_8 <= maxZoomLevel) {
                Render.drawRectOutlineStyle(this.trackMc.graphics, new Rectangle(_loc_3, _loc_4, _loc_5, _loc_6), new StrokeStyle({
                    thickness:1,
                    color:0,
                    alpha:1
                }), new FillStyle({
                    color:this.scrollTrackStyle.fillRGB,
                    alpha:1
                }), true);
                _loc_4 = (_loc_4 + this.getLevelHeight());
                _loc_8 = (_loc_8 + 1);
            };
            _loc_3 = Math.floor(((_loc_2 - this.scrollTrackStyle.trackWidth) / 2));
            _loc_4 = 0;
            _loc_5 = this.scrollTrackStyle.trackWidth;
            _loc_6 = _loc_1;
            _loc_9 = {
                cutCorner:true,
                noClear:true,
                fill:this.scrollTrackStyle.fill,
                fillRGB:this.scrollTrackStyle.fillRGB,
                fillAlpha:this.scrollTrackStyle.fillAlpha,
                stroke:this.scrollTrackStyle.stroke,
                strokeRGB:this.scrollTrackStyle.strokeRGB
            };
            Render.drawRectOutlineStyle(this.trackMc.graphics, new Rectangle(_loc_3, _loc_4, _loc_5, _loc_6), new StrokeStyle({
                thickness:1,
                color:0,
                alpha:1
            }), new FillStyle({
                color:this.scrollTrackStyle.fillRGB,
                alpha:1
            }), true);
        }
        public function createScrollTrackBackground():void{
            this.trackMc = Bootstrap.getSpriteFactory().createSprite().getSprite();
            this.scrollButtonSize = new Point(DefaultVar.getNumber(this.scrollTrackStyle, "buttonWidth", 17), DefaultVar.getNumber(this.scrollTrackStyle, "buttonHeight", 9));
            setScrollTrackBackground(this.trackMc, this.getScrollTrackBaseY(), this.getLevelHeight());
        }
        private function getLevelHeight():Number{
            return (this.scrollTrackStyle.hh);
        }
        public function initialize(param1:Number, param2:Object=null):void{
            this.buttonStyle = Util.getDefaultButtonStyle();
            this.scrollTrackStyle = (!((param2 == null))) ? DefaultVar.cloneObject(param2) : getDefaultStyle();
            this.createScrollTrackBackground();
            this.createScrollTrackButton();
            this.maxZoomLevel = param1;
            updateControl();
        }
        private function getScrollTrackBaseY():Number{
            return ((this.scrollTrackStyle.padding + Math.floor((this.getLevelHeight() / 2))));
        }
        private function createScrollTrackButton():void{
            var _loc_1:Sprite;
            var _loc_2:IconButton;
            var _loc_3:Point;
            _loc_1 = Bootstrap.getSpriteFactory().createSprite().getSprite();
            _loc_2 = new IconButton(_loc_1);
            _loc_2.initialize("scrollButton", this.scrollButtonSize, this.buttonStyle);
            _loc_2.setIcon(new this.ScrollWidgetIcon());
            _loc_3 = new Point(Math.floor(((this.scrollTrackStyle.w - this.scrollButtonSize.x) / 2)), (this.getScrollTrackBaseY() - Math.floor((this.scrollButtonSize.y / 2))));
            setScrollButton(_loc_2, _loc_3);
        }

    }
}//package com.mapplus.maps.controls.common 
