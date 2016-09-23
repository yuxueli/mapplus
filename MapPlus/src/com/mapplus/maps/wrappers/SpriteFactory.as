//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import mx.core.*;

    public final class SpriteFactory extends WrapperBase implements ISpriteFactory {

        public function SpriteFactory(){
            super();
        }
        public function getChildCount(param1:DisplayObjectContainer):int{
            return (param1.numChildren);
        }
        public function removeChildAt(param1:DisplayObjectContainer, param2:int):DisplayObject{
            return (param1.removeChildAt(param2));
        }
        public function addChildAt(param1:DisplayObjectContainer, param2:DisplayObject, param3:int):DisplayObject{
            return (param1.addChildAt(param2, param3));
        }
        public function get version():int{
            return (3);
        }
        public function isUIComponent(param1:DisplayObject):Boolean{
            if ((param1 is UIComponent)){
                return (true);
            };
            return (false);
        }
        public function createComponentContainer(param1:DisplayObject):IWrappableSprite{
            return (new WrappableComponentContainer(param1));
        }
        public function createSprite():IWrappableSprite{
            return (new WrappableSprite());
        }
        public function toWrappableSprite(param1:DisplayObject):IWrappableSprite{
            return ((param1 as IWrappableSprite));
        }
        public function getEventDispatcher(param1:DisplayObject):IWrappableEventDispatcher{
            var _loc_2:IWrappableEventDispatcher;
            var _loc_3:EventDispatcherWrapper;
            _loc_2 = toWrappableSprite(param1);
            if (_loc_2 == null){
                _loc_3 = new EventDispatcherWrapper();
                _loc_3.initializeEventDispatcher(param1);
                _loc_2 = _loc_3;
            };
            return (_loc_2);
        }
        public function getParent(param1:DisplayObject):DisplayObjectContainer{
            return (param1.parent);
        }
        public function createComponent():IWrappableSprite{
            return (new WrappableComponent());
        }
        public function addChild(param1:DisplayObjectContainer, param2:DisplayObject):DisplayObject{
            return (param1.addChild(param2));
        }
        public function removeChild(param1:DisplayObjectContainer, param2:DisplayObject):DisplayObject{
            return (param1.removeChild(param2));
        }

    }
}//package com.mapplus.maps.wrappers 
