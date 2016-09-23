//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IPolylineShape extends IOverlay {

        function getOptions():PolylineOptions;
        function setOptions(param1:PolylineOptions):void;

    }
}//package com.mapplus.maps.interfaces 
