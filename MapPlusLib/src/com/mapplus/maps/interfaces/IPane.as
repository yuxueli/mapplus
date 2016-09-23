//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import flash.geom.*;

    public interface IPane extends IWrappableEventDispatcher {

        function fromPaneCoordsToLatLng(param1:Point, param2:Boolean=false):LatLng;
        function updatePosition(param1:Boolean=false):void;
        function clear():void;
        function fromProjectionPointToPaneCoords(param1:Point):Point;
        function get id():uint;
        function get map():IMap;
        function set visible(param1:Boolean):void;
        function get paneManager():IPaneManager;
        function bringToTop(param1:IOverlay):void;
        function removeOverlay(param1:IOverlay):void;
        function addOverlay(param1:IOverlay):void;
        function getViewportBounds():Rectangle;
        function get visible():Boolean;
        function fromPaneCoordsToProjectionPoint(param1:Point):Point;
        function fromLatLngToPaneCoords(param1:LatLng, param2:Boolean=false):Point;
        function invalidate():void;

    }
}//package com.mapplus.maps.interfaces 
