//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;

    public interface IMouse {

        function addGlobalMouseUpListener(param1:Function):void;
        function removeGlobalMouseMoveListener(param1:Function):Boolean;
        function addListener(_arg1:DisplayObject, _arg2:String, _arg3:Function, _arg4:Boolean=false):void;
        function addGlobalMouseMoveListener(param1:Function):void;
        function removeListener(_arg1:DisplayObject, _arg2:String, _arg3:Function, _arg4:Boolean=false):void;
        function reportMouseEvent(param1:MouseEvent):void;
        function removeGlobalMouseUpListener(param1:Function):Boolean;
        function startDrag(_arg1:Sprite, _arg2:Boolean=false, _arg3:Rectangle=null):void;
        function stopDrag(param1:Sprite):void;

    }
}//package com.mapplus.maps.core 
