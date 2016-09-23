//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;

    public interface IDirections extends IWrappableEventDispatcher {

        function get distanceHtml():String;
        function setOptions(param1:DirectionsOptions):void;
        function get distance():Number;
        function load(param1:String):void;
        function getOptions():DirectionsOptions;
        function clear():void;
        function getGeocode(param1:uint):Placemark;
        function get numRoutes():uint;
        function get summaryHtml():String;
        function get status():uint;
        function getRoute(param1:uint):Route;
        function get duration():Number;
        function get bounds():LatLngBounds;
        function get copyrightsHtml():String;
        function get encodedPolylineData():EncodedPolylineData;
        function get numGeocodes():uint;
        function createPolyline(param1:PolylineOptions=null):IPolyline;
        function get durationHtml():String;

    }
}//package com.mapplus.maps.interfaces 
