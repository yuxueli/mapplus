//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;

    public class ButtonStyle {

        private var _downState:ButtonFaceStyle;
        private var _upState:ButtonFaceStyle;
        private var _overState:ButtonFaceStyle;

        public function ButtonStyle(param1:Object=null){
            super();
            this.copyFromObject((param1) ? param1 : {});
        }
        public static function fromObject(param1:Object):ButtonStyle{
            var _loc_2:ButtonStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (ButtonStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function mergeStyles(param1:Array):ButtonStyle{
            return ((Wrapper.mergeStyles(ButtonStyle, param1) as ButtonStyle));
        }

        public function get allStates():ButtonFaceStyle{
            return (null);
        }
        public function set downState(param1:ButtonFaceStyle):void{
            this._downState = param1;
        }
        public function setAllStates(param1:ButtonFaceStyle):void{
            if (!(param1)){
                return;
            };
            if (!(this._upState)){
                this._upState = new ButtonFaceStyle();
            };
            this._upState.copyFromObject(param1);
            if (!(this._overState)){
                this._overState = new ButtonFaceStyle();
            };
            this._overState.copyFromObject(param1);
            if (!(this._downState)){
                this._downState = new ButtonFaceStyle();
            };
            this._downState.copyFromObject(param1);
        }
        public function set upState(param1:ButtonFaceStyle):void{
            this._upState = param1;
        }
        public function copyFromObject(param1:Object):void{
            var _loc_2:ButtonFaceStyle;
            _loc_2 = new ButtonFaceStyle();
            if (param1.allStates){
                _loc_2.copyFromObject(param1.allStates);
            };
            this.setAllStates(_loc_2);
            if (param1.upState){
                this.upState.copyFromObject(param1.upState);
            };
            if (param1.downState){
                this.downState.copyFromObject(param1.downState);
            };
            if (param1.overState){
                this.overState.copyFromObject(param1.overState);
            };
        }
        public function get downState():ButtonFaceStyle{
            return (this._downState);
        }
        public function get upState():ButtonFaceStyle{
            return (this._upState);
        }
        public function set overState(param1:ButtonFaceStyle):void{
            this._overState = param1;
        }
        public function toString():String{
            return ((((((("ButtonStyle: { upState: " + this._upState) + ", overState: ") + this._overState) + ", downState: ") + this._downState) + " }"));
        }
        public function get overState():ButtonFaceStyle{
            return (this._overState);
        }

    }
}//package com.mapplus.maps.styles 
