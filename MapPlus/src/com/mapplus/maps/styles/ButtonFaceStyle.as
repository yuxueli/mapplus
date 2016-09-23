//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;
    import flash.text.*;

    public class ButtonFaceStyle extends BevelStyle {

        private var _labelFormat:TextFormat = null;

        public function ButtonFaceStyle(param1:Object=null){
            _labelFormat = null;
            super(null);
            if (param1 != null){
                copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):ButtonFaceStyle{
            var _loc_2:ButtonFaceStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (ButtonFaceStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function mergeStyles(param1:Array):ButtonFaceStyle{
            return ((Wrapper.mergeStyles(ButtonFaceStyle, param1) as ButtonFaceStyle));
        }

        override public function toString():String{
            return (((((("ButtonFaceStyle: { " + "\n\t") + super.toString()) + "\n\tlabelFormat: ") + this._labelFormat) + " } "));
        }
        public function set labelFormat(param1:TextFormat):void{
            this._labelFormat = param1;
        }
        public function get labelFormat():TextFormat{
            return (this._labelFormat);
        }
        override public function copyFromObject(param1:Object):void{
            super.copyFromObject(param1);
            if (param1.labelFormat != null){
                if (this.labelFormat == null){
                    this.labelFormat = new TextFormat();
                };
                Wrapper.copyTextFormatProperties(this.labelFormat, param1.labelFormat);
            };
        }

    }
}//package com.mapplus.maps.styles 
