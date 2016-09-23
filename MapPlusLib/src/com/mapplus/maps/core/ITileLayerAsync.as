//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;

    public interface ITileLayerAsync extends ITileLayer {

        function getTileDomain(param1:int, param2:int, param3:int):String;
        function loadTileAsync(x:int, y:int, zoom:int):ITile;

    }
}//package com.mapplus.maps.core 
