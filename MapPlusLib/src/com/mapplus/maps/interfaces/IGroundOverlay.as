//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.overlays.*;

    public interface IGroundOverlay extends IOverlay {

        function hide():void;
        function setOptions(param1:GroundOverlayOptions):void;
        function getOptions():GroundOverlayOptions;
        function isHidden():Boolean;
        function show():void;

    }
}//package com.mapplus.maps.interfaces 
