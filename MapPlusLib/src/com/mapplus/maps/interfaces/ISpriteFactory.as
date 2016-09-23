//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;

    public interface ISpriteFactory extends IWrappable {

        function createComponentContainer(param1:DisplayObject):IWrappableSprite;
        function getParent(param1:DisplayObject):DisplayObjectContainer;
        function getChildCount(param1:DisplayObjectContainer):int;
        function toWrappableSprite(param1:DisplayObject):IWrappableSprite;
        function getEventDispatcher(param1:DisplayObject):IWrappableEventDispatcher;
        function addChildAt(param1:DisplayObjectContainer, param2:DisplayObject, param3:int):DisplayObject;
        function createSprite():IWrappableSprite;
        function removeChildAt(param1:DisplayObjectContainer, param2:int):DisplayObject;
        function get version():int;
        function createComponent():IWrappableSprite;
        function removeChild(param1:DisplayObjectContainer, param2:DisplayObject):DisplayObject;
        function addChild(param1:DisplayObjectContainer, param2:DisplayObject):DisplayObject;
        function isUIComponent(param1:DisplayObject):Boolean;

    }
}//package com.mapplus.maps.interfaces 
