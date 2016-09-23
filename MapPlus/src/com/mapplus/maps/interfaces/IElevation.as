//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IElevation extends IWrappableEventDispatcher {

        function loadElevationForEncodedLocations(param1:EncodedPolylineData):void;
        function loadElevationForLocations(param1:Array):void;
        function loadElevationAlongPath(param1:Array, param2:int):void;
        function loadElevationAlongEncodedPath(param1:EncodedPolylineData, param2:int):void;

    }
}//package com.mapplus.maps.interfaces 
