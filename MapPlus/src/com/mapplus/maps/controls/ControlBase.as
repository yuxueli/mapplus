//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.geom.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;

    public class ControlBase extends WrappableComponent implements IControl {

        protected var map:IMap;
        protected var position:ControlPosition;

        public function ControlBase(param1:ControlPosition){
            super();
            this.position = param1;
            this.map = null;
        }
        public function initControlWithMap(param1:IMap):void{
            this.map = param1;
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.position = param1;
            this.map.placeControl(this, getControlPosition());
        }
        public function getDisplayObject():DisplayObject{
            return (this);
        }
        override public function get interfaceChain():Array{
            return (["IControl"]);
        }
        public function getControlPosition():ControlPosition{
            return (this.position);
        }
        public function getSize():Point{
            return (new Point(this.width, this.height));
        }

    }
}//package com.mapplus.maps.controls 
