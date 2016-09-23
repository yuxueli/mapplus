//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public interface IMapBase extends IEventDispatcher {

        function getAttitude():Attitude;
        function getFocus():LatLng;
        function setSize(param1:Point):void;
        function loadResourceString(param1:String):String;
        function getZoom():Number;
        function getCenter():LatLng;
        function setAttitude(param1:Attitude):void;
        function isLoaded():Boolean;
        function displayHint(param1:String):void;
        function setMapType(param1:IMapType):void;
        function setZoom(_arg1:Number, _arg2:Boolean=false):void;
        function setCenter(_arg1:LatLng, _arg2:Number=NaN, _arg3:IMapType=null):void;
        function getCurrentMapType():IMapType;
        function getCamera():Camera;
        function getSize():Point;

    }
}//package com.mapplus.maps.core 
