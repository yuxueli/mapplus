//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;

    public class MapTypeOptions {

        private var _urlArg:String;
        private var _linkColor:Object;
        private var _minResolution:Object;
        private var _shortName:String;
        private var _alt:String;
        private var _tileSize:Object;
        private var _radius:Object;
        private var _textColor:Object;
        private var _maxResolution:Object;
        private var _errorMessage:String;

        public function MapTypeOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):MapTypeOptions{
            return ((Wrapper.mergeStyles(MapTypeOptions, param1) as MapTypeOptions));
        }
        public static function fromObject(param1:Object):MapTypeOptions{
            var _loc_2:MapTypeOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (MapTypeOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function set minResolution(param1:Object):void{
            this._minResolution = (param1 as Number);
        }
        public function set errorMessage(param1:String):void{
            this._errorMessage = param1;
        }
        public function get linkColor():Object{
            return (this._linkColor);
        }
        public function set shortName(param1:String):void{
            this._shortName = param1;
        }
        public function get tileSize():Object{
            return (this._tileSize);
        }
        public function set linkColor(param1:Object):void{
            this._linkColor = (param1 as Number);
        }
        public function set urlArg(param1:String):void{
            this._urlArg = param1;
        }
        public function set alt(param1:String):void{
            this._alt = param1;
        }
        public function get minResolution():Object{
            return (this._minResolution);
        }
        public function set maxResolution(param1:Object):void{
            this._maxResolution = (param1 as Number);
        }
        public function get radius():Object{
            return (this._radius);
        }
        public function set radius(param1:Object):void{
            this._radius = (param1 as Number);
        }
        public function set tileSize(param1:Object):void{
            this._tileSize = (param1 as Number);
        }
        public function get errorMessage():String{
            return (this._errorMessage);
        }
        public function get shortName():String{
            return (this._shortName);
        }
        public function set textColor(param1:Object):void{
            this._textColor = (param1 as Number);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["maxResolution", "minResolution", "tileSize", "textColor", "linkColor", "radius"], Number);
            Wrapper.copyProperties(this, param1, ["shortName", "urlArg", "errorMessage", "alt"], String);
        }
        public function get alt():String{
            return (this._alt);
        }
        public function get urlArg():String{
            return (this._urlArg);
        }
        public function toString():String{
            return ((((((((((((((((((((("MapTypeOptions: { shortName: " + this._shortName) + "\n\t  urlArg: ") + this._urlArg) + "\n\t  maxResolution: ") + this._maxResolution) + "\n\t  minResolution: ") + this._minResolution) + "\n\t  tileSize: ") + this._tileSize) + "\n\t  textColor: ") + this._textColor) + "\n\t  linkColor: ") + this._linkColor) + "\n\t  errorMessage: ") + this._errorMessage) + "\n\t  alt: ") + this._alt) + "\n\t  radius: ") + this._radius) + " }"));
        }
        public function get textColor():Object{
            return (this._textColor);
        }
        public function get maxResolution():Object{
            return (this._maxResolution);
        }

    }
}//package com.mapplus.maps 
