//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;

    public interface IOverlay extends IWrappableEventDispatcher {

        function getDefaultPane(param1:IMap):IPane;
        function get foreground():DisplayObject;
        function set visible(param1:Boolean):void;
        function positionOverlay(param1:Boolean):void;
        function set pane(param1:IPane):void;
        function get visible():Boolean;
        function get pane():IPane;
        function get shadow():DisplayObject;

    }
}//package com.mapplus.maps.interfaces 
