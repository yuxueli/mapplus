//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class SatelliteTileLayer extends TileLayerImpl {

        private var flashClient:String;

        public function SatelliteTileLayer(param1:Number, param2:Array, param3:ICopyrightCollection, param4:Number, param5:String){
            var _loc_6:Object;
            super(param1, addSecurityToken(param2, param5), param3, 0, param4);
            _loc_6 = Bootstrap.getBootstrap().getClientConfiguration();
            if (((_loc_6) && (_loc_6.hasOwnProperty("flc")))){
                flashClient = _loc_6.flc;
            };
        }
        private static function addSecurityToken(param1:Array, param2:String):Array{
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            if (!param2){
                return (param1);
            };
            _loc_3 = [];
            _loc_4 = 0;
            while (_loc_4 < param1.length) {
                _loc_3.push((((param1[_loc_4] + "cookie=") + param2) + "&"));
                _loc_4 = (_loc_4 + 1);
            };
            return (_loc_3);
        }

        override public function loadTileAsync(param1:int, param2:int, param3:int):ITile{
            var _loc_4:String;
            _loc_4 = getTileBaseUrl(param1, param2, param3);
            if (isEmbeddedParamTemplate(_loc_4)){
                _loc_4 = replaceEmbeddedParams(_loc_4, param1, param2, param3);
            } else {
                _loc_4 = (_loc_4 + ("t=" + getQuadTreeEncoding(param1, param2, param3)));
                if (flashClient){
                    _loc_4 = (_loc_4 + ("&flc=" + flashClient));
                };
            };
            return (createTile(_loc_4));
        }
        private function createTile(param1:String):ITile{
            return (new Tile(param1, getTileSize(), PConstants.SATELLITE_MAP_ERROR_ID));
        }

    }
}//package com.mapplus.maps.core 
