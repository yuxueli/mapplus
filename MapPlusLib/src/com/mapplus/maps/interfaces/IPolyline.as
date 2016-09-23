//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;

    public interface IPolyline extends IOverlay {

        function hide():void;
        function getLatLngBounds():LatLngBounds;
        function getVertexCount():Number;
        function getLength(param1:Number=6378137):Number;
        function getVertex(param1:Number):LatLng;
        function setOptions(param1:PolylineOptions):void;
        function getOptions():PolylineOptions;
        function isHidden():Boolean;
        function show():void;
    }
}//package com.mapplus.maps.interfaces 
