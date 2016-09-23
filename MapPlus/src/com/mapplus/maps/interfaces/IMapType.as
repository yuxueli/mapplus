//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import flash.geom.*;

    public interface IMapType extends IWrappableEventDispatcher {

        function getTextColor():Number;
        function getName(param1:Boolean=false):String;
        function getCopyrights(param1:LatLngBounds, param2:Number):Array;
        function getMinimumResolution(param1:LatLng=null):Number;
        function getTileSize():Number;
        function getTileLayers():Array;
        function getRadius():Number;
        function setMaxResolutionOverride(param1:Number):void;
        function getAlt():String;
        function getProjection():IProjection;
        function getBoundsZoomLevel(param1:LatLngBounds, param2:Point):Number;
        function getSpanZoomLevel(param1:LatLng, param2:LatLng, param3:Point):Number;
        function getErrorMessage():String;
        function getMaximumResolution(param1:LatLng=null):Number;
        function getLinkColor():Number;
        function getUrlArg():String;
        function getMaxResolutionOverride():Number;

    }
}//package com.mapplus.maps.interfaces 
