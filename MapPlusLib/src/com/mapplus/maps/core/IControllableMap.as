//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import flash.geom.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;

    public interface IControllableMap extends IMapBase {

        function returnToSavedPosition():void;
        function removeMapType(param1:IMapType):void;
        function panBy(param1:Point, param2:Boolean=true):void;
        function placeControl(param1:IControl, param2:ControlPosition):void;
        function addMapType(param1:IMapType):void;
        function getMaxZoomLevel(param1:IMapType=null, param2:LatLng=null):Number;
        function savePosition():void;
        function getMinZoomLevel(param1:IMapType=null, param2:LatLng=null):Number;
        function panTo(param1:LatLng):void;
        function getMapTypes():Array;

    }
}//package com.mapplus.maps.core 
