//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.interfaces.*;
    import flash.utils.*;
    import flash.display.*;
    import flash.events.*;
    import com.mapplus.maps.wrappers.*;

    public class OverlayBase extends WrappableComponent implements IOverlay, IEventDispatcher {

        private var _pane:IPane;

        public function OverlayBase(){
            super();
        }
        public function get shadow():DisplayObject{
            return (null);
        }
        override public function get visible():Boolean{
            return (super.visible);
        }
        public function get foreground():DisplayObject{
            return (this);
        }
        public function get pane():IPane{
            return (this._pane);
        }
        private function notImplemented(param1:String):String{
            return (((("Method not implemented: " + getQualifiedClassName(this)) + ".") + param1));
        }
        public function set pane(param1:IPane):void{
            this._pane = param1;
        }
        public function positionOverlay(param1:Boolean):void{
            throw (new Error(notImplemented("positionOverlay")));
        }
        public function getDefaultPane(param1:IMap):IPane{
            throw (new Error(notImplemented("getDefaultPane")));
        }
        override public function set visible(param1:Boolean):void{
            super.visible = param1;
            if (this.shadow != null){
                this.shadow.visible = param1;
            };
        }

    }
}//package com.mapplus.maps.overlays 
