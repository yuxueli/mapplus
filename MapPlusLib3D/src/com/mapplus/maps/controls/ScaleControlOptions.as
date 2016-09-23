//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.text.*;

    public class ScaleControlOptions {

        public static const UNITS_IMPERIAL_ONLY:int = 6;
        public static const UNITS_METRIC_ONLY:int = 5;
        public static const UNITS_BOTH:int = 0;
        public static const UNITS_BOTH_PREFER_METRIC:int = 1;
        public static const UNITS_BOTH_PREFER_IMPERIAL:int = 2;
        public static const UNITS_SINGLE:int = 4;

        private var _maxWidth:Object;
        private var _position:ControlPosition;
        private var _labelFormat:TextFormat;
        private var _units:Object;
        private var _lineThickness:Object;

        public function ScaleControlOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):ScaleControlOptions{
            var _loc_2:ScaleControlOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (ScaleControlOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function merge(param1:Array):ScaleControlOptions{
            return ((Wrapper.mergeStyles(ScaleControlOptions, param1) as ScaleControlOptions));
        }

        public function set lineThickness(param1:Object):void{
            if ((param1 is int)){
                this._lineThickness = int(param1);
            };
        }
        public function set maxWidth(param1:Object):void{
            if ((param1 is Number)){
                this._maxWidth = Number(param1);
            };
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["units", "lineThickness", "maxWidth"], Number);
            if (((param1.hasOwnProperty("position")) && (!((param1.position == null))))){
                this.position = ControlPosition.fromObject(param1.position);
            };
            if (param1.labelFormat != null){
                if (this.labelFormat == null){
                    this.labelFormat = new TextFormat();
                };
                Wrapper.copyTextFormatProperties(this.labelFormat, param1.labelFormat);
            };
        }
        public function get labelFormat():TextFormat{
            return (this._labelFormat);
        }
        public function get lineThickness():Object{
            return (this._lineThickness);
        }
        public function get maxWidth():Object{
            return (this._maxWidth);
        }
        public function set position(param1:ControlPosition):void{
            this._position = param1;
        }
        public function set labelFormat(param1:TextFormat):void{
            this._labelFormat = param1;
        }
        public function toString():String{
            return ((((((((((("ScaleControlOptions:\n\t{ position: " + this._position) + "\n\t  units: ") + this._units) + "\n\t  lineThickness: ") + this._lineThickness) + "\n\t  maxWidth: ") + this._maxWidth) + "\n\t  labelFormat: ") + this._labelFormat) + " }"));
        }
        public function get units():Object{
            return (this._units);
        }
        public function get position():ControlPosition{
            return (this._position);
        }
        public function set units(param1:Object):void{
            if ((param1 is int)){
                this._units = int(param1);
            };
        }

    }
}//package com.mapplus.maps.controls 
