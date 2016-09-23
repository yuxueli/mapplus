//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.geom.*;

    public interface ICamera extends IWrappableEventDispatcher {

        function get maxRoll():Number;
        function get minYaw():Number;
        function get shadowMatrix():Matrix;
        function getLatLngClosestToCenter(param1:LatLng):LatLng;
        function get minPitch():Number;
        function getTransformationGeometry():TransformationGeometry;
        function worldToLatLng(param1:Point):LatLng;
        function get center():LatLng;
        function viewportToWorld(param1:Point):Point;
        function getWorldViewPolygon():Array;
        function get zoom():Number;
        function get is3D():Boolean;
        function get viewport():Point;
        function latLngToViewport(param1:LatLng):Point;
        function get attitude():Attitude;
        function get maxYaw():Number;
        function viewportToLatLng(param1:Point):LatLng;
        function get minRoll():Number;
        function latLngToWorld(param1:LatLng):Point;
        function get focalLength():Number;
        function isOnMap(param1:Point):Boolean;
        function worldDistance(param1:Point):Number;
        function get zoomScale():Number;
        function worldToViewport(param1:Point):Point;
        function get maxPitch():Number;
        function getTransformationCoefficients():Array;
        function isAhead(param1:LatLng):Boolean;

    }
}//package com.mapplus.maps.interfaces 
