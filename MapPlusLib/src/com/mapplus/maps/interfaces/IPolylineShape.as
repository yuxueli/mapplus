//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IPolylineShape extends IOverlay {

        function setOptions(param1:PolylineOptions):void;
        function getOptions():PolylineOptions;

    }
}//package com.mapplus.maps.interfaces 
