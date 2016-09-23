//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;

    public interface IControllableMap extends IMapBase {

        function removeMapType(param1:IMapType):void;
        function panBy(_arg1:Point, _arg2:Boolean=true):void;
        function returnToSavedPosition():void;
        function placeControl(_arg1:IControl, _arg2:ControlPosition):void;
        function getMinZoomLevel(_arg1:IMapType=null, _arg2:LatLng=null):Number;
        function panTo(param1:LatLng):void;
        function getMaxZoomLevel(_arg1:IMapType=null, _arg2:LatLng=null):Number;
        function getMapTypes():Array;
        function addMapType(param1:IMapType):void;
        function savePosition():void;

    }
}//package com.mapplus.maps.core 
