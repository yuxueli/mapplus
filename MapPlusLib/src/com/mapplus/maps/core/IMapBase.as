//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import flash.events.*;

    public interface IMapBase extends IEventDispatcher {

        function getFocus():LatLng;
        function setSize(param1:Point):void;
        function loadResourceString(param1:String):String;
        function displayHint(param1:String):void;
        function getCenter():LatLng;
        function isLoaded():Boolean;
        function getZoom():Number;
        function getCurrentMapType():IMapType;
        function setZoom(param1:Number, param2:Boolean=false):void;
        function setCenter(param1:LatLng, param2:Number=NaN, param3:IMapType=null):void;
        function setMapType(param1:IMapType):void;
        function getCamera():Camera;
        function getSize():Point;

    }
}//package com.mapplus.maps.core 
