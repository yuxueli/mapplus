//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public interface IMapBase2 extends IMapBase {

        function get overlayRaising():Boolean;
        function set overlayRaising(param1:Boolean):void;
        function set mouseClickRange(param1:Number):void;
        function closeInfoWindow():Boolean;
        function openInfoWindow(_arg1:LatLng, _arg2:InfoWindowOptions=null):IInfoWindow;
        function openInfoWindowOnOverlay(_arg1:LatLng, _arg2:IOverlay, _arg3:InfoWindowOptions=null):IInfoWindow;
        function get mouseClickRange():Number;
        function getPane(param1:int):IPane;
        function getPaneManager():IPaneManager;

    }
}//package com.mapplus.maps.core 
