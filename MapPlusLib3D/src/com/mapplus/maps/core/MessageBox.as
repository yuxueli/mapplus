//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;

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
            boxWidth = 0;
            textField = new TextField();
            textField.x = PAD_X;
            textField.y = PAD_Y;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.multiline = true;
            textField.wordWrap = true;
            textField.selectable = false;
            _loc_1 = new StyleSheet();
            _loc_1.setStyle("p", {
                color:"#000000",
                fontFamily:"_sans",
                fontSize:12
            });
            textField.styleSheet = _loc_1;
            addChild(textField);
            closeButton = new Sprite();
            closeButton.addChild(new CloseImage());
            addChild(closeButton);
            closeButton.useHandCursor = true;
            closeButton.buttonMode = true;
            closeButton.addEventListener(MouseEvent.CLICK, onCloseButton);
            addEventListener(MouseEvent.CLICK, stopMousePropagation);
            addEventListener(MouseEvent.MOUSE_DOWN, stopMousePropagation);
            addEventListener(MouseEvent.MOUSE_MOVE, stopMousePropagation);
        }
        private function onCloseButton(event:MouseEvent):void{
            visible = false;
        }
        private function redraw():void{
            var _loc_1:Number = NaN;
            if (boxWidth <= 0){
                return;
            };
            textField.width = (boxWidth - (CLOSE_W + (PAD_X * 3)));
            _loc_1 = (Math.max(textField.height, CLOSE_H) + (PAD_Y * 2));
            graphics.clear();
            graphics.beginFill(16773544);
            graphics.lineStyle(1, 0);
            graphics.drawRect(0, 0, boxWidth, _loc_1);
            graphics.endFill();
            closeButton.x = (boxWidth - (CLOSE_W + PAD_X));
            closeButton.y = PAD_Y;
        }
        private function stopMousePropagation(event:MouseEvent):void{
            event.stopPropagation();
        }
        public function setWidth(param1:Number):void{
            boxWidth = param1;
            redraw();
        }
        public function setText(param1:String):void{
            textField.width = 1000000;
            textField.htmlText = param1;
            visible = true;
            redraw();
        }

    }
}//package com.mapplus.maps.core 
