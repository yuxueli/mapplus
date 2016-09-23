//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.services.*;

    public interface IClientGeocoder extends IWrappableEventDispatcher {

        function resetCache():void;
        function getBaseCountryCode():String;
        function reverseGeocode(param1:LatLng):void;
        function setOptions(param1:ClientGeocoderOptions):void;
        function getOptions():ClientGeocoderOptions;
        function setBaseCountryCode(param1:String):void;
        function setViewport(param1:LatLngBounds):void;
        function getViewport():LatLngBounds;
        function geocode(param1:String):void;

    }
}//package com.mapplus.maps.interfaces 
