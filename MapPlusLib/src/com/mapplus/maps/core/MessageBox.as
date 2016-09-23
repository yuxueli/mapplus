//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.text.*;
    import flash.display.*;
    import flash.events.*;

    public class MessageBox extends Sprite {

        private static const CLOSE_W:int = 15;
        private static const CLOSE_H:int = 15;
        private static const CloseImage:Class = MessageBox_CloseImage;
        private static const PAD_X:int = 2;
        private static const PAD_Y:int = 2;

        private var closeButton:Sprite;
        private var boxWidth:Number;
        private var textField:TextField;

        public function MessageBox(){
            super();
            var _loc_1:StyleSheet;
            visible = false;
            this.boxWidth = 0;
            this.textField = new TextField();
            this.textField.x = PAD_X;
            this.textField.y = PAD_Y;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.multiline = true;
            this.textField.wordWrap = true;
            this.textField.selectable = false;
            _loc_1 = new StyleSheet();
            _loc_1.setStyle("p", {
                color:"#000000",
                fontFamily:"_sans",
                fontSize:12
            });
            this.textField.styleSheet = _loc_1;
            addChild(this.textField);
            this.closeButton = new Sprite();
            this.closeButton.addChild(new CloseImage());
            addChild(this.closeButton);
            this.closeButton.useHandCursor = true;
            this.closeButton.buttonMode = true;
            this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseButton);
            addEventListener(MouseEvent.CLICK, this.stopMousePropagation);
            addEventListener(MouseEvent.MOUSE_DOWN, this.stopMousePropagation);
            addEventListener(MouseEvent.MOUSE_MOVE, this.stopMousePropagation);
        }
        private function stopMousePropagation(event:MouseEvent):void{
            event.stopPropagation();
        }
        public function setWidth(param1:Number):void{
            this.boxWidth = param1;
            this.redraw();
        }
        public function setText(param1:String):void{
            this.textField.width = 1000000;
            this.textField.htmlText = param1;
            visible = true;
            this.redraw();
        }
        private function onCloseButton(event:MouseEvent):void{
            visible = false;
        }
        private function redraw():void{
            var _loc_1:Number = NaN;
            if (this.boxWidth <= 0){
                return;
            };
            this.textField.width = (this.boxWidth - (CLOSE_W + (PAD_X * 3)));
            _loc_1 = (Math.max(this.textField.height, CLOSE_H) + (PAD_Y * 2));
            graphics.clear();
            graphics.beginFill(16773544);
            graphics.lineStyle(1, 0);
            graphics.drawRect(0, 0, this.boxWidth, _loc_1);
            graphics.endFill();
            this.closeButton.x = (this.boxWidth - (CLOSE_W + PAD_X));
            this.closeButton.y = PAD_Y;
        }

    }
}//package com.mapplus.maps.core 
