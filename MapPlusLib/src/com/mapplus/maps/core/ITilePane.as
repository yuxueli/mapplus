//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;

    public interface ITilePane {

        function onTileCreated(param1:TileLoader, param2:Object):void;
        function getTileLayer():ITileLayer;
        function getLoadScheduler():LoadScheduler;

    }
}//package com.mapplus.maps.core 
