//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;

    public interface IMouse {

        function removeGlobalMouseMoveListener(param1:Function):Boolean;
        function addGlobalMouseMoveListener(param1:Function):void;
        function reportMouseEvent(event:MouseEvent):void;
        function removeGlobalMouseUpListener(param1:Function):Boolean;
        function addGlobalMouseUpListener(param1:Function):void;
        function addListener(param1:DisplayObject, param2:String, param3:Function, param4:Boolean=false):void;
        function startDrag(param1:Sprite, param2:Boolean=false, param3:Rectangle=null):void;
        function removeListener(param1:DisplayObject, param2:String, param3:Function, param4:Boolean=false):void;
        function stopDrag(param1:Sprite):void;

    }
}//package com.mapplus.maps.core 
