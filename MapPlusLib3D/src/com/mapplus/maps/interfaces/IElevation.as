//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IElevation extends IWrappableEventDispatcher {

        function loadElevationForEncodedLocations(param1:EncodedPolylineData):void;
        function loadElevationForLocations(param1:Array):void;
        function loadElevationAlongPath(_arg1:Array, _arg2:int):void;
        function loadElevationAlongEncodedPath(_arg1:EncodedPolylineData, _arg2:int):void;

    }
}//package com.mapplus.maps.interfaces 
