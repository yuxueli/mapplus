//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;

    public interface IMap extends IWrappableEventDispatcher {

        function scrollWheelZoomEnabled():Boolean;
        function set overlayRaising(param1:Boolean):void;
        function setSize(param1:Point):void;
        function enableScrollWheelZoom():void;
        function getBoundsZoomLevel(param1:LatLngBounds):Number;
        function fromPointToLatLng(_arg1:Point, _arg2:Number=NaN, _arg3:Boolean=false):LatLng;
        function disableScrollWheelZoom():void;
        function disableContinuousZoom():void;
        function setMapType(param1:IMapType):void;
        function monitorCopyright(param1:IMap):void;
        function clearOverlays():void;
        function removeMapType(param1:IMapType):void;
        function disableControlByKeyboard():void;
        function configureMap():void;
        function getImplementationVersion():String;
        function disableCrosshairs():void;
        function clearControls():void;
        function controlByKeyboardEnabled():Boolean;
        function openInfoWindow(_arg1:LatLng, _arg2:InfoWindowOptions=null):IInfoWindow;
        function removeOverlay(param1:IOverlay):void;
        function fromLatLngToViewport(_arg1:LatLng, _arg2:Boolean=false):Point;
        function getMinZoomLevel(_arg1:IMapType=null, _arg2:LatLng=null):Number;
        function setDoubleClickMode(param1:Number):void;
        function removeControl(param1:IControl):void;
        function get overlayRaising():Boolean;
        function getDoubleClickMode():Number;
        function getProjection():IProjection;
        function savePosition():void;
        function getZoom():Number;
        function getCenter():LatLng;
        function loadResourceString(param1:String):String;
        function isLoaded():Boolean;
        function getLatLngBounds():LatLngBounds;
        function panBy(_arg1:Point, _arg2:Boolean=true):void;
        function addMapType(param1:IMapType):void;
        function placeControl(_arg1:IControl, _arg2:ControlPosition):void;
        function disableDragging():void;
        function enableControlByKeyboard():void;
        function setZoom(_arg1:Number, _arg2:Boolean=false):void;
        function returnToSavedPosition():void;
        function setCenter(_arg1:LatLng, _arg2:Number=NaN, _arg3:IMapType=null):void;
        function continuousZoomEnabled():Boolean;
        function getPrintableBitmap():Bitmap;
        function getMaxZoomLevel(_arg1:IMapType=null, _arg2:LatLng=null):Number;
        function enableContinuousZoom():void;
        function zoomIn(_arg1:LatLng=null, _arg2:Boolean=false, _arg3:Boolean=false):void;
        function getOptions():MapOptions;
        function displayHint(param1:String):void;
        function getDisplayObject():DisplayObject;
        function fromLatLngToPoint(_arg1:LatLng, _arg2:Number=NaN):Point;
        function closeInfoWindow():Boolean;
        function getPaneManager():IPaneManager;
        function crosshairsEnabled():Boolean;
        function fromViewportToLatLng(_arg1:Point, _arg2:Boolean=false):LatLng;
        function draggingEnabled():Boolean;
        function getCurrentMapType():IMapType;
        function enableCrosshairs():void;
        function get MERCATOR_PROJECTION():IProjection;
        function getSize():Point;
        function panTo(param1:LatLng):void;
        function enableDragging():void;
        function getMapTypes():Array;
        function zoomOut(_arg1:LatLng=null, _arg2:Boolean=false):void;
        function addControl(param1:IControl):void;
        function addOverlay(param1:IOverlay):void;
        function unload():void;

    }
}//package com.mapplus.maps.interfaces 
