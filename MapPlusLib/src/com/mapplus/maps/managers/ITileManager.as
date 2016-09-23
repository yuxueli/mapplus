//Created by yuxueli 2011.6.6
package com.mapplus.maps.managers {

    public interface ITileManager {

        function setTargetZoom(param1:int, param2:Boolean):void;
        function iterateBlend():void;
        function destroy():void;
        function isAnimatingBlend():Boolean;

    }
}//package com.mapplus.maps.managers 
