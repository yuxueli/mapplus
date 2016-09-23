//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class QQMap extends TileLayerImpl {

        private var SALT_SHAKER:String = ".png";

        public function QQMap(tileSize:int, baseUrls:Array, copyrightCollection:ICopyrightCollection=null, maxZoom:Number=17){
            super(tileSize, baseUrls, copyrightCollection, 0, maxZoom);
        }
        override public function loadTileAsync(x:int, y:int, zoom:int):ITile{
            var ymax:int;
            var sy:int;
            var tx:int;
            var ty:int;
            var _loc_6:String;
            _loc_6 = getTileBaseUrl(x, y, zoom);
            if (isEmbeddedParamTemplate(_loc_6)){
                _loc_6 = replaceEmbeddedParams(_loc_6, x, y, zoom);
            } else {
                ymax = (1 << zoom);
                sy = ((ymax - y) - 1);
                tx = Math.floor((x / 16));
                ty = Math.floor((sy / 16));
                _loc_6 = ((((((((((_loc_6 + zoom) + "/") + tx) + "/") + ty) + "/") + x) + "_") + sy) + SALT_SHAKER);
            };
            return (new Tile(_loc_6, getTileSize(), PConstants.NORMAL_MAP_ERROR_ID));
        }

    }
}//package com.mapplus.maps.core 
