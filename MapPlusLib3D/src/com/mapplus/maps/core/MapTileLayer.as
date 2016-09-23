//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class MapTileLayer extends TileLayerImpl {

        private var SALT_SHAKER:String = "Galileo";
        private var flashClient:String;

        public function MapTileLayer(param1:Number, param2:Array, param3:ICopyrightCollection, param4:Number){
            var _loc_5:Object;
            SALT_SHAKER = "Galileo";
            super(param1, param2, param3, 0, param4);
            _loc_5 = Bootstrap.getBootstrap().getClientConfiguration();
            if (((_loc_5) && (_loc_5.hasOwnProperty("flc")))){
                flashClient = _loc_5.flc;
            };
        }
        override public function loadTileAsync(param1:int, param2:int, param3:int):ITile{
            var _loc_4:Number = NaN;
            var _loc_5:String;
            var _loc_6:String;
            _loc_4 = (((param1 * 3) + param2) % 8);
            _loc_5 = SALT_SHAKER.substr(0, _loc_4);
            _loc_6 = getTileBaseUrl(param1, param2, param3);
            if (isEmbeddedParamTemplate(_loc_6)){
                _loc_6 = replaceEmbeddedParams(_loc_6, param1, param2, param3);
            } else {
                _loc_6 = (_loc_6 + ("x=" + param1));
                if ((((param2 >= 10000)) && ((param2 < 100000)))){
                    _loc_6 = (_loc_6 + "&s=");
                };
                _loc_6 = (_loc_6 + ((((("&y=" + param2) + "&z=") + param3) + "&s=") + _loc_5));
            };
            return (new Tile(_loc_6, getTileSize(), PConstants.NORMAL_MAP_ERROR_ID));
        }

    }
}//package com.mapplus.maps.core 
