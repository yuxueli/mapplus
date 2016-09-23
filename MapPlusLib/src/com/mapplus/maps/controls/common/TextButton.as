//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.text.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;

    public class TextButton extends Button {

        private var minimalSize:Point;
        private var textField:TextField;
        private var buttonText:String;

        public function TextButton(param1:Sprite, param2:String, param3:Boolean){
            super(param1, param3);
            this.buttonText = param2;
            this.textField = new TextField();
            this.textField.type = TextFieldType.DYNAMIC;
            this.textField.selectable = false;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.mouseEnabled = false;
            this.mc.addChild(this.textField);
        }
        public function getText():String{
            return (this.buttonText);
        }
        private function changeTextLayout(param1:Point, param2:ButtonFaceStyle):void{
            var _loc_3:TextFormat;
            this.textField.width = param1.x;
            this.textField.height = param1.y;
            if (this.buttonText != null){
                this.textField.text = this.buttonText;
            };
            _loc_3 = param2.labelFormat;
            if (_loc_3 != null){
                this.textField.setTextFormat(_loc_3);
            };
            this.textField.x = ((param1.x - this.textField.width) / 2);
            this.textField.y = ((param1.y - this.textField.height) / 2);
        }
        override public function initialize(param1:String, param2:Point, param3:ButtonStyle):void{
            var _loc_4:Point;
            if (this.buttonText != null){
                this.textField.text = this.buttonText;
            };
            this.minimalSize = param2;
            _loc_4 = this.calculateSize(param2, param3);
            super.initialize(param1, _loc_4, param3);
        }
        override protected function setBevelStyle(param1:ButtonFaceStyle):void{
            this.changeTextLayout(getButtonSize(), param1);
            super.setBevelStyle(param1);
        }
        private function calculateSize(param1:Point, param2:ButtonStyle):Point{
            var _loc_3:Point;
            var _loc_4:Array;
            var _loc_5:ButtonFaceStyle;
            var _loc_6:TextFormat;
            _loc_3 = param1;
			
			if(_loc_3==null)
			{
				_loc_3=new Point();
			}
			
            if (this.buttonText == null || this.textField == null){
                return _loc_3;
            };
            _loc_4 = [param2.upState, param2.overState, param2.downState];
            this.textField.text = this.buttonText;
            for each (_loc_5 in _loc_4) {
                _loc_6 = _loc_5.labelFormat;
                if (_loc_6 == null)
				{
					continue;
                } 

                this.textField.setTextFormat(_loc_6);
                _loc_3 = new Point(Math.max(_loc_3.x, (this.textField.width + 2)), Math.max(_loc_3.y, (this.textField.height + 2)));
            };
            return (_loc_3);
        }
        override public function setButtonStyle(param1:ButtonStyle):void{
            this.initialize(this.getButtonId(), this.minimalSize, param1);
        }
        public function setText(param1:String):void{
            this.buttonText = param1;
            this.initialize(this.getButtonId(), this.minimalSize, this.getButtonStyle());
        }

    }
}//package com.mapplus.maps.controls.common 
