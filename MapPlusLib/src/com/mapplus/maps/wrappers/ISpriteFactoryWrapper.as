//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;

    public class ISpriteFactoryWrapper extends WrapperBase implements ISpriteFactory {

        public function ISpriteFactoryWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["ISpriteFactory"]);
        }
        public function getChildCount(param1:DisplayObjectContainer):int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getChildCount(param1));
        }
        public function addChild(param1:DisplayObjectContainer, param2:DisplayObject):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.addChild(param1, param2));
        }
        public function removeChildAt(param1:DisplayObjectContainer, param2:int):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.removeChildAt(param1, param2));
        }
        public function addChildAt(param1:DisplayObjectContainer, param2:DisplayObject, param3:int):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.addChildAt(param1, param2, param3));
        }
        public function get version():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.version);
        }
        public function createComponentContainer(param1:DisplayObject):IWrappableSprite{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIWrappableSprite(this.instance.createComponentContainer(param1)));
        }
        public function createComponent():IWrappableSprite{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIWrappableSprite(this.instance.createComponent()));
        }
        public function createSprite():IWrappableSprite{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIWrappableSprite(this.instance.createSprite()));
        }
        public function getEventDispatcher(param1:DisplayObject):IWrappableEventDispatcher{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIWrappableEventDispatcher(this.instance.getEventDispatcher(param1)));
        }
        public function isUIComponent(param1:DisplayObject):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isUIComponent(param1));
        }
        public function getParent(param1:DisplayObject):DisplayObjectContainer{
            Wrapper.checkValid(this.instance);
            return (this.instance.getParent(param1));
        }
        public function toWrappableSprite(param1:DisplayObject):IWrappableSprite{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIWrappableSprite(this.instance.toWrappableSprite(param1)));
        }
        public function removeChild(param1:DisplayObjectContainer, param2:DisplayObject):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.removeChild(param1, param2));
        }

    }
}//package com.mapplus.maps.wrappers 
