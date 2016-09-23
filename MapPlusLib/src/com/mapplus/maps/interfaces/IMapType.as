//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import flash.geom.*;

    public interface IMapType extends IWrappableEventDispatcher {

        function getCopyrights(param1:LatLngBounds, param2:Number):Array;
        function getProjection():IProjection;
        function getTileSize():Number;
        function getName(param1:Boolean=false):String;
        function getSpanZoomLevel(param1:LatLng, param2:LatLng, param3:Point):Number;
        function getLinkColor():Number;
        function getErrorMessage():String;
        function getRadius():Number;
        function getTextColor():Number;
        function getUrlArg():String;
        function getTileLayers():Array;
        function getMinimumResolution(param1:LatLng=null):Number;
        function getBoundsZoomLevel(param1:LatLngBounds, param2:Point):Number;
        function setMaxResolutionOverride(param1:Number):void;
        function getMaxResolutionOverride():Number;
        function getAlt():String;
        function getMaximumResolution(param1:LatLng=null):Number;

    }
}//package com.mapplus.maps.interfaces 
