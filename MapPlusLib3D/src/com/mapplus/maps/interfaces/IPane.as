//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.geom.*;
    import com.mapplus.maps.*;

    public interface IPane extends IWrappableEventDispatcher {

        function getViewportBounds():Rectangle;
        function invalidate():void;
        function set visible(param1:Boolean):void;
        function get paneManager():IPaneManager;
        function bringToTop(param1:IOverlay):void;
        function fromLatLngToPaneCoords(_arg1:LatLng, _arg2:Boolean=false):Point;
        function removeOverlay(param1:IOverlay):void;
        function clear():void;
        function addOverlay(param1:IOverlay):void;
        function fromPaneCoordsToLatLng(_arg1:Point, _arg2:Boolean=false):LatLng;
        function updatePosition(param1:Boolean=false):void;
		function fromPaneCoordsToProjectionPoint(param1:Point):Point;
		function fromProjectionPointToPaneCoords(param1:Point):Point;
		function get visible():Boolean;
        function get id():uint;
        function get map():IMap;

    }
}//package com.mapplus.maps.interfaces 
