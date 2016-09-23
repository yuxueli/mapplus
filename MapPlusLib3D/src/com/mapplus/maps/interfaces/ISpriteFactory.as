//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;

    public interface ISpriteFactory extends IWrappable {

        function createComponentContainer(param1:DisplayObject):IWrappableSprite;
        function createSprite():IWrappableSprite;
        function isUIComponent(param1:DisplayObject):Boolean;
        function getParent(param1:DisplayObject):DisplayObjectContainer;
        function createComponent():IWrappableSprite;
        function getChildCount(param1:DisplayObjectContainer):int;
        function toWrappableSprite(param1:DisplayObject):IWrappableSprite;
        function removeChildAt(_arg1:DisplayObjectContainer, _arg2:int):DisplayObject;
        function addChildAt(_arg1:DisplayObjectContainer, _arg2:DisplayObject, _arg3:int):DisplayObject;
        function getEventDispatcher(param1:DisplayObject):IWrappableEventDispatcher;
        function get version():int;
        function addChild(_arg1:DisplayObjectContainer, _arg2:DisplayObject):DisplayObject;
        function removeChild(_arg1:DisplayObjectContainer, _arg2:DisplayObject):DisplayObject;

    }
}//package com.mapplus.maps.interfaces 
