//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IMapFocusableComponentWrapper extends IWrappableSpriteWrapper implements IMapFocusableComponent {

        public function IMapFocusableComponentWrapper(){
            super();
        }
        public function set focusable(param1:Boolean):void{
            Wrapper.checkValid(this.instance);
            this.instance.focusable = param1;
        }
        public function hasFocus():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.hasFocus());
        }
        override public function get interfaceChain():Array{
            return (["IMapFocusableComponent", "IWrappableSprite"]);
        }
        public function get focusable():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.focusable);
        }
        public function releaseFocus():void{
            Wrapper.checkValid(this.instance);
            this.instance.releaseFocus();
        }
        public function grabFocus():void{
            Wrapper.checkValid(this.instance);
            this.instance.grabFocus();
        }

    }
}//package com.mapplus.maps.wrappers 
