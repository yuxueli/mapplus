//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.services.*;

    public interface IClientGeocoder extends IWrappableEventDispatcher {

        function setBaseCountryCode(param1:String):void;
        function resetCache():void;
        function reverseGeocode(param1:LatLng):void;
        function geocode(param1:String):void;
        function getOptions():ClientGeocoderOptions;
        function getBaseCountryCode():String;
        function setOptions(param1:ClientGeocoderOptions):void;
        function getViewport():LatLngBounds;
        function setViewport(param1:LatLngBounds):void;

    }
}//package com.mapplus.maps.interfaces 
