//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;

    public class MapTileLayer extends TileLayerImpl {

        private var flashClient:String;
        private var SALT_SHAKER:String = "Galileo";

        public function MapTileLayer(tileSize:Number, baseUrls:Array, copyrightCollection:ICopyrightCollection, maxZoom:Number){
            var _loc_5:Object;
            this.SALT_SHAKER = "Galileo";
            super(tileSize, baseUrls, copyrightCollection, 0, maxZoom);
            _loc_5 = Bootstrap.getBootstrap().getClientConfiguration();
            if (((_loc_5) && (_loc_5.hasOwnProperty("flc")))){
                this.flashClient = _loc_5.flc;
            };
        }
        override public function loadTileAsync(x:int, y:int, zoom:int):ITile{
            var _loc_4:Number = NaN;
            var _loc_5:String;
            var _loc_6:String;
            _loc_4 = (((x * 3) + y) % 8);
            _loc_5 = this.SALT_SHAKER.substr(0, _loc_4);
            _loc_6 = getTileBaseUrl(x, y, zoom);
            if (isEmbeddedParamTemplate(_loc_6)){
                _loc_6 = replaceEmbeddedParams(_loc_6, x, y, zoom);
            } else {
                _loc_6 = (_loc_6 + ("x=" + x));
                if ((((y >= 10000)) && ((y < 100000)))){
                    _loc_6 = (_loc_6 + "&s=");
                };
                _loc_6 = (_loc_6 + ((((("&y=" + y) + "&z=") + zoom) + "&s=") + _loc_5));
                _loc_6 = (_loc_6 + this.getExtraTileUrlParams());
            };
            return (new Tile(_loc_6, getTileSize(), PConstants.NORMAL_MAP_ERROR_ID));
        }
        protected function getExtraTileUrlParams():String{
            return (this.flashClient);
        }

    }
}//package com.mapplus.maps.core 
