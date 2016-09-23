//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;

    public interface IMarker extends IOverlay {

        function hide():void;
        function closeInfoWindow():void;
        function setLatLng(param1:LatLng):void;
        function setOptions(param1:MarkerOptions):void;
        function getOptions():MarkerOptions;
        function openInfoWindow(param1:InfoWindowOptions=null, param2:Boolean=false):IInfoWindow;
        function isHidden():Boolean;
        function getLatLng():LatLng;
        function show():void;

    }
}//package com.mapplus.maps.interfaces 
