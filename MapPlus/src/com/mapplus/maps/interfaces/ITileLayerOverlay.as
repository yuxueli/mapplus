//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface ITileLayerOverlay extends IOverlay {

        function get tileLayer():ITileLayer;
        function refresh():void;
        function get projection():IProjection;
        function get tileSize():int;

    }
}//package com.mapplus.maps.interfaces 
