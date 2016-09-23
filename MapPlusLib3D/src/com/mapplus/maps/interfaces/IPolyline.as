//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;

    public interface IPolyline extends IOverlay {

        function getLatLngBounds():LatLngBounds;
        function hide():void;
        function isHidden():Boolean;
        function getVertexCount():Number;
        function getOptions():PolylineOptions;
        function getVertex(param1:Number):LatLng;
        function setOptions(param1:PolylineOptions):void;
        function getLength(param1:Number=6378137):Number;
        function show():void;

    }
}//package com.mapplus.maps.interfaces 
