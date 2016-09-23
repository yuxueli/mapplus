//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface IMapFocusableComponent extends IWrappableSprite {

        function set focusable(param1:Boolean):void;
        function grabFocus():void;
        function releaseFocus():void;
        function get focusable():Boolean;
        function hasFocus():Boolean;

    }
}//package com.mapplus.maps.interfaces 
