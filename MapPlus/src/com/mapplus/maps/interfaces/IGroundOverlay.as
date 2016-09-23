//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IGroundOverlay extends IOverlay {

        function getOptions():GroundOverlayOptions;
        function hide():void;
        function setOptions(param1:GroundOverlayOptions):void;
        function show():void;
        function isHidden():Boolean;

    }
}//package com.mapplus.maps.interfaces 
