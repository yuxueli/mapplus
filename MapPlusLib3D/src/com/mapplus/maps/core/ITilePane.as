//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;

    public interface ITilePane {

        function onTileCreated(_arg1:TileLoader, _arg2:Object):void;
        function getTileLayer():ITileLayer;
        function getLoadScheduler():LoadScheduler;

    }
}//package com.mapplus.maps.core 
