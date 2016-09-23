//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface ITileLayerOverlay extends IOverlay {

        function get tileLayer():ITileLayer;
        function get tileSize():int;
        function refresh():void;
        function get projection():IProjection;

    }
}//package com.mapplus.maps.interfaces 
