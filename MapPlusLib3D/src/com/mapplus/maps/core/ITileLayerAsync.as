//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;

    public interface ITileLayerAsync extends ITileLayer {

        function getTileDomain(_arg1:int, _arg2:int, _arg3:int):String;
        function loadTileAsync(_arg1:int, _arg2:int, _arg3:int):ITile;

    }
}//package com.mapplus.maps.core 
