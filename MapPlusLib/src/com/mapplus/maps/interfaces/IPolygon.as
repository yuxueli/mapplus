//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;

    public interface IPolygon extends IOverlay {

        function setPolyline(param1:int, param2:Array):void;
        function getOuterVertex(param1:int):LatLng;
        function getInnerVertexCount(param1:int):int;
        function isHidden():Boolean;
        function getLatLngBounds():LatLngBounds;
        function getVertexCount(param1:int):int;
        function setOptions(param1:PolygonOptions):void;
        function getOuterVertexCount():int;
        function getVertex(param1:int, param2:int):LatLng;
        function setPolylineFromEncoded(param1:int, param2:EncodedPolylineData):void;
        function getInnerVertex(param1:int, param2:int):LatLng;
        function getInnerPolylineCount():int;
        function removePolyline(param1:int):void;
        function getOptions():PolygonOptions;
        function getPolylineCount():int;
        function hide():void;
        function show():void;

    }
}//package com.mapplus.maps.interfaces 
