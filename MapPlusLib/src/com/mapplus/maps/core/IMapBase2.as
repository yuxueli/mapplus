//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public interface IMapBase2 extends IMapBase {

        function get mouseClickRange():Number;
        function closeInfoWindow():Boolean;
        function getPane(param1:int):IPane;
        function openInfoWindow(param1:LatLng, param2:InfoWindowOptions=null):IInfoWindow;
        function getPaneManager():IPaneManager;
        function openInfoWindowOnOverlay(param1:LatLng, param2:IOverlay, param3:InfoWindowOptions=null):IInfoWindow;
        function set overlayRaising(param1:Boolean):void;
        function set mouseClickRange(param1:Number):void;
        function get overlayRaising():Boolean;

    }
}//package com.mapplus.maps.core 
