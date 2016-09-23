//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface IInfoWindow extends IOverlay, IWrappable {

        function get removed():Boolean;
        function hide():void;
        function isHidden():Boolean;
        function show():void;

    }
}//package com.mapplus.maps.interfaces 
