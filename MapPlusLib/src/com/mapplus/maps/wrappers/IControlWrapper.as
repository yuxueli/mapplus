//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;
    import flash.geom.*;

    public class IControlWrapper extends IWrappableSpriteWrapper implements IControl {

        public function IControlWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IControl", "IWrappableSprite"]);
        }
        public function initControlWithMap(param1:IMap):void{
            Wrapper.checkValid(this.instance);
            this.instance.initControlWithMap(this.extWrapper.wrapIMap(param1));
        }
        public function setControlPosition(param1:ControlPosition):void{
            Wrapper.checkValid(this.instance);
            this.instance.setControlPosition(this.extWrapper.wrapControlPosition(param1));
        }
        public function getControlPosition():ControlPosition{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapControlPosition(this.instance.getControlPosition()));
        }
        public function getDisplayObject():DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.getDisplayObject());
        }
        public function getSize():Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.getSize());
        }

    }
}//package com.mapplus.maps.wrappers 
