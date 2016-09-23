//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;

    public interface IDirections extends IWrappableEventDispatcher {

        function getRoute(param1:uint):Route;
        function get duration():Number;
        function getGeocode(param1:uint):Placemark;
        function get distanceHtml():String;
        function get numGeocodes():uint;
        function clear():void;
        function get copyrightsHtml():String;
        function get durationHtml():String;
        function createPolyline(param1:PolylineOptions=null):IPolyline;
        function getOptions():DirectionsOptions;
        function setOptions(param1:DirectionsOptions):void;
        function load(param1:String):void;
        function get numRoutes():uint;
        function get summaryHtml():String;
        function get status():uint;
        function get bounds():LatLngBounds;
        function get encodedPolylineData():EncodedPolylineData;
        function get distance():Number;

    }
}//package com.mapplus.maps.interfaces 
