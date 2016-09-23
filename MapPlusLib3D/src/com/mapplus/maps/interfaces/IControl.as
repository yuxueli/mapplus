//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.controls.*;

    public interface IControl extends IWrappableEventDispatcher {

        function getControlPosition():ControlPosition;
        function initControlWithMap(param1:IMap):void;
        function getDisplayObject():DisplayObject;
        function setControlPosition(param1:ControlPosition):void;
        function getSize():Point;

    }
}//package com.mapplus.maps.interfaces 
