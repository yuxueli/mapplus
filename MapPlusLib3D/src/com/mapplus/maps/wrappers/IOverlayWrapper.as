//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;

    public class IOverlayWrapper extends EventDispatcherWrapper implements IOverlay {

        public function IOverlayWrapper(){
            super();
        }
        public function set visible(param1:Boolean):void{
            Wrapper.checkValid(this.instance);
            this.instance.visible = param1;
        }
        public function get pane():IPane{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPane(this.instance.pane));
        }
        public function get foreground():DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.foreground);
        }
        public function positionOverlay(param1:Boolean):void{
            Wrapper.checkValid(this.instance);
            this.instance.positionOverlay(param1);
        }
        override public function get interfaceChain():Array{
            return (["IOverlay"]);
        }
        public function set pane(param1:IPane):void{
            Wrapper.checkValid(this.instance);
            this.instance.pane = this.extWrapper.wrapIPane(param1);
        }
        public function get visible():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.visible);
        }
        public function get shadow():DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.shadow);
        }
        public function getDefaultPane(param1:IMap):IPane{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPane(this.instance.getDefaultPane(this.extWrapper.wrapIMap(param1))));
        }

    }
}//package com.mapplus.maps.wrappers 
