//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.display.*;
    import com.mapplus.maps.core.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.Render;

    public class Button extends ButtonBase {

        private var buttonFaceStyle:ButtonFaceStyle;
        private var size:Point;
        private var outline:Sprite;
        private var style:ButtonStyle;

        public function Button(param1:Sprite, param2:Boolean=false){
            super(param1, param2);
        }
        public function initialize(param1:String, param2:Point, param3:ButtonStyle):void{
            setButtonId(param1);
            this.size = param2;
            this.style = param3;
            if (this.outline == null){
                this.outline = Bootstrap.createChildSprite(this.mc);
            };
            this.mc.setChildIndex(this.outline, 0);
            updateButton();
        }
        override public function setState(param1:int):void{
            var _loc_2:ButtonFaceStyle;
            super.setState(param1);
            if (this.style != null){
                _loc_2 = this.style.upState;
                switch (getState()){
                    case ButtonConstants.STATE_OVER:
                        _loc_2 = this.style.overState;
                        break;
                    case ButtonConstants.STATE_DOWN:
                        _loc_2 = this.style.downState;
                        break;
                };
                this.setBevelStyle(_loc_2);
            };
            if (this.outline != null){
                this.drawOutline();
            };
        }
        public function getButtonSize():Point{
            return (this.size);
        }
        public function setButtonSize(param1:Point):void{
            this.size = param1;
            updateButton();
        }
        protected function setBevelStyle(param1:ButtonFaceStyle):void{
            this.buttonFaceStyle = param1;
        }
        private function getStrokeStyle():StrokeStyle{
            if (this.buttonFaceStyle != null){
                return (this.buttonFaceStyle.strokeStyle);
            };
            return (null);
        }
        protected function drawOutline():void{
            this.outline.graphics.clear();
            if (((!(this.size)) || (!(this.style)))){
                return;
            };
            this.outline.filters = Render.createBevelFilters(this.buttonFaceStyle);
            Render.drawRectOutlineStyle(this.outline.graphics, new Rectangle(0, 0, this.size.x, this.size.y), (this.getStrokeStyle()) ? this.getStrokeStyle() : new StrokeStyle(), (this.getFillStyle()) ? this.getFillStyle() : new FillStyle());
        }
        public function setButtonStyle(param1:ButtonStyle):void{
            this.style = param1;
            updateButton();
        }
        public function getButtonStyle():ButtonStyle{
            return (this.style);
        }
        private function getFillStyle():FillStyle{
            if (this.buttonFaceStyle != null){
                return (this.buttonFaceStyle.fillStyle);
            };
            return (null);
        }

    }
}//package com.mapplus.maps.controls.common 
