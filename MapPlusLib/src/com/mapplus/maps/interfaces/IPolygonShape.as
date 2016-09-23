//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IPolygonShape extends IOverlay {

        function setOptions(param1:PolygonOptions):void;
        function getOptions():PolygonOptions;

    }
}//package com.mapplus.maps.interfaces 
