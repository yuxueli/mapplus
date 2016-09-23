//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import com.mapplus.maps.styles.*;

    public class TextButton extends Button {

        private var minimalSize:Point;
        private var textField:TextField;
        private var buttonText:String;

        public function TextButton(param1:Sprite, param2:String, param3:Boolean){
            super(param1, param3);
            buttonText = param2;
            textField = new TextField();
            textField.type = TextFieldType.DYNAMIC;
            textField.selectable = false;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.mouseEnabled = false;
            this.mc.addChild(textField);
        }
        public function getText():String{
            return (buttonText);
        }
        private function calculateSize(param1:Point, param2:ButtonStyle):Point{
            var _loc_3:Point;
            var _loc_4:Array;
            var _loc_5:ButtonFaceStyle;
            var _loc_6:TextFormat;
            _loc_3 = param1;
            if ((((buttonText == null)) || ((this.textField == null)))){
                return (_loc_3);
            };
            _loc_4 = [param2.upState, param2.overState, param2.downState];
            this.textField.text = this.buttonText;
            for each (_loc_5 in _loc_4) {
                _loc_6 = _loc_5.labelFormat;
                if (_loc_6 == null){
                } else {
                    this.textField.setTextFormat(_loc_6);
                    _loc_3 = new Point(Math.max(_loc_3.x, (textField.width + 2)), Math.max(_loc_3.y, (textField.height + 2)));
                };
            };
            return (_loc_3);
        }
        private function changeTextLayout(param1:Point, param2:ButtonFaceStyle):void{
            var _loc_3:TextFormat;
            textField.width = param1.x;
            textField.height = param1.y;
            if (buttonText != null){
                textField.text = buttonText;
            };
            _loc_3 = param2.labelFormat;
            if (_loc_3 != null){
                textField.setTextFormat(_loc_3);
            };
            textField.x = ((param1.x - textField.width) / 2);
            textField.y = ((param1.y - textField.height) / 2);
        }
        public function setText(param1:String):void{
            this.buttonText = param1;
            initialize(this.getButtonId(), this.minimalSize, this.getButtonStyle());
        }
        override public function initialize(param1:String, param2:Point, param3:ButtonStyle):void{
            var _loc_4:Point;
            if (buttonText != null){
                textField.text = buttonText;
            };
            this.minimalSize = param2;
            _loc_4 = calculateSize(param2, param3);
            super.initialize(param1, _loc_4, param3);
        }
        override protected function setBevelStyle(param1:ButtonFaceStyle):void{
            changeTextLayout(getButtonSize(), param1);
            super.setBevelStyle(param1);
        }
        override public function setButtonStyle(param1:ButtonStyle):void{
            initialize(this.getButtonId(), this.minimalSize, param1);
        }

    }
}//package com.mapplus.maps.controls.common 
