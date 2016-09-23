﻿//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;

    public interface IMarker extends IOverlay {

        function hide():void;
        function isHidden():Boolean;
        function closeInfoWindow():void;
        function openInfoWindow(param1:InfoWindowOptions=null, param2:Boolean=false):IInfoWindow;
        function setLatLng(param1:LatLng):void;
        function getLatLng():LatLng;
        function setOptions(param1:MarkerOptions):void;
        function show():void;
        function getOptions():MarkerOptions;

    }
}//package com.mapplus.maps.interfaces 
