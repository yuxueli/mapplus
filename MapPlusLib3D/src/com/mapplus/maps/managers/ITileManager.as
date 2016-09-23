//Created by yuxueli 2011.6.6
package com.mapplus.maps.managers {

    public interface ITileManager {

        function destroy():void;
        function isAnimatingBlend():Boolean;
        function setTargetZoom(_arg1:int, _arg2:Boolean):void;
        function iterateBlend():void;

    }
}//package com.mapplus.maps.managers 
