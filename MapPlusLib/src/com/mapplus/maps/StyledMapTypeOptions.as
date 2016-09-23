//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.interfaces.*;

    public class StyledMapTypeOptions {

        private var _minResolution:Object;
        private var _baseMapType:IStyledMapType;
        private var _alt:String;
        private var _maxResolution:Object;
        private var _name:String;

        public function StyledMapTypeOptions(param1:Object=null){
            super();
            if (param1){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):StyledMapTypeOptions{
            return ((Wrapper.mergeStyles(StyledMapTypeOptions, param1) as StyledMapTypeOptions));
        }
        public static function fromObject(param1:Object):StyledMapTypeOptions{
            var _loc_2:StyledMapTypeOptions;
            if (!(param1)){
                return (null);
            };
            _loc_2 = new (StyledMapTypeOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function set baseMapType(param1:Object):void{
            this._baseMapType = (param1 as IStyledMapType);
        }
        public function get name():String{
            return (this._name);
        }
        public function set alt(param1:String):void{
            this._alt = param1;
        }
        public function set name(param1:String):void{
            this._name = param1;
        }
        public function get minResolution():Object{
            return (this._minResolution);
        }
        public function set maxResolution(param1:Object):void{
            this._maxResolution = (param1 as Number);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["maxResolution", "minResolution"], Number);
            Wrapper.copyProperties(this, param1, ["name", "alt"], String);
            if (param1.baseMapType){
                this.baseMapType = Wrapper.instance().wrapIStyledMapType(param1.baseMapType);
            };
        }
        public function get alt():String{
            return (this._alt);
        }
        public function get baseMapType():Object{
            return (this._baseMapType);
        }
        public function get maxResolution():Object{
            return (this._maxResolution);
        }
        public function toString():String{
            return ((((((((("StyledMapTypeOptions: { minResolution: " + this._minResolution) + "\n  maxResolution: ") + this._maxResolution) + "\n  name: ") + this._name) + "\n  alt: ") + this._alt) + " }"));
        }
        public function set minResolution(param1:Object):void{
            this._minResolution = (param1 as Number);
        }

    }
}//package com.mapplus.maps 
