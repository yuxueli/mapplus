//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class BingMapTileLayer extends TileLayerImpl {

        private var SALT_SHAKER:String = ".png?g=69";

        public function BingMapTileLayer(tileSize:Number, baseUrls:Array, copyrightCollection:ICopyrightCollection, maxZoom:Number){
            super(tileSize, baseUrls, copyrightCollection, 0, maxZoom);
        }
        override public function loadTileAsync(x:int, y:int, zoom:int):ITile{
            var _loc_3:* = Math.pow(2, zoom);
            var _loc_6:String;
            var _loc_7:int;
            _loc_6 = getTileBaseUrl(x, y, zoom);
            if (isEmbeddedParamTemplate(_loc_6)){
                _loc_6 = replaceEmbeddedParams(_loc_6, x, y, zoom);
            } else {
                while (_loc_7 < zoom) {
                    _loc_3 = (_loc_3 / 2);
                    if (y < _loc_3){
                        if (x < _loc_3){
                            _loc_6 = (_loc_6 + "0");
                        } else {
                            _loc_6 = (_loc_6 + "1");
                            x = (x - _loc_3);
                        };
                    } else {
                        if (x < _loc_3){
                            _loc_6 = (_loc_6 + "2");
                            y = (y - _loc_3);
                        } else {
                            _loc_6 = (_loc_6 + "3");
                            x = (x - _loc_3);
                            y = (y - _loc_3);
                        };
                    };
                    _loc_7 = (_loc_7 + 1);
                };
            };
            return (new Tile((_loc_6 + SALT_SHAKER), getTileSize(), PConstants.NORMAL_MAP_ERROR_ID));
        }

    }
}//package com.mapplus.maps.core 
