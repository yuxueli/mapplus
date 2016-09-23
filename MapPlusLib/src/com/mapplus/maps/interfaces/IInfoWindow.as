//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface IInfoWindow extends IOverlay, IWrappable {

        function hide():void;
        function get removed():Boolean;
        function isHidden():Boolean;
        function show():void;

    }
}//package com.mapplus.maps.interfaces 
