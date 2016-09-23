//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import flash.geom.*;
    import com.mapplus.maps.controls.*;
    import flash.display.*;

    public interface IMap extends IWrappableEventDispatcher {

        function scrollWheelZoomEnabled():Boolean;
        function zoomOut(param1:LatLng=null, param2:Boolean=false):void;
        function enableCrosshairs():void;
        function disableContinuousZoom():void;
        function monitorCopyright(param1:IMap):void;
        function fromPointToLatLng(param1:Point, param2:Number=NaN, param3:Boolean=false):LatLng;
        function clearOverlays():void;
        function getPaneManager():IPaneManager;
        function removeMapType(param1:IMapType):void;
        function enableDragging():void;
        function getBoundsZoomLevel(param1:LatLngBounds):Number;
        function configureMap():void;
        function getImplementationVersion():String;
        function disableCrosshairs():void;
        function setSize(param1:Point):void;
        function draggingEnabled():Boolean;
        function disableControlByKeyboard():void;
        function clearControls():void;
        function openInfoWindow(param1:LatLng, param2:InfoWindowOptions=null):IInfoWindow;
        function removeOverlay(param1:IOverlay):void;
        function controlByKeyboardEnabled():Boolean;
        function fromLatLngToViewport(param1:LatLng, param2:Boolean=false):Point;
        function getMinZoomLevel(param1:IMapType=null, param2:LatLng=null):Number;
        function setDoubleClickMode(param1:Number):void;
        function removeControl(param1:IControl):void;
        function getDoubleClickMode():Number;
        function getProjection():IProjection;
        function savePosition():void;
        function get overlayRaising():Boolean;
        function getZoom():Number;
        function getCenter():LatLng;
        function loadResourceString(param1:String):String;
        function isLoaded():Boolean;
        function getLatLngBounds():LatLngBounds;
        function panBy(param1:Point, param2:Boolean=true):void;
        function addMapType(param1:IMapType):void;
        function placeControl(param1:IControl, param2:ControlPosition):void;
        function disableDragging():void;
        function enableControlByKeyboard():void;
        function setZoom(param1:Number, param2:Boolean=false):void;
        function returnToSavedPosition():void;
        function setCenter(param1:LatLng, param2:Number=NaN, param3:IMapType=null):void;
        function continuousZoomEnabled():Boolean;
        function getPrintableBitmap():Bitmap;
        function getMaxZoomLevel(param1:IMapType=null, param2:LatLng=null):Number;
        function enableContinuousZoom():void;
        function zoomIn(param1:LatLng=null, param2:Boolean=false, param3:Boolean=false):void;
        function getOptions():MapOptions;
        function displayHint(param1:String):void;
        function getDisplayObject():DisplayObject;
        function fromLatLngToPoint(param1:LatLng, param2:Number=NaN):Point;
        function closeInfoWindow():Boolean;
        function get MERCATOR_PROJECTION():IProjection;
        function crosshairsEnabled():Boolean;
        function fromViewportToLatLng(param1:Point, param2:Boolean=false):LatLng;
        function set overlayRaising(param1:Boolean):void;
        function getCurrentMapType():IMapType;
        function setMapType(param1:IMapType):void;
        function addOverlay(param1:IOverlay):void;
        function getSize():Point;
        function panTo(param1:LatLng):void;
        function disableScrollWheelZoom():void;
        function getMapTypes():Array;
        function addControl(param1:IControl):void;
        function enableScrollWheelZoom():void;
        function unload():void;

    }
}//package com.mapplus.maps.interfaces 
