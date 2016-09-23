//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;

    public interface IPolygon extends IOverlay {

        function setPolyline(param1:int, param2:Array):void;
        function getInnerVertex(param1:int, param2:int):LatLng;
        function getOuterVertexCount():int;
        function getOptions():PolygonOptions;
        function getOuterVertex(param1:int):LatLng;
        function getInnerVertexCount(param1:int):int;
        function show():void;
        function setPolylineFromEncoded(param1:int, param2:EncodedPolylineData):void;
        function getLatLngBounds():LatLngBounds;
        function isHidden():Boolean;
        function getVertexCount(param1:int):int;
        function getInnerPolylineCount():int;
        function getPolylineCount():int;
        function getVertex(param1:int, param2:int):LatLng;
        function hide():void;
        function setOptions(param1:PolygonOptions):void;
        function removePolyline(param1:int):void;

    }
}//package com.mapplus.maps.interfaces 
