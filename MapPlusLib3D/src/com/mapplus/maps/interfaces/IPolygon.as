//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;

    public interface IPolygon extends IOverlay {

        function setPolyline(_arg1:int, _arg2:Array):void;
        function getInnerVertex(_arg1:int, _arg2:int):LatLng;
        function getOuterVertexCount():int;
        function getOptions():PolygonOptions;
        function getOuterVertex(param1:int):LatLng;
        function getInnerVertexCount(param1:int):int;
        function show():void;
        function setPolylineFromEncoded(_arg1:int, _arg2:EncodedPolylineData):void;
        function getLatLngBounds():LatLngBounds;
        function isHidden():Boolean;
        function getVertexCount(param1:int):int;
        function getInnerPolylineCount():int;
        function getPolylineCount():int;
        function getVertex(_arg1:int, _arg2:int):LatLng;
        function hide():void;
        function setOptions(_arg1:PolygonOptions):void;
        function removePolyline(_arg1:int):void;

    }
}//package com.mapplus.maps.interfaces 
