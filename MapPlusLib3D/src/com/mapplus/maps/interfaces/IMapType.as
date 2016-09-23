//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.geom.*;
    import com.mapplus.maps.*;

    public interface IMapType extends IWrappableEventDispatcher {

        function getTextColor():Number;
        function getName(param2:Boolean=false):String;
        function getCopyrights(_arg1:LatLngBounds, _arg2:Number):Array;
        function getMinimumResolution(param1:LatLng=null):Number;
        function getTileSize():Number;
        function getTileLayers():Array;
        function getRadius():Number;
        function setMaxResolutionOverride(LatLngBounds:Number):void;
        function getAlt():String;
        function getProjection():IProjection;
        function getBoundsZoomLevel(_arg1:LatLngBounds, _arg2:Point):Number;
        function getSpanZoomLevel(_arg1:LatLng, _arg2:LatLng, _arg3:Point):Number;
        function getErrorMessage():String;
        function getMaximumResolution(param1:LatLng=null):Number;
        function getLinkColor():Number;
        function getUrlArg():String;
        function getMaxResolutionOverride():Number;

    }
}//package com.mapplus.maps.interfaces 
