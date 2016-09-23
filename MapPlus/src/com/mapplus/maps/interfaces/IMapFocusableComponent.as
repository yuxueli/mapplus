//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface IMapFocusableComponent extends IWrappableSprite {

        function releaseFocus():void;
        function get focusable():Boolean;
        function set focusable(param1:Boolean):void;
        function hasFocus():Boolean;
        function grabFocus():void;

    }
}//package com.mapplus.maps.interfaces 
